#!/bin/bash
i=0
while read line; do
  echo "memory[$i] <= 32'b$line ;"
  i=$((i+4))
done < program.bin