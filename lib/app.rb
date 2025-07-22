RACK_ENV = ENV.fetch('RACK_ENV', 'development')

require 'bundler'
Bundler.require

require_relative 'hacker_news'
require_relative 'tools/get_stories'
require_relative 'tools/get_comments'

def logger
  @logger ||= Logger.new(STDOUT).tap do |log|
    log.level = case RACK_ENV
                when 'development' then Logger::DEBUG
                when 'production' then Logger::INFO
                when 'test' then Logger::FATAL
                else Logger::DEBUG
                end
    log.progname = 'HnMcpApp'
  end
end

def mcp_server
  server = FastMcp::Server.new(name: 'hn-mcp', version: '1.0.0')
  server.register_tool(GetStories)
  server.register_tool(GetComments)
  server
end

class HnMcpApp < Sinatra::Application
  before { content_type :json }

  use FastMcp::Transports::RackTransport, mcp_server, logger: logger

  set :logger, logger

  get '/health' do
    { status: 'ok', timestamp: Time.now.to_i }.to_json
  end

  get '/' do
    {
      message: 'Hacker News MCP Server',
      version: '1.0.0',
      endpoints: {
        health: '/health',
        mcp: '/mcp'
      }
    }.to_json
  end

  # Run the application if this file is executed directly
  run! if app_file == $0
end
