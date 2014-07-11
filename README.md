SpreePaymentNetwork
===================

Extends Spree for supporting Payment Network aka sofortueberweisung.de aka sofort.com. An appropriate Merchant Account is required to use it.

See also https://www.sofort.com/integrationCenter-eng-DE/content/view/full/2513


Installation
------------

Add spree_payment_network to your Gemfile:

```ruby
gem 'spree_payment_network', :git => 'git://github.com/hefan/spree_payment_network.git'
```

For a specific version use the appropriate branch, for example

```ruby
gem 'spree_payment_network', :git => 'git://github.com/hefan/spree_payment_network.git', :branch => '2-2-stable'
```


Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_payment_network:install
```


Setup
-----

Navigate to Spree Backend/Configuration/Payment Methods and add a new payment method with Provider "Spree::PaymentMethod::PaymentNetwork".
Enter the Configuration key from your sofort merchant account. The default server url should work.

Turn on the test mode in your sofort merchant backend to do testing.

Sofort aka Payment Network does only support Euro currency.


License
-------
released under the New BSD License
