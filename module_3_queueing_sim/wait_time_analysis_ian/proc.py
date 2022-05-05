import pandas as pd
from tqdm import tqdm
from matplotlib import pyplot as plt
import numpy as np
from datetime import datetime

def add_fn_plot(ax, fn, bounds=[0, 50]):
    ax = ax.twinx() # create another y axis, https://stackoverflow.com/a/7734614
    x = np.linspace(*bounds, 100)
    y = [fn(xv) for xv in x]
    ax.set_ylim([0, max(y)*1.7])
    # ax.set_ylim([0, 1.5])
    ax.set_ylabel('theoretical probability')
    ax.plot(x, y, 'r')

lambda_arrival = 5
mu_checkout = 0.2

lambda_arrival, mu_checkout = 1/lambda_arrival, 1/mu_checkout

THEORETICAL_DISTRIBUTIONS = [
    lambda x: 0,
    lambda x: (mu_checkout*lambda_arrival/(lambda_arrival+mu_checkout)) * np.exp(-lambda_arrival*x),
]

if __name__ == '__main__':
    with open('queue_times.csv', 'r') as rf:
        # for theory_dist, (customer_n, line) in zip(THEORETICAL_DISTRIBUTIONS, enumerate(rf)):
        for customer_n, line in enumerate(rf):
            wait_times = [float(x) for x in line.split(',')]


            # plot stuff
            fig, ax = plt.subplots()
            ax.set_xlim([0, 150])
            ax.hist(wait_times, bins=100)

            # overlay predicted distribution
            # add_fn_plot(ax, theory_dist, [0, max(tqdm(wait_times, desc='normalizing...', leave=False))])

            # label and show
            ax.set_title(f'distribution of wait times for customer {customer_n+1}')
            ax.set_ylabel('# of trials (histogram)')
            ax.set_xlabel('wait time')
            plt.savefig(f"/Users/albhuan/Desktop/busops3_{datetime.now()}.png", dpi=300)
            # plt.show()
            # input()

