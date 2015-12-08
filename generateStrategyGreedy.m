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
            kill = A(agent, :);
            switch sum(kill)
                case 0
                    connection = agent;
                case 1
                    if (cost > beta ^ pL(agent, agent))
                        connection = kill;
                    else
                        connection = agent;
                    end
                otherwise
                    kill = find(kill);
                    score = (pL(agent, agent) - 1 == pL(kill, agent)) + rand(size(kill))';
                    [~, i] = min(score);
                    connection = kill(i);
            end
        end
        
        newA = [];
        newpL = [];
        newU = [];

    end
    
end
