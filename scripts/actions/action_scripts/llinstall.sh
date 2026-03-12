#!/bin/bash
for f in "$@"
do
    /opt/LastOS/LLStore/llstore -i $f
done
