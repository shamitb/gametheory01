function [S, A, U, statistics]...
    = iterateGame(S, A, pL, U, eventCount, imitationEpoch, strategy, mistakeRate)
% [S, A, U, statistics] = 
%     iterateGame(S, A, pL, U, actionCount, imitationEpoch)
% 
% S - Nx1 vector of agent strategies (required!)
% A - NxN initial adjacency matrix (default zeros)
% pL - precomputed NxN path length matrix (default recompute)
% U - precomputed Nx1 vector of utilities (default recompute)
%
% eventCount - number of events to proceed (default = N)
% imitationEpoch - average time between imitations or false (default = N)
% mistakeRate - probability of random action
%
% statistics - table of events

    if ~exist('S','var') || isempty(S) || ~exist('strategy', 'var') || isempty(strategy)
    %% if no strategies given return empty results

        S = [];
        A = [];
        U = [];
        SHistory = [];            
        AHistory = [];
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

        % validate LP, default = leastPath(A)
        if ~exist('LP', 'var') ||...
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
        
        % validate eventCount, default = N
        if ~exist('eventCount', 'var') ||...
           ~isreal(eventCount) ||...
           eventCount < 1
       
            eventCount = N;
        end
        
        % validate imitationEpoch, default = N
        if ~exist('imitationEpoch', 'var') ||...
           ~isreal(imitationEpoch)
       
            imitationEpoch = N;
        end
        
        % validate mistakeRate, default = 0
        if ~exist('mistakeRate', 'var') ||...
           ~isreal(mistakeRate)
       
            mistakeRate = 0;
        end
        
    %% initialize variables
        
        i = 0;
        [from, to] = find(A);
        assortM = accumarray([S(from) S(to)], 1, [M M]);
        
        agent = zeros(eventCount, 1);
        agentS = zeros(eventCount, 1);
        assortativity = zeros(eventCount, 1);
        
        direction = zeros(eventCount, 1);     % 1 make, -1 break, 0 else
        imitate = false(eventCount, 1);
        mistake = false(eventCount, 1);
        target = zeros(eventCount, 1);
        targetS = zeros(eventCount, 1);
        time = zeros(eventCount, 1);
        util = zeros(eventCount, N);
        
        if ~imitationEpoch
            imitationEpoch = inf;            
        end
         
        % start poisson process
        t = 0;
        untilAction = -log(rand);
        untilImitate = -log(rand) * imitationEpoch;
        
    %% main loop        
        while eventCount > i

            % select random agent
            i = i + 1;
            agent(i) = randi(N);
            agentS(i) = S(agent(i));
            
            if untilAction < untilImitate
        %% action
                % advance time
                untilImitate = untilImitate - untilAction;
                t = t + untilAction;
                untilAction = -log(rand);
                
                % Apply agent's strategy
                if mistakeRate > rand
                    [target(i), newpL, newU] = strategy{1}(agent(i), A, pL, U);
                    mistake(i) = true;
                else
                    [target(i), newpL, newU] = strategy{S(agent(i))}(agent(i), A, pL, U);
                end
                
                targetS(i) = S(target(i));
                
                if agent(i)~=target(i)
                    
                    if A(agent(i), target(i))
                        direction(i) = -1;
                    else
                        direction(i) = 1;
                    end
                    
                    A(agent(i), target(i)) =...
                        A(agent(i), target(i)) + direction(i);
                    assortM(agentS(i), targetS(i)) =...
                        assortM(agentS(i), targetS(i)) + direction(i);
                    
                    if isempty(newpL)
                        pL = pathLength(A);
                    else
                        pL = newpL;
                    end
                    
                    if isempty(newU)
                        U = utility(A, pL);
                    else
                        U = newU;
                    end
                    
                end
                
            % imitate?
            else
        %% imitation
                
                % advance time
                untilAction = untilAction - untilImitate;
                t = t + untilImitate;
                untilImitate = -log(rand) * imitationEpoch;
                imitate(i) = true;
                
                % utility-weighted selection of new strategy
                w = cumsum(U - min(U));
                target(i) = sum(w < rand * w(end)) + 1;
                targetS(i) = S(target(i));
                
                if agentS(i)~=targetS(i)
                    S(agent(i)) = S(target(i));
                    [from, to] = find(A);
                    assortM = accumarray([S(from) S(to)], 1, [M M]);
                end
                
            end % act or imitate
            
            % calculate strategy assortativity
            e = assortM / sum(assortM(:));
            a = sum(e, 2);
            b = sum(e);
            assortativity(i) = (sum(e(1:M+1:end)) - b * a) / (1 - b * a);
            
            time(i) = t;
            util(i, :) = U;
            
        end % while loop
        
        statistics = table(agent,...
                           agentS,...
                           assortativity,...
                           direction,...
                           imitate,...
                           mistake,...
                           target,...
                           targetS,...
                           time,...
                           util);
    end % if valid strategy
end



