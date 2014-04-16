require 'mechanize'
require 'json'

class NetAnswer
  def call
    auth_list = open('auth.txt') {|i| JSON.load(i)}
    auth_list.each do |auth|
      csv = get_mechanize_res(auth)
      if(csv)
        csv.save_as('./detail_' + Time.now.strftime('%Y%m') + '_' + auth['name'] + '.csv')
      else
        Mechanize::File.new.save_as('./detail_' + Time.now.strftime('%Y%m') + '_' + auth['name'] + '.csv')
      end
    end
    nil
  end

  def get_mechanize_res(auth)
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    login = agent.get 'https://netanswerplus.saisoncard.co.jp/WebPc/welcomeSCR.do'
    login_form = login.form
    login_form.field_with(:name=>'inputId').value = auth['id']
    login_form.field_with(:name=>'inputPassword').value = auth['password']
    mypage = login_form.click_button
    detail_link = mypage.link_with(:text=>'利用明細確認')
    detail = detail_link.click unless detail_link.nil?
    csv_link = detail.link_with(:text=>'CSVダウンロード')
    csv = csv_link.click unless csv_link.nil?
    mypage.link_with(:text=>'ログアウト').click
    csv
  end
end