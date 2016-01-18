function handle = generateStrategyGreedy(beta, cost)

    handle = @strategyGreedy;

    function [connection, newpL, newU] = strategyGreedy(agent, A, pL, U)
        % Always make best move for self
        
        % Current connections
        connected = A(agent, :) > 0;
        
        % Change in utility, start with cost of following
        deltaU = cost * connected - cost * ~connected;
        
        % Self value through other node
        loop = pL(:, agent)' + 1;

        if isfinite(pL(agent, agent))
            % Critical nodes are equal to current loop
            critical = (loop == pL(agent, agent)) & connected;

            % If tightest loop is unique, subtract from utility
            if nnz(critical) == 1
                deltaU(critical) = deltaU(critical) - beta .^ pL(agent, agent);
                % If next tightest exists, add to utility
                if any(~critical & connected)
                    nextbest = max(beta .^ loop(~critical & connected));
                    deltaU(critical) = deltaU(critical) + nextbest;
                end
            end
        end
        
        % Shorter available loops
        shorter = loop < pL(agent, agent) & ~connected;
        deltaU(shorter) = deltaU(shorter) - beta .^ pL(agent, agent)...
            + beta .^ loop(shorter);
        
        deltaU(agent) = 0;
        
        [~, connection] = max(deltaU);
        connection = connection(randi(numel(connection)));
        
        newpL = [];
        newU = [];

    end
    
end
