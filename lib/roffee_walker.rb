# encoding: utf-8

require 'rubygems'
require 'sexp_processor'

class RoffeeRewriter < SexpProcessor
	BINOP = {
		:== => :_Req,
		:+  => :_Rplus,
		:-  => :_Rsub,
		:*  => :_Rmul,
		:/  => :_Rdiv,
		:%  => :_Rmod,
	}
	def initialize
		super
		self.strict = false
		self.auto_shift_type = true
	end

	def _process_lit(exp)
		v = exp.shift
		case v
		when Fixnum
			s = new_lit :Fixnum, v
		when String
			s = new_lit :String, v
		else
			fail "unknown literal"
		end
		s
	end

	def _process_call(exp)		
		receiver = exp.shift
		method = exp.shift
		n = s(:call, receiver, method)
		exp.delete_if do |arg|
			n << arg
			true
		end
		n
	end

	def process_iter(exp)
		call = process(exp.shift)
		args = process(exp.shift)
		block = process(exp.shift) unless exp.empty?
		block ||= nil
		call <<= s(:defn, nil, args, block)
		call	
	end

	private
	def new_lit type, v
		type = type.to_s.intern unless Symbol === type
		s(:call, s(:const, type), :new, s(:lit, v))
	end

	def rewrite_binop(method)
		n = BINOP[method]
		return method if n.nil?
		return n
	end

end

class RoffeeWalker < SexpProcessor
	VERSION = '0.0.1'
	class Printer
		def initialize(output=nil)
			output ||= STDOUT
			@out = output
			@indent_deep = 0
			@isnewline = true
		end

		def emit(s, space=true)
			@out.write "\t" * @indent_deep if @isnewline
			@out.write " " unless @isnewline || !space
			@out.write s.to_s
			@isnewline = false
		end

		def write(s)
			emit s, false
		end

		def newline force=false
			return if @isnewline && !force
			@isnewline = true
			@out.write "\n"
		end

		def indent
			@indent_deep += 1
		end

		def unindent
			@indent_deep -= 1 if @indent_deep > 0
		end

	end

	def initialize output=nil
		super()
		self.strict = false
		self.auto_shift_type = true
		@printer = Printer.new output
	end

	private
	def emit(s)
		@printer.emit s
	end

	def newline
		@printer.newline
	end

	public
	def process_lit(exp)
		emit exp.shift
		exp
	end

	def process_str(exp)
		emit '"'+exp.shift+'"'
		exp
	end

	def process_array(exp)
		emit "["
		exp.delete_if do |elem|
			process elem
			emit "," unless elem == exp.last
			true
		end
		emit "]"
		exp
	end

	def process_lasgn(exp)
		emit exp.shift
		emit "="
		process(exp.shift)
		exp
	end

	def process_block(exp)
		#TODO
		exp.delete_if do |stmt|
			process stmt unless exp.nil?
			newline
			true
		end
	end

	def process_if(exp)
		emit "if "
		process exp.shift
		newline
		@printer.indent
		process exp.shift
		newline
		@printer.unindent
		el = exp.shift
		unless el.nil?
			emit "else"
			newline
			@printer.indent
			process exp.shift
			@printer.unindent
		end
		newline
		exp
	end

	def process_return(exp)
		emit "return"
		process(exp.shift) unless exp.empty?
		newline
		exp
	end

	def process_const(exp)
		c = exp.shift
		emit c
		exp
	end

	def process_lvar(exp)
		emit exp.shift
		exp
	end

	def process_call(exp)		
		emit "("
		receiver = exp.shift
		process receiver unless receiver.nil?
		method = exp.shift
		@printer.write "." if !receiver.nil? && RoffeeRewriter::BINOP[method].nil?
		@printer.write "#{method}("
		exp.delete_if do |arg|
			process(arg)
			emit "," unless arg == exp.last
			true
		end
		emit ")"
		emit ")"
		exp
	end

	def process_args(exp)
		exp.delete_if do |e|
			if Sexp === e then
				process e
			else
				emit e
			end
			emit "," unless e == exp.last
			true
		end
	end

	def process_defn(exp)
		name = exp.shift
		unless name.nil?
			emit name.to_s
			emit "="
		end
		emit "("
		process(exp.shift)
		emit ") ->"
		newline
		@printer.indent
		exp.delete_if do |stmt|
			process(stmt)
			newline
			true
		end
		@printer.unindent
		newline
		exp
	end

	private
end
