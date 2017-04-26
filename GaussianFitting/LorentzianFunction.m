function l_add = LorentzianFunction(a,x)
    
    %define continuum
    l_add = 1;
    
    for i = 1:size(a,2)
        
        %add the Gaussian equations
        l =a(2,i)*(a(3,i)^2./((x-a(1,i)).^2+a(3,i)^2));
        l_add = l_add + l;

    end 

end