class AddSofortTransactionToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sofort_transaction, :string
  end
end
