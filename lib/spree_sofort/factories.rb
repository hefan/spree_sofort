FactoryGirl.define do

  factory :sofort, class: Spree::PaymentMethod::Sofort do
		name "sofort.com payment"
		type "Spree::PaymentMethod::Sofort"
		active true
  end

end
