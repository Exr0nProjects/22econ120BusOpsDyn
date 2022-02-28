from matplotlib import pyplot as plt
import numpy as np
from tqdm import tqdm
from random import choices
from math import *

NUM_URNS = 1000

def sim_urn(steps=1000, n_stones=2, add=1, save_steps=[]):
    num_stones = [1] * n_stones
    ret = []
    for i in tqdm(range(steps), leave=False):
        drawn = choices(range(n_stones), weights=num_stones, k=1)[0]
        num_stones[drawn] += add
        if len(save_steps) > 0 and i == save_steps[0]:
            ret.append(num_stones[:])
            save_steps.pop(0)
    ret.append(num_stones[:])
    return ret

if __name__ == '__main__':
    cap = int(1e4)
    num = int(log10(cap))
    linspace = np.linspace(1, cap, num=num)
    sims = []
    for u in tqdm(range(NUM_URNS)):
        s = sim_urn(steps=cap, save_steps=[int(x) for x in linspace])
        sims.append([a/(a+b) for a, b in s])

    sims = np.array(sims).T
    print(sims)

    linspace = np.linspace(1, cap, num=num)
    for steps, row in zip(linspace, sims):
        plt.title(f"n steps = {int(steps) + 1}")
        plt.hist(row)
        plt.show()

    # weirdly, it seems like the distribution stays uniform, even though it diverges in the limit
