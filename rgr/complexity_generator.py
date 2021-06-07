import timeit as time
import time as t
import signal_generator
import statistics_utils


def calculate_time_signal(signal_harmonics, start_frequency, number_discrete_calls):
    time = []
    for n in range(number_discrete_calls):
        start_time = t.time()
        signal_generator.generate_signal(signal_harmonics, start_frequency, n)
        end_time = t.time()
        time.append(end_time - start_time)
    return time


def calculate_time_correlation(signal_harmonics, start_frequency, number_discrete_calls, type_correlation):
    signal_first = signal_generator.generate_signal(signal_harmonics, start_frequency, number_discrete_calls)
    signal_second = signal_generator.generate_signal(signal_harmonics, start_frequency, number_discrete_calls)
    start_time = time.default_timer()

    if type_correlation == 'cross':
        statistics_utils.cross_correlation(signal_first, signal_second)
    else:
        statistics_utils.auto_correlation(signal_first)
    end_time = time.default_timer()
    return end_time - start_time
