function handle = generateStrategyCooperative(beta, cost)

    handle = @strategyCooperative;

    function [connection, newA, newpL, newU] = strategyCooperative(agent, A, pL, U)
    % Benefit all players
        %fprintf('Current agent: %i \n', agent);

        N = numel(U);
        
        othersMask = ones(length(A), 1);
        othersMask(agent) = 0;
        teamMembers = find(pL(:, agent));
        %teamMembers = find(pL(:, agent).*othersMask);
        %parasites = find(pL(agent, :)==1);
        parasites = find((pL(agent, :)==1).*(~pL(:, agent)'));
        
        % as default action, choose to disconnect from one of the parasites
        disconnectU = U(teamMembers);
        myTeamIndex = find(teamMembers==agent);
        if (~isempty(parasites))
            disconnection = parasites(randi(numel(parasites)));
            disconnectU(myTeamIndex) = disconnectU(myTeamIndex)+1;
        else
            disconnection = agent; %do nothing
        end
        
        % find if there are team members I am not following
        check = teamMembers(find(~A(agent, teamMembers)));
        
        if (~isempty(check))
            % original "costless" utility
            % base(i, j) = i's contribution to j's utility
            base = beta.^pL.*(pL~=0);

            % only check unconnected in my audience
            %A(agent, agent) = 1;
            %check = find(~A(agent, :)); % gives those I'm not already connected to
            %check = find(pL(check, agent)); % CHECK! should give only those that has a path length (is connected) to me
            m = numel(check);
            %A(agent, agent) = 0;

            % estimate new pathlength from agent through connection
            pL(pL==0) = inf;
            %pathOut = pL(check, :) + 1;
            pathOut = pL(check, teamMembers) + 1;
            %pathOut = bsxfun(@min, pathOut, pL(agent,:));
            pathOut = bsxfun(@min, pathOut, pL(agent, teamMembers));
            for i = 1:m
                pathOut(i, check(i)==teamMembers) = 1; % buggy
            end
            pathOut(pathOut==inf)=0;

            % improvement from path out
            %helpOut = bsxfun(@minus, beta.^pathOut.*(pathOut~=0), base(agent,:));
            helpOut = bsxfun(@minus, beta.^pathOut.*(pathOut~=0), base(agent,teamMembers));

            % estimate new pathlength through agent to connection
            %pathIn = pL(:, agent) + 1;
            pathIn = pL(teamMembers, agent) + 1;
            %pathIn = bsxfun(@min, pathIn, pL(:, check));
            pathIn = bsxfun(@min, pathIn, pL(teamMembers, check));
            %pathIn(agent, :) = 1;
            pathIn(agent == teamMembers, :) = 1;
            pathIn(pathIn==inf) = 0;
            pL(pL==inf) = 0;

            % improvement from path in
            %helpIn = beta.^pathIn.*(pathIn~=0) - base(:, check);
            helpIn = beta.^pathIn.*(pathIn~=0) - base(teamMembers, check);

            % total improvement
            %deltaU = sum(helpOut, 2) + sum(helpIn)' - helpIn(agent, :)';
            if (isempty(find(teamMembers==agent)))
                deltaU = sum(helpOut, 2) + sum(helpIn)';
            else
                deltaU = sum(helpOut, 2) + sum(helpIn)' - helpIn(find(teamMembers==agent), :)';
            end

            % take best result, randomize if more than one
            best = max(deltaU);
            connection = check(find(deltaU==best));
            connection = connection(randi(numel(connection)));

            % compute new move
            checkA = A;
            checkA(agent, connection) = 1 - checkA(agent, connection);
            checkpL = pathLength(checkA);
            checkU = utility(checkA, checkpL);
        else
            connection = agent;
            checkA = [];
            checkpL = [];
            checkU = [];
        end
        % TO HERE!
        
        
        
        % use only if better than original
        %if sum(checkU) < sum(U)
        oldTeamU = sum(U(teamMembers));
        connectTeamU = sum(checkU(teamMembers));
        disconnectTeamU = sum(disconnectU);
        UAltArray = [oldTeamU, connectTeamU, disconnectTeamU];
        bestU = max(UAltArray);
        choice = find(UAltArray==bestU);
        choice = choice(randi(numel(choice)));
        if choice == 1
            % not changing anything is better
            connection = agent;
            newA = A;
            newpL = pL;
            newU = U;
        elseif choice == 2
            newA = checkA;
            newpL = checkpL;
            newU = checkU;
        else
            connection = disconnection;
            newA = [];
            newpL = [];
            newU = [];
        end

        % check for redundancies
%         check = find(A(agent, :));
%         if ~isempty(check)
% % heuristic                
%             m = numel(check);
%             l = max(pL(:)) + 1;
%             lengths = zeros(m, l);
%             core = pL(check, check) + 1;
%             for i = 1:m
%                 lengths(i, :) = accumarray(core(:,i), 1, [l, 1])';
%             end
%             lengths = lengths(:, 2:end);
%             lengths = lengths + 1e-8 * rand(size(lengths));
%             score = lengths * beta.^(1:l-1)';
%             [~, i] = max(score);
%                 
%             checkA = A;
%             checkA(agent, check(i)) = 0;
%             checkpL = pathLength(checkA);
%             checkU = utility(checkA, checkpL);
%             if mean(checkU) > mean(newU)
%                 connection = check(i);
%                 newA = checkA;
%                 newpL = checkpL;
%                 newU = checkU;
%             end
                
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
        %end
        
    end
end
