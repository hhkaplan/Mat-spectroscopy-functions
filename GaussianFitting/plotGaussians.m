function h = plotGaussians(x, a, distr)

distr = func2str(distr);
matrix = [];  

%Plot individual curves depending on the input distribution and values for
%x, a
if strcmp(distr, 'GaussianFunction')

        for i = 1: size(a,2)
        g = 1 + a(2, i)*exp(-(x-a(1,i)).^2/(2*a(3,i)^2));
        matrix = [matrix, g];
        h = plot(x, g); hold on;
      
        end

elseif strcmp(distr, 'LorentzianFunction')
        
        for i = 1: size(a,2)

        l = 1 + a(2,i)*(a(3,i)^2./((x-a(1,i)).^2+a(3,i)^2));
        matrix = [matrix, l];
        h = plot(x, l); hold on;
        
        end
        
elseif strcmp(distr, 'PseudoVoigtFunction')
        x0 = a(1,:);
        amp = a(2,:);
        FWHM = a(3,:);
        n = a(4,:);

        for i = 1: size(a,2)

         Lorentz = amp(i)*(FWHM(i)^2./((x-x0(i)).^2+FWHM(i)^2));
         Gauss = amp(i)*exp(-(x-x0(i)).^2/(2*(FWHM(i)/2.355)^2));

         PV = 1 + (1-n(i)).*Gauss + n(i).*Lorentz;
         matrix = [matrix, PV];
        
        h = plot(x, PV); hold on;
        
        end
        
elseif strcmp(distr, 'SkewGaussFunction')
    
        for i = 1: size(a,2)

        pdf_g = a(2, i)*exp(-(x-a(1,i)).^2/(2*a(3,i)^2));
        cdf_g = .5*(1+erf(a(4,i)*(x-a(1,i))/(sqrt(2)*a(3,i)))); 
        skew_pdf_g =1+  2.*pdf_g.*cdf_g;
        matrix = [matrix, skew_pdf_g];
        
        h = plot(x, skew_pdf_g); hold on;
        
        end
             
else
    disp('Nothing is being plotted');

end


end

