include "globals.mzn";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int: num_teams;                                     % number of teams in the league
set of int: Team = 1..num_teams; 
int: num_rounds = (num_teams - 1);                  % number of rounds in the league
enum Round = R(1..num_rounds);                      % rounds
enum HoA = {H,A};                                   % indicates home or away location
array [1..num_teams,1..num_teams] of int: cost;     % cost incurred by team i to travel to team j's stadium

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
type Game = var record(Team: vs, HoA: loc);       % variable for the opponent-location pair
array[Team, Round] of var Game: game;             % array of game variables for each team and round combination
var int: obj;                                     % objective value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve item
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve minimize obj;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Constraint 1: a team never plays itself

% Constraint 2: the opponent of a team’s opponent is the team itself

% Constraint 3: if a team plays home, its opponent plays away

% Constraint 4: all teams play someone else within the same round
% HINT: check "all_different" global constraint

% Constraint 5: all teams play each other once
% HINT: check "all_different" global constraint

% Constraint 6: a team cannot play more than two consecutive home and three consecutive away games
% HINT: check sliding_sum global constraint

% Constraint 6: update obj variable
% HINT: check conditional expressions


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [
    "Objective value: " ++ show(obj) ++ "\n" ++
    "Schedule:\n",
    concat([ 
        show(t) ++ ": " ++
        concat([
            show(game[t, r].vs) ++ 
            "(" ++ show(game[t, r].loc) ++ ")" ++ 
            if r != num_rounds then ", " else "" endif
            | r in Round
        ]) ++ "\n"
        | t in Team
    ])
];