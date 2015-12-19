function pL = pathLength(A)
% pL = pathLength(A)

    N = length(A);
    pL = inf(N);	          % assume infinite distance
    depth = 1;                % current path length
    frontier = A > 0;
    while any(frontier(:))    % until connections are exhausted
        pL(frontier) = depth;
                              % step forward into unchecked paths
        frontier = and(frontier * A > 0, isinf(pL));
        depth = depth + 1;
    end
end
