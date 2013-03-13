#!/bin/bash

ruby -Ilib test.rb test/tests/"$1" output.coffee |tee output.js

