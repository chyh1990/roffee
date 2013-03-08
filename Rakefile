require 'rake/testtask'

Rake::TestTask.new do |t|
	puts 'Starting tests...'
	t.libs << "test"
	t.test_files = FileList['test/test*.rb']
	t.verbose = true
end
