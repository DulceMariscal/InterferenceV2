function ca = my_fill_ca(iA1m,iA2m,sA1m,sA2m,A1,A2,INT,SAV)

ca=cell(2,2);
ca{INT,A1} = iA1m; 
ca{INT,A2} = iA2m;
ca{SAV,A1} = sA1m;
ca{SAV,A2} = sA2m;

end