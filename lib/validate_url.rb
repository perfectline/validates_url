require 'active_model'
require 'active_support/i18n'
require 'ipaddr'
require 'resolv'

require_relative 'aws/sns/uri'
require_relative 'aws/sns/sns_uri_validator'

I18n.load_path += Dir[File.dirname(__FILE__) + "/locale/*.yml"]

module ActiveModel
  module Validations
    class UrlValidator < ActiveModel::EachValidator
      RESERVED_OPTIONS = [:schemes, :no_local, :blacklisted_domains]

      BLACKLISTED_INTERNAL_IPS = [
        IPAddr.new('10.0.0.0/8'),
        IPAddr.new('127.0.0.0/8'),
        IPAddr.new('192.168.0.0/16'),
        IPAddr.new('169.254.0.0/16'),
        IPAddr.new('224.0.0.0/4'),
        IPAddr.new('0.0.0.0/8'),
        IPAddr.new('255.255.255.255'),
        IPAddr.new('::1'),
        IPAddr.new('fc00::/7'),
        IPAddr.new('fd00::/8'),
        IPAddr.new('fe80::/10')
      ].freeze

      def initialize(options)
        options.reverse_merge!(:schemes => %w(http https))
        options.reverse_merge!(:message => :url)
        options.reverse_merge!(:no_local => false)
        options.reverse_merge!(:blacklisted_domains => [])

        super(options)
      end

      def validate_each(record, attribute, value)
        schemes = [*options.fetch(:schemes)].map(&:to_s)
        begin
          uri = URI.parse(value)
          hostname = uri.host || uri.to_s

          unless uri && uri.host && schemes.include?(uri.scheme)
            record.errors.add(attribute, :url, filtered_options(value))
            return
          end

          if options.fetch(:no_local) && self.class.local?(hostname)
            record.errors.add(attribute, :url, filtered_options(value))
            return
          end

          if options.fetch(:blacklisted_domains).any? && blacklisted_domain?(hostname)
            record.errors.add(attribute, :url, filtered_options(value))
            return
          end
        rescue URI::InvalidURIError
          record.errors.add(attribute, :url, filtered_options(value))
        end
      end

      def blacklisted_domain?(hostname)
        blacklisted_domains_regex = Regexp.new(
          options[:blacklisted_domains].map do |blacklisted_domain|
            %r{^([\w-]+\.)?#{Regexp.escape(blacklisted_domain)}}
          end.join('|'),
          Regexp::IGNORECASE
        )

        (hostname =~ blacklisted_domains_regex).present?
      end

      def self.local?(hostname)
        ip = begin
               Resolv.getaddress(hostname)
             rescue Resolv::ResolvError
               nil
             end

        return false unless ip

        ip_addr = IPAddr.new(ip)

        BLACKLISTED_INTERNAL_IPS.any? do |blacklisted_ip|
          # note 1: explicit usage of triple equals operator
          # note 2: a === b is not equal to b === a when dealing with IPAddr
          blacklisted_ip === ip_addr
        end
      end

      protected

      def filtered_options(value)
        filtered = options.except(*RESERVED_OPTIONS)
        filtered[:value] = value
        filtered
      end
    end

    module ClassMethods
      # Validates whether the value of the specified attribute is valid url.
      #
      #   class Unicorn
      #     include ActiveModel::Validations
      #     attr_accessor :homepage, :ftpsite
      #     validates_url :homepage, :allow_blank => true
      #     validates_url :ftpsite, :schemes => ['ftp']
      #   end
      # Configuration options:
      # * <tt>:message</tt> - A custom error message (default is: "is not a valid URL").
      # * <tt>:allow_nil</tt> - If set to true, skips this validation if the attribute is +nil+ (default is +false+).
      # * <tt>:allow_blank</tt> - If set to true, skips this validation if the attribute is blank (default is +false+).
      # * <tt>:schemes</tt> - Array of URI schemes to validate against. (default is +['http', 'https']+)

      def validates_url(*attr_names)
        validates_with UrlValidator, _merge_attributes(attr_names)
      end
    end
  end
end
