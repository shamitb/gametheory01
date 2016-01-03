function handle = generateStrategyFollowMax(beta, cost)

handle = @strategyFollowMax;

    function [connection, newA, newpL, newU] = strategyFollowMax(agent, A, pL, U)
        % Always make best move for self
        
        % Get the max connection
        maxi = max(U);
        I = find( maxi == U )
        
        index = randperm(size(I,2), 1);
        connection = I(index)
        
        while(length(I) > 1)
            
            if A(agent, connection) == 1
                I(index) = [];
                index = randperm(size(I,2), 1);
                connection = I(index)
            else
                break;
            end
        end
        
        
        newA = [];
        newpL = [];
        newU = [];
        
    end

end
