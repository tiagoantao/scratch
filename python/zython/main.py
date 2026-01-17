import numpy as np


def main(n: np.int16) -> np.int16:
    print(f"Hello from zython {n}!")
    return n + 1


if __name__ == "__main__":
    x = main(np.int16(1))
    print(type(x))
