function y=degcentre(x,c)
    if( nargin == 1  )
        c = 0;
    end
    
    y = x;
    
    for i=1:length(y)
        cmin = c-180;
        cmax = c+180;
        
        while( y(i) < cmin )
            y(i) = y(i) + 360;
        end
        
        while( y(i) >= cmax )
            y(i) = y(i) - 360;
        end
    end
end
