class TestApp < Minitest::Test
  def setup
    super
    stub_hn_api_calls
  end

  def test_root_endpoint
    get '/'

    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type

    data = JSON.parse(last_response.body)
    assert_values({ 'message' => 'Hacker News MCP Server', 'version' => '1.0.0' }, data)
    assert data['endpoints'].key?('health')
    assert_values({ 'mcp' => '/mcp' }, data['endpoints'])
  end

  def test_health_endpoint
    get '/health'

    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type

    data = JSON.parse(last_response.body)
    assert_values({ 'status' => 'ok' }, data)
    assert data['timestamp'].is_a?(Integer)
  end

  def test_mcp_tools_list_request_accepted
    payload = {
      jsonrpc: '2.0',
      id: 'test-123',
      method: 'tools/list',
      params: {}
    }
    post '/mcp/messages', payload.to_json, mcp_headers

    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  def test_mcp_get_stories_tool_call_accepted
    payload = {
      jsonrpc: '2.0',
      id: 'test-456',
      method: 'tools/call',
      params: {
        name: 'GetStories',
        arguments: { story_type: 'top', limit: 5 }
      }
    }
    post '/mcp/messages', payload.to_json, mcp_headers

    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  def test_mcp_get_comments_tool_call_accepted
    payload = {
      jsonrpc: '2.0',
      id: 'test-456',
      method: 'tools/call',
      params: {
        name: 'GetComments',
        arguments: { story_id: 123, max_depth: 2 }
      }
    }
    post '/mcp/messages', payload.to_json, mcp_headers

    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  def test_mcp_invalid_origin_blocked
    payload = {
      jsonrpc: '2.0',
      id: 'test-123',
      method: 'tools/list',
      params: {}
    }
    headers = mcp_headers.merge('HTTP_ORIGIN' => 'http://malicious.com')
    post '/mcp/messages', payload.to_json, headers

    assert_equal 403, last_response.status
  end

  def test_mcp_base_path_not_found
    payload = {
      jsonrpc: '2.0',
      id: 'test-123',
      method: 'tools/list',
      params: {}
    }
    post '/mcp', payload.to_json, mcp_headers

    assert_equal 404, last_response.status
  end

  def test_mcp_sse_endpoint_exists
    get '/mcp/sse', {}, mcp_headers

    assert_equal 200, last_response.status
  end

  def test_mcp_server_responds_to_tools_list
    payload = {
      jsonrpc: '2.0',
      id: 'test-123',
      method: 'tools/list',
      params: {}
    }
    post '/mcp/messages', payload.to_json, mcp_headers

    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  def test_mcp_server_responds_to_tool_calls
    payload = {
      jsonrpc: '2.0',
      id: 'test-456',
      method: 'tools/call',
      params: {
        name: 'GetStories',
        arguments: { story_type: 'top' }
      }
    }
    post '/mcp/messages', payload.to_json, mcp_headers

    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  private


  def mcp_headers
    {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_ORIGIN' => 'http://localhost',
      'SERVER_NAME' => 'localhost',
      'SERVER_PORT' => '3000'
    }
  end

  def stub_hn_api_calls
    story_tags = %w[front_page story ask_hn show_hn job]

    story_tags.each do |tag|
      stub_request(:get, /hn\.algolia\.com.*tags=#{tag}/)
        .to_return(
          status: 200,
          body: { hits: [mock_story_data] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    stub_request(:get, /hn\.algolia\.com.*tags=comment/)
      .to_return(
        status: 200,
        body: { hits: [mock_comment_data] }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def mock_story_data
    {
      objectID: '123',
      title: 'Test Story',
      url: 'https://example.com',
      author: 'testuser',
      points: 100,
      num_comments: 50,
      created_at: '2025-01-01T00:00:00.000Z'
    }
  end

  def mock_comment_data
    {
      objectID: '456',
      comment_text: 'Test comment',
      author: 'commenter',
      created_at: '2025-01-01T01:00:00.000Z',
      story_id: 123,
      parent_id: nil
    }
  end
end
