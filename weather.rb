require "open-uri"

p "Where are you located?"

user_location = gets.chomp

p user_location

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=Memphis&key=AIzaSyAgRzRHJZf-uoevSnYDTf08or8QFS_fb3U"

p URI.open(gmaps_url)
