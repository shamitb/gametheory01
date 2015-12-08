function handle = generateStrategyGreedy(beta, cost)

    handle = @strategyGreedy;

    function [connection, newA, newpL, newU] = strategyGreedy(agent, A, pL, U)
        % if any unlooped connections, remove one
        % else if more than one loop, remove one
        % else if loop gives no advantage, remove
        
        kill = find(A(agent, :) & ~pL(:, agent)');
        
        if any(kill)
            connection = kill(randi(numel(kill)));
        else
            kill = find(A(agent, :));
            switch sum(kill)
                case 0
                    connection = agent;
                case 1
                    if (cost > beta ^ pL(agent, agent))
                        connection = kill;
                    else
                        connection = agent;
                    end
                case 2
                    if beta ^ (pL(kill(1), agent) + rand - 0.5) < beta ^ (pl(kill(2), agent))
                        connection = kill(1);
                    else
                        connection = kill(2);
                    end
                otherwise
                    connection = kill(randi(numel(kill)));                    
            end
        end
        
        newA = [];
        newpL = [];
        newU = [];

    end
    
end
