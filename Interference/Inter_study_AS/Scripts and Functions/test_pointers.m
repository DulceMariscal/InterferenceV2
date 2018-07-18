a=1;

this_var=[2 10];
that_var=[22 33];

if a==1
    storage_var=this_var;
    mystring='this_var';
else
    storage_vat=that_var;
    mystring='that_var';
end

storage_var(2)=3;
eval([mystring '= ' num2str(a)])