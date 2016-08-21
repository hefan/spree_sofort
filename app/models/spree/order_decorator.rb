Spree::Order.class_eval do

	def last_payment_method
    last_payment.try(:payment_method)
	end

	def last_payment
		payments.last
	end

  def sofort_ref_number
		last_payment_method ? "#{last_payment_method.preferred_reference_prefix}#{number}#{last_payment_method.preferred_reference_suffix}" : number
	end

end
