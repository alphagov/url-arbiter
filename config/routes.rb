Rails.application.routes.draw do
  scope format: false do |r|
    get "/paths(/*reserved_path)", to: "reservations#show"
    put "/paths(/*reserved_path)", to: "reservations#update"
  end

  get "/healthcheck" => proc { [200, {}, ["OK\n"]] }
end
