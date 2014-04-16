require 'twitter'

class TwitCommunicator
	include MyLogger
	def initialize(settings)
		@logger = get_logger
		Twitter.configure do |config|
			config.consumer_key = settings["consumer_key"]
			config.consumer_secret = settings["consumer_secret"]
			config.oauth_token = settings["access_token"]
			config.oauth_token_secret = settings["access_token_secret"]
		end
		@target_user = settings["myself"]
	end

	def gather_new_direct_messages
		Twitter.direct_messages
	end

	def create_direct_message(text)
		Twitter.direct_message_create(@target_user, text)
	end

end