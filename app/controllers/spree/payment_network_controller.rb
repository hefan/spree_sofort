class Spree::PaymentNetworkController < ApplicationController

  def success
    order = Spree::Order.find_by_payment_network_hash(params[:oid])

    if params.blank? or params[:oid].blank? or order.blank?
     	flash[:error] = "payment network canceled, order could not be found"
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
      flash[:notice] = I18n.t(:order_processed_successfully, :locale => :de)
      success_redirect order
    end

  end

  def cancel
    flash[:error] = "sofort payment canceled"
    redirect_to '/checkout/payment', :status => 302
  end

  def status
    Spree::PaymentNetworkService.instance.eval_transaction_status_change(params)

    render :nothing => true
  end

  private

  def success_redirect order
    redirect_to "/orders/#{order.number}", :status => 302
  end

end
