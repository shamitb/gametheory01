close all;

N = 30;
A = initialAction(N, 0.05);

beta = 1;
cost = 1;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

strategy{1} = @strategyRandom;
strategy{2} = generateStrategyGreedy(beta, cost);
strategy{3} = generateStrategyAltruist(beta, cost);
strategy{4} = generateStrategyCooperative(beta, cost);


%S = randi(4, N, 1);% .* ones(N, 1);
%S = 4 .* ones(N, 1);
S = 2 * ones(10, 1);
S = [S; 4 * ones(10, 1)];
S = [S; 3 * ones(10, 1)];
% S(1:10) = 2;

plot(digraph(A))
 %%
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

plot(digraph(A))
