from os import path
from time import time
import signal_generator
import statistics_utils
import lab2_1
import lab2_2
from pathlib import Path
import numpy as np
from math import ceil

FILE_PATH = 'out/times.txt'
HARMONICS = 10
FREQUENCY = 1500
DISCRETE_CALLS = 256

def get_times(n: int = 256, repeat_times=100, is_main=False):
    Path((path.dirname(FILE_PATH))).mkdir(exist_ok=True)

    if Path(FILE_PATH).is_file() and is_main is False:
        with open(FILE_PATH, 'r') as f:
            lines = [line.strip() for line in f]
            if n == int(lines[0]):
                times = [int(line) for line in lines[1:]]
                return times

    times = np.empty((4, repeat_times))
    for i in range(repeat_times):
        signal = signal_generator.generate_signal(
            HARMONICS,
            FREQUENCY,
            DISCRETE_CALLS
        )
        start = time()
        statistics_utils.math_expectation(signal)
        statistics_utils.math_variance(signal)
        end = time()
        times[0, i] = (end - start)
        start = time()
        statistics_utils.auto_correlation(signal, signal)
        end = time()

        times[1, i] = (end - start)
        start = time()
        lab2_1.dft(signal)
        end = time()
        times[2, i] = (end - start)
        start = time()
        lab2_2.fft(signal)
        end = time()
        times[3, i] = (end - start)
    times = [ceil(t * 10_000) for t in np.mean(times, axis=1)]
    with open(FILE_PATH, 'w') as f:
        print(n, file=f)
        for t in times:
            print(t, file=f)
    return times

if __name__ == ' main ':
    get_times(is_main=True)
