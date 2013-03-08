# encoding: utf-8

require 'rubygems'
require 'sexp_processor'

class RoffeeWalker < SexpProcessor
	VERSION = '0.0.1'
	def initialize
		super
		self.strict = false
		self.auto_shift_type = true
	end

	def output(line)
		puts line
	end

end
