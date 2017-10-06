# Apisync

This gem gives you the tools to interact with [apisync.io](apisync.io).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apisync'
```

## Usage

### Vanilla Ruby

To create an inventory item:

```ruby
client = Apisync.new(api_key: token)
client.inventory_items.save({
  attributes: {
    ad_template_type: "vehicle",
    availability: "on-sale",
    brand: "brand",
    condition: "new",
    content_language: "pt-br"
    # ... more attributes
  }
})
```

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
