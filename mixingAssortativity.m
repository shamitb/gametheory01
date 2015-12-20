function coeff = mixingAssortativity(M)
% coeff = mixingAssortativity(M)
% returns assortativity coefficient for distribution matrix M

    e = M / sum(M(:)); % normalize distribution
    a = sum(e, 2);     % from
    b = sum(e);        % to
    coeff = (sum(diag(e)) - b * a) / (1 - b * a);
    if isnan(coeff)
        coeff = 1;
    end

end
