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
strategy{5} = generateStrategyThreshold(strategy{2}, strategy{3}, 0.5);

nrStrategies = 5;
S = randi(nrStrategies, N, 1); % use for random strategies
S = [2*ones(N/2,1) ; 3*ones(N/2,1)]; % two strategies against each other
%S = ones(N, 1) * 2;

duration = N * 200;
imitationEpoch = N;
imitationStrength = 1.05;
fullStats = true;

% colors for the different strategies
stratColors = [
    0,   0,   0; %random
    1,   0,   0; %greedy
    0,   1,   0; %altruist
    0.5, 0,   0.5; %cooperative
    0,   0,   1;]; %fair

% origColorOrder = get(gca,'ColorOrder');
%%
%[newA, newpL, newU, statistics]...
%    = iterateGame(S, A, pL, U, duration, strategy, mistakeRate, fullStats);

%[newS, newA, newpL, newU, statistics]...
%    = evolveGame(S, A, pL, U, duration, strategy, imitationEpoch, imitationStrength, mistakeRate);

%sOverTime = zeros(duration, nrStrategies); % distribution of strategies
%uOverTime = zeros(duration, 1); % utility change over time



figure(1);
hold on;
figure(2);
hold on;

for run = 1:10
    [newS, newA, newpL, newU, statistics]...
        = evolveGame(S, A, pL, U, duration, strategy, imitationEpoch, imitationStrength, mistakeRate);
    for s = 1:length(strategy)
        figure(1);
        plot(statistics.time, statistics.strategyDist(:,s), 'color', stratColors(s,:));
        figure(2);
        plot(statistics.time, statistics.meanutil(:,s), 'color', stratColors(s,:));
    end
end

figure(1);
xlim([0 duration]);
xlabel('Time');
ylabel('Proportion');
title('Strategy distribution');
    
figure(2);
xlim([0 duration]);
xlabel('Time');
ylabel('Utility');
title('Mean utility');
    
    
% replace all matrices
%    S = newS;
%    A = newA;
%    pL = newpL;
%    U = newU;
    
    % update plot
%    drawnow;
%end
