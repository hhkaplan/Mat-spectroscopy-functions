%This function takes two overlapping spectral datasets (i.e. shorter
%wavelength data and longerwavelength data) and splices them together at a
%chosen wavelength. The parameters are short_data and long_data: spectral
%datasets where the first column is wavelengths in numerical ascending
%order. The longer wavelength data is scaled to the shorter wavelength
%data to facilitate splicing.

%HKaplan, 2017

function spliced_spectra = SpliceSpectra(short_data, long_data, splice_wav)

%Define the wavelength column and find the vectorID of the splice
%wavelength within both short and long wavelength data
short_wav = short_data(:,1);
splice_vector_short = find(short_wav > splice_wav,1);
long_wav = long_data(:,1);
splice_vector_long = find(long_wav > splice_wav,1);

% Trim data > splice point wavelength for shorter wavelength data and
% <splice point for longer wavelength data
short_data(splice_vector_short+1:length(short_wav),:) = []; 
long_data(1:splice_vector_long-1,:) = [];

% Determine the appropriate scale factor for each spectrum (column).
% Scale the longer wavelength (usually FTIR) data to match the shorter(usually
% ASD) data.
scale_factors = short_data(length(short_data(:,1)),2:end)./(long_data(1,2:end));
scale_factors = repmat(scale_factors, [length(long_data(:,1)), 1]);

% Multiply the long wavelength data by the scale factors
long_spectra_scaled = long_data(:,2:end).*scale_factors;
long_spectra_scaled = [long_data(:,1), long_spectra_scaled];

% Merge the short and scaled data into a single matrix and do the same
% for their corresponding wavelength and wavenumber vectors.
spliced_spectra = [short_data; long_spectra_scaled];

% Plot some results 
subplot(1,2,1)
hold on
plot(spliced_spectra(:,1),spliced_spectra(:,2),'-k');
plot(short_data(:,1),short_data(:,2),'-r');
plot(long_data(:,1),long_data(:,2),'-b');
xlabel('wavelength (um)');
ylabel('Reflectance');
title('Scaled and Original Spectra');
hold off
    
subplot(1,2,2)
hold on
plot(spliced_spectra(:,1),spliced_spectra(:,3),'-k');
plot(short_data(:,1),short_data(:,3),'-r');
plot(long_data(:,1),long_data(:,3),'-b');
xlabel('wavelength (um)');
ylabel('Reflectance');
title('Scaled and Original Spectra');
hold off

end