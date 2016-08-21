class Spree::SofortController < Spree::StoreController

  skip_before_filter :verify_authenticity_token, only: :status

  def success
    sofort_payment = Spree::Payment.find_by(sofort_hash: params[:sofort_hash])

    unless sofort_payment
       flash[:error] = I18n.t("sofort.payment_not_found")
       return redirect_to '/checkout/payment', status: 302
    end

    order = sofort_payment.order
    unless order
     	flash[:error] = I18n.t("sofort.order_not_found")
     	return redirect_to '/checkout/payment', status: 302
    end

    unless order.complete?  # complete again via browser back or recalling sofort "go" url
      order.finalize!
      order.state = "complete"
      order.mark_as_paid! if order.last_payment_method.auto_capture?
      order.save!
      session[:order_id] = nil
      flash[:success] = I18n.t("sofort.completed_successfully")
    end
    success_redirect order
  end

  def cancel
    flash[:error] = I18n.t("sofort.canceled")
    redirect_to '/checkout/payment', status: 302
  end

  def status
    Spree::SofortService.instance.eval_transaction_status_change(params)
    render nothing: true
  end

  private

  def success_redirect order
    redirect_to order_path(order.number, order.guest_token), status: 302
  end

end
