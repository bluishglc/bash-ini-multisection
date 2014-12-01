#!/bin/bash

cfg_parser ()
{
    ini="$(<$1)"                # read the file
    ini="${ini//[/\[}"          # escape [
    ini="${ini//]/\]}"          # escape ]
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
      if [ "${line:0:1}" == "[" ] ; then
        # close previous section
        eval "cfg_${section}+=(\"$vals\")"
        if [ "$line" == "[CFG_END]" ]; then
          break
        fi
        # new section
        section=${line#[}
        section=${section%]}
        secs=${sections[*]}
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
}

cfg_section_keys ()
{
  eval "keys=(\${!cfg_$1[@]})"
}

cfg_section ()
{
  section=$1
  key=$2
  if [ "$key" == "" ] ; then
    key=0
  fi
  eval "vals=\${cfg_$section[$key]}"
  eval $vals
}

