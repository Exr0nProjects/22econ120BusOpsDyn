# plan
# 1.

# resources
# https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.linprog.html

N = 2   # number of input variables
M = 3   # number of constraints

import numpy as np
from scipy.optimize import linprog

# variable meanings in linprog
# X : Nx1
# C : 1xN
# minimize C @ X
# A_ub @ x <= b_ub
# A_eq @ x == b_eq
# lb <= x <= ub

## here, c : N x K, c_b: 1 x K, where there are K conditions + c_b_i among which we maximize
# convex objective example to model: https://www.geogebra.org/calculator/fpfhmpza
def convert_convex_objective(c, c_b, A_ub, b_ub, A_eq, b_eq, bounds=[], x_0=None):
    if bounds != []: raise NotImplementedError("bounds not implemented, need to if bounds != [] then linprog() else linprog(bounds=None)")
    # assert c.shape[1] == x_0.shape[0]
    # assert c.shape[0] == c_b.shape[0]
    # assert x_0.shape[1] == c_b.shape[1]

    # minimize z subject to z.broadcast() <= (c @ x + c_b), A_eq @ x = b_eq, A_ub @ x <= b_ub
    # lets tack on z to the end
    neo_c = np.array([[0]*c.shape[0] + 1])
    neo_A_ub = np.concatenate((A_ub, np.array([0] * A_ub.shape[1])), axis=1)    # need vertical concat for the maximize constraints

    print('c', c, neo_c)
    print('A_ub', A_ub, neo_A_ub)

    return

    if bounds == []:
        return linprog(neo_c, neo_A_ub, neo_b_ub, A_eq, b_eq)
    else:
        return linprog(neo_c, neo_A_ub, neo_b_ub, A_eq, b_eq, bounds)

if __name__ == '__main__':
    convert_convex_objective()
