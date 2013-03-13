require 'rake/testtask'
require 'find'
require 'uglifier'

Rake::TestTask.new do |t|
	puts 'Starting tests...'
	t.libs << "test"
	t.test_files = FileList['test/test*.rb']
	t.verbose = true
end


JS_DEP = []
LIBS_JS = "lib/libs.js"
LIBS_JS_MIN = "lib/libs.min.js"
Find.find("lib/runtime") do |f|
	#puts f if File.file?(f)
	JS_DEP.push f if File.file?(f) && (f =~ /.*\.js$/)
end

file LIBS_JS => FileList["lib/runtime/*/*.js"] do
	f = File.open LIBS_JS, "w"
	JS_DEP.each do |fn|
		puts fn
		f.write File.read(fn)
		f.write "\n"
	end
	f.close
end

file LIBS_JS_MIN => LIBS_JS do
	r = Uglifier.compile File.read(LIBS_JS)
	File.open(LIBS_JS_MIN, "w") do |f|
		f.write r
		f.write "\n"
	end
end

task :libjs => [LIBS_JS_MIN]
task :default => :libjs

