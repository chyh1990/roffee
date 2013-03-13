#!/bin/bash

TMP=$(mktemp /tmp/testXXXX.js)
cat lib/libs.js > $TMP
echo "" >> $TMP
cat output.js >> $TMP
cat $TMP
echo "================"
node $TMP
#ruby <<EOF
#require 'rubygems'
#require 'execjs'
#ExecJS.exec File.read("$TMP")
#EOF
rm -f $TMP
