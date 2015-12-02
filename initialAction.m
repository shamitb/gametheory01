function A = initialAction(N, p)
% initialize adjacency matrix
% A = initialAction(N) is equivalent to A = spzeros(N, N)
% A = initialAction(N, p) contains approx p*N ones

if ~exist('p', 'var') || ~isreal(p) % default p=0
    p = 0;
end

A = sprand(N, N, p);
A(A>0) = 1;                         % set nonzeros to 1
A(1:N+1:end) = 0;                   % no self-connections