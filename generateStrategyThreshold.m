function handle = generateStrategyThreshold(below, above, threshold)

handle = @strategyThreshold;

    function [connection, newpL, newU] = strategyThreshold(agent, A, pL, U)
        
        N = length(U);
        betterThan = sum(U(agent) > U);
        if betterThan < threshold * N
            [connection, newpL, newU] = below(agent, A, pL, U);
        else
            [connection, newpL, newU] = above(agent, A, pL, U);
        end
       
    end

end
