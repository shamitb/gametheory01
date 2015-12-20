function coeff = degreeAssortativity(A)
% coeff = degreeAssortativity(A)
% compute Pearson's correlation coefficients for degree assortativity
% returns 2×2 matrix (in, out)

in = 1;
out = 2;
coeff = zeros(2);

inDegree = full(sum(A));
outDegree = full(sum(A, 2))';

meanInDegree = mean(inDegree);
meanOutDegree = mean(outDegree);

centeredInDegree = inDegree - meanInDegree;
centeredOutDegree = outDegree - meanOutDegree;

[from, to] = find(A);

coeff(in, in)  =  (centeredInDegree(from) * centeredInDegree(to)') /...
                  (centeredInDegree(from) * centeredInDegree(from)') /...
                  (centeredInDegree(to) * centeredInDegree(to)');            
coeff(in, out) =  (centeredInDegree(from) * centeredOutDegree(to)') /...
                  (centeredInDegree(from) * centeredInDegree(from)') /...
                  (centeredOutDegree(to) * centeredOutDegree(to)');
coeff(out, in) =  (centeredOutDegree(from) * centeredInDegree(to)') /...
                  (centeredOutDegree(from) * centeredOutDegree(from)') /...
                  (centeredInDegree(to) * centeredInDegree(to)');
coeff(out, out) = (centeredOutDegree(from) * centeredOutDegree(to)') /...
                  (centeredOutDegree(from) * centeredOutDegree(from)') /...
                  (centeredOutDegree(to) * centeredOutDegree(to)');
              
coeff = coeff(:)';

end
