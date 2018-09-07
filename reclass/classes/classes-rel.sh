#!/bin/bash

# Replace classes: section with relative names to subdirectories

# USAGE: ./classes-rel.sh FOLDER

folder=$1

for i in $(find $folder -type f -name "*.yml"); do
  d_dot=$(dirname $i | tr '/' '.'|sed -e "s:$PWD::" -e "s/\.\.//")
  sed -i "s/^\(\s*-\s*\)$d_dot/\1/g" $i ;
done
