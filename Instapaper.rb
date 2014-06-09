require 'restclient'

class Instapaper
	include MyLogger

	def initialize(settings)
		@logger = get_logger
		@user = settings["instapaper_user"]
		@password = settings["instapaper_pw"]
	end

	def add(url)
		RestClient.post("https://www.instapaper.com/api/add",
		    "username"=>@user, "password"=>@password, "url"=>url)
	end

	def add_all(urls)
		@logger.debug("add " + urls.length.to_s + " URLs")
		urls.each do |url|
			add(url)
			sleep 1
		end
	end

end