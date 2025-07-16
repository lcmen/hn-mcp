if ENV['RACK_ENV'] == 'development'
  workers 0
else
  workers Integer(ENV['WEB_CONCURRENCY'] || 2)
  preload_app!
end

threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

rackup 'config.ru'
port        ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'