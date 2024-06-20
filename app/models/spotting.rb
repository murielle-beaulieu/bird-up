class Spotting < ApplicationRecord
  belongs_to :user
  belongs_to :bird

  after_validation :geocode, if: :will_save_change_to_location?

  geocoded_by :location do |obj, results|
    if geo = results.first
      # Setting latitude and longitude manually using data from mapbox api call
      obj.longitude = geo.data["geometry"]["coordinates"][0]
      obj.latitude = geo.data["geometry"]["coordinates"][1]
    end
  end
end
