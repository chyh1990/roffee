#!/bin/bash

for f in test/tests/*.rb; do
	echo $f
	TMP=$(mktemp /tmp/coffee.XXXXX)
	echo $TMP
	ruby -Ilib test.rb "$f"  $TMP || exit 1

	rm -f $TMP
done

