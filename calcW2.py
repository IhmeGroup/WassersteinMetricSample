# computation of the wassersstein metric:

import numpy as np
from plotW2 import plotW2
import matplotlib.pyplot as plt
try:
    import ot
except:
    print('Install pot package first!')

def calcW2(pdf1,pdf2,species_index):

    #sample size
    N = 500

    # pdf1 and pdf2 could have different lengths, which would result in a longer
    # runtime for the Wasserstein metric calculation; recommend downsampling to
    # N limit for faster runtimes

    pdf1 = pdf1.sample(N)
    pdf2 = pdf2.sample(N)

    # normalize standard deviation based on pdf1
    std_pdf = np.std(pdf1.values, axis=0)

    # Nomralize the pdfs with the standard deviation
    pdf1_norm = np.zeros((N, pdf1.shape[1]))
    pdf2_norm = np.zeros((N, pdf2.shape[1]))

    for i in range(0,pdf1.shape[1]):
        pdf1_norm[:,i] = pdf1.iloc[:,i] / std_pdf[i]
        pdf2_norm[:,i] = pdf2.iloc[:,i] / std_pdf[i]

    # Extract data corresponding to species
    # pdf1_norm = pdf1_norm[:, species_index]
    # pdf2_norm = pdf2_norm[:, species_index]

    # now the processing part

    # Build pair-wise distance matrix using Euclidean distance betweeen bins
    C = np.zeros([len(pdf1_norm),len(pdf2_norm)])

    # loop to get the components c_ij of the distance matrix
    for iter1 in range(0,len(pdf1_norm)):
        for iter2 in range(0,len(pdf2_norm)):
            sq_sum = 0 # square sum, to be updated in the loop
            for iter3 in species_index:
                sq_sum = sq_sum + (pdf1_norm[iter1, iter3] - pdf2_norm[iter2, iter3])**2
                C[iter1, iter2] = np.sqrt(sq_sum)

    # correct until here!

    # this is now where the fast EDM algorithm by Pele-Werman is needed
    Calc_out = ot.emd2(np.ones(len(pdf1))/len(pdf1), np.ones(len(pdf2))/len(pdf2), C**2)
    Transport = ot.emd(np.ones(len(pdf1)) / len(pdf1), np.ones(len(pdf2)) / len(pdf2), C ** 2)

    # get the W2 matrix
    W2 = np.sqrt(Calc_out)

    # plot the data
    plotW2(pdf1,pdf2,species_index,std_pdf,W2)

    ###############################################
    # calculate stacked Wasserstein Metric
    ###############################################

    if len(species_index) > 1:

        #  Revised D matrix, which considers each of the multiple dimensions individually
        C_1d = np.zeros((len(pdf1_norm),len(pdf2_norm),len(species_index)))

        for iter1 in range(0,len(pdf1_norm)):
            for iter2 in range(0,len(pdf2_norm)):
                sq_sum = 0 # square sum, to be updated in the loop
                for iter3 in species_index:
                    C_1d[iter1, iter2, iter3] = abs(pdf1_norm[iter1,iter3]-pdf2_norm[iter2,iter3])

        # compute 1d W2s, using transport matrix of multidimensional calculation
        contrib_1d = np.zeros(len(species_index))
        for iter in species_index:
            contrib_1d[iter] = sum(sum(np.multiply(Transport,C_1d[:,:,iter]**2)))

        # Calculate proportion of the total Wasserstein metric, based on individual contribution
        proportion_1d = contrib_1d/sum(contrib_1d)

        # Turncate rounding error, ensuring sum of proportions is one
        sum_proportion = sum(proportion_1d)
        for iter in species_index:
            if proportion_1d[iter] == max(proportion_1d):
                proportion_1d[iter] = proportion_1d[iter] + (1-sum_proportion)

        # Calculate stacked contribution
        W2stacked = W2*proportion_1d

    else:
        W2stacked = W2

    # print results to cmd line


    return W2, Transport, W2stacked
