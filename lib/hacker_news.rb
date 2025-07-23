require_relative "hacker_news/client"
require_relative "hacker_news/story"
require_relative "hacker_news/comment"
require_relative "hacker_news/parser"

module HackerNews
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
    server.register_tool(GetStories)
    server.register_tool(GetComments)
    server
  end
end
