source "https://rubygems.org"

ruby "3.4.4"

gem "activesupport", "~> 8.1", require: false
gem "fast-mcp", "~> 1.6.0", require: "fast_mcp"
gem "puma", "~> 8.0"
gem "rackup", "~> 2.3"
gem "rake", "~> 13.4"
gem "sinatra", "~> 4.2"

group :development do
  gem "rerun", "~> 0.14"
  gem "standard", "~> 1.54"
end

group :test do
  gem "minitest", "~> 5.27"
  gem "webmock", "~> 3.26"
end

group :development, :test do
  gem "rack-test", "~> 2.2"
end
