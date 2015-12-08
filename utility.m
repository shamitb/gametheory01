function score = utility(A, pL, beta, cost, temporary)
% score = utility(A, pL, beta, cost)
% sparse adjacency matrix A
% optional precomputed path length matrix pL
% optional beta, default is 1
% optional cost, default is 1
% optional temporary, default is false
% returns N-by-1 vector

    persistent b
    persistent c
    if isempty(b)
        b = 1; c = 1;
    end

    if ~exist('pL','var') || isempty(pL)        % compute pL if needed
        pL=pathLength(A);
    end
    if ~exist('beta','var') || ~isreal(beta)    % default beta
        beta = b;
    end
    if ~exist('cost','var') || ~isreal(cost)    % default cost
        cost = c;
    end
    if ~exist('temporary', 'var') || ~temporary % save beta and cost by default
        b = beta;
        c = cost;
    end
    
    score = sum(beta.^pL.*(pL~=0))' - cost * sum(A, 2);

end
