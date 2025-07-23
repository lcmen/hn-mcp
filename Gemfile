source "https://rubygems.org"

ruby "3.4.4"

gem "sinatra", "~> 4.1"
gem "rackup", "~> 2.2"
gem "puma", "~> 6.6"
gem "fast-mcp", "~> 1.5.0", require: "fast_mcp"

group :development do
  gem "rerun", "~> 0.14"
  gem "standard", "~> 1.39"
end

group :test do
  gem "minitest", "~> 5.25"
  gem "webmock", "~> 3.25"
end

group :development, :test do
  gem "rack-test", "~> 2.2"
end

gem "rake", "~> 13.3"
