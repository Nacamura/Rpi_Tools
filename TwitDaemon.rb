load 'MyJSON.rb'
load 'MyLogger.rb'
load 'TwitCommunicator.rb'
load 'TrainSearch.rb'
load 'Radio.rb'
load 'MyGmail.rb'

class TwitDaemon
  include MyLogger

  @twitcom

  def call
    @twitcom ||= TwitCommunicator.new( MyJSON.load_json("settings.txt") )
    dms = @twitcom.gather_new_direct_messages
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