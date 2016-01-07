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
        if custom_strategy
          status, headers, response = custom_strategy.call(
            [status, headers, response],
            exposed_tokens
          )
        else
          status = 403
          response = ''
          exposed_tokens.each { |token| log(token) }
        end
      end

      [status, headers, response]
    end

    private

    attr_accessor :app, :custom_strategy, :logger, :tokens

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
