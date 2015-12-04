function pL = pathLength(A)
% pL = pathLength(A)
% expects sparse adjacency matrix A

    pL = full(A);	          % path 1 is just A
    depth = 1;                % current path length
    frontier = A > 0;
    while any(frontier(:))    % until connections are exhausted
        depth = depth + 1;
                              % step forward without duplicates
        frontier = and(frontier * A > 0, ~pL);
        pL(frontier) = depth; % add to path length matrix
    end
end
