require "open-uri"

gmaps_key = ENV.fetch("GMAPS_KEY")
dark_sky_key = ENV.fetch("DARK_SKY_KEY")

puts "\n\n=========================\n\nWhere are you located?\n\n=========================\n\n"

 user_location = gets.chomp
# user_location = "Memphis" #comment this out when ready to accept user input
# p user_location

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=LOCATION&key=MAPSKEY".gsub("LOCATION",user_location).gsub("MAPSKEY",gmaps_key)

#p gmaps_url

raw_data = URI.open(gmaps_url).read
# p raw_data.split("{").at(14).split(":")

require "json"
results_hash = JSON.parse(raw_data)
# puts results_hash.keys
lattitude = results_hash.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lat")
longitude = results_hash.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lng")

puts "\n\nYou are currently located at " + lattitude.to_s + ", " + longitude.to_s
# p lattitude
# # p raw_data.class

darksky_url = "https://api.darksky.net/forecast/REPLACEKEY/REPLACELAT,REPLACELONG".gsub("REPLACELAT",lattitude.to_s).gsub("REPLACELONG",longitude.to_s).gsub("REPLACEKEY",dark_sky_key)
# p darksky_url

raw_weather_data = URI.open(darksky_url).read
# p raw_weather_data
weather_hash = JSON.parse(raw_weather_data)
current_temp = weather_hash.fetch("currently").fetch("temperature")
next_hour_summary = weather_hash.fetch("minutely").fetch("summary")
# p next_hour_summary
puts "\nThe current temperature in " + user_location + " is " + current_temp.to_s + ". Weather in the next hour: " + next_hour_summary

hourly_data = weather_hash.fetch("hourly").fetch("data")
# p hourly_data.at(0)

each_hour = 0
# initial checking of precip for next 12 hours, printing all hours
# while  each_hour < 12
#   puts "Chance of rain at hour " + each_hour.to_s + ": " + hourly_data.at(each_hour).fetch("precipProbability").to_s
#   each_hour = each_hour + 1
# end

while  each_hour < 12
  hourly_precip_chance = hourly_data.at(each_hour).fetch("precipProbability")
  umbrella_need = false
  if hourly_precip_chance > 0.1
    umbrella_need = true
    percent_precip = hourly_precip_chance * 100
    puts "+ There is a " + percent_precip.to_s + "% chance of rain " + each_hour.to_s + " hours from now"
  end
  each_hour = each_hour + 1
  
end
if !umbrella_need
  puts "No significant rain detected in the next 12 hours, leave the umbrella home\n\n"
end
if umbrella_need
  puts "\nYou'll probably want to bring an umbrella today\n\n"
end
