Rails.application.routes.draw do

  with_options :format => false do |r|
    r.with_options :constraints => {:reserved_path => %r[/.*]} do |path_routes|
      path_routes.get "/paths*reserved_path" => "reservations#show"
      path_routes.put "/paths*reserved_path" => "reservations#update"
    end

    r.get "/healthcheck" => proc { [200, {}, ["OK\n"]] }
  end
end
