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
constraint forall(t in Team, r in Round) (
    game[t, r].vs != t
);


% Constraint 2: the opponent of a team’s opponent is the team itself
constraint forall(t in Team, r in Round) (
    game[game[t, r].vs, r].vs = t
);


% Constraint 3: if a team plays home, its opponent plays away
constraint forall(t in Team, r in Round) (
    game[t, r].loc = H <-> game[game[t, r].vs, r].loc = A
);


% Constraint 4: all teams play someone else within the same round
% HINT: check "all_different" global constraint
constraint forall(r in Round) (
    all_different([game[t, r].vs | t in Team])
);


% Constraint 5: all teams play each other once
% HINT: check "all_different" global constraint
constraint forall(t1 in Team) (
    all_different([game[t1, r].vs | r in Round])
);


% Constraint 6: a team cannot play more than two consecutive home and three consecutive away games
% HINT: check sliding_sum global constraint
constraint forall(t in Team) (
    sliding_sum(0, 2, 3, [bool2int(game[t, r].loc = H) | r in Round]) /\
    sliding_sum(0, 3, 4, [bool2int(game[t, r].loc = A) | r in Round])
);




% Constraint 6: update obj variable
% HINT: check conditional expressions
constraint obj = sum(t in Team, r in Round) (
    if game[t, r].loc = A then cost[t, game[t, r].vs] else 0 endif
);



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