#!/usr/bin/env ruby

require 'roffee_compiler'
require 'coffee-script'
file = File.open(ARGV[1], "w+")
rewriter = RoffeeRewriter.new
processor = RoffeeWalker.new file
sexp1 = RoffeeParser.parse File.read(ARGV[0])
STDERR.write sexp1.to_s+"\n"
p1 = rewriter.process sexp1
STDERR.write p1.to_s+"\n"
p2 = processor.process p1
file.rewind
result = file.read
file.close
STDERR.write result+"\n============\n"
js = CoffeeScript.compile result
puts js

