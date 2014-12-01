=== Bash INI parser multikey ===

This is a parser for ini files, written in bash, which allows for multiple repeats of a given section. Each repeat of a section can be accessed independently.

You should be able to see how to use it from the test script `test.sh`, or use the examples below.


  $ . ./ini-multikey.sh       # include the library
  $ cfg_parser test.ini       # parse a file (e.g. test.ini in this repository)
  $ cfg_section_keys lunch    # find the keys for '[lunch]' entries.
  $ echo "${keys[@]}"         # print them out. there are two keys, '0' and '1'
  0 1
  $ cfg_section lunch 1       # read in the settings for the second '[lunch]' section.
  $ echo $name                # you can then access the settings as normal bash variables
  smoked mackerel with salad
  $ echo $time
  5 minutes
