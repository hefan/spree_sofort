require 'spec_helper'

describe Spree::PaymentMethod::PaymentNetwork do

  before(:all) do
    @payment_network = create(:payment_network)
  end

  describe "save preferences" do
    it "can save config key" do
      @payment_network.set_preference(:config_key, "the key")
      @payment_network.save!
      @payment_network.get_preference(:config_key).should eql("the key");
    end

    it "can save server url" do
      @payment_network.set_preference(:server_url, "the url")
      @payment_network.save!
      @payment_network.get_preference(:server_url).should eql("the url");
    end
  end

  after(:all) do
    @payment_network.destroy
  end

end
