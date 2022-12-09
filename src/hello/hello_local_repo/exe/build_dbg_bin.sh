@!/bin/bash

bash -c 'cd ../dll; bazel build helper'
bash -c 'cd exe; bazel build -c dbg main'

# In other to run with grb, keep staying in exe directory
