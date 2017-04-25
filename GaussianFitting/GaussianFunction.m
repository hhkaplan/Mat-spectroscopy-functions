function g_add = GaussianFunction(a,x)
    
    %define continuum
    g_add = 1;
    disp(a)
    for i = 1:size(a,2)
        
        %add the Gaussian equations
        g = a(2, i)*exp(-(x-a(1, i)).^2/(2*a(3,i)^2));
        g_add = g_add + g;

    end 

end



