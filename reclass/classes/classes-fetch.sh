#!/bin/bash

# Fetches classes referenced/used on model from shared location
# MODEL = PWD if not provided as $2

# Usage:
# ./class-fetch.sh PATH_TO_SHARED_CLASS_DIRECTORY [DESTINATION RECLASS MODEL PATH] [CLUSTER PREFIX]

# sanitize
SOURCE=${1}
MODEL=${2:-$PWD} # full path only
MODEL=$(realpath $MODEL)


function fetch_classes() {

  SOURCE=${1}
  MODEL=${2}
  TEMP=${3:-$(mktemp -d -p $MODEL)}
  CLUSTER_PREFIX=${4}

  # get list of used classes
  declare -a classes
  classes=($(for i in $(find ${MODEL} -name '*.yml'|grep -v 'tmp\.');do cat $i | yaml2json | jq -r '.classes[]'; done |sort -u))

  echo Classes found on $MODEL:
  echo "${classes[@]}" | xargs -n1 echo " - "

  # copy
  if [[ -n "${classes[@]}" ]]; then
      # rsync with pattern
      for cls in ${classes[@]}; do
        # skip classes starting with . (local ref, can't be managed)
        if [[ ${cls} == .* ]]; then
          echo "W: relative classes used ($cls), such can't be fetched"
          continue;
        fi
        cls=$(echo $cls| tr '.' '/')
        echo '~~ '$cls
        #echo rsync -avhmLn --recursive --include "/$cls/init.yml" --include "/$cls.yml" --include='*/' --exclude='*' ${SOURCE}/* $TEMP/$CLUSTER_PREFIX/
        #rsync -avhmLn --recursive --include "/$cls/init.yml" --include "/$cls.yml" --include='*/' --exclude='*' ${SOURCE}/* $TEMP/$CLUSTER_PREFIX/
        rsync -avhmL  --recursive --include "/$cls/init.yml" --include "/$cls.yml" --include='*/' --exclude='*' ${SOURCE}/* $TEMP/$CLUSTER_PREFIX/
      done;
  fi
}

function prefix_classes() {
  # replace:
  # - class.name
  # with:
  # - ${cluster}.class.name

  MODEL=${1:-$PWD}
  MODEL=$(realpath $MODEL)
  CLUSTER_PREFIX=${2:-$CLUSTER_PREFIX}
  CLUSTER_PREFIX=${CLUSTER_PREFIX:-'${cluster}'}

  ls $(find ${MODEL} -name '*.yml') | xargs -rn1 -I% sed -i -e '/^classes:/,/^[a-zA-Z0-9_-]*:/!b' -e "s:^\(\s*-\s*\)\(.*\):\1${CLUSTER_PREFIX}.\2:g" %
}


# NOTE, can't fetch to current structure directly,
# first to TEMP and merge it over current classes.
TEMP=$(mktemp -d -p $MODEL)

fetch_classes $SOURCE $MODEL $TEMP $CLUSTER_PREFIX
#prefix_classes $TEMP $CLUSTER_PREFIX

# MAIN - for all fetched classes merge to current
for i in $(find $TEMP/$CLUSTER_PREFIX -maxdepth 1 -type d |sed "s:$TEMP[\/]*::"); do
  echo "== $i"
  ./classes-merge.sh $TEMP/$CLUSTER_PREFIX/$i ./$i
done

#rm -rf $TEMP
