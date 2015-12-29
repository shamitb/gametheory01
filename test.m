N = 50;
A = initialAction(N, 1/N);
mistakeRate = 0.5 / N;
b = 1;
c = 1;

[U, pL] = utility(A, [], b, c);

% mistakes
strategy{1} = @strategyRandom;

% primary strategies
strategy{2} = generateStrategyGreedy(b, c);
strategy{3} = generateStrategyAltruist(b);
strategy{4} = generateStrategyCooperative(b, c);

% split strategies
strategy{5} = generateStrategyThreshold(strategy{2}, strategy{3}, 0.5);

S = randi(4, N, 1) + 1;

duration = N * 10;
fullStats = true;

[A, pL, U, statistics]...
    = iterateGame(S, A, pL, U, duration, strategy, mistakeRate, fullStats);
