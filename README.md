# Validates URL

This gem adds the capability of validating URLs to ActiveRecord and ActiveModel (Rails 3).

## Installation
    
```    
# add this to your Gemfile
gem "validate_url"

# and  run
sudo gem install validate_url
```

## Usage

### With ActiveRecord

```ruby    
class Pony < ActiveRecord::Base
  # standard validation
  validates :homepage, :url => true

  # with allow_nil
  validates :homepage, :url => {:allow_nil => true}

  # with allow_blank
  validates :homepage, :url => {:allow_blank => true}

  # without local hostnames
  validates :homepage, :url => {:no_local => true}
end
```

### With ActiveModel

```ruby
class Unicorn
  include ActiveModel::Validations

  attr_accessor :homepage

  # with legacy syntax (the syntax above works also)
  validates_url :homepage, :allow_blank => true
end
```

### I18n

The default error message `is not valid url`.
You can pass the `:message => "my custom error"` option to your validation to define your own, custom message.


## Contributing


Big thanks to Tanel Suurhans, Tarmo Lehtpuu, Steve Smith and all the [contributors](https://github.com/perfectline/validates_url/contributors)! We appreciate all your work on new features and bugfixes.

## Credits

Validates URL is created and maintained by [PerfectLine](http://www.perfectline.co), LLC.

## License

Validates URL is Copyright © 2010-2014 [PerfectLine](http://www.perfectline.co), LLC. It is free software, and may be
redistributed under the terms specified in the LICENSE file.