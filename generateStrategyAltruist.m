function handle = generateStrategyAltruist(b)
    % Always choose to improve total score

    if b < 1
        handle = @strategyAltruist;
    else
        handle = @strategyAltruistEasy;
    end

    function [connection, newpL, newU] = strategyAltruist(agent, A, pL, U)
    
        N = length(U);
        connection = agent;
        newpL = pL;
        newU = U;
        
        % original "costless" utility
        % base(i, j) = i's contribution to j's utility
        base = b.^pL;
                
        % estimate new pathlength from agent through connection
        pathOut = bsxfun(@min, pL + 1, pL(agent,:));
        pathOut(1:N+1:end) = 1;
        pathOut(agent, :) = inf;
        
        % improvement from path out
        helpOut = bsxfun(...
            @minus, b.^pathOut, base(agent,:));
        
        % estimate new pathlength through agent to connection
        pathIn = bsxfun(@min, pL(:, agent) + 1, pL);
        pathIn(agent, :) = 1;
        pathIn(:, agent) = inf;
        
        % improvement from path in
        helpIn = b.^pathIn - base;
        
        % total improvement
        deltaU = sum(helpOut, 2) + sum(helpIn)';        

        % take best result, randomize if more than one
        check = find(deltaU==max(deltaU));
        check = check(randi(numel(check)));
        
        % compute new move
        if A(agent, check)==0
            checkA = A;
            checkA(agent, check) = 1;
            [checkU, checkpL] = utility(checkA);
            if sum(checkU) > sum(newU)
                newpL = checkpL;
                newU = checkU;
                connection = check;
            end
        end
        
        % check for redundancies
        check = find(A(agent, :));
        m = length(check);
        if m > 0
%{
            maxLength = max(pL(isfinite(pL))) + 1;
            lengths = zeros(m, maxLength);
            core = pL(check, check);
            core(isinf(core)) = maxLength;
            for i = 1:m
                lengths(i, :) = accumarray(core(:, i), 1, [maxLength, 1]);
            end
            maxLength = maxLength - 1;
            lengths = lengths(:, 1:maxLength);
            score = lengths * b.^(1:maxLength)';
%}
            score = sum(b.^pL(check, check), 2);
            score = U(check);
            [~, i] = max(score);

            checkA = A;
            checkA(agent, check(i)) = 0;
            [checkU, checkpL] = utility(checkA);
            if sum(checkU) > sum(newU)
                connection = check(i);
                newpL = checkpL;
                newU = checkU;
            end                
        end
    end

    function [connection, newpL, newU] = strategyAltruistEasy(agent, A, pL, U)
    
        N = length(U);
        connection = agent;
        newpL = pL;
        newU = U;
        
        % current state
        base = isfinite(pL);
                
        pathOut = bsxfun(@or, base, base(agent, :));
        pathOut(1:N+1:end) = true;
        helpOut = pathOut - base;
        
        pathIn = bsxfun(@or, base, base(:, agent));
        pathIn(agent, :) = true;
        helpIn = pathIn - base;
        
        deltaU = sum(helpOut, 2)' + sum(helpIn);
        deltaU(agent) = 0;
        check = find(deltaU == max(deltaU));
        check = check(randi(length(check)));

        if A(agent, check)==0
            checkA = A;
            checkA(agent, check) = 1;
            checkpL = pathLength(checkA);
            checkU = utility(checkA, checkpL);
            if sum(checkU) > sum(newU)
                newpL = checkpL;
                newU = checkU;
                connection = check;
            end
        end
        
        check = find(A(agent, :));
        m = length(check);
        if m > 0
            maxLength = max(pL(isfinite(pL))) + 1;
            lengths = zeros(m, maxLength);
            core = pL(check, check);
            core(isinf(core)) = maxLength;
            for i = 1:m
                lengths(i, :) = accumarray(core(:, i), 1, [maxLength, 1]);
            end
            score = sum(lengths(:, 1:maxLength-1), 2);
            check = check(find(score==max(score)));
            check = check(randi(length(check)));
            checkA = A;
            checkA(agent, check) = 0;
            checkpL = pathLength(checkA);
            checkU = utility(checkA, checkpL);
            if sum(checkU) > sum(newU)
                newpL = checkpL;
                newU = checkU;
                connection = check;
            end
        end        
    end
end
