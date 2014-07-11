require 'spec_helper'

describe Spree::PaymentMethod::Sofort do

  before(:all) do
    @sofort = create(:sofort)
  end

  describe "save preferences" do
    it "can save config key" do
      @sofort.set_preference(:config_key, "the key")
      @sofort.save!
      @sofort.get_preference(:config_key).should eql("the key");
    end

    it "can save server url" do
      @sofort.set_preference(:server_url, "the url")
      @sofort.save!
      @sofort.get_preference(:server_url).should eql("the url");
    end
  end

  after(:all) do
    @sofort.destroy
  end

end
