function handle = generateStrategyFair(greedy, altruistic)

handle = @strategyFair;

    function [connection, newA, newpL, newU] = strategyFair(agent, A, pL, U)
        % if any unlooped connections, remove one
        % else if more than one loop, remove one
        % else if loop gives no advantage, remove
        
        beta = 1, cost = 1;
        meanUtil = mean(U);
        if U(agent) < meanUtil
            greedy(agent, A, pL, U);
        else
            altruistic(agent, A, pL, U);
        end
        
        newA = [];
        newpL = [];
        newU = [];
        
    end

end
