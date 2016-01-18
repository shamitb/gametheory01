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
     sqrt(centeredIn(from) * centeredIn(from)') /...
     sqrt(centeredIn(to) * centeredIn(to)');            
inout =  (centeredIn(from) * centeredOut(to)') /...
     sqrt(centeredIn(from) * centeredIn(from)') /...
     sqrt(centeredOut(to) * centeredOut(to)');
outin =  (centeredOut(from) * centeredIn(to)') /...
     sqrt(centeredOut(from) * centeredOut(from)') /...
     sqrt(centeredIn(to) * centeredIn(to)');
outout = (centeredOut(from) * centeredOut(to)') /...
     sqrt(centeredOut(from) * centeredOut(from)') /...
     sqrt(centeredOut(to) * centeredOut(to)');

if isnan(inin)
    inin = 0;
end
if isnan(inout)
    inout = 0;
end
if isnan(outin)
    outin = 0;
end
if isnan(outout)
    outout = 0;
end

end
