load 'NetAnswer.rb'
load 'VPass.rb'
load 'DropboxUtil.rb'

class CreditCardHistory

  def call
    NetAnswer.new.call
    VPass.new.call
    dropbox = DropboxUtil.new
    Dir.new('./').each do |file|
      if(File.extname(file) == ".csv")
      	dropbox.upload('/', './', file)
      end
    end
  end
  
end