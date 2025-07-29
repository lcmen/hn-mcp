class HijackResponseTest < Minitest::Test
  def setup
    @app = ->(env) { [200, {"Content-Type" => "application/json"}, ["OK"]] }
    @middleware = Middleware::HijackResponse.new(@app)
  end

  def test_preserves_positive_status_codes
    env = {}
    status, headers, body = @middleware.call(env)

    assert_equal 200, status
    assert_equal({"Content-Type" => "application/json"}, headers)
    assert_equal ["OK"], body
  end

  def test_fixes_negative_status_codes
    app = ->(env) { [-1, {"Content-Type" => "text/event-stream"}, ["data: test\n\n"]] }
    middleware = Middleware::HijackResponse.new(app)

    status, headers, body = middleware.call({})

    assert_equal 200, status
    assert_equal({"Content-Type" => "text/event-stream"}, headers)
    assert_equal ["data: test\n\n"], body
  end

  def test_fixes_zero_status_code
    app = ->(env) { [0, {}, []] }
    middleware = Middleware::HijackResponse.new(app)

    status, headers, body = middleware.call({})

    assert_equal 200, status
    assert_equal({}, headers)
    assert_equal [], body
  end

  def test_preserves_standard_http_status_codes
    [100, 201, 301, 404, 500].each do |code|
      app = ->(env) { [code, {}, ["Status #{code}"]] }
      middleware = Middleware::HijackResponse.new(app)

      status, headers, body = middleware.call({})

      assert_equal code, status
      assert_equal({}, headers)
      assert_equal ["Status #{code}"], body
    end
  end
end
