Spree::Core::Engine.routes.draw do
  get '/payment_network/success', :to => 'payment_network#success'
  get '/payment_network/cancel', :to => 'payment_network#cancel'
  post '/payment_network/status', :to => 'payment_network#status'
end
