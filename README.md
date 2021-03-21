# CustomRailsSettingsCached

My Custom with Rails Settings Cached. Easy to setup and use.

## Installation

You need install [Rails Settings Cached](https://github.com/huacnlee/rails-settings-cached) to use this gem.


Then, ddd this line to your application's Gemfile:

```ruby
gem 'custom_rails_settings_cached'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install custom_rails_settings_cached

## Usage

Must define `CUSTOM_RAILS_SETTINGS_KEYS` before `include CustomRailsSettingsCached`

*CUSTOM_RAILS_SETTINGS_KEYS* can be Array or Hash.

```ruby
  CUSTOM_RAILS_SETTINGS_KEYS = {
    google_analytics: [:enabled, :tracking_code],
    facebook_pixel_ads: [:enabled, :tracking_code]
  }
  
  # Or
  
  CUSTOM_RAILS_SETTINGS_KEYS = [:google_analytics, :facebook_pixel_ads]
  
  # Or
  
  CUSTOM_RAILS_SETTINGS_KEYS = {
    google_analytics: :tracking_code,
    facebook_pixel_ads: [:enabled, :tracking_code]
  }
```
Then, include `CustomRailsSettingsCached` in your model.
Exam:
```ruby
  include CustomRailsSettingsCached
 ```

Or, can use with your custom concern.

```ruby
require 'custom_rails_settings_cached'

module MyCustomRailsSetting
  def self.included klass
    klass.include CustomRailsSettingsCached

    # custom more here
    # klass.class_eval do
    #   has_many :players
    #   validates :number_of_player, presence: true
    # end
  end
end

```
Then use `include MyCustomRailsSetting` at model.

Exams:

**Get Value**

```ruby
    object = YourModel.first
    object.google_analytics_tracking_code
```

**Set Value**

```ruby
    object = YourModel.first
    object.update google_analytics_tracking_code: '123456ABCDEF'
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/custom_rails_settings_cached. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/custom_rails_settings_cached/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CustomRailsSettingsCached project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/custom_rails_settings_cached/blob/master/CODE_OF_CONDUCT.md).
