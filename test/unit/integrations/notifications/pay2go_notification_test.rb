require 'test_helper'

class Pay2goNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    ActiveMerchant::Billing::Integrations::Pay2go.hash_key = '1234567'
    ActiveMerchant::Billing::Integrations::Pay2go.hash_iv = 'abcdefg'
    @pay2go_string = Pay2go::Notification.new(string_raw_data)
    @pay2go_json = Pay2go::Notification.new(json_raw_data)
  end

  def test_json_params
    p = @pay2go_json

    assert_equal '30', p.amt
    assert_equal '201407310950239561', p.merchant_order_no
    assert_equal '7D3646868F8E674B01C6DDA90C6D2AC68F44C63F13A7671BC4888224220A7E20', p.check_code
    assert_equal 'CREDIT', p.payment_type
    assert_equal '14073109503001857', p.trade_no
    assert_equal '2014-07-31 09:50:38', p.pay_time
    assert_equal '信用卡授權成功', p.message
    assert_equal '457958', p.card_6no
    assert_equal '3430112', p.merchant_id
  end

  def test_string_params
    p = @pay2go_string

    assert_equal '30', p.amt
    assert_equal '201407310943544334', p.merchant_order_no
    assert_equal 'AE8F2AE008EECBBE95C982F537EA93EC723D05CF11ABBCB22C81287B074FC909', p.check_code
    assert_equal 'WEBATM', p.payment_type
    assert_equal '14073109440419780', p.trade_no
    assert_equal '2014-07-31 09:44:04', p.pay_time
    assert_equal '付款成功', p.message
    assert_equal '12345', p.payer_account_5code
    assert_equal '3430112', p.merchant_id
  end

  def test_json_complete?
    assert @pay2go_json.complete?
  end

  def test_json_checksum_ok?
    assert @pay2go_json.checksum_ok?

    assert @pay2go_json._params['CheckCode'].present?
  end

  def test_string_complete?
    assert @pay2go_string.complete?
  end

  def test_string_checksum_ok?
    assert @pay2go_string.checksum_ok?

    assert @pay2go_string._params['CheckCode'].present?
  end

  private

  def json_raw_data
    'JSONData={"Status": "SUCCESS","Message": "信用卡授權成功","Result": "{\"MerchantID\":\"3430112\",\"Amt\":30,\"TradeNo\":\"14073109503001857\",\"MerchantOrderNo\":\"201407310950239561\",\"RespondType\":\"JSON\",\"CheckCode\":\"7D3646868F8E674B01C6DDA90C6D2AC68F44C63F13A7671BC4888224220A7E20\",\"PaymentType\":\"CREDIT\",\"RespondCode\":\"54\",\"Auth\":\"\",\"Card6No\":\"457958\",\"Card4No\":\"5509\",\"ECI\":\"\",\"PayTime\":\"2014-07-31 09:50:38\"}"}'
  end

  def string_raw_data
    'Status=SUCCESS&Message=%E4%BB%98%E6%AC%BE%E6%88%90%E5%8A%9F&MerchantID=3430112&Amt=30&TradeNo=14073109440419780&MerchantOrderNo=201407310943544334&RespondType=String&CheckCode=AE8F2AE008EECBBE95C982F537EA93EC723D05CF11ABBCB22C81287B074FC909&PaymentType=WEBATM&PayTime=2014-07-31+09%3A44%3A04&PayerAccount5Code=12345&PayBankCode=80800000'
  end
end
