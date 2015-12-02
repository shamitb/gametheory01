function r = ExpRand(mu)
% mu is mean time between events or inverse of mean rate

r = -mu * log(rand);
