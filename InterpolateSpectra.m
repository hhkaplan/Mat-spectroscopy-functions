%This function  is used to interpolate spectra; as many spectral datasets as 
%desired can be input and all data will be interpolated to the wavelengths 
%listed in vector 'wavelengths'. Outputs will include wavelengths and
%interpolated measurements. This uses a linear interpolation, values
%outside of the wavelength range for interpolation are returned as NAN.

%HKaplan, 2017

% example input:
% Filepath = '/Users/hannahkaplan/Desktop/';
% Filename = 'Test';
% spec_data = xlsread([Filepath Filename '.xlsx'],2);
% wavelengths = linspace(0.9,10,100);
%[out1, out2] = InterpolateSpectra(wavelengths, spec_data(:,1:2),spec_data(:,[1,3]))

function [varargout] = InterpolateSpectra(wavelengths, varargin)

wavelengths = wavelengths(:);

%First case: not enough inputs
if (nargin < 2)
    disp('Not enough inputs')
    return

else
    %interpolate all inputs using wavelengths listed
    for i = 1:length(varargin)
        vq = interp1(varargin{i}(:,1),varargin{i}(:,2:end),wavelengths,'linear');
        disp(vq)
        varargout{i} = [wavelengths,vq];
    end
    
end


end
