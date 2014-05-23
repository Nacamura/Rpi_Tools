require 'twitter'

class MyTwitter
	include MyLogger
	RECORDED_TITLE = './recorded_title.log'
	def initialize(settings)
		@logger = get_logger
		Twitter.configure do |config|
			config.consumer_key = settings["consumer_key"]
			config.consumer_secret = settings["consumer_secret"]
			config.oauth_token = settings["access_token"]
			config.oauth_token_secret = settings["access_token_secret"]
		end
		@target_user = settings["target_user"]
		@count = settings["count"]
		@recorded_title = open(RECORDED_TITLE, 'r') do |io|
			io.readlines
		end.map(&:strip)
	end

	def gather_timeline
		Twitter.user_timeline(@target_user, options={:count => @count})
	end

	def gather_hatebu_urls
		gather_timeline.map do |t|
			t.text.slice(/http[^\s]*$/)
		end
	end

	def gather_hatebu_urls_without_ng(ng_words)
		gather_timeline.reject do |t|
			record_title(t.text.gsub(/\(\d+ users\)/, "").gsub(/ *http:.*/, ""))
			has_ng_word?(t.text, ng_words)
		end.map do |t|
			t.text.slice(/http[^\s]*/)
		end
	end

	def has_ng_word?(text, ng_words)
		has_ng_word = false
		ng_words.each do |ng_word|
			has_ng_word = (text.match(ng_word) != nil)
			break if has_ng_word
		end
		@logger.debug("skip:" + text) if has_ng_word
		has_ng_word
	end

	def record_title(title)
		(@recorded_title << title.strip) if not (@recorded_title.include? title.strip)
	end

	def dump_recorded
		open(RECORDED_TITLE, 'w') do |io|
			@recorded_title.each do |title|
				io.puts title
			end
		end
	end

end