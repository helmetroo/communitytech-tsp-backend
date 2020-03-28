Rails.application.routes.draw do
  get '/shortest-route', to: 'shortest_route#get'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
