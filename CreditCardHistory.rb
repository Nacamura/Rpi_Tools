load 'NetAnswer.rb'
load 'DropboxUtil.rb'

class CreditCardHistory

  def call
    NetAnswer.new.call
    dropbox = DropboxUtil.new
    Dir.new('./').each do |file|
      if(File.extname(file) == ".csv")
      	dropbox.upload('/', './', file)
      end
    end
  end
  
end