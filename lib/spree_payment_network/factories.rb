FactoryGirl.define do

  factory :payment_network, class: Spree::PaymentMethod::PaymentNetwork do
		name "sofort.com payment network"
		type "Spree::PaymentMethod::PaymentNetwork"
		active true
		environment "test"
  end

end
