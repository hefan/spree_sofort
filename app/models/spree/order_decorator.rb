Spree::Order.class_eval do

	def last_payment_method
		return nil if last_payment.blank?
		return last_payment.payment_method
	end

	def last_payment
		return nil if payments.blank?
		return payments.last
	end

end
