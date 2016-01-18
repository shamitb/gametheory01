function coeff = mixingAssortativity(A, S)
% coeff = mixingAssortativity(A, S)
% returns assortativity coefficient for distribution matrix A
% if S is given, assume A is adjacency matrix

    if exist('S', 'var')
        m = length(S);
        [from, to] = find(A);
        A = accumarray([S(from) S(to)], 1, [m m]);
    end

    e = A / sum(A(:)); % normalize distribution
    a = sum(e, 2);     % from
    b = sum(e);        % to
    coeff = (sum(diag(e)) - b * a) / (1 - b * a);
    if isnan(coeff)
        coeff = 1;
    end

end
