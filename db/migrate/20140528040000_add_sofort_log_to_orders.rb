class AddSofortLogToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sofort_log, :string
  end
end
