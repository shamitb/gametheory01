function s = fivenum(x)
    s = quantile(x(:), [0 0.25 0.5 0.75 1]);
end
