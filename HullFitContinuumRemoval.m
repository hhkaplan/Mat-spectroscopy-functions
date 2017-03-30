% This function performs a continuum removal for spectral data over a
% specificed wavelength range (lwav, rwav). Input spectral data has a first
% column with wavelength in ascending numerical order followed by columns
% with measurements. Output is both continuum fits to the original data and
% continuum corrected data (baseline = 1). Continuum fits are plotted for
% some of the data.

%HKaplan, 2017

% example input:
% Filepath = '/Users/hannahkaplan/Desktop/';
% Filename = 'Test';
% spec_data = xlsread([Filepath Filename '.xlsx'],2);
% lwav = 3.1;
% rwav = 3.8;

function [ContinuumCorrected, ContinuumFits] = HullFitContinuumRemoval(spec_data, lwav, rwav)

%Define wavelength column and find vectorIDs for the two wavelengths used
%in the continuum removal
wavelength = spec_data(:,1);
lwav_ID = find(wavelength > lwav,1);
rwav_ID = find(wavelength > rwav, 1);

%throw an error if wavelengths are not found in the dataset
if isempty(lwav_ID) || isempty(rwav_ID)
    error('Wavelength(s) are out of range');
end

%Subset wavelengths and spectra based on those vectorIDs
wavelength_subset = wavelength(lwav_ID:rwav_ID);
spectrum_subset = spec_data(lwav_ID:rwav_ID, 2:end);

%Pre-allocate space
ContinuumFits = zeros(rwav_ID-lwav_ID+1,size(spectrum_subset,2));
ContinuumCorrected = zeros(size(spectrum_subset));

%Loop through each reflectance column and run a convex hull fit
for i = 1:size(spectrum_subset,2)
    
    spec = spectrum_subset(:,i);
    
    % Run convex hull operation on subset; output is counterclockwise so we
    % need to flip the result up-down.
    HullFit = convhull(wavelength_subset,spec);
    HullFit = flipud(HullFit);
    
    % The vector HullFit has the vector IDs, not values. Find the max vector ID
    % and remove all points after it so we only have the upper convex hull
    % points.
    MaxHullFitID = find(HullFit == max(HullFit));
    HullFit(MaxHullFitID+1:length(HullFit)) = [];
    
    % Pull out the wavelength and reflectance values that correspond to these
    % HullFit IDs.
    Hull_Wavelengths = wavelength_subset(HullFit);
    Hull_Values = spec(HullFit);
    
    % Convert these hull fit points to a series of linear functions (that is,
    % do a piecewise linear fit between hull points to define the continuum).
    % Start by finding the slopes and intercepts of each line.
    Hull_Slopes = (diff(Hull_Values)./diff(Hull_Wavelengths));
    Hull_Intercepts = Hull_Values(1:length(Hull_Values)-1) - (Hull_Slopes.*Hull_Wavelengths(1:length(Hull_Wavelengths)-1));
    for j=1:length(Hull_Slopes)

        ContinuumFits(HullFit(j):HullFit(j+1),i) = Hull_Slopes(j).*wavelength_subset(HullFit(j):HullFit(j+1)) + Hull_Intercepts(j);
    
    end
    ContinuumCorrected(:,i) = spec./ContinuumFits(:,i);
end

%Finalize the returned datasets
OriginalData = [wavelength_subset, spectrum_subset];
ContinuumFits = [wavelength_subset, ContinuumFits];
ContinuumCorrected = [wavelength_subset, ContinuumCorrected];
    
%Plot some results
subplot(2,2,1)
plot(OriginalData(:,1),OriginalData(:,2),'-k',...
    ContinuumFits(:,1),ContinuumFits(:,2),'-r');

subplot(2,2,2)
plot(OriginalData(:,1),OriginalData(:,3),'-k',...
    ContinuumFits(:,1),ContinuumFits(:,3),'-r');

subplot(2,2,3)
plot(OriginalData(:,1),OriginalData(:,4),'-k',...
    ContinuumFits(:,1),ContinuumFits(:,4),'-r');

subplot(2,2,4)
plot(OriginalData(:,1),OriginalData(:,5),'-k',...
    ContinuumFits(:,1),ContinuumFits(:,5),'-r');
end