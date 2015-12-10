function handle = generateStrategyFair(beta, cost)

    handle = @strategyFair;

    function [connection, newA, newpL, newU] = strategyFair(agent, A, pL, U)
        % if any unlooped connections, remove one
        % else if more than one loop, remove one
        % else if loop gives no advantage, remove
        
        beta = 1, cost = 1;
        generateStrategyGreedy(beta, cost);
        
        newA = [];
        newpL = [];
        newU = [];

    end
    
end
