class Spree::SofortController < ApplicationController

  def success
    sofort_payment = Spree::Payment.find_by_sofort_hash(params[:sofort_hash])
    if params.blank? or params[:oid].blank? or sofort_payment.blank?
       flash[:error] = I18n.t("sofort.payment_not_found")
       redirect_to '/checkout/payment', :status => 302
       return
    end

    order = sofort_payment.order
    if order.blank?
     	flash[:error] = I18n.t("sofort.order_not_found")
     	redirect_to '/checkout/payment', :status => 302
     	return
    end

    if order.state.eql? "complete"  # complete again via browser back or recalling sofort "go" url
      redirect_to "/orders/#{order.number}", :status => 302
    else
      order.finalize!
      order.state = "complete"
      order.save!
      session[:order_id] = nil
      flash[:success] = I18n.t("sofort.completed_successfully")
      success_redirect order
    end

  end

  def cancel
    flash[:error] = I18n.t("sofort.canceled")
    redirect_to '/checkout/payment', :status => 302
  end

  def status
    Spree::SofortService.instance.eval_transaction_status_change(params)

    render :nothing => true
  end

  private

  def success_redirect order
    redirect_to "/orders/#{order.number}", :status => 302
  end

end
