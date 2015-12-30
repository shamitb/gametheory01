function [A, pL, U, statistics]...
    = iterateGame(S, A, pL, U, duration, strategy, mistakeRate, fullStats)

% [A, pL, U, statistics] = 
%     iterateGame(S, A, pL, U, actionCount, imitationEpoch)
% 
% S           - Nx1 vector of agent strategies (required!)
% A           - NxN initial adjacency matrix (default zeros)
% pL          - precomputed NxN path length matrix (default recompute)
% U           - precomputed Nx1 vector of utilities (default recompute)
% duration    - time to proceed
% strategy    - cell array of strategy functions, strategy{1} for mistakes
% mistakeRate - probability of random action (default 0)
% fullStats   - flag for return of full statistics
%
% statistics - table of events

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
        
        % validate duration, default = N
        if ~exist('duration', 'var') ||...
           ~isreal(duration) ||...
           duration < 0
       
            duration = N;
        end
        
        % preallocation for events should be enough 99.9% of the time
        imax = poissinv(0.999, duration);
                
        % validate mistakeRate, default = 0
        if ~exist('mistakeRate', 'var') ||...
           ~isreal(mistakeRate) ||...
           mistakeRate > 1

            mistakeRate = 0;
        end
        
    %% initialize variables
        
        i = 0;
        [from, to] = find(A);
        assortM = accumarray([S(from) S(to)], 1, [M M]);
        
        agent = zeros(imax, 1);
        direction = zeros(imax, 1);     % 1 make, -1 break, 0 else
        mistake = false(imax, 1);
        target = zeros(imax, 1);
        time = zeros(imax, 1);
        util = zeros(imax, N);
        
        unhappy = true(N, 1);           % mask to avoid repeat evaluations

        if fullStats
            inmax = max(sum(A)) + 5;
            outmax = max(sum(A,2)) + 5;
            
            indegree = zeros(imax, inmax);
            outdegree = zeros(imax, outmax);
            
            inin = zeros(imax, 1);
            inout = zeros(imax, 1);
            outin = zeros(imax, 1);
            outout = zeros(imax, 1);
            mixing = zeros(imax, 1);
        end
         
        % start poisson process
        untilAction = -log(rand);
        t = untilAction;
        
    %% main loop        
        while duration > t;

            % select random agent
            i = i + 1;

            % allocate more space
            if i > imax
                imax = imax + ceil(duration - t) + 5;
                agent(imax) = 0;
                direction(imax) = 0;     % 1 make, -1 break, 0 else
                mistake(imax) = 0;
                target(imax) = 0;
                time(imax) = 0;
                util(imax, N) = 0;
                
                if fullStats
                    indegree(imax, 1) = 0;
                    outdegree(imax, 1) = 0;
                    inin(imax) = 0;
                    inout(imax) = 0;
                    outin(imax) = 0;
                    outout(imax) = 0;
                    mixing(imax) = 0;
                end
            end
            
            agent(i) = randi(N);
                            
            % Apply agent's strategy
            if mistakeRate > rand
                [target(i), newpL, newU] = strategy{1}(agent(i), A, pL, U);
                mistake(i) = true;
            elseif unhappy(agent(i))
                [target(i), newpL, newU] = strategy{S(agent(i))}(agent(i), A, pL, U);
            else
                target(i) = agent(i);
            end
            
            unhappy(agent(i)) = false;
                
            if agent(i)~=target(i)
                unhappy(:) = true;
                
                if A(agent(i), target(i))
                    direction(i) = -1;
                else
                    direction(i) = 1;
                end
                    
                A(agent(i), target(i)) =...
                    A(agent(i), target(i)) + direction(i);
                
                if fullStats
                    assortM(S(agent(i)), S(target(i))) =...
                        assortM(S(agent(i)), S(target(i))) + direction(i);
                end
                    
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
            
            if fullStats
                
                mixing(i) = mixingAssortativity(assortM);
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
                
            end
            
            time(i) = t;
            util(i, :) = U;
            
            % advance time
            untilAction = -log(rand);
            t = t + untilAction;
            
        end % while loop
        
        trim = i+1:imax;
        
        agent(trim) = [];
        direction(trim) = [];
        mistake(trim) = [];
        target(trim) = [];
        time(trim) = [];
        util(trim, :) = [];
 
        statistics = table(agent,...
                           direction,...
                           mistake,...
                           target,...
                           time,...
                           util);
        
        if fullStats
            
            indegree(trim,:) = [];
            outdegree(trim,:) = [];
            inin(trim) = [];
            inout(trim) = [];
            outin(trim) = [];
            outout(trim) = [];
            mixing(trim) = [];
            
            details = table(indegree,...
                            outdegree,...
                            inin,...
                            inout,...
                            outin,...
                            outout,...
                            mixing);
            statistics = [statistics details];
        end
    end % if valid strategy
end



