class AddSofortLogToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sofort_log, :text
  end
end
