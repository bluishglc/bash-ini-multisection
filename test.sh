. ./ini-multikey.sh

cfg_parser test.ini

cfg_section global
echo "[global]"
echo "subject=$subject"
echo

for section in breakfast lunch dinner; do
  cfg_section_keys $section
  for key in "${keys[@]}"; do
    echo "[$section]"
    cfg_section $section $key
    echo "name=$name"
    echo "time=$time"
    echo
  done
done

