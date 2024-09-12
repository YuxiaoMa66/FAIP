import argparse
from datetime import timedelta
from pathlib import Path

from minizinc import Model, Solver, Instance
from minizinc.result import Status

MAX_HOME = 2
MAX_AWAY = 3
OPTIMAL = {"small-1.dzn": 77, "large-1.dzn": 949}
MAX_MODEL_GRADE = 8


def team_never_plays_itself(games):
    n_teams = len(games)
    for team in range(1, n_teams + 1):
        for round, match in enumerate(games[team - 1], 1):
            if match["vs"] != team:
                continue
            else:
                return 0, (f"Team {team} plays round #{round} against itself")
    return 1, "No team plays a match against itself"


def opponent_involutive(games):
    n_teams = len(games)
    for team in range(1, n_teams + 1):
        for round, match in enumerate(games[team - 1], 1):
            other_team = match["vs"]
            other_team_match = games[other_team - 1][round - 1]
            other_other_team = other_team_match["vs"]
            if other_other_team == team:
                continue
            else:
                return 0, (
                    f"Team {team} plays round #{round} against {other_team} "
                    f"but team {other_team} plays round #{round} "
                    f"against {other_other_team}"
                )
    return 1, "An opponent of a team plays against that team"


def home_away_complement(games):
    n_teams = len(games)
    for team in range(1, n_teams + 1):
        for round, match in enumerate(games[team - 1], 1):
            other_team = match["vs"]
            other_match = games[other_team - 1][round - 1]
            if match["loc"] != other_match["loc"]:
                continue
            else:
                loc = "at home" if match["loc"] == "H" else "away"
                return 0, (
                    f"Teams {team} and {other_team} plays round #{round} "
                    f"against each other yet both play {loc}"
                )
    return 1, "An opponent of a home team plays an away match"


def different_opponents(games):
    n_teams = len(games)
    for round in range(1, n_teams):
        round_games = dict()
        for team in range(1, n_teams + 1):
            game = games[team - 1][round - 1]
            if game["vs"] in round_games:
                other_team = round_games[game["vs"]]
                return 0, (
                    f"Teams {other_team} and {team} play round #{round} "
                    f'against team {game["vs"]}'
                )
            else:
                round_games[game["vs"]] = team
    return 1, "All teams oppose some other team in every round"


def round_robin(games):
    n_teams = len(games)
    for team in range(1, n_teams + 1):
        opponents = dict()
        for round in range(1, n_teams):
            game = games[team - 1][round - 1]
            if game["vs"] in opponents:
                other_round = opponents[game["vs"]]
                return 0, (
                    f'Team {team} plays against team {game["vs"]} '
                    f"in rounds #{other_round} and #{round}"
                )
            else:
                opponents[game["vs"]] = round
    return 1, "All teams oppose some other team in every round"


def game_bound(games, loc, bound):
    n_teams = len(games)
    loc_name = "at home" if loc == "H" else "away"
    for team in range(1, n_teams + 1):
        is_loc = games[team - 1][0]["loc"] == loc
        run_length = 1
        run_start = 1
        for round in range(2, n_teams):
            game = games[team - 1][round - 1]
            if game["loc"] == loc:
                if is_loc:
                    run_length += 1
                else:
                    is_loc, run_length, run_start = True, 1, round
            else:
                is_loc = False

            if run_length > bound:
                return 0, (
                    f"Team {team} plays too many games {loc_name} "
                    f"from round #{run_start} to round #{round}"
                )
    return 1, f"All teams play at most {bound} games {loc_name}"


def check_objective(key, obj):
    if key in OPTIMAL:
        if obj > OPTIMAL[key]:
            return 0, (
                f"Claimed optimum {obj} for instance {key} ",
                f"does not match the best known solution {OPTIMAL[key]}",
            )
        else:
            return 1, f"Discovered a solution with objective {obj}"
    else:
        return 1, f"Skipping objective check for {key}"


def grade(key, games, obj):
    results = [
        team_never_plays_itself(games),
        opponent_involutive(games),
        home_away_complement(games),
        different_opponents(games),
        round_robin(games),
        game_bound(games, "H", 2),
        game_bound(games, "A", 3),
        check_objective(key, obj),
    ]
    total = sum(grade for grade, _ in results)
    msgs = [f"✘ {msg}" if grade != 1 else f"✔ {msg}" for grade, msg in results]
    return total, msgs


def main(model_path, dzn_path, solver_id, timeout):
    model = Model(model_path)
    solver = Solver.lookup(solver_id)
    total_grade = 0
    max_grade = 0
    for dzn in Path(dzn_path).glob("*.dzn"):
        max_grade += MAX_MODEL_GRADE
        instance = Instance(solver, model)
        instance.add_file(dzn, parse_data=True)
        key = dzn.name
        print(f"[{key}] Parsed the instance file")
        result = instance.solve(timeout=timeout)
        if result.status not in {Status.OPTIMAL_SOLUTION, Status.SATISFIED}:
            print(f"[{key}] Failed to discover a solution")
            print(f"[{key}] Solver status: {result.status}")
        else:
            print(f"[{key}] Received a solution from a solver")
            print(f"[{key}] Solver status: {result.status}")
            next_grade, msgs = grade(key, result["game"], result["obj"])
            total_grade += next_grade
            for msg in msgs:
                print(f"[{key}] {msg}")
    print(f"Final grade: {total_grade} / {max_grade}")
    if total_grade == max_grade:
        print("Success!")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("model", help="Path to MiniZinc model file")
    parser.add_argument("dzn", help="Directory with *.dzn files")
    parser.add_argument(
        "--solver", help="Solver identifier; use OR-Tools by default", default="cpsatlp"
    )
    parser.add_argument(
        "--timeout", type=int, help="Time limit for a solver run, seconds"
    )
    args = parser.parse_args()
    main(
        args.model,
        args.dzn,
        args.solver,
        timedelta(seconds=args.timeout) if args.timeout is not None else None,
    )
