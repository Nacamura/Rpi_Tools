load 'MyGmail.rb'

class NasneErrorChecker

  def call
    auth = open('Nasne_Auth.txt') {|i| JSON.load(i)}
    if(schedule_error?(get_mechanize_res(auth)))
      MyGmail.new.send('NasneAlert', '予約にエラーがあります')
    end
  end

  def get_mechanize_res(auth)
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    login = agent.get ''
    login_form = login.form
    login_form.field_with(:name=>'id').value = auth['id']
    login_form.field_with(:name=>'password').value = auth['password']
    mypage = login_form.click_button
  end

  def schedule_error?(mechanize_res)
    has_error = false
    mechanize_res.search('tr').each do |tr|
      if(tr.some_extraction == 'error')
        has_error = true
      end
    end
    has_error
  end

end