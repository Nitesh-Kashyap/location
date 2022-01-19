class Location < ApplicationRecord
	has_many_attached :image
	geocoded_by :address
  after_validation :geocode
end
