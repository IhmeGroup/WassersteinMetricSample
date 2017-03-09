function [W2, Transport, W2stacked] = calcW2(pdf1,pdf2,species_index)
% Wasserstein  Metric Calculation Code

% Contributors: Ross Johnson, Hao Wu, Matthias Ihme
% Stanford University, Dept. of Mechanical Engineering
% Most Recent Update: March 9, 2017

% Purpose: Calculate 2nd Wasserstein metric, based on provided inputs.

% Inputs: Experimental(pdf1) and Simulated(pdf2) data and species of interest (species_index), corresponding to 
% columns in pdf1 and pdf2

% Outputs: Wasserstein metric calculation (W2), Transport matrix (Transport), and stacked Wasserstein metric 
% contributions (Stack). Outputs also include distribution visualizations for one or two dimensional comparisons.

% Note: Run compile_FastEMD.m, just once, before invoking Pele-Werman algorithm for all future cases.


%% Pre-Processing
rng(10); % Set a default random sampling seed

% Number of data samples; Set at N = 500 for this example that make the analysis managable, 
% cost for evaluating Wasserstein metric increases with N
N = 500; 

% pdf1 and pdf2 could have different lengths, which would result in a
% longer runtime for the Wasserstein metric calculation; recommend
% downsampling to N limit for faster runtimes
pdf1 = datasample(pdf1,N,1,'Replace',false);
pdf2 = datasample(pdf2,N,1,'Replace',false);

% Normalize data by experimental standard deviation
std_pdf1 = std(pdf1); % Local standard deviation

% Use global standard deviation for datasets covering more than one axial/radial location
std_pdf1 = repmat(std_pdf1, N, 1);
pdf1 = pdf1./std_pdf1;
pdf2 = pdf2./std_pdf1;

% Extract data corresponding to species of interest
pdf1 = pdf1(:,species_index);
pdf2 = pdf2(:,species_index);

%% Processing

% Build pair-wise distance matrix using Euclidean distance betweeen bins
C = zeros(length(pdf1),length(pdf2));

for iter = 1:length(pdf1)
    for iter2 = 1:length(pdf2)
        sq_sum = 0; % squared sum, with contributions from each dimension
        for iter3 = 1:length(species_index)
            sq_sum = sq_sum + (pdf1(iter,iter3)-pdf2(iter2,iter3)).^2;
            C(iter,iter2) = sqrt(sq_sum);
        end
    end
end

% Prescribe settings for Pele-Werman "Fast EMD" algorithm
extra_mass_penalty = 0; % Default = 0;
transport_setting = 2; % Case where algorithm delivers "Transport Matrix"

% Compute Wasserstein metric, using Pele-Werman algorithm
tic
% For P and Q inputs, consider an empirical PDF with equal weighting
[Calc_out, Transport] = emd_hat_mex(ones(length(pdf1),1)./length(pdf1),...
                                    ones(length(pdf2),1)./length(pdf2),C.^2,extra_mass_penalty,transport_setting);

W2 = sqrt(Calc_out);

%% Post Processing
% Plot outputs for one-dimensional and two-dimensional cases
plotW2(pdf1,pdf2,species_index,std_pdf1,W2);

%% Stacked Wasserstein Metric

% Calculate stacked contributions
if length(species_index)>1
    
    % Revised D matrix, which considers each of the multiple dimensions individually  
    C_1d = zeros(length(pdf1),length(pdf2),length(species_index));

    for iter = 1:length(pdf1)
        for iter2 = 1:length(pdf2)
            for iter3 = 1:length(species_index)
                C_1d(iter,iter2,iter3) = abs(pdf1(iter,iter3)-pdf2(iter2,iter3));
            end
        end
    end

    % Compute 1d W2s, using transport matrix of multidimensional calculation
    contrib_1d = zeros(length(species_index),1);  
    for iter = 1:length(species_index)
        contrib_1d(iter,1) = sum(sum(Transport.*(C_1d(:,:,iter).^2)));
    end
    
    % Calculate proportion of the total Wasserstein metric, based on individual contribution
    proportion_1d = contrib_1d./sum(contrib_1d);
    
    % Truncate rounding error, ensuring sum of proportions is one
    sum_proportion = sum(proportion_1d);
    for iter = 1:length(species_index)
        if proportion_1d(iter,1) == max(proportion_1d)
            proportion_1d(iter,1) = proportion_1d(iter,1) + (1-sum_proportion);
        end
    end
    
    % Calculate stacked contribution
    W2stacked = (W2.*proportion_1d);
else
    W2stacked = W2; % if previously 1-D, then stacked contribution is 1-D
end

%% Print results to Command Line
toc
% Print results of non-stacked calculation
if length(species_index)<2
    % Unnormalized, natural units
    disp(sprintf('W_2 = %.3f', W2.*std_pdf1(species_index))); 
else
    % Normalized units for dimension > 1
    disp(sprintf('W_2 = %.3f', W2));
end 
