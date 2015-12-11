function handle = generateStrategyGreedy(beta, cost)

    handle = @strategyGreedy;

    function [connection, newA, newpL, newU] = strategyGreedy(agent, A, pL, U)
        % if any unlooped connections, remove one
        % else if more than one loop, remove one
        % else if loop gives no advantage, remove
        
        kill = find(A(agent, :));
        loop = pL(kill, agent) + 1;
        loop(loop == 1) = inf;
        switch numel(kill)
            case 0
                connection = agent;
            case 1
                if loop==inf || (cost > beta ^ loop)
                    connection = kill;
                else
                    connection = agent;
                end
            case 2
                connection = kill(2 - issorted(beta .^ (loop+rand(2,1))));
            otherwise
                critical = loop == pL(agent, agent);
                if sum(critical) == 1
                    kill(critical) = [];
                end
                connection = kill(randi(numel(kill)));
        end
        
        newA = A;
        newA(agent, connection) = 0;
        newpL = pathLength(newA);
        newU = utility(newA, newpL);

    end
    
end
