function handle = generateStrategyCooperative(b, c)

    handle = @strategyCooperative;

    function [connection, newpL, newU] = strategyCooperative(agent, A, pL, U)
    % Benefit all players who are benefitting me

        N = numel(U);
        % default do nothing
        connection = agent;
        newpL = [];
        newU = [];
        
        team = isfinite(pL(:, agent));
        team(agent) = true;
        bestU = sum(U(team));
        
        % check disconnect from one of the parasites
        parasite = find(A(agent, :) & ~team');
        if ~isempty(parasite)
            connection = parasite(randi(numel(parasite)));
            bestU = bestU + c;
        end
        
        team = find(team);
        
        % find if there are team members I am not following
        check = team(~A(agent, team));
        check(check == agent) = [];
        m = length(check);
        
        if m > 0
            base = pL(1:N+1:end);
            loop = bsxfun(@plus, pL(team, agent)', pL(check, team)) + 1;
            loop = bsxfun(@min, loop, base(team));
            
            if b < 1
                score = sum(b.^loop, 2) - sum(b.^base);
            else
                score = sum(isfinite(loop), 2) - sum(isfinite(base));
            end
            
            check = check(score == max(score));
            check = check(randi(numel(check)));
            
            checkA = A;
            checkA(agent, check) = 1;
            [checkU, checkpL] = utility(checkA);
            if sum(checkU(team)) > bestU
                connection = check;
                newpL = checkpL;
                newU = checkU;
                bestU = sum(checkU(team));
            end
        end

        % check for redundancies
        check = find(A(agent, :));
        m = length(check);
        if m > 0
            score = U(check);
            [~, i] = max(score);

            checkA = A;
            checkA(agent, check(i)) = 0;
            [checkU, checkpL] = utility(checkA);
            if sum(checkU(team)) > bestU
                connection = check(i);
                newpL = checkpL;
                newU = checkU;
            end                
        end
                
    end
end
