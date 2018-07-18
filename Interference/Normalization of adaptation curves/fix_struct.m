function all_curves = fix_struct(all_curves)
%Make sure that every adaptation curve is stored as a column vector

dims = size(all_curves);

for i=1:dims(1)
    for j=1:dims(2)
        for k=1:dims(3)
            ccurve = all_curves{i,j,k};
            currDims = size(ccurve);
            if currDims(1)<currDims(2)
                all_curves{i,j,k} = ccurve';
            end
        end
    end
end

end