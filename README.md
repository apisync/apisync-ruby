# apisync-ruby

This gem gives you the tools to interact with [apisync.io](apisync.io).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apisync'
```

## Usage

**On Rails?** Please use
[apisync-rails](https://github.com/apisync/apisync-rails) instead. It has
automatic integration with ActiveRecord.

### Vanilla Ruby

To create an inventory item:

```ruby
client = Apisync.new(api_key: token)
client.inventory_items.save({
  attributes: {
    ad_template_type: "vehicle",
    available:        true,
    brand:            "brand",
    condition:        "new",
    content_language: "pt-br",
    reference_id:     "1"

    # more attributes
  }
})
```

For details on the attributes, see the
[API Reference documentation](https://docs.apisync.io/api/).

You can also define the API key globally:

```ruby
Apisync.api_key = "my-key"

# Instantiate the client now without passing a token
client = Apisync.new
```

#### Verbose

If you want to output to `$stdout`, set `verbose: true`:

```rb
# Define in the instance
client = Apisync.new(api_key: 'api-key', verbose: true)

# or define it globally
Apisync.verbose = true
```

That is useful on Rails console in development mode, so you know what requests
are being made

**Logger**

You can inject a logger as well:

```rb
Apisync.logger = Logger.new($stdout)

# or
Apisync.logger = Rails.logger
```

### Responses

All HTTP calls return an
[HTTPart::Response](https://github.com/jnunemaker/httparty) instance:

```ruby
response = client.inventory_items.save(attributes)
response.success? # => true
```

In case too many requests are made simultaneously, the server will return
429 and this lib will raise the `Apisync::TooManyRequests` exception.

## Development

To run tests:

```
bundle exec rspec spec
```

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/apisync/apisync-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
