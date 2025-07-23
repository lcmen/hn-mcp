require "minitest/autorun"
require "rack/test"
require "webmock/minitest"

ENV["RACK_ENV"] = "test"

require_relative "../lib/app"

class Minitest::Test
  include Rack::Test::Methods

  def app
    HnMcpApp
  end

  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  def assert_all_instance_of(expected_class, collection)
    collection.each do |item|
      assert_instance_of expected_class, item, "Expected #{item} to be an instance of #{expected_class}"
    end
  end

  def assert_attributes(expected_attributes, object)
    expected_attributes.each do |attr, expected_value|
      actual_value = object.public_send(attr)
      if expected_value.nil?
        assert_nil actual_value, "Expected #{attr} to be nil"
      else
        assert_equal expected_value, actual_value, "Expected #{attr} to be #{expected_value}"
      end
    end
  end

  def assert_values(expected_values, hash)
    expected_values.each do |key, expected_value|
      actual_value = hash[key]
      if expected_value.nil?
        assert_nil actual_value, "Expected #{key} to be nil"
      else
        assert_equal expected_value, actual_value, "Expected #{key} to be #{expected_value}"
      end
    end
  end
end
