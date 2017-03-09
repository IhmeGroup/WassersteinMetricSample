% Wasserstein Metric Sample Plotting Code

% Contributors: Ross Johnson, Hao Wu, Matthias Ihme
% Stanford University, Dept. of Mechanical Engineering
% Most Recent Update: February 23, 2017

% Purpose: Show result of Wasserstein metric calculation, alongside
% data visualizations for one-dimensional and two-dimensional comparisons.

% Inputs:
    % pdf1, pdf2: Sample pdfs that have been downsampled and normalized
        % within the calcW2.m function
    % species_index: Dimensions of W2 comparsion
    % std_pdf1: Local experimental standard deviation
    % W2: Calculated W2 value
   
% Outputs: Wasserstein metric, with 1-D/2-D data visualization.

function plotW2(pdf1,pdf2,species_index,std_pdf1,W2)

%% One dimensional case
if length(species_index) == 1
    % Consider case that built-in 'histogram' function does not exist
    % Use 'hist' function instead
    if (exist('histogram')) < 1
        
        figure;
        hold on
        numBins = 20;
        
        % One Dimensional Histograms, with data unnormalized
        hist(std_pdf1(species_index).*pdf1,numBins);
        hist(std_pdf1(species_index).*pdf2,numBins);
        
        histograms = findobj(gca,'Type','patch');
        hist2 = histograms(1); % Indices backwards, so that colors are right
        hist1 = histograms(2);
        set(hist1,'FaceColor',[0.000,  0.447,  0.741]);
        set(hist1,'FaceAlpha',0.7);
        set(hist2,'FaceColor',[0.850,  0.325,  0.098]);
        set(hist2,'FaceAlpha',0.7);
        
        % Variable x-Axis labeling
        if species_index == 1
            xlab = xlabel('Z (Unnormalized)');
        elseif species_index == 2
            xlab = xlabel('T (K, Unnormalized)');
        elseif species_index == 3
            xlab = xlabel('CO$_2$ Mass Fraction (Unnormalized)');
        elseif species_index == 4
            xlab = xlabel('CO Mass Fraction (Unnormalized)');
        else
            xlab = xlabel('Species Values (Natural Units)');
        end
        set(xlab,'Interpreter','Latex');
        set(xlab,'FontSize',13);

        ylab = ylabel('Frequency');
        set(ylab,'Interpreter','Latex');
        set(ylab,'FontSize',13);

        leg1 = legend('Experiment PDF','Simulation PDF','Location','northeastoutside');
        set(leg1,'FontSize',13);
        set(leg1,'Interpreter','latex');
        legend('boxoff')

        % Annotate with W2 value
        textb = annotation('textbox');
        set(textb,'String',sprintf('$W_2 =$ %.3f', W2.*std_pdf1(species_index)));
        set(textb,'Interpreter','latex');
        set(textb,'FontSize',13);
        set(textb,'FontName','Times New Roman');
        set(textb,'BackgroundColor','none');
        set(textb,'Units','normalized');
        set(textb,'LineStyle','none');
        set(textb,'HorizontalAlignment','center');

        gpos = get(gca,'Position');
        set(textb,'Position',[gpos(1)+(0.32*gpos(3)) gpos(2)+0.8*gpos(4) .4*gpos(3) .15*gpos(4)]);

        set (gca, 'FontName','Times New Roman')
        set (gca, 'FontSize',13);
        box on   
        
    else
        % Use built-in 'histogram' function, for newer versions of MATLAB
        figure;
        hold on
        numBins = 20;
        % One Dimensional Histograms, so data is un-normalized
        hist1 = histogram(pdf1.*std_pdf1(species_index),numBins,'Normalization','pdf');
        hist2 = histogram(pdf2.*std_pdf1(species_index),numBins,'Normalization','pdf');
        hist2.BinWidth = hist1.BinWidth;

        % Variable x-Axis labeling
        if species_index == 1
            xlab = xlabel('Z (Unnormalized)');
        elseif species_index == 2
            xlab = xlabel('T (K, Unnormalized)');
        elseif species_index == 3
            xlab = xlabel('CO$_2$ Mass Fraction (Unnormalized)');
        elseif species_index == 4
            xlab = xlabel('CO Mass Fraction (Unnormalized)');
        else
            xlab = xlabel('Species Values (Natural Units)');
        end
        xlab.Interpreter = 'Latex';
        xlab.FontSize = 13;

        ylab = ylabel('Normalized Histogram (pdf)');
        ylab.Interpreter = 'Latex';
        ylab.FontSize = 13;

        leg1 = legend('Experiment PDF','Simulation PDF','Location','northeastoutside');
        leg1.FontSize = 13;
        leg1.Interpreter = 'latex';
        legend('boxoff')

        % Annotate with W2 value
        textb = annotation('textbox');
        textb.String = sprintf('$W_2 =$ %.3f', W2.*std_pdf1(species_index));
        textb.Interpreter = 'latex';
        textb.FontSize = 13;
        textb.FontName = 'Times New Roman';
        textb.BackgroundColor = 'none';
        textb.Units = 'normalized';
        textb.LineStyle = 'none';
        textb.HorizontalAlignment = 'center';

        gpos = get(gca,'Position');
        textb.Position = [gpos(1)+(0.32*gpos(3)) gpos(2)+0.8*gpos(4) .4*gpos(3) .15*gpos(4)];

        set (gca, 'FontName','Times New Roman')
        set (gca, 'FontSize',13);
        box on  
    end
end

%% Two dimensional case
if length(species_index) == 2
    
    figure;
    hold on
    % Two Dimensional Scatter Plots, so data remains normalized
    scatter(pdf1(:,1),pdf1(:,2),'b');
    scatter(pdf2(:,1),pdf2(:,2),'r');

    % Variable x-Axis labeling
    if species_index(1) == 1
        xlab = xlabel('Z (Normalized Units)');
    elseif species_index(1) == 2
        xlab = xlabel('T (Normalized Units)');
    elseif species_index(1) == 3
        xlab = xlabel('CO$_2$ Mass Fraction (Normalized Units)');
    elseif species_index(1) == 4
        xlab = xlabel('CO Mass Fraction (Normalized Units)');
    else
        xlab = xlabel('Species 1 Values (Normalized Units)');
    end
    xlab.Interpreter = 'Latex';
    xlab.FontSize = 13;
    
    % Variable y-Axis labeling
    if species_index(2) == 1
        ylab = ylabel('Z (Normalized Units)');
    elseif species_index(2) == 2
        ylab = ylabel('T (Normalized Units)');
    elseif species_index(2) == 3
        ylab = ylabel('CO$_2$ Mass Fraction (Normalized Units)');
    elseif species_index(2) == 4
        ylab = ylabel('CO Mass Fraction (Normalized Units)');
    else
        ylab = ylabel('Species 2 Values (Normalized Units)');
    end
    ylab.Interpreter = 'Latex';
    ylab.FontSize = 13;
    
    leg1 = legend('Experiment PDF','Simulation PDF','Location','northeastoutside');
    leg1.FontSize = 13;
    leg1.Interpreter = 'latex';
    legend('boxoff')
    
    % Annotate with W2 value
    textb = annotation('textbox');
    textb.String = sprintf('$W_2 =$ %.3f', W2);
    textb.Interpreter = 'latex';
    textb.FontSize = 13;
    textb.FontName = 'Times New Roman';
    textb.BackgroundColor = 'none';
    textb.Units = 'normalized';
    textb.LineStyle = 'none';
    textb.HorizontalAlignment = 'center';
    
    gpos = get(gca,'Position');
    textb.Position = [gpos(1)+(0.32*gpos(3)) gpos(2)+0.8*gpos(4) .4*gpos(3) .15*gpos(4)];
    
    set (gca, 'FontName','Times New Roman')
    set (gca, 'FontSize',13);
    box on
    
end

