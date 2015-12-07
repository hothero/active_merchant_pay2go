require 'net/http'
require 'uri'
require 'json'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Pay2go
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          attr_accessor :_params

          def _params
            if @_params.nil?
              if @params.key?("JSONData") # json response type
                # puts params['JSONData'].to_s
                @_params = JSON.parse(@params['JSONData'].to_s)
                # puts JSON.parse(@_params['Result'])['Amt']
                @_params = @_params.merge(JSON.parse(@_params['Result']))
              else # string response type
                @_params = @params
              end
            end
            @_params
          end

          # TODO 使用查詢功能實作 acknowledge
          # 而以 checksum_ok? 代替
          def acknowledge
            checksum_ok?
          end

          def complete?
            case status
            when 'SUCCESS' # 付款/取號成功
              true
            end
          end

          def checksum_ok?
            params_copy = _params.clone

            check_fields = [:"Amt", :"MerchantID", :"MerchantOrderNo", :"TradeNo"]
            raw_data = params_copy.sort.map{|field, value|
              "#{field}=#{value}" if check_fields.include?(field.to_sym)
            }.compact.join('&')

            hash_raw_data = "HashIV=#{ActiveMerchant::Billing::Integrations::Pay2go.hash_iv}&#{raw_data}&HashKey=#{ActiveMerchant::Billing::Integrations::Pay2go.hash_key}"

            sha256 = Digest::SHA256.new
            sha256.update hash_raw_data.force_encoding("utf-8")
            (sha256.hexdigest.upcase == check_code.to_s)
          end

          def status
            _params['Status']
          end

          def message
            URI.decode(_params['Message'])
          end

          def merchant_id
            _params['MerchantID']
          end

          def amt
            _params['Amt'].to_s
          end

          def trade_no
            _params['TradeNo']
          end

          def merchant_order_no
            _params['MerchantOrderNo']
          end

          def payment_type
            _params['PaymentType']
          end

          def respond_type
            _params['RespondType']
          end

          def check_code
            _params['CheckCode']
          end

          def pay_time
            URI.decode(_params['PayTime']).gsub("+", " ")
          end

          def ip
            _params['IP']
          end

          def escrow_bank
            _params['EscrowBank']
          end

          # credit card
          def respond_code
            _params['RespondCode']
          end

          def auth
            _params['Auth']
          end

          def card_6no
            _params['Card6No']
          end

          def card_4no
            _params['Card4No']
          end

          def inst
            _params['Inst']
          end

          def inst_first
            _params['InstFirst']
          end

          def inst_each
            _params['InstEach']
          end

          def eci
            _params['ECI']
          end

          def token_use_status
            _params['TokenUseStatus']
          end

          # web atm, atm
          def pay_bank_code
            _params['PayBankCode']
          end

          def payer_account_5code
            _params['PayerAccount5Code']
          end

          # cvs
          def code_no
            _params['CodeNo']
          end

          # barcode
          def barcode_1
            _params['Barcode_1']
          end

          def barcode_2
            _params['Barcode_2']
          end

          def barcode_3
            _params['Barcode_3']
          end

          # other about serials
          def expire_date
            _params['ExpireDate']
          end

        end
      end
    end
  end
end
