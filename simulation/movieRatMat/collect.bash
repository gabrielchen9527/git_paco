#!/bin/bash

cd rawresult-09-25-22-39

cd ga 
cat ga-raw-*-0.88-200 |sort -n> ../../../plot/ga-raw-0.88-20

cd ../even

cat even-raw-*-0.88-200 |sort -n> ../../../plot/even-raw-0.88-20

cd ../inverse

cat inverse-raw-*-0.88-200 |sort -n> ../../../plot/inverse-raw-0.88-20

cd ../loadbalance

cat loadbalance-raw-*-0.88-200 |sort -n> ../../../plot/loadbalance-raw-0.88-20
