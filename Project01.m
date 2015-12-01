
% Follower's Game

NUM_PLAYERS = 3;
u = zeros(NUM_PLAYERS, NUM_PLAYERS);
a = randi([0 1], NUM_PLAYERS, NUM_PLAYERS);
c = 1; % cost
beta = 1;
for i = 1 : NUM_PLAYERS
    for k = 1 : 3
        u(i,:) = -c*sum(a(i,:)) + (beta^k)*(a(i,:).^(k) - a(i,:).^(k-1));
    end
end



