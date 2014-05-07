require 'clockwork'
load 'TwitDaemon.rb'
load 'TweetBookMark.rb'
load 'CreditCardHistory.rb'
load 'Radio.rb'
load 'DropboxUploader.rb'
load 'RadioFailChecker.rb'

@twitdaemon

module Clockwork
  handler do |job|
  	job.call
  end

  #Log Upload jobs
  every(1.hour, DropboxUploader.new(".log", "non_archive"), :at=>['06:00', '12:00', '18:00'])

  #TrainSearch jobs
  every(2.minute, (@twitdaemon ||= TwitDaemon.new), :if=>lambda{|t| (10...22) === t.hour})

  #tweetbookmark jobs
  every(1.hour, TweetBookMark.new, :at=>'**:55')

  #CreditCardHistory jobs
  every(1.day, CreditCardHistory.new, :if=>lambda{|t| t.day == 25}, :at=>'05:00')
  every(1.day, DropboxUploader.new(".csv", "CCH_archive"), :if=>lambda{|t| t.day == 25}, :at=>'07:00')

  #Radio jobs
  every(1.week, Radio.new("Radiko", "TBS", "120", "0100", "Baka"), :at=>'Tuesday 00:59')
  every(1.week, Radio.new("AandG", "Anigera", "90", "2100", "Anigera"), :at=>'Thursday 20:59')
  every(1.week, Radio.new("AandG", "AoiSaori", "30", "2330", "AoiSaori"), :at=>'Wednesday 23:29')
  every(1.hour, DropboxUploader.new(".mp3", "mp3_archive"), :at=>['06:00', '22:15'])

  #RadioFailChecker jobs
  every(1.day, RadioFailChecker.new, :at=>'22:30')

end