load 'NetAnswer.rb'
load 'VPass.rb'

class CreditCardHistory
  def call
    NetAnswer.new.call
    VPass.new.call
  end
end