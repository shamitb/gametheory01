close all;

N = 100;
A = initialAction(N, 1/N);

beta = 1;
cost = 1;

pL = pathLength(A);
U = utility(A, pL, beta, cost);
mean(U)

strategy = {...
    @strategyRandom,...
    generateStrategyGreedy(beta, cost),...
    generateStrategyAltruist(beta, cost)};

S = [ones(N/2,1)*3;ones(N/2,1)*2];

[S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 100, false, strategy);
mean(U)

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
