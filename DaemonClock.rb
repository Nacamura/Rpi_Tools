require 'clockwork'
load 'TwitDaemon.rb'
load 'TweetBookMark.rb'
load 'CreditCardHistory.rb'
load 'Radio.rb'
load 'DropboxUploader.rb'
load 'RadioFailChecker.rb'
load 'NanacoDepoChecker.rb'

@twitdaemon

module Clockwork
  handler do |job|
  	job.call
  end

  every(1.hour, DropboxUploader.new(".log", "non_archive"), :at=>['08:30', '20:30'])

  every(3.minute, (@twitdaemon ||= TwitDaemon.new), :if=>lambda{|t| (16..19) === t.hour})

  every(1.hour, TweetBookMark.new, :at=>'**:55')

  every(1.day, CreditCardHistory.new, :if=>lambda{|t| t.day == 20}, :at=>'03:00')
  every(1.day, DropboxUploader.new(".csv", "CCH_archive"), :if=>lambda{|t| t.day == 20}, :at=>'03:30')

  every(1.day, NanacoDepoChecker.new, :at=>'20:00')

  every(1.week, Radio.new("Radiko", "TBS", "120", "0100", "Baka"), :at=>'Tuesday 00:59')
  every(1.week, Radio.new("AandG", "Anigera", "90", "2100", "Anigera"), :at=>'Thursday 20:59')
  every(1.hour, DropboxUploader.new(".mp3", "mp3_archive"), :at=>['06:00', '22:15'])

  every(1.day, RadioFailChecker.new, :at=>'22:30')

end