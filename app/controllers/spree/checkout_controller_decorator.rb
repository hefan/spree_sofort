Spree::CheckoutController.class_eval do
  before_filter :redirect_to_payment_network, :only => [:update]

  def redirect_to_payment_network
    return unless (params[:state] == "payment")
    return unless params[:order][:payments_attributes]

    payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])

    if payment_method.kind_of?(Spree::PaymentMethod::PaymentNetwork)
      @order.update_attributes(object_params)

      @order.set_invoice_number
      response = Spree::PaymentNetworkService.instance.initial_request(@order, @order.invoice_number)

      flash[:error] = response[:error] if response[:error].present?
      redirect_to response[:redirect_url], :status => 302
    end
  end

end
