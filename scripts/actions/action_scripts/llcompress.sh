#!/bin/bash
for f in "$@"
do
    /opt/LastOS/LLStore/llstore -c $f
done
