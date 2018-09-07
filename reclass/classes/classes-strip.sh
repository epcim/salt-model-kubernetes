#!/bin/bash

# Strip system/service and cluster level prefix in classes

# USAGE: ./classes-strip.sh

folder=${1:-}

# replace cluster. with prefix.
if [[ -n "$folder" ]]; then
  prefix="$(echo $folder | tr '/' '.')."
  echo "# $prefix"
fi

for i in $(find $folder -type f -name "*.yml"); do sed -i 's/^\(\s*-\s*\)system\./\1/g' $i ;done
for i in $(find $folder -type f -name "*.yml"); do sed -i 's/^\(\s*-\s*\)service\./\1/g' $i ;done
for i in $(find $folder -type f -name "*.yml"); do
  d_dot=$(dirname $i | tr '/' '.'|sed -e "s:$PWD::" -e "s/\.\.//")
  sed -i "s/^\(\s*-\s*\)cluster\.[-_a-zA-Z0-9]*\./\1$prefix/g" $i ;
done
