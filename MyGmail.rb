require 'gmail'
load 'MyJSON.rb'

class MyGmail
	def initialize
		@settings = MyJSON.load_json("settings.txt")
		@gmail = Gmail.new(@settings['email'], @settings['email_pw'])
	end

	def send
		target = @settings["target_email"]
		@gmail.deliver do
			to target
			subject 'Test Mail'
			text_part do
				body 'テスト送信しています'
			end
		end
  end
end