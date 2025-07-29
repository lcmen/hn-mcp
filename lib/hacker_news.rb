module HackerNews
  def self.auth_token
    ENV.fetch("AUTH_TOKEN") do
      if ENV["RACK_ENV"] == "production"
        raise "AUTH_TOKEN environment variable is not set"
      else
        "token"
      end
    end
  end

  def self.logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.level = case RACK_ENV
      when "development" then Logger::DEBUG
      when "production" then Logger::INFO
      when "test" then Logger::FATAL
      else Logger::DEBUG
      end
      log.progname = "HnMcpApp"
    end
  end

  def self.mcp_server
    server = FastMcp::Server.new(name: "hn-mcp", version: "1.0.0")
    server.register_tool(Tools::GetStories)
    server.register_tool(Tools::GetComments)
    server
  end
end
