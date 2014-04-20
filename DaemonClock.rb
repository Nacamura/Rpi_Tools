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

  #TrainSearch jobs
  every(2.minute, (@twitdaemon ||= TwitDaemon.new), :if=>lambda{|t| (10...24) === t.hour})

  #tweetbookmark jobs
  every(1.hour, (TweetBookMark.new), :at=>'**:55')

  #CreditCardHistory jobs
  every(1.day, (CreditCardHistory.new), :if=>lambda{|t| t.day == 25})

  #Radio jobs
  every(1.week, Radio.new("AandG", "SuzakiNishi", "30", "0100", "SuzakiNishi"), :at=>'Wednesday 00:59')
  every(1.hour, DropboxUploader.new(".mp3"), :at=>'03:00')
end