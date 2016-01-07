require 'test_helper'

class Rack::HoneytokenTest < Minitest::Test

  TOKENS = 3.times.map { SecureRandom.hex }

  def app
    Rack::Builder.new {
      use Rack::Honeytoken, tokens: TOKENS
      run lambda { |env|
        if env['PATH_INFO'] == '/vulnerable'
          [200, {}, ["Hello #{TOKENS.first} World #{TOKENS.last}"]]
        else
          [200, {}, ["Hello World"]]
        end
      }
    }.to_app
  end

  def test_that_it_has_a_version_number
    refute_nil ::Rack::Honeytoken::VERSION
  end

  def test_okay_without_tokens_present
    get '/'
    assert last_response.ok?
  end

  def test_unauthorized_with_token_present
    get '/vulnerable'
    assert_equal 403, last_response.status
  end

end
