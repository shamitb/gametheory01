function [indexMaxUtil A U]...
    = doStrategy(iPlayer, S, A, U, beta, cost)
    [indexMaxUtil A U] = doStrategyCheckAll(iPlayer, S, A, U, beta, cost)
end

function [indexMaxUtil A U]...
    = doStrategyCheckAll(iPlayer, S, A, U, beta, cost)

    [row col] = size(A);
    utilitySet = [];
    Atemp = A;
    U1 = U;
    for i = 1 : col
        Atemp = A;
        Atemp(iPlayer, i) = 0;
        pL = pathLength(Atemp);
        U1 = utility(Atemp, pL, beta, cost);
        utilitySet = [utilitySet U1(iPlayer)];
    end
    [M, indexMaxUtil] = max(utilitySet);
    A(iPlayer, indexMaxUtil) = 0;
    pL = pathLength(A);
    U = utility(A, pL, beta, cost);
end
