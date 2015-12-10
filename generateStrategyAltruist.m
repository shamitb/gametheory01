function handle = generateStrategyAltruist(beta, cost)

    handle = @strategyAltruist;

    function [connection, newA, newpL, newU] = strategyAltruist(agent, A, pL, U)
    % Benefit all players

        N = numel(U);
        
        % original "costless" utility
        % base(i, j) = i's contribution to j's utility
        base = beta.^pL.*(pL~=0);
        
        % only check unconnected
        A(agent, agent) = 1;
        check = find(~A(agent, :));
        m = numel(check);
        A(agent, agent) = 0;
        
        % estimate new pathlength from agent through connection
        pL(pL==0) = inf;
        pathOut = pL(check, :) + 1;
        pathOut = bsxfun(@min, pathOut, pL(agent,:));
        for i = 1:m
            pathOut(i, check(i)) = 1;
        end
        pathOut(pathOut==inf)=0;
        
        % improvement from path out
        helpOut = bsxfun(...
            @minus, beta.^pathOut.*(pathOut~=0), base(agent,:));
        
        % estimate new pathlength through agent to connection
        pathIn = pL(:, agent) + 1;
        pathIn = bsxfun(@min, pathIn, pL(:, check));
        pathIn(agent, :) = 1;
        pathIn(pathIn==inf) = 0;
        pL(pL==inf) = 0;
        
        % improvement from path in
        helpIn = beta.^pathIn.*(pathIn~=0) - base(:, check);
        
        % total improvement
        deltaU = sum(helpOut, 2) + sum(helpIn)' - helpIn(agent, :)';        

        % take best result, randomize if more than one
        best = max(deltaU);
        connection = check(find(deltaU==best));
        connection = connection(randi(numel(connection)));
        
        % compute new move
        checkA = A;
        checkA(agent, connection) = 1 - checkA(agent, connection);
        checkpL = pathLength(checkA);
        checkU = utility(checkA, checkpL);
        
        % use only if better than original
        if sum(checkU) < sum(U)
            connection = agent;
            newA = A;
            newpL = pL;
            newU = U;
        else
            newA = checkA;
            newpL = checkpL;
            newU = checkU;
        end

        % check for redundancies
        check = find(A(agent, :));
        if ~isempty(check)
% heuristic                
            m = numel(check);
            l = max(pL(:)) + 1;
            lengths = zeros(m, l);
            core = pL(check, check) + 1;
            for i = 1:m
                lengths(i, :) = accumarray(core(:,i), 1, [l, 1])';
            end
            lengths = lengths(:, 2:end);
            lengths = lengths + 1e-8 * rand(size(lengths));
            score = lengths * beta.^(1:l-1)';
            [~, i] = max(score);
                
            checkA = A;
            checkA(agent, check(i)) = 0;
            checkpL = pathLength(checkA);
            checkU = utility(checkA, checkpL);
            if mean(checkU) > mean(newU)
                connection = check(i);
                newA = checkA;
                newpL = checkpL;
                newU = checkU;
            end
                
% brute force :( works but ugh
%{
                for i = check(randperm(numel(check)))
                    checkA = A;
                    checkA(agent, i) = 0;
                    checkpL = pathLength(checkA);
                    checkU = utility(checkA, checkpL);
                    if mean(checkU) > bestU
                        newA = checkA;
                        newpL = checkpL;
                        newU = checkU;
                        bestU = sum(checkU);
                    end
                end
%}
        end
        
    end
end
