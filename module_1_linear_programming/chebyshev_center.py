import numpy as np
# given a set of constraints, find the maximal n-hypersphere that fits in the constraints

if __name__ == '__main__':
    a = np.array([[-1, -1,  0, -1],
                  [ 0,  3, -1,  0],
                  [ 0, -3,  1,  0],
                  [ 0,  0,  1,  1],
                  [ 1,  0,  0,  0],
                  [ 0,  0, -1,  0]])
    x = np.array([1, 1, 1, 1])
    b = np.array([-2, 5, -5, 3, 0, 0])

    print(a.dot(x))
    print(b)

