# Wasserstein Metric Sample Plotting Code

# Contributors: Ross Johnson, Hao Wu, Matthias Ihme
# Stanford University, Dept. of Mechanical Engineering
# Most Recent Update: February 23, 2017

# Purpose: Show result of Wasserstein metric calculation, alongside
# data visualizations for one-dimensional and two-dimensional comparisons.

# Inputs:
    # pdf1, pdf2: Sample pdfs that have been downsampled and normalized
        # within the calcW2.m function
    # species_index: Dimensions of W2 comparsion
    # std_pdf1: Local experimental standard deviation
    # W2: Calculated W2 value
   
# Outputs: Wasserstein metric, with 1-D/2-D data visualization.

import matplotlib.pyplot as plt

def plotW2(pdf1,pdf2,species_index,std_pdf,W2):
    plt.rc('text', usetex=True)
    plt.rc('font', family='serif')
    ## One dimensional case
    if len(species_index) == 1:
        # Consider case that built-in 'histogram' function does not exist
        # Use 'hist' function instead

        numBins = 20

        fig, ax = plt.subplots(1)
        # One Dimensional Histograms, with data unnormalized
        ax.hist(pdf1.iloc[:, species_index[0]], bins=numBins, density=True, alpha=0.7, edgecolor='black')
        ax.hist(pdf2.iloc[:, species_index[0]], bins=numBins, density=True, alpha=0.7, edgecolor='black')
        ax.xaxis.label.set_size(13)
        ax.yaxis.label.set_size(13)

        ax.text(0.8, 0.5, 'W$_2$ = %s' % str(round(W2, 3)), fontsize=15, horizontalalignment='center',
                verticalalignment='center', transform=ax.transAxes)

        # Title
        if species_index[0] == 0:
            ax.set_xlabel('Z (Unnormalized)')
        elif species_index[0] == 1:
            ax.set_xlabel('T (K, Unnormalized)')
        elif species_index[0] == 2:
            ax.set_xlabel('CO_2 Mass Fraction (Unnormalized)')
        elif species_index[0] == 3:
            ax.set_xlabel('CO Mass Fraction (Unnormalized)')
        else:
            ax.set_xlabel('Species Values (Natural Units)')

        ax.set_ylabel('Normalized Histogram (pdf)')

        ax.legend(['Experiment PDF', 'Simulation PDF'], loc='best', fontsize=13)

        plt.show(block=False)


    elif len(species_index) == 2:

        fig, ax, = plt.subplots(1)

        ax.scatter(pdf1.iloc[:, species_index[0]]/std_pdf[species_index[0]], pdf1.iloc[:, species_index[1]]/std_pdf[species_index[1]], facecolors='none', edgecolors='b')
        ax.scatter(pdf2.iloc[:, species_index[0]]/std_pdf[species_index[0]], pdf2.iloc[:, species_index[1]]/std_pdf[species_index[1]], facecolors='none', edgecolors='r')
        ax.xaxis.label.set_size(13)
        ax.yaxis.label.set_size(13)

        ax.text(0.8, 0.5, 'W$_2$ = %s' % str(round(W2, 3)), fontsize=15, horizontalalignment='center',
                verticalalignment='center', transform=ax.transAxes)

        # x label
        if species_index[0] == 0:
            ax.set_xlabel('Z (Normalized)')
        elif species_index[0] == 1:
            ax.set_xlabel('T (K, Normalized)')
        elif species_index[0] == 2:
            ax.set_xlabel('CO_2 Mass Fraction (Normalized)')
        elif species_index[0] == 3:
            ax.set_xlabel('CO Mass Fraction (Normalized)')
        else:
            ax.set_xlabel('Species 1 Values (Natural Units)')

        # y label
        if species_index[1] == 0:
            ax.set_ylabel('Z (Normalized)')
        elif species_index[1] == 1:
            ax.set_ylabel('T (K, Normalized)')
        elif species_index[1] == 2:
            ax.set_ylabel('CO_2 Mass Fraction (Normalized)')
        elif species_index[1] == 3:
            ax.set_ylabel('CO Mass Fraction (Normalized)')
        else:
            ax.set_ylabel('Species 2 Values (Natural Units)')

        ax.legend(['Experiment PDF', 'Simulation PDF'], loc='best', fontsize=13)

        plt.show(block=False)





