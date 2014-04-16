require 'restclient'

class Pocket
	include MyLogger

	def initialize(settings)
		@logger = get_logger
		@consumer_key = settings["pocket_key"]
		@access_token = settings["pocket_token"]
	end

	def add(url)
		RestClient.post("https://getpocket.com/v3/add", "url"=>url,
		    "consumer_key"=>@consumer_key, "access_token"=>@access_token)
	end

	def add_all(urls)
		@logger.debug("pocket: add " + urls.length.to_s + " URLs")
		urls.each do |url|
			add(url)
			sleep 1
		end
	end
end