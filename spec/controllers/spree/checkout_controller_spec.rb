require 'spec_helper'

describe Spree::CheckoutController do

  let(:token) { 'some_token' }
  let(:user) { stub_model(Spree::User) }
  let(:order) { FactoryGirl.create(:order_with_totals) }

  let(:address_params) do
    address = FactoryGirl.build(:address)
    address.attributes.except("created_at", "updated_at")
  end

  before(:each) do
    @order = create(:order_with_line_items)
    @payment_network = create(:payment_network)
    @payment_network.set_preference(:config_key, "the key")
    payment = create(:payment, order: @order, payment_method: @payment_network)

    controller.stub :try_spree_current_user => user
    controller.stub :spree_current_user => user
    controller.stub :current_order => @order
  end

#-------------------------------------------------------------------------------------------------
  describe "checkout" do

    it "updates order correctly" do
    end

    it "redirects to cancel url without payment network account" do
    end

  end

end
