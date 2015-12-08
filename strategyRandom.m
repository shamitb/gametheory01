function [connection, newA, newpL, newU] = strategyRandom(agent, A, pL, U)
% Randomly chooses move to make
% Does not compute result
% Useful as mistake - expected 50% connection rate

    connection = randi(length(U));
    newA = [];
    newpL = [];
    newU = [];
    
end
