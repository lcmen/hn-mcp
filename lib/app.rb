require 'sinatra'

class HnMcpApp < Sinatra::Base
  before { content_type :json }

  get '/health' do
    { status: 'ok', timestamp: Time.now.to_i }.to_json
  end

  get '/' do
    {
      message: 'Hacker News MCP Server',
      version: '1.0.0',
      endpoints: {
        health: '/health'
      }
    }.to_json
  end

  # Run the application if this file is executed directly
  run! if app_file == $0
end
