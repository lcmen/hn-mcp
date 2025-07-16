require_relative 'test_helper'

class TestApp < Minitest::Test
  def test_root_endpoint
    get '/'
    
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
    
    data = JSON.parse(last_response.body)
    assert_equal 'Hacker News MCP Server', data['message']
    assert_equal '1.0.0', data['version']
    assert data['endpoints'].key?('health')
  end

  def test_health_endpoint
    get '/health'
    
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
    
    data = JSON.parse(last_response.body)
    assert_equal 'ok', data['status']
    assert data['timestamp'].is_a?(Integer)
  end
end