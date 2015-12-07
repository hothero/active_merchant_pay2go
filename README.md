# ActiveMerchantPay2go

This plugin is an active_merchant patch for Pay2go(智付寶) online payment in Taiwan.
Now it supports Credit card(信用卡), ATM(ATM轉帳), and CVS(超商繳費).

## Installation

Add this line to your application's Gemfile:

    gem 'active_merchant_pay2go', '>=0.1'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_merchant_pay2go

## Usage

You can get Payment API and SPEC in [Pay2go API](https://www.pay2go.com/info/site_description/api_description).
Then create an initializer, like initializers/pay2go.rb. Add the following configurations depends on your settings.

``` ruby

# config/environments/development.rb
config.after_initialize do
  ActiveMerchant::Billing::Base.integration_mode = :development
end

# config/environments/production.rb
config.after_initialize do
  ActiveMerchant::Billing::Base.integration_mode = :production
end

```

``` ruby

# initializers/pay2go.rb
ActiveMerchant::Billing::Integrations::Pay2go.setup do |pay2go|
  if Rails.env.development?
    # change to yours
    pay2go.merchant_id = '5455626'
    pay2go.hash_key    = '5294y06JbISpM5x9'
    pay2go.hash_iv     = 'v77hoKGq4kWxNNIS'
  else
    # change to yours
    pay2go.merchant_id = '7788520'
    pay2go.hash_key    = 'adfas123412343j'
    pay2go.hash_iv     = '123ddewqerasdfas'
  end
end
```

## Example Usage

Once you’ve configured ActiveMerchantPay2go, you need a checkout form; it looks like:

``` ruby
  <% payment_service_for  @order,
                          @order.user.email,
                          :service => :pay2go,
                          :html    => { :id => 'pay2go-checkout-form', :method => :post } do |service| %>
    <% service.merchant_order_no @order.payments.last.identifier %>
    <% service.respond_type "String" %>
    <% service.time_stamp @order.created_at.to_i %>
    <% service.version "1.2" %>
    <% service.item_desc @order.number %>
    <% service.amt @order.money %>
    <% service.email @order.buyer.email %>
    <% service.login_type 0 %>
    <% service.client_back_url spree.orders_account_url %>
    <% service.notify_url pay2go_return_url %>
    <% service.encrypted_data %>
    <%= submit_tag 'Buy!' %>
  <% end %>
```

Also need a notification action when Pay2go service notifies your server; it looks like:

``` ruby
  def notify
    notification = ActiveMerchant::Billing::Integrations::Pay2go::Notification.new(request.raw_post)

    order = Order.find_by_number(notification.merchant_order_no)

    if notification.status && notification.checksum_ok?
      # payment is compeleted
    else
      # payment is failed
    end

    render text: '1|OK', status: 200
  end
```

## Troublechooting
If you get a error "undefined method \`payment\_service\_for\`", you can add following configurations to initializers/pay2go.rb. 
```
require "active_merchant/billing/integrations/action_view_helper"
ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
```

## TODOs
* Transaction Query Review
* CreditCard Refund
* CreditCard Inst（定期定額）
* Electronic Invoice

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

