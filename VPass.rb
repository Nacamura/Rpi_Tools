require 'mechanize'
require 'json'

class VPass
  def call
    auth_list = open('VPass_Auth.txt') {|i| JSON.load(i)}
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
    login = agent.get 'https://www.smbc-card.com/mem/vps/index.jsp'
    login_form = login.forms[1]
    login_form.field_with(:name=>'userid').value = auth['id']
    login_form.field_with(:name=>'password').value = auth['password']
    mypage = login_form.click_button
    detail_link = mypage.link_with(:text=>'ご利用明細を見る')
    detail = detail_link.click unless detail_link.nil?
    csv_link = detail.link_with(:text=>'CSV形式で保存')
    csv = csv_link.click unless csv_link.nil?
    mypage.link_with(:text=>'ログアウト').click
    csv
  end
end