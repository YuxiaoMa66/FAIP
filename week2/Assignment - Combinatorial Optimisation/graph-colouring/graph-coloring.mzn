% Model for the graph colouring problem, using a 2-D matrix of 0..1 variables.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int: NUM_NODES;                            % the number of nodes in the graph
set of int: Nodes = 1..NUM_NODES;          % the nodes in the graph
int: NUM_EDGES;                            % the number of edges in the graph
array[1..NUM_EDGES, 1..2] of Nodes: edges; % each row is a pair of nodes that are connected


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
array[Nodes, Nodes] of var 0..1: colour;   % colour[i, c] = 1 iff node i is colour c. Note: we need at most NUM_NODES colours.
array[Nodes] of var 0..1: used_colour;     % used_colour[c] = 1 iff the colour c is used
var 0..NUM_NODES: k;                       % the number of used colours


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve item
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve minimize k;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraint 1: Each node should have exactly 1 colour
constraint forall(i in Nodes) (
    sum(j in Nodes) (colour[i, j]) = 1
);


% Constraint 2: Neighbouring nodes cannot have the same colour
% HINT: Try to think about each neighbour pair
constraint forall(i in 1..NUM_EDGES) (
    forall(j in Nodes) (
        colour[edges[i,1], j] + colour[edges[i,2], j] <= 1
    )
);


% Constraint 3: k is the number of used colours
constraint k = sum(c in Nodes) (used_colour[c]);
constraint forall(c in Nodes) (
    used_colour[c] = max(i in Nodes) (colour[i, c])
);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output[show(k)];