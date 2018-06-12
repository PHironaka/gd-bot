require 'twitter'
require 'httparty'
require 'nokogiri'


twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = "WwDGVMUlhCXUS3iYi2qgE3ixR"
  config.consumer_secret     = "agk5YXQsHwHVEseZ7Q7g34dM9aoufGjzthPsXFTPTqfiZdLl36"
  config.access_token        = "890724584093237249-1lhv87SSwEsnfPb69YIsLEUrK7S9ISb"
  config.access_token_secret = "pjDElKNuet213FIEvupycJwkc71pY9E48CeiqemwpRZK2"
end

latest_tweets = twitter.user_timeline("scoutmaster_app")
previous_links = latest_tweets.map do |tweet|
	if tweet.urls.any?
		tweet.urls[0].expanded_url
	end
end

rss = HTTParty.get("https://www.golfdigest.com/feed/rss")
doc = Nokogiri::XML(rss)

doc.css("item").take(5).each do |item|
	title = item.css("title").text
	link = item.css("link").text

	unless link.start_with?("http")
		link = item.css("description").text
	end 

	unless previous_links.include?(link)
		twitter.update("#{title} #{link}")
	end
end