function SG_add = SkewGaussFunction(a,x)
    
    %define continuum
    SG_add = 1;
    
    for i = 1:size(a,2)
        
        %add the equations
        pdf_g = a(2, i)*exp(-(x-a(1,i)).^2/(2*a(3,i)^2));
        cdf_g = .5*(1+erf(a(4,i)*(x-a(1,i))/(sqrt(2)*a(3,i)))); 
        skew_pdf_g = 2.*pdf_g.*cdf_g;
        SG_add = SG_add + skew_pdf_g;

    end 

end