N = 20;
A = initialAction(N,0.1);
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
strategy{5} = generateStrategyThreshold(strategy{2}, strategy{3}, 0.25);

nrStrategies = 5;
S = randi(nrStrategies, N, 1); % use for random strategies
S = [2*ones(N/2,1) ; 3*ones(N/2,1)]; % two strategies against each other
%S = ones(N, 1) * 2;

duration = N * 2000;
imitationEpoch = N;
imitationStrength = 1.05;
fullStats = true;

% colors for the different strategies
stratColors = [
    1, 0.5, 0; %random
    1, 0, 0; %greedy
    0, 1, 0; %altruist
    0.5, 0, 0.5; %cooperative
    0, 0, 1;]; %fair
origColorOrder = get(gca,'ColorOrder');
set(gca, 'ColorOrder', stratColors, 'NextPlot', 'replacechildren');
%%
%[newA, newpL, newU, statistics]...
%    = iterateGame(S, A, pL, U, duration, strategy, mistakeRate, fullStats);

%[newS, newA, newpL, newU, statistics]...
%    = evolveGame(S, A, pL, U, duration, strategy, imitationEpoch, imitationStrength, mistakeRate);

sOverTime = zeros(duration, nrStrategies); % distribution of strategies
uOverTime = zeros(duration, 1); % utility change over time
figure;
for i=1:duration
    fprintf('Iteration %i \n',i);
    % currently makes a step of t=5 every iteration
    [newS, newA, newpL, newU, statistics]...
        = evolveGame(S, A, pL, U, 5, strategy, imitationEpoch, imitationStrength, mistakeRate);
    
    % set Matlab's default color order
    set(gca, 'ColorOrder', origColorOrder, 'NextPlot', 'replacechildren');
    
    % top left plot
    subplot(2,2,1);
    h = plot(digraph(newA));
    highlight(h, find(S==1), 'NodeColor', stratColors(1,:)); %random
    highlight(h, find(S==2), 'NodeColor', stratColors(2,:)); %greedy
    highlight(h, find(S==3), 'NodeColor', stratColors(3,:)); %altruist
    highlight(h, find(S==4), 'NodeColor', stratColors(4,:)); %cooperative
    highlight(h, find(S==5), 'NodeColor', stratColors(5,:)); %fair
    title('Network');
    
    % top right plot
    subplot(2,2,2);
    [counts,centers] = hist(newS, 1:nrStrategies);
    bar(centers, counts);
    xlim([1,nrStrategies]);
    title('Current strategy distribution');
    
    % bottom left plot
    subplot(2,2,3);
    % change color order to correspond to strategies
    set(gca, 'ColorOrder', stratColors, 'NextPlot', 'replacechildren');
    sOverTime(i,:) = counts; % current iteration's strategy distribution
    plot(sOverTime(1:i,:));
    xlabel('Iteration');
    title('Strategy distribution');
    
    % bottom right plot
    subplot(2,2,4);
    % reset color order to Matlab default
    set(gca, 'ColorOrder', origColorOrder, 'NextPlot', 'replacechildren');
    uOverTime(i) = mean(newU); % avg utility
    plot(uOverTime(1:i,:));
    xlabel('Iteration');
    ylabel('Mean utility');
    title('Mean utility');
    
    
    % replace all matrices
    S = newS;
    A = newA;
    pL = newpL;
    U = newU;
    
    % update plot
    drawnow;
end
