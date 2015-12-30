N = 256;
A = initialAction(N);
mistakeRate = 0.5 / N;
b = 1;
c = 0.5;

for node = 1:N-1
    A(node, node + 1) = 1;
end
A(N, 1) = 1;

[U, pL] = utility(A, [], b, c);

% mistakes
strategy{1} = @strategyRandom;

% primary strategies
strategy{2} = generateStrategyGreedy(b, c);
strategy{3} = generateStrategyAltruist(b);
strategy{4} = generateStrategyCooperative(b, c);

% split strategies
strategy{5} = generateStrategyThreshold(strategy{2}, strategy{3}, 0.25);

%S = sort(randi(3, N, 1) + 1);
S = ones(N, 1) * 2;

duration = N * 200;

fullStats = true;

[newA, newpL, newU, statistics]...
    = iterateGame(S, A, pL, U, duration, strategy, mistakeRate, fullStats);
