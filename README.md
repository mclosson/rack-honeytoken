# Rack::Honeytoken

Rack HoneyToken Middleware

Honey Tokens are unique and unlikely values that should be planted in various
places within your web application to assist in the detection of a security
breach.  They are useful at trying to detect SQL injection attacks where the
intended logic of an SQL query is bypassed and the HTTP request is used to
attempt to download private data instead for example the users or accounts
table and associated password hashes.

## Status

***Warning:*** This gem is currently under development and while functional,
it is not yet recommended be used on production systems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-honeytoken', git: 'https://github.com/mclosson/rack-honeytoken.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-honeytoken

## Usage

Below is an example of creating three fake users with their password hashes
set to a honey token for detection by the in the event of a successful SQL
injection attack.

```ruby
honey_tokens = 3.times.map do
  token = SecureRandom.hex
  user = User.create(..., password: token)
  token
end
```

Configuring a Rails 4.x application
config/application.rb

```ruby
config.middleware.use(
  "HoneyToken",
  tokens: honey_tokens,
  logger: Proc.new { |token| Rails.logger.warn("Honey token exposed: #{token}") }
)
```

Or to use a customize the status, headers and response by configuration you can
provide a custom_strategy option which must return a [status, headers, response]
array.

```ruby
config.middleware.use(
  'HoneyToken',
  tokens: honey_tokens
  custom_strategy: Proc.new { |tuple, exposed_tokens|
    exposed_tokens.each { |token| Rails.logger.warn("Honey Token Exposed: #{token}") }
    status, headers, response = tuple
    response = ['My custom response']
    [status, headers, response]
  }
)
```

NOTE: Skillful attackers (or attackers with sufficiently advanced tools) may
be able to encode or transform the honey tokens in the database query before
pulling it back into the HTTP response effectively bypassing the protection
however in practice many attackers tend to start with more basic attacks and
may make enough noise in the logs to allow you to detect and fix the vulnerable
code before they are able to craft a more stealthy request.

Your reaction to an exposed HoneyToken in an HTTP response should be to
alter or redirect the request to prevent private data from being downloaded
and to fix or shutoff the vulnerable code path immediately as it means a 
successful attack is under way.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mclosson/rack-honeytoken.

