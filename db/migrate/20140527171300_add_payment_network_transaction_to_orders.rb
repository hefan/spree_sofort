class AddPaymentNetworkTransactionToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :payment_network_transaction, :string
  end
end
