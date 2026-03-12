#!/bin/bash
for f in "$@"
do
    /opt/LastOS/LLStore/llstore -e $f
done
