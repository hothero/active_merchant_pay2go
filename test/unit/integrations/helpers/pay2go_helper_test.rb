require 'test_helper'

class Pay2goHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
  end

  def test_check_value
    @helper = Pay2go::Helper.new '20140901001', '123456'
    @helper.add_field 'MerchantID', '123456'
    @helper.add_field 'TimeStamp', '1403243286'
    @helper.add_field 'MerchantOrderNo','20140901001'
    @helper.add_field 'Amt', '200'
    @helper.add_field 'Version', '1.1'
    @helper.add_field 'ItemDesc', 'djklfjai23ojf'
    @helper.add_field 'RespondType', 'JSON'

    ActiveMerchant::Billing::Integrations::Pay2go.hash_key = '1A3S21DAS3D1AS65D1'
    ActiveMerchant::Billing::Integrations::Pay2go.hash_iv = '1AS56D1AS24D'

    @helper.encrypted_data

    assert_equal '841F57D750FB4B04B62DDC3ECDC26F1F4028410927DD28BD5B2E34791CC434D2', @helper.fields['CheckValue']
  end
end
