@!/bin/bash

bash -c 'cd ../dll; bazel build -c opt helper'
bash -c 'bazel build -c dbg main'

# In other to run with gdb, keep staying in exe directory

# ldd bazel-bin/main
# gdb bazel-bin/main