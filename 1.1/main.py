import random
import math
import matplotlib.pyplot as plt

n = 10
omegaMax = 1200
N = 64
k = 512
x = []
y = []
Dx = 0
Mx = 0


def Plot():
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
        x.append(res)
        yy = i
        y.append(yy)

def Expectancy():
    Mxx = 0
    for t in range(k):
        Mxx += (1 / k) * x[t]
    return Mxx

def Dispersion():
    Dx = 0
    for t in range(k):
        Dx += (1 / (k - 1)) * (x[t] - Mx) * (x[t] - Mx)
    return Dx


if __name__ == "__main__":
    Plot()
    print(Expectancy())
    print(Dispersion())
    plt.plot(y, x)
    plt.show()

