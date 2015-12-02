
close all;
% Follower's Game

NUM_PLAYERS = 10;
A = randi([0 1], NUM_PLAYERS, NUM_PLAYERS);
A = A.*(eye(NUM_PLAYERS)==0);
score = zeros(NUM_PLAYERS,1);
cost = 1; % cost
beta = 1;

NUM_ITER = 5;


for i = 1 : NUM_ITER
    pL = pathLength(A);
    
    score = utility(A, pL, beta, cost);
end

A
score


plot(digraph(A))
