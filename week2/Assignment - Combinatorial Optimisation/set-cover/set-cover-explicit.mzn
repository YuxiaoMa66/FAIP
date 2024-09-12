% Model for the weighted set cover problem. In the model the skills are represented by integers.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Anika, Bao, Cees, Dave
var 0..1: chosen_anika;
var 0..1: chosen_bao;
var 0..1: chosen_cees;
var 0..1: chosen_dave;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve item
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve satisfy;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% by analysing the small-1: 

% Constraint 1: at least one person should be chosen for skill 1
constraint chosen_anika >= 1;

% Constraint 2: at least one person should be chosen for skill 2
constraint chosen_anika + chosen_bao >= 1;

% Constraint 3: at least one person should be chosen for skill 3
constraint chosen_anika + chosen_cees >= 1;

% Constraint 4: at least one person should be chosen for skill 4
constraint chosen_bao + chosen_cees >= 1;

% Constraint 5: at least one person should be chosen for skill 5
constraint chosen_dave >= 1;
