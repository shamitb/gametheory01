function pL = pathLength(A)
% pL = pathLength(A)
% expects sparse adjacency matrix A

    pL = full(A);	% path 1 is just A
    n = size(A, 1);     % get node count
    depth = 1;          % current path length
    frontier = A;
    while depth < n && any(frontier(:)) % until depth or connections are exhausted
        depth = depth + 1;
        frontier = frontier * A;        % take one step
        frontier(pL~=0) = 0;            % remove duplicates
        pL(frontier~=0) = depth;        % add to path length matrix
    end
end
