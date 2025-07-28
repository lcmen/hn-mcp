# Puma configuration for HN MCP Server

environment ENV["RACK_ENV"] || "development"

rackup "config.ru"
port ENV["PORT"] || 3000

threads_count = Integer(ENV["MAX_THREADS"] || 5)
threads threads_count, threads_count

# Workers
if ENV["RACK_ENV"] == "development"
  workers 0
else
  workers Integer(ENV["WEB_CONCURRENCY"] || 2)
  preload_app!
end

pidfile "tmp/pids/puma.pid"
state_path "tmp/pids/puma.state"

worker_timeout 60
