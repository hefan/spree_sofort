module Spree
  class PaymentNetworkService

    include Singleton

    # make the initialization request
    # https://www.sofort.com/integrationCenter-ger-DE/content/view/full/2513#h6-1
    # https://www.sofort.com/integrationCenter-ger-DE/content/view/full/2513#h6-2
    def initial_request order, ref_number
      init_data(order)
      ref_number = @order.number if ref_number.blank?
      @order.update_attribute(:payment_network_hash, build_exit_param)
      raw_response = HTTParty.post(@payment_network.preferred_server_url,
                                  :headers => header,
                                  :body => initial_request_body(ref_number))

      response = parse_initial_response(raw_response)
      @order.update_attribute(:payment_network_transaction, response[:transaction])
      return response
    end

    # evaluate transaction status change
    # https://www.sofort.com/integrationCenter-ger-DE/content/view/full/2513#h6-3
    # https://www.sofort.com/integrationCenter-ger-DE/content/view/full/2513#h6-4
    # https://www.sofort.com/integrationCenter-ger-DE/content/view/full/2513#h6-5
    def eval_transaction_status_change params
      init_data(Spree::Order.find_by_payment_network_transaction(params[:status_notification][:transaction]))

      raw_response = HTTParty.post(@payment_network.preferred_server_url,
                                  :headers => header,
                                  :body => transaction_request_body)

      new_entry = "empty transaction status change"
      if raw_response.parsed_response["transactions"].present? and
         raw_response.parsed_response["transactions"]["transaction_details"].present?

        td = raw_response.parsed_response["transactions"]["transaction_details"]
        new_entry = "#{td["time"]}: #{td["status"]} / #{td["status_reason"]} (#{td["amount"]})"
      end
      old_entries = @order.payment_network_log || ""
      @order.update_attribute(:payment_network_log, old_entries += "#{new_entry}\n")
    end


    private

    def init_data(order, cancel_url = "/checkout/payment")
      raise "no order given" if order.blank?
      @order = order
      @cancel_url = cancel_url

      raise "order has no payment method" if @order.last_payment_method.blank?
      raise "orders payment method is not payment network " unless @order.last_payment_method.kind_of? Spree::PaymentMethod::PaymentNetwork
      @payment_network = @order.last_payment_method

      config_key_parts = @payment_network.preferred_config_key.split(":")
      raise "there is no valid config key" if config_key_parts.length < 3
      @user_id = config_key_parts[0]
      @project_id = config_key_parts[1]
      @api_key = config_key_parts[2]
      @http_auth_key = "#{@user_id}:#{@api_key}"
    end

    def header
      return {
        "Authorization" => "Basic #{Base64.encode64(@http_auth_key)}",
        "Content-Type" => "application/xml; charset=UTF-8",
        "Accept" => "application/xml; charset=UTF-8"
      }
    end

    def initial_request_body ref_number
      base_url = "http://#{Spree::Config.site_url}"
      notification_url = Spree::Config.site_url.start_with?("localhost") ? "" : "#{base_url}/payment_network/status"
      body_hash = {
        :su => {:customer_protection => "1"},
        :amount => @order.total,
        :currency_code => Spree::Config.currency,
        :reasons => {:reason => ref_number},
        :success_url => "#{base_url}/payment_network/success?oid=#{@order.payment_network_hash}",
        :success_link_redirect => "1",
        :abort_url => "#{base_url}/payment_network/cancel",
        # no url with port as notification url allowed
        :notification_urls => {:notification_url => notification_url},
        :project_id => @project_id
      }
      body_hash.to_xml(:dasherize => false, :root => 'multipay',
                       :root_attrs => {:version => '1.0'})
    end

    def transaction_request_body
      body_hash = {
        :transaction => @order.payment_network_transaction
      }
      body_hash.to_xml(:dasherize => false, :root => 'transaction_request',
                       :root_attrs => {:version => '2'})
    end

    def parse_initial_response raw_response
      response = {}
      if raw_response.parsed_response["errors"].present?
        response[:redirect_url] = @cancel_url
        response[:transaction] = ""
        response[:error] = "Error from sofort:
                        #{raw_response.parsed_response["errors"]["error"]["field"]}:
                        #{raw_response.parsed_response["errors"]["error"]["message"]}"
      else
        response[:redirect_url] = raw_response.parsed_response["new_transaction"]["payment_url"]
        response[:transaction] = raw_response.parsed_response["new_transaction"]["transaction"]
      end
      return response
    end

    def build_exit_param
      Digest::SHA2.hexdigest(@order.number+@payment_network.preferred_config_key)
    end

  end
end
