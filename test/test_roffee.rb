require 'tempfile'
require 'roffee_compiler'
require 'coffee-script'

EX1=<<EOF
def conditional1 arg1=1, arg2
	return 1 if arg1 == 0
	puts "abc"
	if arg1 == 2
		puts "a"
		puts "b"
	end
	puts (4+3)*3
	return 0
end

puts conditional1(2)
EOF

EX2=<<EOF

def foo2 
	2.upto(10) do  |i|
		if i%2 == 0
			puts i
		end
	end
	3.downto(-1) do |i|
		puts i
	end
end

puts foo2
EOF

def pretty_print sexp, depth=0
	sexp.each do |s|
		if Sexp === s
			pretty_print s, depth+1
		else
			puts "\t"*depth + s.inspect
		end
	end
end

sexp1 = RoffeeParser.parse EX2
p sexp1
#pretty_print sexp1
puts ""
file = Tempfile.new('roffee')
puts file.path
rewriter = RoffeeRewriter.new
processor = RoffeeWalker.new file

p1 = rewriter.process sexp1
p p1
puts ""
p2 = processor.process p1
p p2
puts ""

file.rewind
result = file.read
file.close

result.split("\n").each_with_index do |v,i|
	puts "#{i+1}\t#{v}"
end

begin
	js = CoffeeScript.compile result
	puts js
	File.open("output.js", "w") do |f|
		f.write js
	end
rescue Exception => ex
	puts ex.message
end

