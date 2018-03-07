# Stacked Wasserstein Metric Plotting Code

# Contributors: Ross Johnson, Hao Wu, Matthias Ihme
# Stanford University, Dept. of Mechanical Engineering
# Most Recent Update: February 23, 2017

# Purpose: Show result of Wasserstein metric calculation, drawing attention
# to 1-D stacked contributions of each species to the total metric.

# Input: stacked_data: Preformatted 4xn matrix of previously computed 
    # W2stack data, where n is the number of W2 calculations to be shown.
   
# Output: Visualization of 1-D stacked contributions towards each
# [multidimensional] Wasserstein metric calculation.

import matplotlib.pyplot as plt

def plotW2stack(stacked_data):
    plt.rc('text', usetex=True)
    plt.rc('font', family='serif')
    #grey scale colormap
    plt.style.use('grayscale')

    fig, ax, = plt.subplots(1)
    ax.xaxis.label.set_size(13)
    ax.yaxis.label.set_size(13)

    stacked_data.plot.bar(stacked=True, ax=ax, rot=0)

    plot_range = range(1,stacked_data.shape[0]+1)
    # for i in range(0,stacked_data.shape[1]):
    #     if i > 0:
    #         ax.bar(plot_range, stacked_data[:, i], bottom = stacked_data[:, i-1])
    #     else:
    #         ax.bar(plot_range, stacked_data[:, i])

    ax.xaxis.label.set_size(13)
    ax.yaxis.label.set_size(13)
    
    # Formatting
    ax.set_xlabel('$W_2$ Calculations')

    ax.set_ylabel('$W_2$, Normalized')
    ax.legend(['Z', 'T','CO$_2$', 'CO'], fontsize=13)

    plt.sca(ax)
    plt.xticks([0,1,2], ['1','2','3'])

    plt.show(block=False)



