require 'spec_helper'

describe Spree::SofortService do

  before(:each) do
    @order = create(:order_with_line_items)
    @sofort = create(:sofort)
  end

  describe "initial_request" do
    it "raise null order exception" do
      expect {
        Spree::SofortService.instance.initial_request(nil)
      }.to raise_error(RuntimeError, "no order given")
    end

    it "raises no payment method exception" do
      expect {
        Spree::SofortService.instance.initial_request(@order)
      }.to raise_error(RuntimeError, "order has no payment method")
    end

    it "raises wrong payment method exception" do
      payment = FactoryGirl.create(:payment, order: @order, payment_method: create(:check_payment_method))
      expect {
        Spree::SofortService.instance.initial_request(@order)
      }.to raise_error(RuntimeError, "orders payment method is not sofort payment")
    end

    it "raises blank config key exception" do
      payment = FactoryGirl.create(:payment, order: @order, payment_method: @sofort)
      expect {
        Spree::SofortService.instance.initial_request(@order)
      }.to raise_error(RuntimeError, "sofort config key is blank")
    end

    it "raises invalid config key exception" do
      @sofort.set_preference(:config_key, "something:not3segmented")
      @sofort.save!
      payment = FactoryGirl.create(:payment, order: @order, payment_method: @sofort)
      expect {
        Spree::SofortService.instance.initial_request(@order)
      }.to raise_error(RuntimeError, "sofort config key is invalid")
    end

    it "sets the correct sofort_hash" do
      @sofort.set_preference(:config_key, "aa:bb:cc")
      @sofort.save!
      correct_hash = Digest::SHA2.hexdigest(@order.number+@sofort.get_preference(:config_key))
      payment = FactoryGirl.create(:payment, order: @order, payment_method: @sofort)
      Spree::SofortService.instance.initial_request(@order)
      expect(@order.sofort_hash).to eq(correct_hash)
    end

    it "get unauthorized response without valid sofort merchant key" do
      @sofort.set_preference(:config_key, "aa:bb:cc")
      @sofort.save!
      payment = FactoryGirl.create(:payment, order: @order, payment_method: @sofort)
      expect(Spree::SofortService.instance.initial_request(@order)[:error]).to eq("Unauthorized")
    end

  end

  # TODO Use Webmock for testing payment network initial and transaction response


  after(:each) do
    @order.destroy
    @sofort.destroy
  end

end
