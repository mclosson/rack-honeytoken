require "rack/honeytoken/version"

module Rack
  class Honeytoken

    def initialize(app, options = {})
      self.app = app
      self.custom_strategy = options.fetch(:custom_strategy, nil)
      self.logger = options.fetch(:logger, nil)
      self.tokens = options.fetch(:tokens, [])
    end

    def call(env)
      status, headers, response = app.call(env)
      exposed_tokens = tokens_present_in?(response)

      if exposed_tokens.any?
        status, headers, response = strategy.call(
          [status, headers, response],
          exposed_tokens
        )
      end

      [status, headers, response]
    end

    private

    attr_accessor :app, :custom_strategy, :logger, :tokens

    def default_strategy
      Proc.new {|tuple, exposed_tokens|
        status = 403
        headers = tuple[1]
        response = []
        exposed_tokens.each { |token| log(token) }
        [status, headers, response]
      }
    end

    def strategy
      custom_strategy || default_strategy
    end

    def tokens_present_in?(response)
      pattern = tokens.map { |token| Regexp.escape(token) }.join('|')
      regex = Regexp.new(pattern)

      if response.respond_to?(:body)
        response.body.scan(regex)
      elsif response.respond_to?(:join)
        response.join.scan(regex)
      else
        response.to_s.scan(regex)
      end
    end

    def log(token)
      logger.call(token) if logger
    end

  end
end
