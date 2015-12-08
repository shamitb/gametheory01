close all;

N = 100;
A = initialAction(N, 2/N);

beta = 1;
cost = 1;

strategy = {...
    @strategyRandom,...
    generateStrategyGreedy(beta, cost)};

plot(digraph(A));

for iter = 1:1000
    agent = randi(N);
    pL = pathLength(A);
    U = utility(A, pL, beta, cost);
    c = strategy{2}(agent, A, pL, U);
    if agent~=c
        A(agent, c) = 1 - A(agent, c);
    end
end

figure;
plot(digraph(A));

