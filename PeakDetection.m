%This function finds minima in the spectral data as a way of finding
%absorptions using Matlab's findpeaks. Local minima are plotted (it may be
%important to visually inspect results to distinguish between noise and
%absorpitons) and a matrix with wavelengths/reflectance values of results
%is output. Peaks must meet certain values of prominence (amplitude) and distance
%(number of data points between consecutive peaks) to be chosen. These
%values can be user specified; if they are not conservative values are
%included.

%HKaplan, 2017

function wav_peak_data = PeakDetection(spec_data, minProminence, minDistance)

if nargin == 1
    minProminence = 0.001;
    minDistance = 10;
end

%invert data so we can find peaks (instead of troughs)
BD_data = 1 - spec_data(:,2:end);

for i = 1:size(BD_data,2)
    %Use findpeaks to find
    [~,locs] = findpeaks(BD_data(:,i), 'MinPeakProminence',minProminence, 'MinPeakDistance',minDistance);

    %Plot and return data in reflectance space
    wav_peak_data{i} = [spec_data(locs,1), BD_data(locs,i)];

    figure(i)
    plot(spec_data(:,1), spec_data(:,i+1), '-k'); hold on;
    scatter(spec_data(locs,1), spec_data(locs,i+1),'*','red');
end

end