class AddPaymentNetworkLogToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :payment_network_log, :text
  end
end
