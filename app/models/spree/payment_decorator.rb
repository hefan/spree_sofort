Spree::Payment.class_eval do 
  scope :sofort, -> { where source_type: "Spree::Sofort"}
end