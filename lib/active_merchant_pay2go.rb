require "active_merchant_pay2go/version"
require "active_merchant"

module ActiveMerchant
  module Billing
    module Integrations
      autoload :Pay2go, 'active_merchant/billing/integrations/pay2go'
    end
  end
end
