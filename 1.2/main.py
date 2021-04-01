import random
import math
import matplotlib.pyplot as plt

n = 10
omegaMax = 1200
N = 64
k = 1024
tau = 512
Yrxx = []

def Plot(g):
    A = []
    fi = []
    for i in range(n):
        A.append(random.random())
        fii = random.random() * omegaMax
        fi.append(fii)
    for i in range(k):
        res = 0
        for j in range(n):
            res += A[j] * math.sin((omegaMax / (j + 1)) * i + fi[j])
        g.append(res)
        yy = i

def AutoCorr(g):
    return MutualCorr(g, g)

def MutualCorr(g, h):
    res = []
    Rxy = 0
    Mx = Expectancy(g)
    My = Expectancy(h)
    for T in range(tau):
        for t in range(tau):
           Rxy = Rxy + ((g[t] - Mx) * (h[t + T] - My)) / (tau - 1)
        res.append(Rxy)
        Rxy = 0
    return res

def Expectancy(g):
    Mxx = 0
    for t in range(k):
        Mxx += (1 / k) * g[t]
    return Mxx


if __name__ == "__main__":
    x = []
    y = []
    Plot(x)
    Plot(y)
    Rxx = AutoCorr(x)
    plt.plot(Yrxx, Rxx)
    plt.show()
    Rxy = MutualCorr(x, y)
    plt.plot(Yrxx, Rxy)
    plt.show()