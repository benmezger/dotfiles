#!/usr/bin/env python3

# Author: Ben Mezger <me@benmezger.nl>
# Created at <2020-09-29 Tue 22:50>

# Some python defaults I find usefull when using the interpreter
# start.py is automatically loaded in Ipython's interpreter

import json
import time
from pprint import pprint


def timeit(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = (time.time() - start) * 1000.0  # ms
        print(f"Function {func.__name__} too {end:0.3f} ms")
        return result

    return wrapper


print("Assigning print to 'pprint.pprint'")
print = pprint

# easier when pasting json with 'true'/'false' values
true = True
false = False
null = None
