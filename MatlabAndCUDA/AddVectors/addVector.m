function out = addVector(a, b, size)
out = zeros(size,1);
for i = 1:size
    out(i) = a(i) + b(i);
end