$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'rack/honeytoken'
require 'rack/test'
require 'securerandom'

class MiniTest::Test
  include Rack::Test::Methods
end
