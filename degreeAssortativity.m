function [inin, inout, outin, outout, inDist, outDist] = degreeAssortativity(A)
% [coeff, indist, outdist] = degreeAssortativity(A)
% 
% From adjacency matrix A, computes:
%
% inin    - Pearson's degree correlations
% inout
% outin
% outout
% 
% inDist  - in degree distribution
% outDist - out degree distribution


in = 1;
out = 2;
coeff = zeros(2);
N = length(A);

inDegree = full(sum(A));
outDegree = full(sum(A, 2))';

inDist = accumarray(inDegree(inDegree>0)', 1) / N;
outDist = accumarray(outDegree(outDegree>0)', 1) / N;

centeredIn = inDegree - mean(inDegree);
centeredOut = outDegree - mean(outDegree);

[from, to] = find(A);        % index over all edges

inin  =  (centeredIn(from) * centeredIn(to)') /...
         (centeredIn(from) * centeredIn(from)') /...
         (centeredIn(to) * centeredIn(to)');            
inout =  (centeredIn(from) * centeredOut(to)') /...
         (centeredIn(from) * centeredIn(from)') /...
         (centeredOut(to) * centeredOut(to)');
outin =  (centeredOut(from) * centeredIn(to)') /...
         (centeredOut(from) * centeredOut(from)') /...
         (centeredIn(to) * centeredIn(to)');
outout = (centeredOut(from) * centeredOut(to)') /...
         (centeredOut(from) * centeredOut(from)') /...
         (centeredOut(to) * centeredOut(to)');

end
