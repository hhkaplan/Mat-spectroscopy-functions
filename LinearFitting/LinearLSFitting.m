%This function fits an experimental spectrum (e.g. spectrum of a rock) with
%endmember spectra (i.e. spectra of pure minerals we think are found in the
%rock but in unknown quantities), to predict endmember composition.
%A linear regression is run using Matlabs lsqlin, endmember coefficients
%are constrained to be 0 - 1. An option is given to have endmember
%coefficients add to 1. Fitting procedure can be weighted using a vector of
%weights.

%Example:
% Data = data; one column wavelength, remainder are spectra with unknown composition to be fit
% Endmembers = endmembers; first column is wavelength remainder are endmember spectra that are used to fit the unknown spectrum
% addToOne = 1; 1- true, 0 - false; default is true;
% weights = weighting value to add at each wavelength, default is 1 at
% every wavelength.

%HKaplan 2017

function [result, resN] = LinearLSFitting(Data, Endmembers, addToOne, weights)

% Seperate out the data
End_wav = Endmembers(:,1);
End_spec = Endmembers(:,2:end);
Orig_wav = Data(:,1);
Orig_spec = Data(:,2:end);

%Throw a warning if the wavelengths of endmembers and spectra to be fit do
%not match
if ~isequal(End_wav, Orig_wav)
    error('Wavelengths of the datasets are not equal');
end

if nargin < 3
    addToOne = 1;
end

if nargin < 4
    weights = ones(length(End_wav),1);
end

for i = 1 :size(Orig_spec,2)
    
    %Get spectrum to fit
    Orig = Orig_spec(:,i);
  
    %Set parameters for endmembers (min/max abundance)
    n = size(End_spec,2);
    endmemMinAbun = zeros(n,1);
    endmemMaxAbun = ones(n,1);
    
    %Solve the linear least squares equation
    options = optimset('Display', 'off', 'MaxFunEvals', 1e16, 'TolFun', 1e-16, 'TolX', 1e-16, ...
        'MaxIter', 1000, 'Algorithm', 'interior-point');
    
    if addToOne
        [abunRslt, resnorm,~] = lsqlin(End_spec.*repmat(weights,1,size(End_spec,2)),...
        weights.*Orig, [],[],ones(n,1)',1,  endmemMinAbun, endmemMaxAbun, [], options);
    else
        [abunRslt, resnorm,~] = lsqlin(End_spec.*repmat(weights,1,size(End_spec,2)),...
        weights.*Orig, [],[],[],[],  endmemMinAbun, endmemMaxAbun, [], options);   
    end
    
    %tabulate and plot the results
    result(:,i) = abunRslt;
    resN(:,i) = resnorm;
    
    figure(i)
    plot(Orig_wav, End_spec*abunRslt)
    hold on;
    plot(Orig_wav, Orig)
    legend('Modeled','Measured');
    
end

end
