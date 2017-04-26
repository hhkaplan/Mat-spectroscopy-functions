% Data = data; one column wavelength, remainder are spectra with unknown composition to be fit
% Endmembers = endmembers; first column is wavelength remainder are endmember spectra that are used to fit the unknown spectrum
% addToOne = 1; 1- true, 0 - false; default is true;
% weights = weighting value to add at each wavelength, default is 1s


function [result, resN] = LinearLSFitting(Data, Endmembers, addToOne, weights)

disp(size(Data))
% Seperate out the data
End_wav = Endmembers(:,1);
End_spec = Endmembers(:,2:end);
Orig_wav = Data(:,1);
Orig_spec = Data(:,2:end);


%Throw a warning if the wavelengths of endmembers and spectra to be fit do
%not match
if ~isequal(End_wav, Orig_wav)
    disp('Wavelengths not equal');
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
