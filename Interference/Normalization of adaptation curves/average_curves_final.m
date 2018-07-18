function [avgc, SE] = average_curves_final(curves) %It's a 2 X 2
%Generalize to other cases. Here I am assuming that I want to avg accross
%the second dimension

dims = size(curves);
avgc = cell(dims(1), dims(3));
SE = cell(dims(1), dims(3));

for i=1:dims(1)
    for j=1:dims(3)
        curves_to_average = curves(i,:,j);
        [avgc{i,j}, SE{i,j}]= average_ca(curves_to_average);
    end
end


end