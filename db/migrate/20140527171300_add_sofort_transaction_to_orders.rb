class AddSofortTransactionToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_orders, :sofort_transaction, :string
  end
end
