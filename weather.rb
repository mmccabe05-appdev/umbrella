require "open-uri"

p "Where are you located?"

# user_location = gets.chomp
user_location = "Chicago" #comment this out when ready to accept user input
# p user_location

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=LOCATION&key=AIzaSyAgRzRHJZf-uoevSnYDTf08or8QFS_fb3U".gsub("LOCATION",user_location)

#p gmaps_url

raw_data = URI.open(gmaps_url).read
# p raw_data.split("{").at(14).split(":")

require "json"
results_hash = JSON.parse(raw_data)
# puts results_hash.keys
lattitude = results_hash.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lat")
longitude = results_hash.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lng")

p lattitude
p longitude
# p lattitude
# # p raw_data.class

darksky_url = "https://api.darksky.net/forecast/26f63e92c5006b5c493906e7953da893/REPLACELAT,REPLACELONG".gsub("REPLACELAT",lattitude.to_s).gsub("REPLACELONG",longitude.to_s)
# p darksky_url

raw_weather_data = URI.open(darksky_url).read
# p raw_weather_data
weather_hash = JSON.parse(raw_weather_data)
current_temp = weather_hash.fetch("currently").fetch("temperature")
next_hour_summary = weather_hash.fetch("minutely").fetch("summary")
p next_hour_summary
p "The current temperature in " + user_location + " is " + current_temp.to_s + ". Weather in the next hour: " + next_hour_summary

hourly_data = weather_hash.fetch("hourly").fetch("data")
puts hourly_data.at(0).fetch("precipProbability")
