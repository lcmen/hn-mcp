require_relative 'tools/get_stories_tool'
require_relative 'tools/get_comments_tool'

class McpServer
  def self.build
    server = FastMcp::Server.new(name: 'hacker-news-mcp-server', version: '1.0.0')
    server.register_tool(GetStoriesTool)
    server.register_tool(GetCommentsTool)
    server
  end
end
