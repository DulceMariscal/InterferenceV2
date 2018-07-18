function M2 = my_duplicate(M)

dims=size(M);
M2 = zeros(2*dims(1),dims(2));
M2(1:2:end)=M;
M2(2:2:end)=M;

end