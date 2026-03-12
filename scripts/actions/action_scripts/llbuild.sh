#!/bin/bash
for f in "$@"
do
    /opt/LastOS/LLStore/llstore -b $f
done
