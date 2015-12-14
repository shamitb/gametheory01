%%
close all;

beta = 1;
cost = 1;

% Primary strategies
strategy{1} = @strategyRandom;
strategy{2} = generateStrategyGreedy(beta, cost);
strategy{3} = generateStrategyAltruist(beta, cost);
strategy{4} = generateStrategyCooperative(beta, cost);

% 50% Split strategies, switches when utility > population average
%      fair = greedy/altruist
strategy{5} = generateStrategyFair(strategy{2}, strategy{3});

%     fair2 = greedy/cooperative
strategy{6} = generateStrategyFair(strategy{2}, strategy{4});

%  antifair = altruist/greedy
strategy{7} = generateStrategyFair(strategy{3}, strategy{2});

%     eager = altruist/cooperative
strategy{8} = generateStrategyFair(strategy{3}, strategy{4});

% antifair2 = cooperative/fair
strategy{9} = generateStrategyFair(strategy{4}, strategy{2});

%   conserve = cooperative/altruist
strategy{10} = generateStrategyFair(strategy{4}, strategy{3});

%% Greedy demo

N = 20;
S = 2 * ones(N, 1);
A = initialAction(N, 4/N);

pL = pathLength(A);
U = utility(A, pL, beta, cost);

P = plot(digraph(A), 'nodecdata', S);
drawnow;

for iter = 1:200
    x = P.XData; y = P.YData;
    [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 1, false, strategy, 0.0);
    P = plot(digraph(A), 'layout', 'force', 'xstart', x, 'ystart', y, 'Iterations', 1, 'nodecdata', S);
    drawnow;
end

pause()

%% Altruist demo

N = 20;
S = 3 * ones(N, 1);
A = initialAction(N, 1/N);

pL = pathLength(A);
U = utility(A, pL, beta, cost);

P = plot(digraph(A), 'nodecdata', S);
drawnow;

for iter = 1:200
    x = P.XData; y = P.YData;
    [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 1, false, strategy, 0.0);
    P = plot(digraph(A), 'layout', 'force', 'xstart', x, 'ystart', y, 'nodecdata', S);
    drawnow;
end

pause()

%% Altruist & greedy demo

N = 20;
S = 3 * ones(N, 1);
S(1:8) = 2;
A = initialAction(N, 1/N);

pL = pathLength(A);
U = utility(A, pL, beta, cost);

P = plot(digraph(A), 'nodecdata', S);
drawnow;

for iter = 1:200
    x = P.XData; y = P.YData;
    [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 1, false, strategy, 0.0);
    P = plot(digraph(A), 'layout', 'force', 'xstart', x, 'ystart', y, 'nodecdata', S);
    drawnow;
end

pause()

%% Cooperative demo
 
N = 20; 
S = 4 * ones(N, 1);
A = initialAction(N, 2/N);
%A(1:10,11:20) = 0;
%A(11:20,1:10) = 0;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

P = plot(digraph(A), 'nodecdata', S);
drawnow;

for iter = 1:200
    x = P.XData; y = P.YData;
    [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 1, false, strategy, 0.0);
    P = plot(digraph(A), 'layout', 'force', 'xstart', x, 'ystart', y, 'nodecdata', S);
    drawnow;
end

pause()

%% Cooperative & Greedy demo

N = 20;
S = 4 * ones(N, 1);
S(1:3:end) = 2;
A = initialAction(N, 2/N);
A(1:10,11:20) = 0;
A(11:20,1:10) = 0;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

P = plot(digraph(A), 'nodecdata', S);
drawnow;

for iter = 1:200
    x = P.XData; y = P.YData;
    [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 1, false, strategy, 0.0);
    P = plot(digraph(A), 'layout', 'force', 'xstart', x, 'ystart', y, 'nodecdata', S);
    drawnow;
end

pause()

%% Cooperative & Greedy & Altruist demo

N = 20;
S = 4 * ones(N, 1);
S(20) = 3;
S(1:3:end) = 2;
A = initialAction(N, 2/N);
A(1:10,11:20) = 0;
A(11:20,1:10) = 0;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

P = plot(digraph(A), 'nodecdata', S);
drawnow;

for iter = 1:200
    x = P.XData; y = P.YData;
    [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 1, false, strategy, 0.0);
    P = plot(digraph(A), 'layout', 'force', 'xstart', x, 'ystart', y, 'nodecdata', S);
    drawnow;
end

%heat = accumarray([AHistory(:).agent; AHistory(:).connection]', 1, [N N]);
%util = sort([AHistory(:).utility]);

%{
Gheat = digraph(heat);
GA = digraph(A);

Gheat.Edges.LWidth = 7 * mat2gray(Gheat.Edges.Weight)+1;
p = plot(Gheat, 'linewidth', Gheat.Edges.LWidth, 'nodecolor', 'none');
hold on;
X = p.XData; Y = p.YData;

plot(GA, 'nodecdata', S, 'xdata', X, 'ydata', Y);

%}

%plot(digraph(A))
