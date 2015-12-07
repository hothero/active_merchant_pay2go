#encoding: utf-8

require 'cgi'
require 'digest/md5'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Pay2go
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          ### 常見介面

          # 廠商編號
          mapping :merchant_id, 'MerchantID'
          mapping :account, 'MerchantID' # AM common
          # 回傳格式
          mapping :respond_type, 'RespondType'
          # 時間戳記
          mapping :time_stamp, 'TimeStamp'
          # 串接程式版本
          mapping :version, 'Version'
          # 語系 (no required)
          mapping :lang_type, 'LangType'
          # 廠商交易編號
          mapping :merchant_order_no, 'MerchantOrderNo'
          mapping :order, 'MerchantOrderNo' # AM common
          # 交易金額（幣別：新台幣）
          mapping :amt, 'Amt'
          mapping :amount, 'Amt' # AM common
          # 商品資訊（限制長度50字）
          mapping :item_desc, 'ItemDesc'
          # 交易限制秒數，下限是 60 秒，上限 900 秒 (no required)
          mapping :trade_limit, 'TradeLimit'
          # 繳費有限期限，格式範例：20140620
          mapping :expire_date, 'ExpireDate'
          # 支付完成返回商店網址（沒給會留在智付寶畫面）
          mapping :return_url, 'ReturnURL'
          # 支付通知網址
          mapping :notify_url, 'NotifyURL'
          # 商店取號網址（沒給的話取號後會留在智付寶畫面）
          mapping :customer_url, 'CustomerURL'
          # 支付取消返回商店網址（交易取消後平台會出現返回鈕）
          mapping :client_back_url, 'ClientBackURL'
          # 付款人電子信箱
          mapping :email, 'Email'
          # 付款人電子信箱是否開放修改（預設為可修改，給0, 1）
          mapping :email_odify, 'EmailModify'
          # 智付寶會員（預設1則需要登入智付寶）
          mapping :login_type, 'LoginType'
          # 商店備註
          mapping :order_comment, 'OrderComment'
          # 信用卡一次付清啟用（1為啟用）
          mapping :credit, 'CREDIT'
          # 信用卡紅利啟用（1為啟用）
          mapping :credit_red, 'CreditRed'
          # 信用卡分期付款啟用
          mapping :inst_flag, 'InstFlag'
          # 信用卡銀聯卡啟用
          mapping :union_pay, 'UNIONPAY'
          # WebATM 啟用
          mapping :web_atm, 'WEBATM'
          # ATM 轉帳啟用
          mapping :vacc, 'VACC'
          # 超商代碼繳費啟用
          mapping :cvs, 'CVS'
          # 條碼繳費啟用
          mapping :barcode, 'BARCODE'
          # 自訂支付啟用
          mapping :custom, 'CUSTOM'
          # 付款人綁定資料（快速結帳參數）
          mapping :token_term, 'TokenTerm'

          def initialize(order, account, options = {})
            super
            add_field 'MerchantID', ActiveMerchant::Billing::Integrations::Pay2go.merchant_id
          end

          def encrypted_data

            url_encrypted_data = ActiveMerchant::Billing::Integrations::Pay2go.fetch_url_encode_data(@fields)

            binding.pry if ActiveMerchant::Billing::Integrations::Pay2go.debug

            add_field 'CheckValue', url_encrypted_data
          end
        end
      end
    end
  end
end
