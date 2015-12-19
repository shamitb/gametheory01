function [U, pL] = utility(A, pL, b, c, temporary)
% score = utility(A, pL, beta, cost)
% adjacency matrix A (N×N)
% optional precomputed path length matrix pL
% optional beta, default is 1
% optional cost, default is 1
% optional temporary, default is false
% returns N-by-1 vector

    persistent BETA
    persistent COST
    
    if isempty(BETA)                      % initial defaults
        BETA = 1; COST = 1;
    end

    if ~exist('b','var') || ~isreal(b)    % default beta
        b = BETA;
    end
    
    if ~exist('c','var') || ~isreal(c)    % default cost
        c = COST;
    end
    
    if ~exist('temporary', 'var') ||...
       ~temporary                         % save beta and cost by default
        BETA = b;
        COST = c;
    end
    
    if ~exist('pL','var') || isempty(pL)  % compute pL if needed
        pL=pathLength(A);
    end
    
    if b < 1
        U = sum(b .^ pL)';
    else
        N = length(A);
        U = sum(pL <= N)';
    end
    
    U = U - c * sum(A, 2);

end
