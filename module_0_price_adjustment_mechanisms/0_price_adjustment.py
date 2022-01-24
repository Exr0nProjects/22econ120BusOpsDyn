from matplotlib import pyplot as plt

from random import randint
from math import sqrt

from gc import collect

# def supply(p):
#     return p
# def demand(p):
#     return 30-p
# def f(p):
#     return demand(p) / supply(p)

def f_factory(elasticity):
    def f(P):
        c = 0.3
        e_d = elasticity
        e_s = 0.0
        return c * P ** (e_d - e_s)
    return f

def default_P(t, epsilon, prev, f):
    return ((1-epsilon) + epsilon * f(prev)) * prev

def new_P(t, epsilon, prev, f):
    epsilon = epsilon / sqrt(t+1)
    return ((1-epsilon) + epsilon * f(prev)) * prev

def P_by_f(t, epsilon, prev, f):
    epsilon *= 1.2*abs(1- f(prev))+0.1
    return ((1-epsilon) + epsilon * f(prev)) * prev

def test_f(f, epsilon, total=100, new_P=default_P, color=None):
    num_successes = 0
    # collect()
    for i in range(total):
        P = randint(0, 100) / 50
        while P == 0:
            P = randint(0, 100) / 50
        graph_x = []
        graph_y = []
        graph_f = []
        num_steps = 0
        for i in range(int(1e2)):
            # print("    ",i)
            if abs(((1-epsilon) + epsilon * f(P)) - 1) < 1e-3: break
            P = new_P(i, epsilon, P, f)
            graph_x.append(i)
            # print(P)
            graph_y.append(P)
            graph_f.append(f(P))
            num_steps += 1
        else:
            num_successes -= 1
        num_successes += 1
        # plt.plot(graph_x[0:], graph_y[0:], color="blue")
        plt.plot(graph_x, graph_f, color=color)
    # plt.savefig('price_discovery_out.png')
    return num_successes / total

# for some reason, the maximum value that works changes based on epsilon
# sometimes it takes too long (when epsilon is low), but sometimes low values of elasticity with high epsilon break too??

# while True:
if True:
    # print('start', P)
    epsilon = 0.3

    # for x in range(-20, 20):
    #     # print(x)
    #     # if x == 0: continue
    #     success_ratio = test_f(f_factory(x / 10), epsilon)
    #     print(f"{x/10}: {success_ratio > 0.5} {success_ratio}")

    for x in range(-660, -100000, -1):
    # if True:
    #     x = -30
        success_ratio = [
                test_f(f_factory(x / 100), epsilon, color="gray"),
                test_f(f_factory(x / 100), epsilon, new_P=new_P, color="green"),
                test_f(f_factory(x / 100), epsilon, new_P=P_by_f, color="blue"),
            ]
        plt.show()
        # if success_ratio > 0.5: plt.show()
        print(f"{x/100}: {' '.join([f'{x:.3f}' for x in success_ratio])}")


