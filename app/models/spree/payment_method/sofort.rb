# encoding: UTF-8
module Spree
  class PaymentMethod::Sofort < PaymentMethod::Check
    preference :config_key, :string  # config key is USER_ID:PROJECT_ID:API_KEY
    preference :server_url, :string, :default => "https://api.sofort.com/api/xml"
    preference :reference_prefix, :string, :default => ""
    preference :reference_suffix, :string, :default => ""
  end
end
