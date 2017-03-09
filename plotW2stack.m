% Stacked Wasserstein Metric Plotting Code

% Contributors: Ross Johnson, Hao Wu, Matthias Ihme
% Stanford University, Dept. of Mechanical Engineering
% Most Recent Update: February 23, 2017

% Purpose: Show result of Wasserstein metric calculation, drawing attention
% to 1-D stacked contributions of each species to the total metric.

% Input: stacked_data: Preformatted 4xn matrix of previously computed 
    % W2stack data, where n is the number of W2 calculations to be shown.
   
% Output: Visualization of 1-D stacked contributions towards each
    % [multidimensional] Wasserstein metric calculation.

function plotW2stack(stacked_data)  
    figure
    bar(stacked_data,'stacked');
    
    % Formatting
    xlab = xlabel('$W_2$ Calculations');
    set(xlab,'Interpreter','Latex'); 
    set(xlab,'FontSize',13);

    ylab = ylabel('$W_2$, Normalized');
    set(ylab,'Interpreter','Latex');
    set(ylab,'FontSize',13);

    colormap('gray');
    leg1 = legend('Z', 'T','CO$_2$', 'CO');
    set(leg1,'Location','BestOutside');
    set(leg1,'FontSize',13);
    set(leg1,'Interpreter','latex');
    legend('boxoff')
    
    set (gca, 'FontName','Times New Roman')
    set (gca, 'FontSize',13);
    box on
end
