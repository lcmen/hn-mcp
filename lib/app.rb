RACK_ENV = ENV.fetch("RACK_ENV", "development")

require "bundler"
Bundler.require

require_relative "hacker_news"
require_relative "tools/get_stories"
require_relative "tools/get_comments"

class HnMcpApp < Sinatra::Application
  before { content_type :json }

  use FastMcp::Transports::RackTransport, HackerNews.mcp_server, logger: HackerNews.logger

  set :logger, HackerNews.logger

  get "/health" do
    {status: "ok", timestamp: Time.now.to_i}.to_json
  end

  get "/" do
    {
      message: "Hacker News MCP Server",
      version: "1.0.0",
      endpoints: {
        health: "/health",
        mcp: "/mcp"
      }
    }.to_json
  end

  # Run the application if this file is executed directly
  run! if app_file == $0
end
