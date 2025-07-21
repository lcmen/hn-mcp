class TestApp < Minitest::Test
  def test_root_endpoint
    get '/'

    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type

    data = JSON.parse(last_response.body)
    assert_equal 'Hacker News MCP Server', data['message']
    assert_equal '1.0.0', data['version']
    assert data['endpoints'].key?('health')
    assert_equal '/mcp', data['endpoints']['mcp']
  end

  def test_health_endpoint
    get '/health'

    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type

    data = JSON.parse(last_response.body)
    assert_equal 'ok', data['status']
    assert data['timestamp'].is_a?(Integer)
  end

  def test_mcp_server_creation
    server = McpServer.build
    assert_equal 'hacker-news-mcp-server', server.name
    assert_equal '1.0.0', server.version
  end

  def test_get_stories_tool_creation
    tool = GetStoriesTool.new
    assert_equal 'get_stories', tool.name
    assert_includes tool.description, 'Fetch stories from Hacker News'
    
    # Test argument schema
    args = tool.instance_variable_get(:@arguments)
    assert args[:story_type][:required]
    assert_equal 'string', args[:story_type][:type]
    assert_includes args[:story_type][:enum], 'top'
    assert_includes args[:story_type][:enum], 'new'
  end

  def test_get_comments_tool_creation
    tool = GetCommentsTool.new
    assert_equal 'get_comments', tool.name
    assert_includes tool.description, 'Fetch comments for a specific Hacker News story'
    
    # Test argument schema  
    args = tool.instance_variable_get(:@arguments)
    assert args[:story_id][:required]
    assert_equal 'integer', args[:story_id][:type]
    refute args[:max_depth][:required]
  end

  def test_tools_registered_in_server
    server = McpServer.build
    tools = server.instance_variable_get(:@tools) || []
    
    tool_classes = tools.map(&:class)
    assert_includes tool_classes, GetStoriesTool
    assert_includes tool_classes, GetCommentsTool
  end
end