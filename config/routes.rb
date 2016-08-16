Spree::Core::Engine.routes.draw do
  get '/sofort/success', to: 'sofort#success'
  get '/sofort/cancel', to: 'sofort#cancel'
  post '/sofort/status', to: 'sofort#status'
end
