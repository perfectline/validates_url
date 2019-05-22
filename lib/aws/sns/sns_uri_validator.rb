module ActiveModel
  module Validations
    class SnsUriValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        Aws::SNS::URI.parse(value).test_publish
      rescue Aws::SNS::Errors::InvalidURIError, Aws::SNS::Errors::ServiceError => e
        record.errors[attribute] << "is invalid. #{e.message}"
      end
    end
  end
end
