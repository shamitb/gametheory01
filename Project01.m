
% Follower's Game

NUM_PLAYERS = 3;
u = zeros(NUM_PLAYERS, NUM_PLAYERS);
a = randi([0 1], NUM_PLAYERS, NUM_PLAYERS);
c = 1; % cost
beta = 1;
max_k = 3;

for i = 1 : NUM_PLAYERS
    sumk = 0;
    for k = 1 : max_k
        ak = a^(k);
        ak1 = a^(k-1)
        sumk = sumk + (beta^k)*(sum(ak(i,:)) - sum(ak1(i,:)));
    end
    u(i,:) = -c*sum(a(i,:)) + sumk;
end

display(u);

