class Spree::SofortController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :status

  def success
    order = Spree::Order.find_by_sofort_hash(params[:oid])

    if params.blank? or params[:oid].blank? or order.blank?
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
      order.last_payment.complete! if order.last_payment.present? and order.last_payment_method.kind_of? Spree::PaymentMethod::Sofort
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
