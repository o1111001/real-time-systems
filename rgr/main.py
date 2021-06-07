import numpy as np
from dataclasses import dataclass
from random import randint
from typing import List
import matplotlib.pyplot as plt
from times import get_times
from concurrent.futures import ProcessPoolExecutor, wait, ALL_COMPLETED
from collections import defaultdict


@dataclass
class Task:
    time_start: int
    time_count: int
    k: int
    l: int

    @property
    def time_deadline(self) -> int: return self.time_start + self.k * self.time_count


def fifo(queue: List[Task]) -> int:
    return 0


def defalt(): return 0


def edf(queue: List[Task]) -> int:
    return min(enumerate(queue), key=lambda t: t[1].time_deadline)[0]


def rm(queue: List[Task]) -> int:
    smallest_time_index = min(enumerate(queue), key=lambda t: t[1].time_count)[0]

    smallest_tasks_by_time = [(i, t) for i, t in enumerate(queue) if
                              t.time_count == queue[smallest_time_index].time_count]

    return min(smallest_tasks_by_time, key=lambda t: t[1].l)[0]


class Scheduler:
    number_of_ticks = 0
    queue: List[Task] = list()
    rejected = 0
    work_ticks = 0
    left_to_exec = None
    total_wt = 0
    total_processed_tasks = 0

    def __init__(self, erlang1, erlang2, n=256, simulation_length=1000, selection_strategy=fifo, k=2, l1=3, l2=5):
        self.simulation_length = simulation_length
        self.selection_strategy = selection_strategy
        self.l1 = l1
        self.l2 = l2
        self.k = k
        self.erlang1 = erlang1
        self.erlang2 = erlang2
        self.times = get_times(n=n)
        self.dict = defaultdict(defalt)

    def __calculate_wt(self, t: Task):
        fake_queue = list(self.queue)
        wait_time = 0
        while True:
            i = self.selection_strategy(fake_queue)
            if fake_queue[i] == t:
                break
            wait_time += fake_queue[i].time_count
            fake_queue.pop(i)
        return wait_time

    def __select(self):
        return self.selection_strategy(self.queue)

    def __new_task(self):
        was_added = False
        if self.erlang1[self.number_of_ticks] > self.erlang1[self.number_of_ticks - 1]:
            time_count = self.times[randint(0, 1)]
            self.queue.append(Task(self.number_of_ticks, time_count, self.k, self.l1))
            was_added = True
        if self.erlang2[self.number_of_ticks] > self.erlang2[self.number_of_ticks - 1]:
            time_count = self.times[2 + randint(0, 1)]
            self.queue.append(Task(self.number_of_ticks, time_count, self.k, self.l2))
            was_added = True
        if was_added is True:
            wt = self.__calculate_wt(self.queue[-1])
            self.dict[wt // 200] += 1
            self.total_wt += wt
            self.total_processed_tasks += 1

    def one_tick(self):
        if self.number_of_ticks != 0:
            self.__new_task()
        for i, t in enumerate(self.queue):
            if self.number_of_ticks > t.time_deadline - t.time_count:
                self.rejected += 1
                del self.queue[i]
        if self.left_to_exec is None and len(self.queue) != 0:
            i = self.__select()
            self.left_to_exec = self.queue.pop(i).time_count
        if self.left_to_exec is not None:

            self.work_ticks += 1

            self.left_to_exec -= 1

            if self.left_to_exec == 0:
                self.left_to_exec = None
        self.number_of_ticks += 1

    def simulate(self):
        for i in range(self.simulation_length):
            self.one_tick()
        return self

    @property
    def awt(self):
        return self.total_wt / self.total_processed_tasks

    @property
    def work_time(self):
        return self.work_ticks / self.number_of_ticks


def main():
    simulation_length = 100
    awt = [[], [], []]
    work_time = [[], [], []]
    xs = list(range(1, 11))
    erlang_k = 10
    k = 5
    with ProcessPoolExecutor() as pool:
        for l in xs:
            print(f'l = {l}')

            erlang1 = np.cumsum(np.random.gamma(1 / erlang_k, 1 / l, simulation_length))
            erlang2 = np.cumsum(np.random.gamma(1 / erlang_k, 1 / l, simulation_length))
            filo_scheduler = Scheduler(erlang1=erlang1, erlang2=erlang2, selection_strategy=fifo,
                                       simulation_length=simulation_length, l1=l, l2=l, k=k)
            edf_scheduler = Scheduler(erlang1=erlang1, erlang2=erlang2, selection_strategy=edf,
                                      simulation_length=simulation_length, l1=l, l2=l, k=k)
            rm_scheduler = Scheduler(erlang1=erlang1, erlang2=erlang2, selection_strategy=rm,
                                     simulation_length=simulation_length, l1=l, l2=l, k=k)
            schedulers = [filo_scheduler, edf_scheduler, rm_scheduler]
            futures = []
            for s in schedulers:
                futures.append(pool.submit(s.simulate))
            wait(futures, return_when=ALL_COMPLETED)
            schedulers = [f.result() for f in futures]
            for i, s in enumerate(schedulers):
                awt[i].append(s.awt)
                work_time[i].append(s.work_time)

    simulation_length = 100
    l = 4
    erlang1 = np.cumsum(np.random.gamma(1 / erlang_k, 1 / l, simulation_length))
    erlang2 = np.cumsum(np.random.gamma(1 / erlang_k, 1 / l, simulation_length))
    filo_scheduler = Scheduler(erlang1=erlang1, erlang2=erlang2, selection_strategy=fifo,
                               simulation_length=simulation_length, l1=l, l2=l, k=k)
    edf_scheduler = Scheduler(erlang1=erlang1, erlang2=erlang2, selection_strategy=edf,
                              simulation_length=simulation_length, l1=l, l2=l, k=k)
    rm_scheduler = Scheduler(erlang1=erlang1, erlang2=erlang2, selection_strategy=rm,
                             simulation_length=simulation_length, l1=l, l2=l, k=k)
    filo_scheduler.simulate()
    edf_scheduler.simulate()
    rm_scheduler.simulate()
    wtd = [None, None, None]
    wtd[0] = sorted(filo_scheduler.dict.items())
    wtd[1] = sorted(edf_scheduler.dict.items())
    wtd[2] = sorted(rm_scheduler.dict.items())
    plt.figure(dpi=200, figsize=(16, 9))
    plt.subplot(311)
    plt.title('Залежність кількості заявок від часу очікування при фіксованій інтенсивності')
    plt.plot(list(map(lambda v: v[0] * 200, wtd[0])), list(map(lambda v: v[1], wtd[0])), label='fifo', color="r")
    plt.plot(list(map(lambda v: v[0] * 200, wtd[1])), list(map(lambda v: v[1], wtd[1])), label='edf', color="m")
    plt.plot(list(map(lambda v: v[0] * 200, wtd[2])), list(map(lambda v: v[1], wtd[2])), label='rm', color="c")
    plt.legend()
    plt.subplot(312)
    plt.title('Залежність середнього часу очікування від інтенсивності')
    plt.plot(xs, awt[0], label='fifo', color="r")
    plt.plot(xs, awt[1], label='edf', color="m")
    plt.plot(xs, awt[2], label='rm', color="c")
    plt.legend()
    plt.subplot(313)
    plt.title('Залежність проценту простою від інтенсивності')
    plt.step(xs, work_time[0], label='fifo', color="r")
    plt.step(xs, work_time[1], label='edf', color="m")
    plt.step(xs, work_time[2], label='rm', color="c")
    plt.legend()
    plt.savefig('out/out.png', pad_inches=0.1, bbox_inches='tight')
    plt.show()


if __name__ == '__main__':
    main()
