Spree::PaymentMethod.class_eval do 
  scope :sofort, -> { where type: "Spree::PaymentMethod::Sofort"}
end