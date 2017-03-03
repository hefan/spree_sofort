require 'spec_helper'

describe Spree::PaymentMethod::Sofort do

  before(:all) do
    @sofort = create(:sofort)
  end

  describe "save preferences" do
    it "can save config key" do
      @sofort.set_preference(:config_key, "the key")
      @sofort.save!
      expect(@sofort.get_preference(:config_key)).to eq("the key");
    end

    it "can save server url" do
      @sofort.set_preference(:server_url, "the url")
      @sofort.save!
      expect(@sofort.get_preference(:server_url)).to eq("the url");
    end

    it "can save reference prefix" do
      @sofort.set_preference(:reference_prefix, "prefix")
      @sofort.save!
      expect(@sofort.get_preference(:reference_prefix)).to eq("prefix");
    end

    it "can save reference suffix" do
      @sofort.set_preference(:reference_suffix, "suffix")
      @sofort.save!
      expect(@sofort.get_preference(:reference_suffix)).to eq("suffix");
    end

  end

  after(:all) do
    @sofort.destroy
  end

end
