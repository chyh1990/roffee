#!/bin/bash

TMP=$(mktemp /tmp/testXXXX.js)
cat lib/runtime/std_base.js > $TMP
echo "" >> $TMP
cat output.js >> $TMP
cat $TMP
node $TMP
rm -f $TMP
