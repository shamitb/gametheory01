close all;
clear all;

N = 40;
A = initialAction(N,0.1);
mistakeRate = 0.5 / N;
b = 1;
c = 1;

t = 5;

[U, pL] = utility(A, [], b, c);

% mistakes
strategy{1} = @strategyRandom;

% primary strategies
strategy{2} = generateStrategyGreedy(b, c);
strategy{3} = generateStrategyAltruist(b);
strategy{4} = generateStrategyCooperative(b, c);

% split strategies
strategy{5} = generateStrategyThreshold(strategy{2}, strategy{3}, 0.5);
strategyName{5} = 'Fair';
strategy{6} = generateStrategyThreshold(strategy{3}, strategy{2}, 0.5);
strategyName{6} = 'Anti-fair';
strategy{7} = generateStrategyThreshold(strategy{2}, strategy{4}, 0.5);
strategyName{7} = 'Cooperatively fair';
strategy{8} = generateStrategyThreshold(strategy{4}, strategy{2}, 0.5);
strategyName{8} = 'Cooperatively anti-fair';
strategy{9} = generateStrategyThreshold(strategy{4}, strategy{3}, 0.5);
strategyName{9} = 'Scratch my back';
strategy{10} = generateStrategyThreshold(strategy{3}, strategy{4}, 0.5);
strategyName{10} = 'Scratch your back';

nrStrategies = 10;
S = randi(nrStrategies, N, 1); % use for random strategies
%S = [2*ones(N/2,1) ; 3*ones(N/2,1)]; % two strategies against each other
%S = ones(N, 1) * 2;

duration = N * 2000;
imitationEpoch = N;
imitationStrength = 1.05;
fullStats = true;

% colors for the different strategies
stratColors = [
    0,    0,    0;    % random      1
    0.75, 0,    0;    % greedy      2
    0,    0.75, 0;    % altruist    3
    0,    0,    0.75; % cooperative 4
    1,    0.4,  0;    % fair        5
    0.4,  1,    0;    % anti        6
    1,    0,    0.4;  % coop fair   7
    0.4,  0,    1;    % coop anti   8
    0,    0.4,  1;    % my back     9
    0,    1,    0.4;  % your back   10
    ];
origColorOrder = get(gca,'ColorOrder');
set(gca, 'ColorOrder', stratColors, 'NextPlot', 'replacechildren');
close;

%% All Greedy - no dynamics
S = 2*ones(N,1);
mistakeRate = 0;
imitationEpoch = inf;

%% All Altruistic - no dynamics
A = initialAction(N,0);
[U, pL] = utility(A, [], b, c);
t = 10;

S = 3*ones(N,1);
mistakeRate = 0.5 / N;
imitationEpoch = inf;

%% Greedy vs Altruist - dynamics turned off
A = initialAction(N,0);
[U, pL] = utility(A, [], b, c);

S = mod(1:N, 2)' + 2;
mistakeRate = 0.5 / N;
imitationEpoch = inf;

%% Greedy vs Altruist - dynamics turned on
A = initialAction(N,0);
[U, pL] = utility(A, [], b, c);

S = mod(1:N, 2)' + 2;
t = 60;
mistakeRate = 0.5 / N;
imitationEpoch = N;

%% Greedy vs Altruist vs Coop - dynamics turned off  (kinda interesting)
A = initialAction(N,0);
[U, pL] = utility(A, [], b, c);

S = mod(1:N, 3)' + 2;
mistakeRate = 0.5 / N;
imitationEpoch = inf;

%% Greedy vs Altruist vs Coop - dynamics turned on
A = initialAction(N,0);
[U, pL] = utility(A, [], b, c);

S = mod(1:N, 3)' + 2;
t = 60;
mistakeRate = 0.5 / N;
imitationEpoch = N;

%% Coalition flower - dynamics turned off
b = 0.9;
c = 0.8;
strategy{2} = generateStrategyGreedy(b, c);
strategy{3} = generateStrategyAltruist(b);
A = initialAction(N,0);
[U, pL] = utility(A, [], b, c);
t = 10;

S = 2*ones(N,1);
S(1) = 3;
%mistakeRate = 0.5 / N;
mistakeRate = 0;
imitationEpoch = inf;

%% Coalition loop - dynamics turned off
b = 1;
c = 0.9;
strategy{2} = generateStrategyGreedy(b, c);
strategy{3} = generateStrategyAltruist(b);
A = initialAction(N,0);
[U, pL] = utility(A, [], b, c);
t = 5;

S = 3*ones(N,1);
%mistakeRate = 0.5 / N;
mistakeRate = 0;
imitationEpoch = inf;

%% All vs all - dynamics turned on
S = mod(1:N, nrStrategies-1)' + 2;
t = 20;
mistakeRate = 0.5 / N;
imitationEpoch = N;

%% ************ SIMULATION ***************
sOverTime = zeros(duration, nrStrategies); % distribution of strategies
uPopOverTime = zeros(duration, 1); % population utility change over time
uOverTime = zeros(duration, nrStrategies); % utility change over time
figure('Position', get(0, 'ScreenSize'));
subplot(2,2,1);
P = plot(digraph(A), 'nodecdata', S);
for i=1:duration
    fprintf('Iteration %i \n',i);
    % currently makes a step of t=5 every iteration
    [newS, newA, newpL, newU, statistics]...
        = evolveGame(S, A, pL, U, t, strategy, imitationEpoch, imitationStrength, mistakeRate);
    
    % set Matlab's default color order
    set(gca, 'ColorOrder', origColorOrder, 'NextPlot', 'replacechildren');
    
    % top left plot
    subplot(2,2,1);
    if isvalid(P)
        x = P.XData; y = P.YData;
    end
    %h = plot(digraph(newA));
    P = plot(digraph(newA), 'layout', 'force', 'xstart', x, 'ystart', y, 'Iterations', 50);
    for j=1:nrStrategies
        highlight(P, find(S==j), 'NodeColor', stratColors(j,:));
    end
    title('Network');
    
    % bottom left plot
    subplot(2,2,3);
    [counts,centers] = hist(newS, 1:nrStrategies);
%     hold off;
%     h = bar(1, counts(1));
%     set(h, 'FaceColor', stratColors(j,:));
%     hold on;
%     for j=2:numel(counts)
%         h = bar(j, counts(j));
%         set(h, 'FaceColor', stratColors(j,:));
%     end
%     hold off;
    bar(centers, counts);
    xlim([1,nrStrategies]);
    title('Current strategy distribution');
    
    % top right plot
    subplot(2,2,2);
    % change color order to correspond to strategies
    set(gca, 'ColorOrder', stratColors, 'NextPlot', 'replacechildren');
    sOverTime(i,:) = counts; % current iteration's strategy distribution
    plot(sOverTime(1:i,:));
    xlabel('Iteration');
    title('Strategy distribution');
    
    % bottom right plot
    subplot(2,2,4);
    uPopOverTime(i) = mean(newU); % avg utility
    for j=1:nrStrategies
        uOverTime(i,j) = mean(newU(newS==j));
    end
    uOverTime(i,isnan(uOverTime(i,:))) = 0;
    % change color order to correspond to strategies
    set(gca, 'ColorOrder', stratColors, 'NextPlot', 'replacechildren');
    plot(uOverTime(1:i,:));
    hold on;
    plot(uPopOverTime(1:i,:), 'k');
    xlabel('Iteration');
    ylabel('Mean utility');
    title('Mean utility');
    
    % reset color order to Matlab default
    set(gca, 'ColorOrder', origColorOrder, 'NextPlot', 'replacechildren');
    
    
    % replace all matrices
    S = newS;
    A = newA;
    pL = newpL;
    U = newU;
    
    % update plot
    drawnow;
end
