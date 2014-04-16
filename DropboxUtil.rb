require 'dropbox_sdk'
load 'MyJSON.rb'

class DropboxUtil
	def initialize
		auth = MyJSON.load_json("dropbox_auth.txt")
		session = DropboxSession.new(auth["app_key"], auth["app_secret"])
		session.set_request_token(auth["request_token_key"], auth["request_token_secret"])
		session.set_access_token(auth["access_token_key"], auth["access_token_secret"])
		@client = DropboxClient.new(session, auth["access_type"]) 
	end

	def upload(cloud_path, local_path, filename)
		file = open(local_path + filename)
		@client.put_file(cloud_path + filename, file)
	end
end