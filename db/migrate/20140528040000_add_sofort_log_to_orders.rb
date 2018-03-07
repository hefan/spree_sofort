class AddSofortLogToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_orders, :sofort_log, :string
  end
end
