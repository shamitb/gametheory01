function [coeff, inDist, outDist] = degreeAssortativity(A)
% [coeff, indist, outdist] = degreeAssortativity(A)
% 
% From adjacency matrix A, computes:
%
% coeff   - Pearson's degree correlation 1×4
%           in/in, out/in, in/out, out/out
% inDist  - in degree distribution
% outDist - out degree distribution


in = 1;
out = 2;
coeff = zeros(2);
N = length(A);

inDegree = full(sum(A));
outDegree = full(sum(A, 2))';

inDist = accumarray(inDegree', 1) / N;
outDist = accumarray(outDegree', 1) / N;

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
