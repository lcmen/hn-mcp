require 'minitest/autorun'
require 'rack/test'
require 'webmock/minitest'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/app'

class Minitest::Test
  include Rack::Test::Methods

  def app
    HnMcpApp
  end

  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end