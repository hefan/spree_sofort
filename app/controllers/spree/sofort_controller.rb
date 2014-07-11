class Spree::SofortController < ApplicationController

  def success
    order = Spree::Order.find_by_sofort_hash(params[:oid])

    if params.blank? or params[:oid].blank? or order.blank?
<<<<<<< HEAD:app/controllers/spree/payment_network_controller.rb
     	flash[:error] = I18n.t("payment_network.order_not_found")
=======
     	flash[:error] = I18n.t("sofort.order_not_found")
>>>>>>> 2-2-stable:app/controllers/spree/sofort_controller.rb
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
<<<<<<< HEAD:app/controllers/spree/payment_network_controller.rb
      flash[:notice] = I18n.t("payment_network.completed_successfully")
=======
      flash[:notice] = I18n.t("sofort.completed_successfully")
>>>>>>> 2-2-stable:app/controllers/spree/sofort_controller.rb
      success_redirect order
    end

  end

  def cancel
<<<<<<< HEAD:app/controllers/spree/payment_network_controller.rb
    flash[:error] = I18n.t("payment_network.canceled")
=======
    flash[:error] = I18n.t("sofort.canceled")
>>>>>>> 2-2-stable:app/controllers/spree/sofort_controller.rb
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
