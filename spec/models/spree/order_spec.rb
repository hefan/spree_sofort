require 'spec_helper'

describe Spree::Order do

  before(:each) do
    @order = FactoryGirl.create(:order)
    @payment_method = FactoryGirl.create(:check_payment_method)
  end

#-------------------------------------------------------------------------------------------------
  context "it has no payment" do
    it "last payment is null" do
      @order.last_payment.should be_nil
    end

    it "last payment method is null" do
      @order.last_payment_method.should be_nil
    end
  end
#-------------------------------------------------------------------------------------------------
  context "it has a valid payment" do
    before(:each) do
      @payment = FactoryGirl.create(:payment, order: @order, payment_method: @payment_method)
    end

    it "last payment is given" do
      @order.last_payment.should_not be_nil
    end

    it "last payment method is given" do
      @order.last_payment_method.should_not be_nil
    end

    after(:each) do
      @payment.destroy
    end
  end
#-------------------------------------------------------------------------------------------------
  after(:each) do
    @order.destroy
    @payment_method.destroy
  end

end
