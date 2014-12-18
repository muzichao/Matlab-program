function out = mulMatrix(a, b, numRowsA, numColsA, numColsB)
out = zeros(numRowsA,numColsB);
for i = 1:numRowsA
    for j = 1:numColsB
        for k = 1:numColsA
            out(i,j) = out(i,j) + a(i,k) * b(k,j);
        end
    end
end