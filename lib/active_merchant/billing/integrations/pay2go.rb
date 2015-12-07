require File.dirname(__FILE__) + '/pay2go/helper.rb'
require File.dirname(__FILE__) + '/pay2go/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Pay2go
        autoload :Helper, 'active_merchant/billing/integrations/pay2go/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/pay2go/notification.rb'

        mattr_accessor :service_url
        mattr_accessor :merchant_id
        mattr_accessor :hash_key
        mattr_accessor :hash_iv
        mattr_accessor :debug

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
            when :production
              'https://api.pay2go.com/MPG/mpg_gateway'
            when :development
              'https://capi.pay2go.com/MPG/mpg_gateway'
            when :test
              'https://capi.pay2go.com/MPG/mpg_gateway'
            else
              raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.notification(post)
          Notification.new(post)
        end

        def self.setup
          yield(self)
        end

        def self.fetch_url_encode_data(fields)
          check_fields = [:"Amt", :"MerchantID", :"MerchantOrderNo", :"TimeStamp", :"Version"]
          raw_data = fields.sort.map{|field, value|
            "#{field}=#{value}" if check_fields.include?(field.to_sym)
          }.compact.join('&')

          hash_raw_data = "HashKey=#{ActiveMerchant::Billing::Integrations::Pay2go.hash_key}&#{raw_data}&HashIV=#{ActiveMerchant::Billing::Integrations::Pay2go.hash_iv}"

          sha256 = Digest::SHA256.new
          sha256.update hash_raw_data.force_encoding("utf-8")
          sha256.hexdigest.upcase
        end
      end
    end
  end
end
