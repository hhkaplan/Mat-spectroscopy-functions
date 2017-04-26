function PV_add = PseudoVoigtFunction(a,x)
 
PV_add = 1;
 
x0 = a(1,:);
amp = a(2,:);
FWHM = a(3,:);
n = a(4,:);
 
 
for i = 1: size(a,2)
 
 Lorentz = amp(i)*(FWHM(i)^2./((x-x0(i)).^2+FWHM(i)^2));
 Gauss = amp(i)*exp(-(x-x0(i)).^2/(2*(FWHM(i)/2.355)^2));
  
 PV = (1-n(i)).*Gauss + n(i).*Lorentz;
  
 PV_add = PV_add + PV;
     
end
 
end