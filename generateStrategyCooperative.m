function handle = generateStrategyCooperative(beta, cost)

    handle = @strategyCooperative;

    function [connection, newA, newpL, newU] = strategyCooperative(agent, A, pL, U)
    % Benefit all players who are benefitting me

        N = numel(U);
        % default do nothing
        connection = agent;
        newA = [];
        newpL = [];
        newU = [];
        
        teamMembers = pL(:, agent)~=0;
        teamMembers(agent) = true;
        teamAgent = sum(teamMembers(1:agent));
        teampL = pL(teamMembers, teamMembers);
        bestU = sum(U(teamMembers));

        parasites = find(A(agent, :) & ~teamMembers');
        
        % check disconnect from one of the parasites
        if ~isempty(parasites)
            connection = parasites(randi(numel(parasites)));
            bestU = bestU + cost;
        end
        
        % find if there are team members I am not following
        A(agent, agent) = 1;
        check = find(~A(agent, teamMembers));
        A(agent, agent) = 0;
        m = numel(check);
        
        if m > 0
            % original "costless" utility
            % base(i, j) = i's contribution to j's utility
            base = beta.^teampL.*(teampL~=0);       

            % estimate new pathlength from agent through connection
            teampL(teampL==0) = inf;
            pathOut = teampL(check, :) + 1;
            pathOut = bsxfun(@min, pathOut, teampL(teamAgent, :));
            for i = 1:m
                pathOut(i, check(i)) = 1;
            end
            pathOut(pathOut==inf)=0;

            % improvement from path out
            %helpOut = bsxfun(@minus, beta.^pathOut.*(pathOut~=0), base(agent,:));
            helpOut = bsxfun(@minus, beta.^pathOut.*(pathOut~=0), base(teamAgent,:));

            % estimate new pathlength through agent to connection
            %pathIn = pL(:, agent) + 1;
            pathIn = teampL(:, teamAgent) + 1;
            %pathIn = bsxfun(@min, pathIn, pL(:, check));
            pathIn = bsxfun(@min, pathIn, teampL(:, check));
            %pathIn(agent, :) = 1;
            pathIn(teamAgent, :) = 1;
            pathIn(pathIn==inf) = 0;
            teampL(teampL==inf) = 0;

            % improvement from path in
            %helpIn = beta.^pathIn.*(pathIn~=0) - base(:, check);
            helpIn = beta.^pathIn.*(pathIn~=0) - base(:, check);

            % total improvement
            %deltaU = sum(helpOut, 2) + sum(helpIn)' - helpIn(agent, :)';
            deltaU = sum(helpOut, 2) + sum(helpIn)' - helpIn(teamAgent, :)';

            % take best result, randomize if more than one
            best = max(deltaU);
            teamMembers = find(teamMembers);
            check = teamMembers(check(find(deltaU==best)));
            check = check(randi(numel(check)));
            assert(A(agent, check)==0);

            % compute new move
            checkA = A;
            checkA(agent, check) = 1;
            checkpL = pathLength(checkA);
            checkU = utility(checkA, checkpL);
            checkTeamU = sum(checkU(teamMembers));
            
            % save if best so far
            if checkTeamU > bestU
                bestU = checkTeamU;
                newA = checkA;
                newpL = checkpL;
                newU = checkU;
            end
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
             checkTeamU = sum(checkU(teamMembers));
            
             % save if best so far
             if checkTeamU > bestU
                 bestU = checkTeamU;
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
