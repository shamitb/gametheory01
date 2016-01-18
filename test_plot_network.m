
N = 200;
A = initialAction(N,0.5/N);
%A = initialAction(N, log(N)/N);
%A = cycleNetwork(N);
%A = starNetwork(N);

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
stratInGame = [10];

% fill evenly from startStrategies
S = stratInGame(mod(1:N, length(stratInGame)) + 1);
% scramble and columnize
S = S(randperm(N));
S = S(:);

duration = N * N;
imitationEpoch = N;
imitationStrength = 1.05;
fullStats = false;

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

[newA, newpL, newU, statistics]...
    = iterateGame(S, A, pL, U, duration, strategy, mistakeRate, fullStats);
%}
hasout = any(newA, 2);
hasin = any(newA, 1)';
show = or(hasout, hasin);
show(:) = true;

h = plot(digraph(newA(show, show)), 'edgecolor', [0.7 0.7 0.7]);
for s = stratInGame
    highlight(h, find(S(show)==s), 'NodeColor', stratColors(s,:));
end
layout(h, 'force');
axis off
    
