require_relative "bootstrap"

class HnMcpApp < Sinatra::Application
  before { content_type :json }

  use Middleware::DowncaseHeaders
  use Middleware::HijackResponse
  use FastMcp::Transports::AuthenticatedRackTransport,
    HackerNews.mcp_server,
    allowed_origins: [],
    auth_token: HackerNews.auth_token,
    localhost_only: false,
    logger: HackerNews.logger

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
