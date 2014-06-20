class AddPaymentNetworkHashToOrders < ActiveRecord::Migration

  def change
    add_column :spree_orders, :payment_network_hash, :string
  end
  
end
