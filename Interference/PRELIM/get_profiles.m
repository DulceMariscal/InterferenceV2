function [D,ND] = get_profiles(a,b,d2,offs)

%DOMINANT
bd1=a*ones(1,150);
pd1=(a+d2)*ones(1,300);
gd1=linspace(a+d2,b,600); 
pd2=(b+d2)*ones(1,300);
gd2=linspace(b+d2,a,600); 
bd2=b*ones(1,150);
D = [bd1 pd1 gd1 bd2 pd2 gd2 bd1 pd1 gd1 bd2 pd2 gd2 bd1 pd1 gd1 bd2] + offs ;

%NON DOMINANT
bnd1=a*ones(1,150);
pnd1=(a-d2)*ones(1,300);
gnd1=linspace(a-d2,b,600); 
pnd2=(b-d2)*ones(1,300);
gnd2=linspace(b-d2,a,600); 
bnd2=b*ones(1,150);
ND = [bnd1 pnd1 gnd1 bnd2 pnd2 gnd2 bnd1 pnd1 gnd1 bnd2 pnd2 gnd2 bnd1 pnd1 gnd1 bnd2]- offs ;


end