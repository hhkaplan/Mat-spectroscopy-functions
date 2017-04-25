Data = importdata('/Users/Hannah/Desktop/GREX2.csv');
x0 = [3.38, 3.42, 3.48, 3.50];
maxWidth = 0.05;
maxShift = 0.0001;
func = @GaussianFunction;

for i = 2: 5%size(Data,2) 
    
    %define data columns
    xdata = Data(:, 1);
    ydata = Data(:, i); 

    %initial guess
    a0 =  [x0;... %band position
          -0.05*ones(1,size(x0,2));... %band depth
          maxWidth*ones(1,size(x0,2))]; %band width

    %lower and upper bounds
    lb = [x0 + (maxShift/2); -1*ones(1,size(x0,2)); zeros(1,size(x0,2))]; 
    ub = [x0 - (maxShift/2); zeros(1, size(x0,2)); maxWidth*ones(1,size(x0,2))]; 

    %solving options
    options=optimset('MaxFunEvals',100000,'TolFun',1e-5,'MaxIter',10000, 'Display', 'off','DiffMinChange', 1e-3);

    %least squares fitting
    [a, resnorm, residual, exitflag,output, l, j] = lsqcurvefit(func, a0, xdata,ydata,lb,ub, options);
    
    disp(a)
    %tabulate results
    Band_Centers = a(1,:); Band_Depths = -a(2,:); Band_Widths = a(3,:);

    %plot the results
    figure(i)
    plot (xdata, ydata, 'r', 'LineWidth',2, 'LineStyle', '--'); hold on;
    plot(xdata, func(a, xdata), 'black', 'LineWidth', 1.2);
    plotGaussians(xdata, a, 'gauss'); %%%%% Change this to deal with non-gaussian scenarios, see plotGaussians for details
    
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
