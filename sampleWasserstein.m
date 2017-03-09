% Wasserstein Metric Sample Script
%
% Contributors: Ross Johnson, Hao Wu, Matthias Ihme
% Stanford University, Dept. of Mechanical Engineering
% Most Recent Update: March 9, 2017
%
% Purpose: Demonstrate Wasserstein metric calculation procedure for quantitative evaluation of
% simulations, as outlined in manuscript: http://arxiv.org/abs/1702.05539
% This example focuses on an arbitrary point of the Sydney piloted jet flame, located at x/D_J = 10, r/D_J = 0.6.
%
% Inputs: Experimental (expData.cvs) and Simulated data (simData.cvs) for this flame location
% from the experimental configuration of the piloted turbulent burner with inhomgenous inlets
% with operating point FJ-5GP-Lr75-57; related references on the experimental configuration
%  
%  - Meares and  Masri, Combust. Flame, 161(2):484-495, 2014.
%  - Meares, Prasad, Magnotti, Barlow, and Masri, Proc. Combust. Inst., 35(2):1477-1484, 2015.
%  - Barlow, Meares, Magnotti, Cutcher, and Masri, Combust. Flame, 162(10):3516-3540, 2015.
%
% A species index establishing dimensions of the comparison. For this dataset, the data is organized 
% in columns such that:
    % 1: Mixture Fraction
    % 2: Tempertature (K)
    % 3: CO2 Mass Fraction
    % 4: CO Mass Fraction
%
% The scrip calls the main function calcW2, taking inputs for experimental data, simulated data, and a 
% species index-vector from which scalars are evaluted: 
%  - to specify a one-dimensional Z comparison, write: species_index = 1;
%  - To specify a two-dimensional Z-T comparison, write: species_index = [1 2];  
%
% Outputs: Wasserstein metric calculation (W2), Transport matrix (Transport), and stacked Wasserstein 
% metric contributions (Stack). Figures include distribution visualizations for one or two dimensional
% comparisons, as well as plots of stacked contributions to the complete Wasserstein metric. Example 
% visualizations are provided as .png-s in the sample code directory.
%
% Note: Compile emd_hat_mex-files using compile_FastEMD.m from Directory <FastEMD> once, before invoking Pele-Werman algorithm for all future cases.
% Further information on EMD-code available at: http://www.ariel.ac.il/sites/ofirpele/FastEMD/code/

close all 
clear all

addpath('./FastEMD')

%% Read in Data
disp('... reading experimental data: expData.cvs')
% Read in experimental data
headerlines = 5;
expData = csvread('expData.csv',headerlines);

% Read in simulated data
disp('... reading simulated data: simData.cvs')
simData = csvread('simData.csv',headerlines);

disp(' ')
disp('... perform calculations of Wasserstein metric (each calculations takes few seconds)')

%% One-Dimensional Z Comparsion
disp('... cacluates Wasserstein metric for scalar(s): Z')
[W2_Z,Transport_Z,Stack_Z] = calcW2(expData,simData,1);

%% Two-Dimensional Z-T Comparison
disp('... cacluates Wasserstein metric for scalar(s): Z, T')
[W2_ZT,Transport_ZT,Stack_ZT] = calcW2(expData,simData,[1 2]);

%% Four-Dimensional Z-T-CO2-CO Comparison
disp('... cacluates Wasserstein metric for scalar(s): Z, T, CO2, CO')
[W2_4dim,Transport_4dim,Stack_4dim] = calcW2(expData,simData,[1 2 3 4]);

%% Plot Stacked Contributions
disp('... plot results')
Stacked_data = [Stack_Z 0 0 0; Stack_ZT(1) Stack_ZT(2) 0 0;...
                Stack_4dim(1) Stack_4dim(2) Stack_4dim(3) Stack_4dim(4)];
plotW2stack(Stacked_data);
