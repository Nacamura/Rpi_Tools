require 'json'
load 'MyLogger.rb'
load 'MyTwitter.rb'
load 'Instapaper.rb'
load 'Pocket.rb'

class TweetBookMark
  include MyLogger
  def call
    settings = MyJSON.load_json("settings.txt")
    stored_urls = MyJSON.load_json("urls.txt")
    twitter = MyTwitter.new(settings)
    ng_words = MyJSON.load_json("ng_words.txt")
    urls = twitter.gather_hatebu_urls_without_ng(ng_words).reverse!
    new_urls = urls.reject {|url| stored_urls.include? url}
    Instapaper.new(settings).add_all(new_urls)
    Pocket.new(settings).add_all(new_urls)
    MyJSON.store_json(urls, "urls.txt")
    twitter.dump_recorded
  end
end