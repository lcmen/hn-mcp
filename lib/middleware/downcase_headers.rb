# This middleware downcases all HTTP headers in the response to make them compatible with Rack lint checks.
class DowncaseHeaders
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers = headers.each_with_object({}) do |(k, v), h|
      h[k.downcase] = v
    end
    [status, headers, body]
  end
end
