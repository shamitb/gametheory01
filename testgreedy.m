function testgreedy()

clear all;

N = 30;

Ucummulative = zeros(1, N);

A = initialAction(N, 0.8);

agent = randi([1 N],1,1);;
beta = 0.5;
cost = 0.3;

pL = pathLength(A);
U = utility(A, pL, beta, cost);

Uprev = U(agent);

utilitySet = [];
for i = 1 : N
    Atemp = A;
    Atemp(agent, i) = 1;
    temppL = pathLength(Atemp);
    U1 = utility(Atemp, temppL, beta, cost);
    utilitySet = [utilitySet U1(agent)];
end

for i = 1 : N
    Atemp = A;
    Atemp(agent, i) = 0;
    temppL = pathLength(Atemp);
    U1 = utility(Atemp, temppL, beta, cost);
    utilitySet = [utilitySet U1(agent)];
end

handle = generateStrategyGreedy(beta, cost);
[connection] = handle(agent, A, pL, U);
if(connection ~= agent)
    A(agent, connection) = 0;
    pL = pathLength(A);
    U = utility(A, pL, beta, cost);
    
    utilitySet = utilitySet - Uprev
    Unext = U(agent);
    Udiff = Unext - Uprev
    
end

end