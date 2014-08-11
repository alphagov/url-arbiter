Rails.application.routes.draw do

  with_options :format => false do |r|
    r.put "/paths(*reserved_path)" => "reservations#update", :constraints => {:reserved_path => %r[/.*]}

    r.get "/healthcheck" => proc { [200, {}, ["OK\n"]] }
  end
end
