class MoveSofortDataToPayments < ActiveRecord::Migration[4.2]

  def change
    remove_column :spree_orders, :sofort_hash
	  remove_column :spree_orders, :sofort_transaction
    remove_column :spree_orders, :sofort_log

    add_column :spree_payments, :sofort_hash, :string
    add_column :spree_payments, :sofort_transaction, :string
    add_column :spree_payments, :sofort_log, :text
  end

end
