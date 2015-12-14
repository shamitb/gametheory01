function [S, A, U, SHistory, AHistory]...
    = iterateGame(S, A, pL, U, actionCount, imitationEpoch, strategy, mistakeRate)
% [S, A, U, SHistory, AHistory] = iterateGame(S, A, pL, U,
% actionCount, imitationEpoch)
% 
% S - Nx1 vector of agent strategies (required!)
% A - NxN initial adjacency matrix (default zeros)
% pL - precomputed NxN path length matrix (default recompute)
% U - precomputed Nx1 vector of utilities (default recompute)
% actionCount - number of actions to take (default = N)
% imitationEpoch - average time between imitations or false (default = N)
%
% SHistory - struct list of strategy changes, (agent, strategy, time)
% AHistory - struct list of actions (agent, connection, utility, time)

    if ~exist('S','var') || isempty(S) || ~exist('strategy', 'var') || isempty(strategy)
    %% if no strategies given return empty results

        S = [];
        A = [];
        U = [];
        SHistory = struct('agent', {}, 'strategy', {}, 'time', {});            
        AHistory = struct('agent', {}, 'connection', {}, 'time', {});

    else
    %% validate inputs
        N = length(S);
        
        % validate A, default = zeros(N)
        if ~exist('A', 'var') || isempty(A) || any(size(A)~=[N N])
            A = sparse(N, N);
            pL = zeros(N);
            U = zeros(N, 1);
        end

        % validate LP, default = leastPath(A)
        if ~exist('LP', 'var') || isempty(pL) || any(size(pL)~=[N N])
            pL = pathLength(A);
        end
        
        % validate U, default = utility(A)
        if ~exist('U', 'var') || isempty(U) || any(size(U)~=[N 1])
            U = utility(A, pL);
        end
        
        % validate actionCount, default = N
        if ~exist('actionCount', 'var') || ~isreal(actionCount)
            actionCount = N;
        end
        
        % validate imitationEpoch, default = N
        if ~exist('imitationEpoch', 'var') || ~isreal(imitationEpoch)
            imitationEpoch = N;
        end
        
        % validate mistakeRate, default = 0
        if ~exist('mistakeRate', 'var') || ~isreal(mistakeRate)
            mistakeRate = 0;
        end
        
    %% initialize variables
        
        actionIndex = 0;
        imitationIndex = 0;
        
        if imitationEpoch
            % preallocate strategy history
            SHistory(ceil(actionCount / imitationEpoch) + 10) = struct(...
                'agent', [], 'strategy', [], 'time', []);
        else
            % empty strategy history
            imitationEpoch = inf;
            SHistory = struct('agent', {}, 'strategy', {}, 'time', {});            
        end
        
        % preallocate action history
        AHistory(actionCount) =...
            struct('agent', [], 'connection', [], 'utility', [], 'time', []);
        
        % start poisson process
        t = 0;
        untilAction = -log(rand);
        untilImitate = -log(rand) * imitationEpoch;
        
    %% main loop        
        while actionCount > actionIndex
            
            % select random agent
            agent = randi(N);
            
            if untilAction < untilImitate
        %% action
                % advance time
                untilImitate = untilImitate - untilAction;
                t = t + untilAction;
                untilAction = -log(rand);
                actionIndex = actionIndex + 1;
                
                % Apply agent's strategy
                if mistakeRate==0 || mistakeRate < rand
                    [connection, newA, newpL, newU] = strategy{S(agent)}(agent, A, pL, U);
                else
                    [connection, newA, newpL, newU] = strategy{1}(agent, A, pL, U);
                end
                
                if connection ~= agent
                    
                    % Update A
                    A(agent, connection) = 1 - A(agent, connection);
                    
                    % Compute pL if needed
                    if isempty(newpL)
                        pL = pathLength(A);
                    else
                        pL = newpL;
                    end
                    
                    % Compute U if needed
                    if isempty(newU)
                        U = utility(A, pL);
                    else
                        U = newU;
                    end
                    
                    % Record utility in history
                    AHistory(actionIndex).utility = U;
                    
                end
                
                % Record action in history
                AHistory(actionIndex).agent = agent;
                AHistory(actionIndex).connection = connection;
                AHistory(actionIndex).time = t;
                
            % imitate?
            else
        %% imitation
                
                % advance time
                untilAction = untilAction - untilImitate;
                t = t + untilImitate;
                untilImitate = -log(rand) * imitationEpoch;
                imitationIndex = imitationIndex + 1;
                
                % utility-weighted selection of new strategy
                w = cumsum(U) - min(U);
                rolemodel = sum(w < rand * w(end)) + 1;
                S(agent) = S(rolemodel);
                SHistory(imitationIndex).agent = agent;
                SHistory(imitationIndex).strategy = S(agent);
                SHistory(imitationIndex).time = t;
                
            end % act or imitate
                        
        end % while loop

        SHistory=SHistory(1:imitationIndex);

    end % if valid strategy
end



