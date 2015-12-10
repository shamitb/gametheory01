function handle = generateStrategyAltruist(beta, cost)

    handle = @strategyAltruist;

    function [connection, newA, newpL, newU] = strategyAltruist(agent, A, pL, U)
    % Benefit all players
    % Does not compute result
        N = numel(U);
        base = beta.^pL.*(pL~=0);
        
        pL(pL==0) = inf;
        pathOut = pL + 1;
        pathOut = bsxfun(@min, pathOut, pL(agent,:));
        self = pathOut(agent, agent);
        pathOut(1:N+1:end)=1;
        pathOut(agent, agent) = self;
        pathOut(pathOut==inf)=0;
        helpOut = bsxfun(...
            @minus, beta.^pathOut.*(pathOut~=0), base(agent,:));
        
        pathIn = pL(:, agent) + 1;
        pathIn = bsxfun(@min, pathIn, pL);
        pathIn(agent, :) = 1;
        pathIn(:, agent) = pL(:, agent);
        pathIn(pathIn==inf) = 0;
        helpIn = beta.^pathIn.*(pathIn~=0) - base;
        
        deltaU = sum(helpOut, 2) + sum(helpIn)' - helpIn(agent, :)' - cost;

        best = max(deltaU);
        pL(pL==inf) = 0;

        connection = find(deltaU==best);
        connection = connection(randi(numel(connection)));
        
        checkA = A;
        checkA(agent, connection) = 1 - checkA(agent, connection);
        checkpL = pathLength(checkA);
        checkU = utility(checkA, checkpL);
        
        % never make negative move
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
            score = lengths * 0.5.^(1:l-1)';
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
