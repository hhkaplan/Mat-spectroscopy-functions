%This function takes all CSV files in a folder and adds them to a single
%dataset (full_perc_data). This works for FTIR data which has a first
%column of wavenumber and second column of reflectance data. Data is
%reduced and the output is a wavelength (microns) column with following
%reflectance data scaled to 1.

%HKaplan, 2017

function full_perc_data = Concatenate_FTIR_Outputs(fpath)

%find all filenames in the directory
filens = dir( fullfile(fpath,'*.CSV'));
files = strcat(fpath,{filens.name}');

% Read data from files and store in cell array
Full_series = cell(numel(files),1);
for i=1:numel(files)
  if i == 1
    newData = importdata(files{i});
    Full_series{i} = newData(:,:); %Adds both wavenumer and reflectance from first file
  else
    newData = importdata(files{i});
    Full_series{i} = newData(:,2); %Adds reflectance only from remaining files
  end
end

% Combine all into a matrix
data = horzcat(Full_series{:});

% Divide reflectances by 100 and replace wavenumber column with wavelengths
% in microns
full_perc_data = [10000./data(:,1), data(:,2:end)./100];

%names column can also be output if necessary
names =  {'Wavelength',filens.name};