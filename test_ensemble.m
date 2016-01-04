N = 50;
A = initialAction(N,0.0);
mistakeRate = 0.5 / N;
b = 1;
c = 1;

[U, pL] = utility(A, [], b, c);

% mistakes
strategy{1} = @strategyRandom;
strategyName{1} = '';

% primary strategies
strategy{2} = generateStrategyGreedy(b, c);
strategyName{2} = 'Greedy';
strategy{3} = generateStrategyAltruist(b);
strategyName{3} = 'Altruist';
strategy{4} = generateStrategyCooperative(b, c);
strategyName{4} = 'Cooperative';

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

% populate with indices to use
stratInGame = [2 3];

% fill evenly from startStrategies
S = stratInGame(mod(1:N, length(stratInGame)) + 1);
% scramble and columnize
S = S(randperm(N));
S = S(:);

duration = N * N * 100;
imitationEpoch = N;
imitationStrength = 1.05;

% colors for the different strategies
stratColors = [
    0,    0,    0;    % random
    0.75, 0,    0;    % greedy
    0,    0.75, 0;    % altruist
    0,    0,    0.75; % cooperative
    1,    0.4,  0;    % fair
    0.4,  1,    0;    % anti
    1,    0,    0.4;  % coop fair
    0.4,  0,    1;    % coop anti
    0,    0.4,  1;    % my back
    0,    1,    0.4;  % your back
    ];

maxRuns = 100;
totalWins = zeros(length(stratInGame), 1);
winner = zeros(maxRuns, 1);
flattenmeanutil = zeros(ceil(duration / N), maxRuns, 1+length(stratInGame));
flattendist = zeros(ceil(duration / N), maxRuns, length(stratInGame));

for run = 1:maxRuns
    tic();
    [newS, newA, newpL, newU, statistics]...
        = evolveGame(S, A, pL, U, duration, strategy, imitationEpoch, imitationStrength, mistakeRate);
    statistics.meanutil(isnan(statistics.meanutil)) = 0;
    temp = interp1(...
        statistics.time,...
        statistics.meanutil(:, 1),...
        1:duration, 'previous');
    flattenmeanutil(:, run, 1) = mean(reshape(temp, N, duration / N));
    for s = 1:length(stratInGame)
        flattendist(:, run, s) = interp1(...
            statistics.time,...
            statistics.strategyDist(:, stratInGame(s)),...
            N/2:N:duration, 'previous');
        temp = interp1(...
            statistics.time,...
            statistics.meanutil(:,stratInGame(s)),...
            1:duration, 'previous');
        flattenmeanutil(:, run, s+1) = mean(reshape(temp, N, duration / N));
    end
    
    [~, winner(run)] = max(statistics.strategyDist(end,:));
    winner(run) = find(stratInGame == winner(run));
    totalWins(winner(run)) = totalWins(winner(run)) + 1;
    disp(['Run ' num2str(run) ' of ' num2str(maxRuns) ' complete'])
    toc();
end
totalWins = totalWins / maxRuns


for w = 1:length(stratInGame)
    figure(w);
    plot(N/2:N:duration,...
        mean(flattenmeanutil(:, winner==w, 1), 2),...
        'color', stratColors(1, :));
    hold on;
    for s = 1:length(stratInGame)
        plot(N/2:N:duration,...
            mean(flattenmeanutil(:, winner==w, s+1), 2),...
            'color', stratColors(stratInGame(s), :));
    end
    xlabel('time');
    ylabel('utility');
    title(['Ensemble mean utility ' strategyName{stratInGame(w)} ' wins']);
    drawnow;
    pause(1);
    figure(20 + w);
    hold on;
    for s = 1:length(stratInGame)
        plot(N/2:N:duration,...
            mean(flattendist(:, winner==w, s), 2),...
            'color', stratColors(stratInGame(s), :));
    end
    xlabel('time');
    ylabel('utility');
    title(['Ensemble mean strategy distribution ' strategyName{stratInGame(w)} ' wins']);
    drawnow;
    pause(1);
end
