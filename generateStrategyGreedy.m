function handle = generateStrategyGreedy(beta, cost)

    handle = @strategyGreedy;

    function [connection, newpL, newU] = strategyGreedy(agent, A, pL, U)
        % Always make best move for self
        
        % Current connections
        kill = find(A(agent, :));
        
        % Self value through other node
        loop = pL(:, agent)' + 1;
        loop(agent) = inf;
        gain = beta .^ loop;
        gain(isnan(gain)) = 0;
        
        switch numel(kill)            
            case 0
                % No connections, is there a good connection?
                best = max(gain);
                if best > cost
                    bestIndex = find(gain==best);
                    connection = bestIndex(randi(numel(bestIndex)));
                else
                    connection = agent;
                end
            case 1
                % One connection, is it good?
                if gain(kill) < cost
                    connection = kill;
                else
                    connection = agent;
                end
            otherwise
                % Several connections, don't kill a unique best loop
                critical = loop == pL(agent, agent);
                if sum(critical) == 1
                    if gain(critical) == max(gain(kill))
                        kill(kill==find(critical)) = [];
                    else
                        kill = find(critical);
                    end
                end
                connection = kill(randi(numel(kill)));
        end
        
        newpL = [];
        newU = [];

    end
    
end
