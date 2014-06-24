require 'spec_helper'

describe Spree::PaymentNetworkService do

  before(:each) do
    @order = create(:order_with_line_items)
    @payment_network = create(:payment_network)
  end

  describe "initial_request" do
    it "raise null order exception" do
      expect {
        Spree::PaymentNetworkService.instance.initial_request(nil)
      }.to raise_error(RuntimeError, "no order given")
    end

    it "raises no payment method exception" do
      expect {
        Spree::PaymentNetworkService.instance.initial_request(@order)
      }.to raise_error(RuntimeError, "order has no payment method")
    end

    it "raises wrong payment method exception" do
      payment = FactoryGirl.create(:payment, order: @order, payment_method: create(:check_payment_method))
      expect {
        Spree::PaymentNetworkService.instance.initial_request(@order)
      }.to raise_error(RuntimeError, "orders payment method is not payment network")
    end

    it "raises blank config key exception" do
      payment = FactoryGirl.create(:payment, order: @order, payment_method: @payment_network)
      expect {
        Spree::PaymentNetworkService.instance.initial_request(@order)
      }.to raise_error(RuntimeError, "payment network config key is blank")
    end

    it "raises invalid config key exception" do
      @payment_network.set_preference(:config_key, "something:not3segmented")
      @payment_network.save!
      payment = FactoryGirl.create(:payment, order: @order, payment_method: @payment_network)
      expect {
        Spree::PaymentNetworkService.instance.initial_request(@order)
      }.to raise_error(RuntimeError, "payment network config key is invalid")
    end

    it "sets the correct payment_network_hash" do
      @payment_network.set_preference(:config_key, "aa:bb:cc")
      @payment_network.save!
      correct_hash = Digest::SHA2.hexdigest(@order.number+@payment_network.get_preference(:config_key))
      payment = FactoryGirl.create(:payment, order: @order, payment_method: @payment_network)
      Spree::PaymentNetworkService.instance.initial_request(@order)
      expect(@order.payment_network_hash).to eq(correct_hash)
    end

    it "get unauthorized response without valid sofort merchant key" do
      @payment_network.set_preference(:config_key, "aa:bb:cc")
      @payment_network.save!
      payment = FactoryGirl.create(:payment, order: @order, payment_method: @payment_network)
      expect(Spree::PaymentNetworkService.instance.initial_request(@order)[:error]).to eq("Unauthorized")
    end

  end

  # TODO Use Webmock for testing payment newtwork initial and transaction response


  after(:each) do
    @order.destroy
    @payment_network.destroy
  end

end
