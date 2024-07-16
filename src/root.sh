#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No Kernel provided."
  echo "Usage: $0 <kernel>"
  exit 1
fi

kernel="$1"
lqxGpg='9AE4078033F8024D'
keyServer='hkps://keyserver.ubuntu.com'

echo $kernel
