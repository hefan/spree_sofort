Spree::Order.class_eval do

  def mark_as_paid!
    payment = last_payment
    payment.amount = total # 100% payed, no credit owned
    payment.capture!
  end

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
