function [indexMaxUtil]...
    = doStrategy(iPlayer, S, A, U, beta, cost)
    indexMaxUtil = doStrategyCheckAll(iPlayer, S, A, U, beta, cost)
end

function [indexMaxUtil]...
    = doStrategyCheckAll(iPlayer, S, A, U, beta, cost)

    [row col] = size(A);
    utilitySet = [];
    for i = 1 : col
        Atemp = A;
        Atemp(iPlayer, i) = 1;
        pL = pathLength(Atemp);
        U1 = utility(Atemp, pL, beta, cost);
        utilitySet = [utilitySet U1(iPlayer)];
    end
    [M, indexMaxUtil] = max(utilitySet);
end
