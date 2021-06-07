import numpy as np


def math_expectation(signal_data):
    return np.mean(signal_data)


def math_variance(signal_data):
    return np.var(signal_data)


def cross_correlation(signal1_data, signal2_data):
    result = np.correlate(signal1_data, signal2_data, mode='same')
    return result


def auto_correlation(signal_data):
    result = np.correlate(signal_data, signal_data, mode='full')
    return result[result.size // 2:]

