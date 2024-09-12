import argparse
from datetime import timedelta
from pathlib import Path

from minizinc import Model, Solver, Instance
from minizinc.result import Status

OPTIMAL = dict()


def grade(key, chosen, sets, cost):
    if len(chosen) != len(cost):
        print("✘ Received {} costs but {} decisions")
        return False
    obj = sum(var * c for var, c in zip(chosen, cost))
    if key in OPTIMAL:
        if obj > OPTIMAL[key]:
            print(
                f"✘ Claimed optimum {obj} for instance {key} ",
                f"does not match the known optimum {OPTIMAL[key]}",
            )
            return False
    else:
        print("Skipping objective check for", key)
    skills = set.union(*sets)
    for skill in skills:
        targets = [ix for ix, s in enumerate(sets) if skill in s]
        if all(chosen[t] == 0 for t in targets):
            print(f"✘ Skill with index {skill} is not covered;")
            print(f"none of the persons {targets} have been chosen")
            return False
    return True


def main(model_path, dzn_path, solver_id, timeout):
    model = Model(model_path)
    solver = Solver.lookup(solver_id)
    score = 0
    max_score = 0
    for dzn in Path(dzn_path).glob("*.dzn"):
        max_score += 1
        instance = Instance(solver, model)
        instance.add_file(dzn, parse_data=True)
        print(f"Opened instance {dzn.name}")
        result = instance.solve(timeout=timeout)
        if result.status not in {Status.OPTIMAL_SOLUTION, Status.SATISFIED}:
            print(f"Failed to discover a solution")
            print(f"Solver status: {result.status}")
        else:
            print(f"Received a solution from a solver")
            print(f"Solver status: {result.status}")
            if grade(dzn.name, result["chosen"], instance["people"], instance["costs"]):
                print(f"✔ Solved instance {dzn_path}")
                score += 1
    print(f"Score: {score} / {max_score}")
    if score == max_score:
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
