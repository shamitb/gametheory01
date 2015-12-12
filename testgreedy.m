function testgreedy()

clear all;

N = 20;

Ucummulative = zeros(1, N);

A = initialAction(N, 0.2);

agent = randi([1 N],1,1);;
beta = 0.7;
cost = 0.5;

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