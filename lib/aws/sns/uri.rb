require "aws-sdk-sns"
require "addressable/uri"

module Aws
  module SNS
    class URI
      attr_accessor :key_id, :access_key, :region, :topic_owner, :topic_name

      def self.parse(uri)
        return if uri.nil?

        uri = Addressable::URI.parse(uri) unless uri.is_a?(Addressable::URI)

        raise Aws::SNS::Errors::InvalidURIError unless uri.scheme == 'sns'

        raise Aws::SNS::Errors::InvalidURIError if uri.host.blank?

        region = uri.host

        raise Aws::SNS::Errors::InvalidURIError if uri.user.blank? || uri.password.blank?

        key_id = CGI.unescape(uri.user)
        access_key = CGI.unescape(uri.password)

        segments = uri.path&.split('/')

        raise Aws::SNS::Errors::InvalidURIError unless segments&.size == 3

        topic_owner = CGI.unescape(segments[1])
        topic_name = CGI.unescape(segments[2])

        new(
          key_id: key_id,
          access_key: access_key,
          region: region,
          topic_owner: topic_owner,
          topic_name: topic_name
        )
      end

      def initialize(key_id:, access_key:, region:, topic_owner:, topic_name:)
        @key_id = key_id
        @access_key = access_key
        @region = region
        @topic_owner = topic_owner
        @topic_name = topic_name
      end

      def arn
        "arn:aws:sns:#{region}:#{topic_owner}:#{topic_name}"
      end

      def test_publish
        Aws::SNS::Resource.new(region: region, access_key_id: key_id, secret_access_key: access_key)
          .topic(arn).publish(message: "{ \"msg\": \"This a publish test to #{arn} from Checkr\" }")
      end
    end

    module Errors
      class InvalidURIError < StandardError
        def message
          "It should match the format "\
          "sns://<key_id>:<access_key>@<region>/<topic_owner>/<topic_name>"
        end
      end
    end
  end
end
