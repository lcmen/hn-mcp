source "https://rubygems.org"

ruby "3.4.4"

gem "activesupport", "~> 8.0", require: false
gem "fast-mcp", "~> 1.5.0", require: "fast_mcp"
gem "puma", "~> 7.1"
gem "rackup", "~> 2.2"
gem "rake", "~> 13.3"
gem "sinatra", "~> 4.2"

group :development do
  gem "rerun", "~> 0.14"
  gem "standard", "~> 1.51"
end

group :test do
  gem "minitest", "~> 5.25"
  gem "webmock", "~> 3.25"
end

group :development, :test do
  gem "rack-test", "~> 2.2"
end
