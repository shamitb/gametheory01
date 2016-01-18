function A = starNetwork(n)
    hub = ones(n-1,1);
    spokes = (2:n)';
    A = sparse([hub; spokes], [spokes; hub], 1, n, n, n * ceil(sqrt(n) / 2));
end
