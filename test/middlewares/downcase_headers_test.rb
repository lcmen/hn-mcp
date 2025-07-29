class DowncaseHeadersTest < Minitest::Test
  def setup
    @app = ->(env) { [200, {"Content-Type" => "application/json", "X-Custom-Header" => "value"}, ["OK"]] }
    @middleware = Middleware::DowncaseHeaders.new(@app)
  end

  def test_downcases_response_headers
    env = {}
    status, headers, body = @middleware.call(env)

    assert_equal 200, status
    assert_equal ["OK"], body
    assert_equal "application/json", headers["content-type"]
    assert_equal "value", headers["x-custom-header"]
  end

  def test_handles_empty_headers
    app = ->(env) { [204, {}, []] }
    middleware = Middleware::DowncaseHeaders.new(app)

    status, headers, body = middleware.call({})

    assert_equal 204, status
    assert_equal [], body
    assert_equal({}, headers)
  end
end
