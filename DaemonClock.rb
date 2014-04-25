require 'clockwork'
load 'TwitDaemon.rb'
load 'TweetBookMark.rb'
load 'CreditCardHistory.rb'
load 'Radio.rb'
load 'DropboxUploader.rb'

@twitdaemon

module Clockwork
  handler do |job|
  	job.call
  end

  #Log Upload jobs
  every(1.day, DropboxUploader.new(".log"), :at=>'06:30')

  #TrainSearch jobs
  every(2.minute, (@twitdaemon ||= TwitDaemon.new), :if=>lambda{|t| (10...24) === t.hour})

  #tweetbookmark jobs
  every(1.hour, TweetBookMark.new, :at=>'**:55')

  #CreditCardHistory jobs
  every(1.day, CreditCardHistory.new, :if=>lambda{|t| t.day == 25}, :at=>'05:00')
  every(1.day, DropboxUploader.new(".csv"), :if=>lambda{|t| t.day == 25}, :at=>'06:00')

  #Radio jobs
  every(1.week, Radio.new("Radiko", "TBS", "120", "0100", "Baka"), :at=>'Tuesday 00:59')
  every(1.week, Radio.new("AandG", "Anigera", "90", "2100", "Anigera"), :at=>'Thursday 20:59')
  every(1.week, Radio.new("AandG", "AoiSaori", "30", "2330", "AoiSaori"), :at=>'Wednesday 23:29')
  every(1.hour, DropboxUploader.new(".mp3"), :at=>['06:00', '22:15'])
end