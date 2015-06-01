#!/bin/bash

cfg_parser ()
{
    ini="$(<$1)"                # read the file
    oldifs=$IFS
    IFS=$'\n' && ini=( ${ini} ) # convert to line-array
    ini=( ${ini[*]//;*/} )      # remove comments with ;
    ini=( ${ini[*]/\    =/=} )  # remove tabs before =
    ini=( ${ini[*]/=\   /=} )   # remove tabs be =
    ini=( ${ini[*]/\ =\ /=} )   # remove anything with a space around =
    ini+=("[CFG_END]") # dummy section to terminate
    sections=()
    section=CFG_NULL
    vals=""
    for line in "${ini[@]}"; do
      #echo $line
      if [ "${line:0:1}" == "[" ] ; then
        #echo "section mark"
        # close previous section
        eval "cfg_${section}+=(\"$vals\")"
        #eval echo "cfg_$section[@]"
        if [ "$line" == "[CFG_END]" ]; then
          break
        fi
        # new section
        section=${line#[}
        section=${section%]}
        #echo "section: $section"
        secs="${sections[*]}"
        if [ "$secs" == "${secs/$section//}" ] ; then
          sections+=($section)
          eval "cfg_${section}=()"
        fi
        vals=""
        continue
      fi
      key=${line%%=*}
      value=${line#*=}
      value=${value//\"/\\\"}
      if [ "$vals" != "" ] ; then
        vals+=" "
      fi
      vals+="$key='$value'"
    done
    IFS=$oldifs
}

cfg_section_keys ()
# read number of keys (subsections) in a given section
{
  eval "keys=(\${!cfg_$1[@]})"
}

cfg_section ()
# read in settings for a specific key in a given section
{
  section=$1
  key=$2
  if [ "$key" == "" ] ; then
    key=0
  fi
  eval "vals=\${cfg_$section[$key]}"
  eval $vals
}

cfg_section_merge ()
# read and merge all settings for all keys of a given section
{
  cfg_section_keys $1
  for key in "${keys[@]}"; do
    cfg_section $section $key
  done
}
