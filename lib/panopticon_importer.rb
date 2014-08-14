require 'rest_client'
require 'plek'

class PanopticonImporter

  def import
    puts "Importing artefacts from panopticon"

    count = 0
    each_artefact do |artefact|
      count += 1
      begin
        reservation = Reservation.find_or_initialize_by(:path => artefact_base_path(artefact))
        reservation.publishing_app = artefact.fetch("owning_app")
        reservation.save!
      rescue => e
        puts "\nError creating reservation for #{artefact["name"]}(#{artefact["slug"]}) - #{e.class}: #{e.message}"
      end
      print "." if count % 500 == 0
    end
    puts "done."
  end

  def artefact_base_path(artefact)
    "/#{artefact.fetch("slug")}"
  end

  def each_artefact
    page = 1
    while true do
      artefacts = get_page(page)
      return if artefacts.empty?
      artefacts.each {|a| yield a }
      page += 1
    end
  end

  def get_page(page)
    response = RestClient.get(artefacts_url + "?page=#{page}")
    return JSON.parse(response.body)
  end

  def artefacts_url
    @_artefacts_url ||= Plek.new.find('panopticon') + "/artefacts.json"
  end
end