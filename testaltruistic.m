function testaltruistic()

clear all;

N = 10;
A = initialAction(N, 4/N);

beta = 1;
cost = 0.5;


pL = pathLength(A);
U = utility(A, pL, beta, cost);

Uprev = U';

figure(1);
plot(digraph(A))

handle = generateStrategyAltruist(beta, cost);
[connection A, pL, U] = handle(1, A, pL, U);

figure(2);
plot(digraph(A))

Unext = U';

Udiff = Unext - Uprev

% [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 500, false, strategy, 0.05);


end