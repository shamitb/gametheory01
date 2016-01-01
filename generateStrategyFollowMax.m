function handle = generateStrategyFollowMax(beta, cost)

handle = @strategyFollowMax;

    function [connection, newA, newpL, newU] = strategyFollowMax(agent, A, pL, U)
        % Always make best move for self
        
        % Get the max connection
        maxi = max(U);
        I = find( maxi == U );
        connection = I(randperm(size(I,2), 1));
        
        newA = [];
        newpL = [];
        newU = [];
        
    end

end
