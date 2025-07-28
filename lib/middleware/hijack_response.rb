# This middleware fixes the response status for Server-Sent Events (SSE) connections from `fast-mcp`
# which may return a status of -1, making it incompatible with Rack lint checks.
class HijackResponse
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    status = 200 if status.negative?

    [status, headers, body]
  end
end
