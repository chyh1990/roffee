# encoding: utf-8
require 'rubygems'
require 'ruby_parser'

class RoffeeParser
	def self.parse(source)
		RubyParser.new.parse source
	end
end
