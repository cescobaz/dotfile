#!/bin/bash

clock() {
  DATETIME=$(date)
  echo -n "$DATETIME"
}
cpu() {
  awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf("%.0f %%", ($2+$4-u1) * 100 / (t-t1)); }' \
                <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)
}

memory() {
  free | grep Mem | awk '{ printf("%.0f %%", $3/$2 * 100.0) }'
}

while true; do
  echo "%{c}$(clock)%{r}cpu: $(cpu) mem: $(memory)"
  sleep 1
done
