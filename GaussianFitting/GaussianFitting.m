%This code performs curve fitting of spectra using the following
%distributions: Gaussian, Lorentzian, PseudoVoigt, and Skewed Gaussing. The
%user inputs data (wavelength column, n-spectral columns), the expected
%positions of absorptions to be fit with distributions, max width and
%shift parameters to constrain the fitting, and the function that describes
%the desired distribution.

% Example:
% Data = importdata('GREX2.csv');
% x0 = [3.31, 3.35, 3.38, 3.42, 3.45, 3.48, 3.50];
% maxWidth = 0.03;
% maxShift = 0.001;
% func = @SkewGaussFunction;

%HKaplan 2017

function [A, ResN] = GaussianFitting(Data, x0, func, maxWidth, maxShift)

for i = 2:size(Data,2) 
%% Initializing    
    %define data columns
    xdata = Data(:, 1);
    ydata = Data(:, i); 
    
    %Initial parameters for PV and SG distributions
    if (func2str(func) == 'PseudoVoigtFunction')
                %initial guess
        a0 =  [x0;... %band position
            -0.05*ones(1,size(x0,2));... %band depth
            maxWidth*ones(1,size(x0,2));...%band width
            0.5*ones(1,size(x0,2))]; %distr
       
        %lower and upper bounds
        lb = [x0 - (maxShift/2); -1*ones(1,size(x0,2)); zeros(1,size(x0,2)); zeros(1,size(x0,2))]; 
        ub = [x0 + (maxShift/2); zeros(1, size(x0,2)); maxWidth*ones(1,size(x0,2)); ones(1,size(x0,2))];
    
    elseif (func2str(func) == 'SkewGaussFunction') 
        
        a0 =  [x0;... %band position
            -0.05*ones(1,size(x0,2));... %band depth
            maxWidth*ones(1,size(x0,2));...%band width
            0.5*ones(1,size(x0,2))]; %distr
       
        %lower and upper bounds
        lb = [x0 - (maxShift/2); -1*ones(1,size(x0,2)); zeros(1,size(x0,2)); zeros(1,size(x0,2))]; 
        ub = [x0 + (maxShift/2); zeros(1, size(x0,2)); maxWidth*ones(1,size(x0,2)); ones(1,size(x0,2))];
    
    %Initial parameters for Gauss and Lorentz distributions
    else    
        %initial guess
        a0 =  [x0;... %band position
            -0.05*ones(1,size(x0,2));... %band depth
            maxWidth*ones(1,size(x0,2))]; %band width
        
        %lower and upper bounds
        lb = [x0 - (maxShift/2); -1*ones(1,size(x0,2)); zeros(1,size(x0,2))]; 
        ub = [x0 + (maxShift/2); zeros(1, size(x0,2)); maxWidth*ones(1,size(x0,2))];
        
    end 

%% Solving
    %solving options
    options=optimset('MaxFunEvals',100000,'TolFun',1e-5,'MaxIter',10000, 'Display', 'off','DiffMinChange', 1e-5);

    %least squares fitting
    [a, resnorm, residual] = lsqcurvefit(func, a0, xdata,ydata,lb,ub, options);
    
    %tabulate results
    ResN(i-1) = resnorm;
    Band_Centers = a(1,:); Band_Depths = -a(2,:); Band_Widths = a(3,:);
    A{i} = {Band_Centers', Band_Depths', Band_Widths};
    
%% Plotting
    %plot the results
    figure(i)
    plot (xdata, ydata, 'r', 'LineWidth',2, 'LineStyle', '--'); hold on;
    plot(xdata, func(a, xdata), 'black', 'LineWidth', 1.2);
    plotGaussians(xdata, a, func); %%%%% Change this to deal with non-gaussian scenarios, see plotGaussians for details
    
    xlabel('Wavelength','FontSize', 14, 'FontName', 'Helvetica', 'FontWeight', 'bold');
    ylabel('Reflectance', 'FontSize', 14, 'FontName', 'Helvetica', 'FontWeight', 'bold');
    title('Gaussian Best Fit Model', 'FontSize', 16, 'FontName', 'Helvetica', 'FontWeight','bold');
    legend('Data', 'Model', 'Location', 'SouthWest');
    set(gca,...
        'FontSize', 14, ...xdt
        'FontName', 'Helvetica',...
        'Box', 'on',...
        'TickDir', 'out',...
        'LineWidth', 1);

end
end
