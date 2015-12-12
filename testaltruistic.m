function testaltruistic()

clear all;

N = 20;

maxTrials = 30;
Ucummulative = zeros(1, N);

A = initialAction(N, 0.1);

beta = 1;
cost = 0.5;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

sumUprev = sum(U);

%     figure(1);
%     plot(digraph(A))
utilitySet = [];
for i = 1 : N
    Atemp = A;
    Atemp(1, i) = 1;
    temppL = pathLength(Atemp);
    U1 = utility(Atemp, temppL, beta, cost);
    utilitySet = [utilitySet sum(U1)];
end

for i = 1 : N
    Atemp = A;
    Atemp(1, i) = 0;
    temppL = pathLength(Atemp);
    U1 = utility(Atemp, temppL, beta, cost);
    utilitySet = [utilitySet sum(U1)];
end

handle = generateStrategyAltruist(beta, cost);
[connection A, pL, U] = handle(1, A, pL, U);

utilitySet = utilitySet - sumUprev

%     figure(2);
%     plot(digraph(A))

sumUnext = sum(U);

Udiff = sumUnext - sumUprev



%     for i= 1:maxTrials
%     Ucummulative = Ucummulative + Udiff;
%
% end
%
% UDiffAvg = Ucummulative/maxTrials

% [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 500, false, strategy, 0.05);


end
