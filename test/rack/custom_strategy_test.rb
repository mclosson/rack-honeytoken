require 'test_helper'

class Rack::CustomStrategyTest < Minitest::Test

  TOKENS = 3.times.map { SecureRandom.hex }

  def app
    Rack::Builder.new {
      use Rack::Honeytoken,
        custom_strategy: lambda { |env, exposed_tokens|
          [200, {}, ["Good try ;)"]]
        },
        tokens: TOKENS
      run lambda { |env|
        [200, {}, ["Hello #{TOKENS.first} World #{TOKENS.last}"]]
      }
    }.to_app
  end

  def test_custom_strategy
    get '/'
    assert last_response.ok?
    assert_equal "Good try ;)", last_response.body
  end

end
