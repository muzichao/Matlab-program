function out = addMatrix(a, b, Row, Col)
out = zeros(Row,Col);
for i = 1:Row
    for j = 1:Col
        out(i,j) = a(i,j) + b(i,j);
    end
end