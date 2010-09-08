module Perfectline
  module ValidatesUrl

    class Validator
      require 'uri'
      
      def self.valid_url?(value, schemes)
        schemes = [*schemes].map(&:to_s)
        begin
          uri = ::URI.parse(value)

          unless schemes.include?(uri.scheme)
            raise ::URI::InvalidURIError
          end

          unless uri.send(:scheme).present?
            raise ::URI::InvalidURIError
          end

          unless uri.send(:host).present?
            raise ::URI::InvalidURIError
          end

        rescue ::URI::InvalidURIError
          return false
        end

        true
      end
    end

    module Rails2
      require 'active_record'
      
      def validates_url(*attribute_names)
        options = attribute_names.extract_options!.symbolize_keys
        options.reverse_merge!(:schemes => %w(http https))
        options.reverse_merge!(:message => "is not a valid URL")

        validates_each(attribute_names, options) do |record, attribute, value|
          unless valid_url?(value, options.fetch(:schemes))
            record.errors.add(attribute, options[:message], :value => value)
          end
        end
      end
    end

    module Rails3
      require 'active_model'
      require 'active_model/validations'
      require 'active_support/concern'

      extend ActiveSupport::Concern

      class UrlValidator < ActiveModel::EachValidator
        def initialize(options)
          options.reverse_merge!(:schemes => %w(http https))
          options.reverse_merge!(:message => "is not a valid URL")
          super(options)
        end

        def validate_each(record, attribute, value)
          unless Perfectline::ValidatesUrl::Validator.valid_url?(value, options.fetch(:schemes))
            record.errors.add(attribute, options.fetch(:message), :value => value)
          end
        end
      end

      module ClassMethods
        def validates_url(*attr_names)
          validates_with UrlValidator, _merge_attributes(attr_names)
        end
      end
    end
  end
end

if Rails::VERSION::MAJOR >= 3
  ActiveModel::Validations.send(:include, Perfectline::ValidatesUrl::Rails3)
else
  ActiveRecord::Base.send(:include, Perfectline::ValidatesUrl::Rails2)
end