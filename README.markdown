# ValidateUrl

This gem adds the capability of validating URLs to ActiveRecord (Rails 2) and ActiveModel (Rails 3).

### Installation
    # add this to your Gemfile (Rails 3)
    gem "validate_url"

    # add this to environment.rb
    config.gem "validate_url"

    # and then run
    rake gems:install

    # or just run
    sudo gem install validate_url

### Usage

#### With ActiveRecord in Rails 3
    class Pony < ActiveRecord::Base
      # standard validation
      validates :homepage, :url => true

      # with allow_nil
      validates :homepage, :url => {:allow_nil => true}

      # with allow_blank
      validates :homepage, :url => {:allow_blank => true}
    end

#### With ActiveRecord in Rails 2
    class Pony < ActiveRecord::Base
      validates_url :homepage, :allow_blank => true
    end

#### With ActiveModel
    class Unicorn
      include ActiveModel::Validations

      attr_accessor :homepage

      # with legacy syntax (the syntax above works also)
      validates_url :homepage, :allow_blank => true
    end

#### I18n

The default error message `is not valid url`.
You can pass the `:message => "my custom error"` option to your validation to define your own, custom message.

## Authors

**Tanel Suurhans** (<http://twitter.com/tanelsuurhans>)
**Tarmo Lehtpuu** (<http://twitter.com/tarmolehtpuu>)

## License
Copyright 2010 by PerfectLine LLC (<http://www.perfectline.co.uk>) and is released under the MIT license.
