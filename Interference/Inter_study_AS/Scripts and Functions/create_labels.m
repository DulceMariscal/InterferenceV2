function labels=create_labels(label,indices)
ns=length(indices);
labels=cell(1,ns);

for i=1:ns
   labels{i}=[label num2str(indices(i))]; 
end

end