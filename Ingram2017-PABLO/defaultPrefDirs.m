function prefDirs=defaultPrefDirs(M)
   ang=2*pi*[0:M-1]'/M;
   prefDirs=[cos(ang) sin(ang)]; 
end