class AddSofortHashToOrders < ActiveRecord::Migration[4.2]

  def change
    add_column :spree_orders, :sofort_hash, :string
  end

end
