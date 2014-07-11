class AddSofortHashToOrders < ActiveRecord::Migration

  def change
    add_column :spree_orders, :sofort_hash, :string
  end

end
