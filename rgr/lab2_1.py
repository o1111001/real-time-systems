import numpy as np
from math import sin, cos, pi


import math

def calc_w(p, k, N):
    argument = 2.0 * math.pi * p * k / N
    return complex(math.cos(argument), -math.sin(argument))

def dft(signal):
    N = len(signal)
    spectre = [0] * N
    for p in range(N):
      for k in range(N):
        x = signal[k]
        w = calc_w(p, k, N)
        spectre[p] += w * x
    return [*map(lambda el: abs(el), spectre)]
