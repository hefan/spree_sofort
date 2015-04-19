SpreeSofort
===================

Extends Spree for supporting sofort.com aka sofortueberweisung.de aka Payment Network. An appropriate Merchant Account is required to use it.

See also https://www.sofort.com/integrationCenter-eng-DE/content/view/full/2513


Installation
------------

Add spree_sofort to your Gemfile:
```ruby
gem 'spree_sofort', :git => 'git://github.com/hefan/spree_sofort.git'
```

For a specific version use the appropriate branch, for example
```ruby
gem 'spree_sofort', :git => 'git://github.com/hefan/spree_sofort.git', :branch => '3-0-stable'
```


Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_sofort:install
```

The Sofort-API works with XML, so spree_sofort has to use the actionpack-xml_parser since rails 4.0 / since Spree 2.1. for parsing transactions.
see https://github.com/rails/actionpack-xml_parser

So you have to put
```ruby
require 'action_dispatch/xml_params_parser'
```
and
```ruby
config.middleware.insert_after ActionDispatch::ParamsParser, ActionDispatch::XmlParamsParser
```
at the appropriate places in your application.rb.

Without XML Support transaction processing will not work. 



Setup
-----

Navigate to Spree Backend/Configuration/Payment Methods and add a new payment method with Provider "Spree::PaymentMethod::Sofort".
Enter the Configuration key from your sofort merchant account.

The default server url should work. You may use a reference prefix and/or suffix if you like to add something before or after the order number used as reference for sofort.

Turn on the test mode in your Sofort merchant backend to do testing.

Sofort does only support Euro currency.


License
-------
released under the New BSD License
