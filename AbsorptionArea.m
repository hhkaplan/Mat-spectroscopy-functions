%This function finds the area of absorptions in spec_data. This assumes
%that spec_data is reflectance data (i.e. stronger absorptions lead to
%weaker reflectance values) and, traditionally, this function should only be performed on
%continuum removed data. There is an additional ability to find absorption
%area for a subset of the input spectrum, which can be defined using two
%wavelengths lwav and rwav. Area is calculated using Matlab's trapz
%function.

%ex: AUC = AbsorptionArea(spec_data, 3.1, 3.8);
%    AUC = AbsorptionArea(spec_data);

%HKaplan, 2017

function [AUC] = AbsorptionArea(spec_data, lwav, rwav)

%If wavelengths are specificed subset data:
if nargin >1
    wavelength = spec_data(:,1);
    lwav_ID = find(wavelength > lwav,1);
    rwav_ID = find(wavelength > rwav,1);
    
    %define measurements columns
    spectrum = spec_data(lwav_ID:rwav_ID, 2:end);

    %Calculate area of absorptions
    BD = 1.-spectrum;
    AUC = trapz(BD);

%Otherwise find area of entire spectrum that is input
else
    %define measurements columns
    spectrum = spec_data(:, 2:end);

    %Calculate area of absorptions
    BD = 1.-spectrum;
    AUC = trapz(BD);


end


