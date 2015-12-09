close all;

N = 1000;
A = initialAction(N, 2/N);

beta = 1;
cost = 1;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

strategy = {...
    @strategyRandom,...
    generateStrategyGreedy(beta, cost)};

S = 2 * ones(N, 1);
S(rand(N, 1) < 0.1) = 1;


[S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 10000, false, strategy);

heat = accumarray([AHistory(:).agent; AHistory(:).connection]', 1, [N N]);
util = sort([AHistory(:).utility]);

