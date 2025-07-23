require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.ruby_opts = ["-rhelper"]
end

# StandardRB tasks
desc "Run StandardRB linter"
task :lint do
  sh "bundle exec standardrb"
end

desc "Run StandardRB linter with autofix"
task :lint_fix do
  sh "bundle exec standardrb --fix"
end

task default: [:lint, :test]
