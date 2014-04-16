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
			res = add(url)
			if res != "201" then @logger.warn(url + " : " + res) end
			sleep 1
		end
	end

	def add_with_hatebu(url)
		res = RestClient.post("https://www.instapaper.com/api/add",
			"username"=>@user, "password"=>@password, "url"=>url)
		if res != "201" then return res end
		location = res.headers[:content_location]
		sleep 1
		add("http://b.hatena.ne.jp/entry/" + location)
	end

	def add_all_with_hatebu(urls)
		@logger.debug("add " + urls.length.to_s + " URLs")
		urls.each do |url|
			res = add_with_hatebu(url)
			if res != "201" then @logger.warn(url + " : " + res) end
			sleep 1
		end
	end
end