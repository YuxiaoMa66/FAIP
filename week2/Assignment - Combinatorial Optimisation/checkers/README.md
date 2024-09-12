# Checker scripts, getting started

## Installation

Aside from the MiniZinc distribution, you will need to install the Python 3.7 or newer, the [Poetry](https://python-poetry.org/) package manager, and run `poetry install` from the grading directory.

## Running

Open the shell with the new Python environment with `poetry shell`; run the grading scripts as follows:
- `python sports_scheduling/grade.py <MODEL.mzn> sports_scheduling/dzn/` for sports scheduling
- `python set-cover/grade-explicit.py <MODEL-EXPLICIT.mzn>` for the explicit set covering problem
- `python set-cover/grade.py <MODEL.mzn> set-cover/dzn` for full set covering problem
- `python graph_coloring/grade.py <MODEL.mzn> graph_coloring/dzn/` for graph coloring

You may also want to use the following flags:
- `--solver <SOLVER_ID>` to choose the solver for the problem,
- `--timeout <TIMEOUT_SECONDS>` to limit the execution time; we recommend using `--timeout 60`.
