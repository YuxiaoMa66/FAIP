import argparse

from minizinc import Model, Solver, Instance
from minizinc.result import Status


def grade(anika, bao, cees, dave):
    if (anika, dave) == (1, 1):
        return True
    else:
        print("Expected: {Anika, Dave}")
        print(
            "Received: {"
            + ", ".join(
                name
                for name, sol in zip(
                    ["Anika", "Bao", "Cees", "Dave"], [anika, bao, cees, dave]
                )
                if sol == 1
            )
            + "}"
        )
        return False


def main(model_path, solver_id):
    model = Model(model_path)
    solver = Solver.lookup(solver_id)
    instance = Instance(solver, model)
    result = instance.solve()
    if result.status == Status.UNSATISFIABLE:
        print(f"Failed to solve to optimality")
        print(f"Solver status: {result.status}")
    else:
        print(f"Received a solution from a solver")
        if grade(
            *[
                result[key]
                for key in ["chosen_anika", "chosen_bao", "chosen_cees", "chosen_dave"]
            ]
        ):
            print("Success!")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("model", help="Path to MiniZinc model file")
    parser.add_argument(
        "--solver", help="Solver identifier; use OR-Tools by default", default="cpsatlp"
    )
    args = parser.parse_args()
    main(args.model, args.solver)
