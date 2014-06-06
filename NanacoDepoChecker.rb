require 'mechanize'
require 'json'
load 'MyGmail.rb'

class NanacoDepoChecker
  include MyLogger

  def call
    auth = open('Nanaco_Auth.txt') {|i| JSON.load(i)}
    current_deposit = get_deposit(get_mechanize_res(auth))
    get_logger.info(deposit_message = "Nanaco残高:#{current_deposit}円")
    if(current_deposit < 1500)
      MyGmail.new.send('NanacoDeposit', deposit_message)
    end
  end

  def get_mechanize_res(auth)
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    login = agent.get 'https://www.nanaco-net.jp/pc/emServlet'
    login_form = login.forms[1]
    login_form.field_with(:name=>'XCID').value = auth['id']
    login_form.field_with(:name=>'SECURITY_CD').value = auth['password']
    mypage = login_form.click_button
    mypage.links[2].click
    mypage
  end

  def get_deposit(mechanize_res)
    mechanize_res.search('p')[5].text.gsub(',', '').gsub('円', '').to_i
  end

end