function mySetYlim(fhr, npr, YLIMS)
figure(fhr);

MIN = min(YLIMS(:));
MAX = max(YLIMS(:));

for i=1:npr
   subplot(1,npr,i)
   ylim([MIN MAX]);
end



end