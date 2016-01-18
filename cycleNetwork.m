function A = cycleNetwork(n)
    from = 1:n;
    to = [2:n, 1];
    A = sparse(from, to, 1, n, n, n * ceil(sqrt(n) / 2));
end
