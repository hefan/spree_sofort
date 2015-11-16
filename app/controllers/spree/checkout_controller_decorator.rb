Spree::CheckoutController.class_eval do
  before_filter :check_redirect_to_sofort, :only => [:update]

  def check_redirect_to_sofort
    if @order.confirmation_required?
      redirect_sofort_from_confirm_state
    else
      redirect_sofort_from_payment_state
    end
  end

  private

  def redirect_sofort_from_confirm_state
    return unless (params[:state] == "confirm")
    if @order.last_payment_method.kind_of?(Spree::PaymentMethod::Sofort)
      redirect_sofort
    end
  end

  def redirect_sofort_from_payment_state
    return unless (params[:state] == "payment")
    return unless params[:order][:payments_attributes]
    payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
    if payment_method.kind_of?(Spree::PaymentMethod::Sofort)
      @order.update_from_params(params, permitted_checkout_attributes)
      redirect_sofort
    end
  end

  def redirect_sofort
    response = Spree::SofortService.instance.initial_request(@order)
    flash[:error] = response[:error] if response[:error].present?
    redirect_to response[:redirect_url], :status => 302
  end

end
