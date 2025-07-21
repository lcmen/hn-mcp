RACK_ENV = ENV.fetch('RACK_ENV', 'development')

require 'bundler'
Bundler.require

require_relative 'mcp_server'
require_relative 'hacker_news'

class HnMcpApp < Sinatra::Base
  use FastMcp::Transports::RackTransport, McpServer.build

  before { content_type :json }

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
