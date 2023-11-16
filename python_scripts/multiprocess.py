import multiprocessing as m
import time

# Generic time-consuming function
# We don't actually parallelize it, but we will use it to compare the time
# by running it several times sequentially and in parallel
def fibo(n):
    return fibo(n-1) + fibo(n-2) if n > 1 else n

# Measure the same thing across n runs using k processes
def run_and_measure(n_runs, k_processes):
    start = time.time()
    for i in range(n_runs):
        with m.Pool(k_processes) as p:
            p.map(fibo, [30]*10)
    end = time.time()

    print(f"Elapsed on average with {k_processes} process(es) : {(end - start)/n_runs} sec")

if __name__ == '__main__':
    print("Number of CPUs available : ", m.cpu_count())

    n_runs = 10 # Number of runs for more precise measurements
    run_and_measure(n_runs, 1)
    run_and_measure(n_runs, 2)
    run_and_measure(n_runs, 4)