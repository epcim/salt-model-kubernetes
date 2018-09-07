#!/bin/bash

source=$1
dest=$2

#verbose='-v'

# cleanup
source=$(realpath $source)
dest=$(realpath $dest)

function ymloveryml() {
  # simply merge two yamls
  # 1 - source (wins)
  # 2 - dest
  spruce merge $2 $1 > $2.spruce
  mv $verbose $2.spruce $2
}

function ymloverdir() {
  # yaml here is right side (higher level) => overrides
  # 1 - yaml
  # 2 - dest dir
  if [[ -e $2/init.yml ]]; then
    # 1 transition to init and overrides init at 2
    spruce merge $2/init.yml $1 > $2/init.yml.spruce
    mv $verbose $2/init.yml.spruce $2/init.yml
  else
    # 1 transition to init
    cp $verbose $1 $2/init.yml
  fi
}

function diroveryml() {
  # dir here is right side (higher level) => overrides
  # 1 - dir
  # 2 - dest yaml
  dest_path=$(dirname $2)
  dest_name=$(basename $2 .yml)

  mkdir -p $dest_path/$dest_name

  if [[ -e $1/init.yml ]]; then
    # merge $1/init.yml over $2
    spruce merge $2 $1/init.yml > $dest_path/$dest_name/init.yml.spruce
    mv $verbose $dest_path/$dest_name/init.yml.spruce $dest_path/$dest_name/init.yml
    rm $verbose $2
  else
    # 2 transition to init
    #NO#cp $verbose $1/* $dest_path/$dest_name/
    mv $verbose $2 $dest_path/$dest_name/init.yml
  fi
}


# merge system over service directories
for c_file in $(find $source/ -type f -name "*.yml"); do

  echo "-- $c_file"

  d=$(dirname $c_file |sed -e "s:$source[\/]*::")
  c=$(basename $c_file .yml)

  # falback if empty
  d=${d:-.}

  # check dest .yml exist where dir should be
  x=''; # x iterates over path elements to full path of class
  for i in $(echo $d | tr '/' ' '  |xargs -n1); do
    x=$x'/'$i;
    if test -f $dest/$x.yml; then
      echo "E: Dest FILE $dest/$x.yml exist where $source/$x should came";
      diroveryml $source/$x $dest/$x.yml
    #else
      #mkdir -p $dest/$x
      #NO#cp $verbose $source/$x/* $dest/$x/
    fi
  done

  # check dir exist where yml to be copied
  if test -d $dest/$d/$c; then
      echo "E: Dest DIR $dest/$d/$c exist but $source/$d/$c.yml file to be copied"
      ymloverdir $source/$d/$c.yml $dest/$d/$c
  else
    # copy c_file
    mkdir -p $dest/$d
    if test -e $dest/$d/$c.yml; then
      # do merge, c_file over dest
      ymloveryml $source/$d/$c.yml $dest/$d/$c.yml
    else
      # just copy c_file
      cp $verbose $source/$d/$c.yml $dest/$d/$c.yml
    fi
  fi

done
