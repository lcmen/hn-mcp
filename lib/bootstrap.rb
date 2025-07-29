RACK_ENV = ENV.fetch("RACK_ENV", "development")

require "bundler"
Bundler.require

lib_dir = File.expand_path(__dir__)

# Configure Zeitwerk for autoloading from `lib` directory
loader = Zeitwerk::Loader.new
loader.push_dir(lib_dir)

# Ignore files that shouldn't be autoloaded
loader.ignore("#{lib_dir}/app.rb")
loader.ignore("#{lib_dir}/bootstrap.rb")

loader.setup
loader.eager_load
