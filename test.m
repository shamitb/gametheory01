close all;

N = 50;
A = initialAction(N, 0.25);

beta = 1;
cost = 0.5;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

strategy = {...
    @strategyRandom,...
    generateStrategyGreedy(beta, cost),...
    generateStrategyAltruist(beta, cost)};

S = 3 * ones(N, 1);
% S(1:10) = 2;

[S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 10000, false, strategy);

heat = accumarray([AHistory(:).agent; AHistory(:).connection]', 1, [N N]);
util = sort([AHistory(:).utility]);
%{
Gheat = digraph(heat);
GA = digraph(A);

Gheat.Edges.LWidth = 7 * mat2gray(Gheat.Edges.Weight)+1;
p = plot(Gheat, 'linewidth', Gheat.Edges.LWidth, 'nodecolor', 'none');
hold on;
X = p.XData; Y = p.YData;

plot(GA, 'nodecdata', S, 'xdata', X, 'ydata', Y);

%}
