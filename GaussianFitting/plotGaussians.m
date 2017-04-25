function h = plotGaussians(x, a, distr)

matrix = [];  
if strcmp(distr,'gauss') 

        for i = 1: size(a,2)
        g = 1 + a(2, i)*exp(-(x-a(1,i)).^2/(2*a(3,i)^2));
        matrix = [matrix, g];
        h = plot(x, g); hold on;
      
        end

elseif strcmp(distr, 'lorentz')
        
        for i = 1: size(a,2)

        l = 1 + a(1,i)*(a(2,i)^2./((x-x0(i)).^2+a(2,i)^2));
        matrix = [matrix, l];
        h = plot(x, l); hold on;
        end

elseif strcmp(distr, 'skew')
        for i = 1: size(a,2)

        pdf_g = a(1, i)*exp(-(x-x0(i)).^2/(2*a(2,i)^2));
        cdf_g = .5*(1+erf(a(3,i)*(x-x0(i))/(sqrt(2)*a(2,i)))); 
        skew_pdf_g =1+  2.*pdf_g.*cdf_g;
        matrix = [matrix, skew_pdf_g];
        
        h = plot(x, skew_pdf_g); hold on;
        end
        
elseif strcmp(distr, 'gauss_mix')
        for i = 1: size(a,2)

        g = 1 + a(1, i)*exp(-(x-x0(i)).^2/(2*a(2,i)^2));
        matrix = [matrix, g];
        h = plot(x, g); hold on;
    
        end
        
elseif strcmp(distr, 'MGM')
        for i = 1: size(a,2)

        g = 1 + a(1, i)*exp(-(x.^(-1)-x0(i).^(-1)).^2/(2*a(2,i)^2));
        matrix = [matrix, g];
        h = plot(x, g); hold on;
    
        end  
        
else
    disp('Nothing is being plotted');

end
%save('/Users/Hannah/Desktop/Curves.txt','matrix','-ascii','-tabs')

end

