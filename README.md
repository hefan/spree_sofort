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
gem 'spree_sofort', :git => 'git://github.com/hefan/spree_sofort.git', :branch => '2-2-stable'
```


Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_sofort:install
```


Setup
-----

Navigate to Spree Backend/Configuration/Payment Methods and add a new payment method with Provider "Spree::PaymentMethod::Sofort".
Enter the Configuration key from your sofort merchant account. The default server url should work.

Turn on the test mode in your Sofort merchant backend to do testing.

Sofort does only support Euro currency.


License
-------
released under the New BSD License
