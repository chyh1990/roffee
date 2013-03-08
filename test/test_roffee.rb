require 'roffee_compiler'

EX1=<<EOF
def conditional1 arg1
	return 1 if arg1 == 0
	return 0
end
EOF

sexp1 = RoffeeParser.parse EX1
p sexp1
processor = RoffeeWalker.new
p processor.process sexp1


