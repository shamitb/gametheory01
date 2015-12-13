function testcooperate()

clear all;

N = 10;

A = initialAction(N, 0.2);

% None of 1-5 connect to 6-10 and vice versa
A(1:5,6:10)=0; A(6:10,1:5)=0;

agent = randi([1 N],1,1);
beta = 0.7;
cost = 0.5;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

prevA = A;
prevPL = pL;
prevU = U;
handle = generateStrategyCooperative(beta, cost);
[connection, t1A, t1pL, t1U] = handle(agent, A, pL, U);
if isempty(t1A);
else
    A = t1A;
    U = t1U;
    pL = t1pL;
end

A = prevA;
U = prevU;
pL = prevPL;
handle = generateStrategyAltruist(beta, cost);
[connection, t2A, t2pL, t2U] = handle(agent, A, pL, U);
if isempty(t2A);
else
    A = t2A;
    U = t2U;
    pL = t2pL;
end

end
