import argparse
from datetime import timedelta
from pathlib import Path

from minizinc import Model, Solver, Instance
from minizinc.result import Status

OPTIMAL = dict()


def grade(key, color, used_color, edges):
    obj = sum(used_color)
    if key in OPTIMAL:
        if obj > OPTIMAL[key]:
            print(
                f"✘ Claimed optimum {obj} for instance {key} ",
                f"does not match the known optimum {OPTIMAL[key]}",
            )
            return False
    else:
        print(f"Skipping objective check for {key}; discovered objective {obj}")
    for color_ix, used_color_ix in enumerate(used_color):
        if used_color_ix == 0:
            for v, color_choice in enumerate(color):
                if color_choice[used_color_ix] == 1:
                    print(f"✘ Color {color_ix} is not selected but used in vertex {v}")
                    return False
    for v, color_choice in enumerate(color):
        if len([c for c in color_choice if c == 1]) != 1:
            print(f"✘ Vertex {v} is not uniquely colored: {color_choice}")
            return False
    for u, v in ((u - 1, v - 1) for u, v in edges):
        if color[u] == color[v]:
            for c in range(len(used_color)):
                if color[u][c] == 1:
                    break
            print(f"✘ Edge {u}---{v} is colored with a color {c}")
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
            if grade(
                dzn.name, result["colour"], result["used_colour"], instance["edges"]
            ):
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
