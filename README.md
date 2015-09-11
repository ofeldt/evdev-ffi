# Evdev::FFI

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'evdev-ffi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evdev-ffi

## Usage

```ruby
require 'evdev/ffi'

device = Evdev::InputDevice.new('/dev/input/event0')

puts 'Input device name: "#{device.name}"'
puts 'Input device ID: bus #{device.bustype} vendor #{device.vendor} product #{device.product}'

if !device.has_event_type?(EV_REL) || !device.has_event_code?(EV_KEY, BTN_LEFT)
  puts 'This device does not look like a mouse'
  exit false
end

device.handle_events do |event|
  puts 'Event: #{event[:type]} #{event[:code]} #{event[:value]}'
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/ofeldt/evdev-ffi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
