load 'MyGmail.rb'

class NanacoDepoChecker

  def call
    auth = open('Nanaco_Auth.txt') {|i| JSON.load(i)}
    if(get_deposit(get_mechanize_res(auth)) < 1000)
      MyGmail.new.send('NanacoDeposit', '残高が少なくなっています')
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
  end

  def get_deposit(mechanize_res)
    deposit = 1000000
    mechanize_res.search('tr').each do |tr|
      if(tr.some_extraction == 'money')
        deposit = money_gsub
      end
    end
    deposit
  end

end