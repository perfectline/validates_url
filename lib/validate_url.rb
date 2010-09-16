require 'uri'
require 'active_model'

module ActiveModel
  module Validations
    class UrlValidator < ActiveModel::EachValidator

      def initialize(options)
        options.reverse_merge!(:schemes => %w(http https))
        options.reverse_merge!(:message => "is not a valid URL")
        super(options)
      end

      def validate_each(record, attribute, value)
        schemes = [*options.fetch(:schemes)].map(&:to_s)

        unless URI::regexp(schemes).match(value)
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