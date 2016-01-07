require 'test_helper'
require 'byebug'

class Rack::LoggerTest < Minitest::Test

  LOGGER = MiniTest::Mock.new
  TOKENS = 3.times.map { SecureRandom.hex }

  def app
    Rack::Builder.new {
      use Rack::Honeytoken, logger: LOGGER, tokens: TOKENS
      run lambda { |env|
        [200, {}, ["Hello #{TOKENS.first} World #{TOKENS.last}"]]
      }
    }.to_app
  end

  def test_logs_present_tokens
    LOGGER.expect(:call, nil, [TOKENS.first])
    LOGGER.expect(:call, nil, [TOKENS.last])

    get '/'
    assert LOGGER.verify
  end

end
