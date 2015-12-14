function test()

close all;

N = 50;
A = initialAction(N, 4/N);

beta = 1;
cost = 1;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

strategy{1} = @strategyRandom;
strategy{2} = generateStrategyGreedy(beta, cost);
strategy{3} = generateStrategyAltruist(beta, cost);
strategy{4} = generateStrategyFair(strategy{2}, strategy{3});
strategy{5} = generateStrategyCooperative(beta, cost);

S = 2 * ones(N, 1);
%S = randi(5, N, 1);% .* ones(N, 1);
%S(1:10) = 2;

connectsArray = [];
for iter = 1:500
    [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U, 1, false, strategy, 0.05);
    connectsArray = [connectsArray sum(sum(A,1)'+sum(A,2)-diag(A))/N];
    plot(digraph(A));
    s = 'Epoch: ';
    s = strcat(s, num2str(actionIndex));
    title(s);
    drawnow
end

plot(connectsArray);
title('Node degree over time');
xlabel('Epoch') % x-axis label
ylabel('Avg Node Degree') % y-axis label
    

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

%plot(digraph(A))
end
