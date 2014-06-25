require 'restclient'

class Instapaper

	def initialize(settings)
		@user = settings["instapaper_user"]
		@password = settings["instapaper_pw"]
	end

	def add(url)
		RestClient.post("https://www.instapaper.com/api/add",
		    "username"=>@user, "password"=>@password, "url"=>url)
	end

	def add_all(urls)
		urls.each do |url|
			add(url)
			sleep 3
		end
	end

end