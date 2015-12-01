function score = utility(A, pL, beta, cost)
% score = utility(A, pL, beta, cost)
% sparse adjacency matrix A
% optional precomputed path length matrix pL
% optional beta, default is 1
% optional cost, default is 1
% returns N-by-1 vector

    if ~exist('pL','var') || isempty(pL)       % compute pL if needed
        pL=pathLength(A);
    end
    if ~exist('beta','var') || ~isreal(beta)   % default beta
        beta = 1;
    end
    if ~exist('cost','var') || ~isreal(cost)   % default cost
        cost = 1;
    end
    
    score = sum(beta.^pL)' - cost * sum(A, 2);

end
