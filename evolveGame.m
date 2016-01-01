function [S, A, pL, U, statistics]...
    = evolveGame(S, A, pL, U, duration, strategy, imitationEpoch, imitationStrength, mistakeRate)

% [A, pL, U, statistics] = 
%     iterateGame(S, A, pL, U, actionCount, imitationEpoch)
% 
% S           - Nx1 vector of agent strategies (required!)
% A           - NxN initial adjacency matrix (default zeros)
% pL          - precomputed NxN path length matrix (default recompute)
% U           - precomputed Nx1 vector of utilities (default recompute)
% duration    - time to proceed (default N²)
% strategy    - cell array of strategy functions, strategy{1} for mistakes
% imitationEpoch    - time scale for imitation events (default N)
% imitationStrength - ratio of best/worst utility in roulette wheel 
% mistakeRate - probability of random action (default 0)
%
% statistics - table of imitation events

    if ~exist('S','var') ||...
       isempty(S) ||...
       ~exist('strategy', 'var') ||...
       isempty(strategy)
    %% if no strategies given return empty results

        A = [];
        pL = [];
        U = [];
        statistics = [];

    else
    %% validate inputs
    
        M = length(strategy); % number of strategies
        N = length(S);
        
        % validate A, default = zeros(N)
        if ~exist('A', 'var') ||...
           isempty(A) ||...
           any(size(A)~=[N N])
       
            A = sparse(N, N);
            pL = zeros(N);
            U = zeros(N, 1);
        end

        % validate pL, default = leastPath(A)
        if ~exist('pL', 'var') ||...
           isempty(pL) ||...
           any(size(pL)~=[N N])
       
            pL = pathLength(A);
        end
        
        % validate U, default = utility(A)
        if ~exist('U', 'var') ||...
           isempty(U) ||...
           any(size(U)~=[N 1])
       
            U = utility(A, pL);
        end
        
        % validate duration, default = N²
        if ~exist('duration', 'var') ||...
           ~isreal(duration) ||...
           duration < 0
       
            duration = N * N;
        end
        
        % validate imitationEpoch, default = N
        if ~exist('imitationEpoch', 'var') ||...
           ~isreal(imitationEpoch) ||...
           imitationEpoch < 1
       
            imitationEpoch = N;
        end
        
        % validate imitationStrength, default = N
        if ~exist('imitationStrength', 'var') ||...
           ~isreal(imitationStrength) ||...
           imitationStrength < 1 || isinf(imitationStrength)
       
            imitationStrength = N;
        end
                        
        % validate mistakeRate, default = 0
        if ~exist('mistakeRate', 'var') ||...
           ~isreal(mistakeRate) ||...
           mistakeRate > 1

            mistakeRate = 0;
        end
        
    %% initialize variables

        % preallocation for events
        imax = ceil(duration / imitationEpoch) + 5;
        
        i = 1;
        
        strategyDist = zeros(imax, M);
        strategyImitated = zeros(imax, 1);  % strategy imitated
        time = zeros(imax, 1);
        util = zeros(imax, 5 * M);

        inmax = max(sum(A)) + 5;
        outmax = max(sum(A,2)) + 5;

        indegree = zeros(imax, inmax);
        outdegree = zeros(imax, outmax);
            
        inin = zeros(imax, 1);
        inout = zeros(imax, 1);
        outin = zeros(imax, 1);
        outout = zeros(imax, 1);
        mixing = zeros(imax, 1);
         
        % start poisson process
        t = 0;
        
    %% main loop        
        while duration > t
            
            if t > 0
                % imitate
                agent = randi(N);
                
                w = U - min(U);
                w = w + max(w) / (imitationStrength - 1);
                w = cumsum(w);
                target = sum(w < rand * w(end)) + 1;
                
                % record strategy change
                curStrategyDist(S(agent)) =...
                    curStrategyDist(S(agent)) - 1 / N;
                curStrategyDist(S(target)) =...
                    curStrategyDist(S(target)) + 1 / N;
                strategyImitated(i) = S(target);
                S(agent) = strategyImitated(i);
                    
            else
                curStrategyDist = accumarray(S, 1, [M 1])' / N;
            end
            
            strategyDist(i, :) = curStrategyDist;
            
            % next event, limited to duration
            actionDuration = min(-log(rand) * imitationEpoch, duration - t);
            
            [A, pL, U, actionStatistics] = iterateGame(S, A, pL, U, actionDuration, strategy, mistakeRate, false);
            
            if isempty(actionStatistics)
                actionStatistics.util = U';
            end
            util(i, 1:5) = fivenum(actionStatistics.util);
            for s = 2:M
                util(i, (1:5) + s * 5 - 5) =...
                    fivenum(actionStatistics.util(:, S==s));
            end
            t = t + actionDuration;
            time(i) = t;
            
            mixing(i) = mixingAssortativity(A, S);
            [inin(i), inout(i), outin(i), outout(i), inD, outD] =...
                degreeAssortativity(A);
                
            ink = length(inD);
            outk = length(outD);
                
            if ink > inmax
                inmax = ink + 1;
                indegree(imax, inmax) = 0;
            end
            indegree(i, 1:ink) = inD;
            
            if outk > outmax
                outmax = outmax + 1;
                outdegree(imax, outmax) = 0;
            end
            outdegree(i, 1:outk) = outD;
            
            
            i = i + 1;
            
        end % while loop
        if i > 1
            trim = i:imax;
        
            strategyDist(trim, :) = [];
            strategyImitated(trim, :) = [];
            time(trim) = [];
            util(trim, :) = [];

            indegree(trim,:) = [];
            outdegree(trim,:) = [];
            inin(trim) = [];
            inout(trim) = [];
            outin(trim) = [];
            outout(trim) = [];
            mixing(trim) = [];
 
            statistics = table(strategyDist,...
                               strategyImitated,...
                               time,...
                               util,...
                               indegree,...
                               outdegree,...
                               inin,...
                               inout,...
                               outin,...
                               outout,...
                               mixing);
            
        else
            statistics = [];
        end

    end % if valid strategy
end



