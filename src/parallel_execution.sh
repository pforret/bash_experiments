#!/usr/bin/env bash

#-# PARALLEL EXECUTION
#-# experiments in running processes/programs in parallel


#-# Experiment 1: generate a list of one-liners, feed them to xargs to execute them simultaneously

for i in {1..5} ; do
    echo "( sleep $i ; echo $i; )"
done \
| xargs
