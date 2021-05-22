import random
import math
import matplotlib.pyplot as plt
import time
from multiprocessing import Process, Pipe, Manager
from threading import Thread

n = 10
omegaMax = 1200
N = 64
k = 1024
tau = 512
W = []

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

def Fourier(g):
    Fp = []
    Re = []
    Im = []
    for i in range(len(g)):
        Re.append(math.sin(i * 2 * math.pi / 4))
        Im.append(math.cos(i * 2 * math.pi / 4))
        W.append(math.sqrt((Re[i] * Re[i]) + (Im[i] * Im[i])))
    for k in range(len(g) - 1):
        Wpk = 0
        for p in range(len(g) - 1):
            Wpk = Wpk + W[(p * k) % len(g)]
        Fp.append(g[k] * Wpk)
    return Fp

def FFT(g1, g2):
    fastg = []
    for p in range(int(N / 2) - 1):
        fastg.append(g1[p] + g2[p] * W[p])
    for p in range(int(N / 2), N - 2):
        fastg.append(g1[p - int(N/2)] - g2[p - int(N/2)] * W[p])
    return fastg

def ParallelCompute(g, Fp):
    Fp.extend(Fourier(g))

if __name__ == "__main__":
    xfast = []
    x = []

    x1 = []
    x2 = []
    Fp1 = []
    Fp2 = []
    Plot(x)
    Plot(xfast)

    for i in range(N):
        if(i % 2 == 1):
            x2.append(xfast[i])
        else:
            x1.append(xfast[i])
    p1 = Thread(target=ParallelCompute, args=(x1, Fp1))
    p2 = Thread(target=ParallelCompute, args=(x2, Fp2))
    p1.start()
    p2.start()
    p1.join()
    p2.join()
    FastFp = FFT(Fp1, Fp2)
    Fp = Fourier(x)

    plt.stem([a - b for a, b in zip(FastFp, Fp)])
    plt.show()

