require 'twitter'
load 'MyJSON.rb'
load 'TrainSearch.rb'
load 'Radio.rb'
load 'MyGmail.rb'

class TwitDaemon
  def initialize
    settings = MyJSON.load_json("settings.txt")
    Twitter.configure do |config|
      config.consumer_key = settings["consumer_key"]
      config.consumer_secret = settings["consumer_secret"]
      config.oauth_token = settings["access_token"]
      config.oauth_token_secret = settings["access_token_secret"]
    end
  end

  def call
    dms = Twitter.direct_messages
    dms.each do |dm|
      lines = dm.text.split("\n")
      if(lines[0].strip != "pi")
        next
      else
        parse_command(lines)
      end
    end
  end

  def parse_command(lines)
    lines.each do |l|
      case l.strip
      when "home"
        MyGmail.new.send('TrainSearch', TrainSearch.new.route_text)
      when "radio"
        Radio.temp_schedule(lines)
      end
    end
  end

end