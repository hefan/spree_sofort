Spree::CheckoutController.class_eval do
  before_filter :redirect_to_sofort, :only => [:update]

  def redirect_to_sofort
    return unless (params[:state] == "payment")
    return unless params[:order][:payments_attributes]

    payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])

    if payment_method.kind_of?(Spree::PaymentMethod::Sofort)
      @order.update_attributes(object_params)

      response = Spree::SofortService.instance.initial_request(@order)

      flash[:error] = response[:error] if response[:error].present?
      redirect_to response[:redirect_url], :status => 302
    end
  end

end
