%This function takes reflectance data, usually already continuum removed, and finds
%band depth by subtracting reflectance values from 1. Band Depth at a
%specific wavelength can be found searching the BD output:
        %ex: vecID = find(BD(:,1)>3.4,1));
        %    BD_at_34um = BD(vecID,2:end);

%HKaplan, 2017

function [BD] = BandDepth(Spec_Data)
    
    BD = 1 - Spec_Data(:,2:end);
    BD = [Spec_Data(:,1),BD];

end

