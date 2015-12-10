function handle = generateStrategyAltruist(beta, cost)

    handle = @strategyAltruist;

    function [connection, newA, newpL, newU] = strategyAltruist(agent, A, pL, U)
    % Benefit all players
    % Does not compute result
    
        newA = [];
        newpL = [];
        newU = [];
        
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
        
        % never make negative move
        if best < 0
            best = 0;
            connection = agent;
        else
            connection = find(deltaU==best);
            connection = connection(randi(numel(connection)));
        end
        
        % if benefit is small, check for redundancies
        if best < cost
        end
        
    end
end
