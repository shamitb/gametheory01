function [S, A, U, SHistory, AHistory, UHistory]...
    = iterateGame(S, A, pL, U, actionCount, imitationEpoch)
% [S, A, U, SHistory, AHistory, UHistory] = iterateGame(S, A, pL, U,
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
% AHistory - struct list of actions (agent, connection, time)
% UHistory - struct list of utilities (agent, utility, time)

    if ~exist('S','var') || isempty(S)
    %% if no strategies given return empty results

        S = [];
        A = [];
        U = [];
        SHistory = struct('agent', {}, 'strategy', {}, 'time', {});            
        AHistory = struct('agent', {}, 'connection', {}, 'time', {});
        UHistory = struct('agent', {}, 'utility', {}, 'time', {});
        
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
        
        % preallocate action and utility histories
        AHistory(actionCount) =...
            struct('agent', [], 'connection', [], 'time', []);
        UHistory(actionCount) =...
            struct('agent', [], 'utility', [], 'time', []);
        
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
                
                % TODO: do strategy
                display('Action')
                
                % Common strategy function interface
                doStrategy(agent, S, A, U,1,1);
                
            % imitate?
            else
        %% imitation
                
                % advance time
                untilAction = untilAction - untilImitate;
                t = t + untilImitate;
                untilImitate = -log(rand) * imitationEpoch;
                imitationIndex = imitationIndex + 1;
                
                %TODO: do imitation
                display('Imitate')
                
            end % act or imitate
        end % while loop                
    end % if valid strategy
end



