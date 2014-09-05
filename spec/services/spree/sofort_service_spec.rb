require 'spec_helper'

describe Spree::SofortService do

  before(:each) do
    @order = create(:order_with_line_items)
    @sofort = create(:sofort)
  end

  let(:valid_config_key) { {user_id: "aa" ,project_id:"bb", api_key: "cc"} }
  let(:invalid_config_key) { {user_id: "aa" ,project_id:"bb", api_key: "dd"} }

  let(:redirect_url) { "http://sofort.com/payhere" }
  let(:transaction) { "123-456" }


  def valid_auth
    valid_config_key[:user_id]+":"+valid_config_key[:api_key]
  end

  def invalid_auth
    invalid_config_key[:user_id]+":"+invalid_config_key[:api_key]
  end

  def valid_config
    valid_config_key[:user_id]+":"+valid_config_key[:project_id]+":"+valid_config_key[:api_key]
  end

  def invalid_config
    invalid_config_key[:user_id]+":"+invalid_config_key[:project_id]+":"+invalid_config_key[:api_key]
  end

  def stub_initial_request auth
    if auth.eql? valid_auth
      stub_request(:post, "https://#{auth}@api.sofort.com/api/xml")
        .to_return(:status => 200, :headers => {'Content-Type' => 'application/xml'},
                   :body => {:payment_url => redirect_url, :transaction => transaction }
                     .to_xml(:dasherize => false, :root => 'new_transaction'))
    else
      stub_request(:post, "https://#{auth}@api.sofort.com/api/xml")
        .to_return(:status => 401, :headers => {'Content-Type' => 'application/xml'},
                   :body => nil)
    end
  end

  def stub_transaction_request auth
    stub_request(:post, "https://#{auth}@api.sofort.com/api/xml")
      .to_return(:status => 200, :headers => {'Content-Type' => 'application/xml'},
                 :body => {:transaction_details => { :time => "2013-06-03T10:48:52+02:00",
                                                     :status => "some status",
                                                     :status_reason => "some reason",
                                                     :amount => "100.0" } }
                   .to_xml(:dasherize => false, :root => 'transactions'))
  end


  describe "initial_request" do

    context "fail" do

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

      it "get unauthorized response without valid sofort merchant key" do
        stub_initial_request invalid_auth
        @sofort.set_preference(:config_key, invalid_config)
        @sofort.save!
        payment = FactoryGirl.create(:payment, order: @order, payment_method: @sofort)
        expect(Spree::SofortService.instance.initial_request(@order)[:error]).to eq("Unauthorized")
      end

    end # context fail


    context "success" do

      before(:each) do
        stub_initial_request valid_auth
        @sofort.set_preference(:config_key, valid_config)
        @sofort.save!
        FactoryGirl.create(:payment, order: @order, payment_method: @sofort)
      end

      it "sets the correct sofort_hash" do
        correct_hash = Digest::SHA2.hexdigest(@order.number+@sofort.get_preference(:config_key))
        Spree::SofortService.instance.initial_request(@order)
        expect(@order.sofort_hash).to eq(correct_hash)
      end

      it "gets a redirect url and transaction key from sofort" do
        response = Spree::SofortService.instance.initial_request(@order)
        expect(response[:redirect_url]).to eq(redirect_url)
        expect(response[:transaction]).to eq(transaction)
      end

      it "sets the correct transaction key" do
        Spree::SofortService.instance.initial_request(@order)
        expect(@order.sofort_transaction).to eq(transaction)
      end

    end # context success
  end # initial request


  describe "transaction_status_change" do

    before(:each) do
      @sofort.set_preference(:config_key, valid_config)
      @sofort.save!
      FactoryGirl.create(:payment, order: @order, payment_method: @sofort)
      stub_initial_request valid_auth
      Spree::SofortService.instance.initial_request(@order)
    end

    context "fail" do

      it "with wrong transaction id" do
        expect {
          Spree::SofortService.instance.eval_transaction_status_change({:status_notification => {:transaction => "bogus" }})
        }.to raise_error(RuntimeError, "no order given")
      end

    end


    context "success" do

      it "logs status change" do
        stub_transaction_request valid_auth
        Spree::SofortService.instance.eval_transaction_status_change({:status_notification => {:transaction => transaction}})
        changed_order = Spree::Order.find_by_sofort_transaction(transaction)
        expect(changed_order.sofort_log).to include("some status")
      end

    end

  end


  after(:each) do
    @order.destroy
    @sofort.destroy
  end

end
