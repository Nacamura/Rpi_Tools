class JorudanSearch

  require 'mechanize'
  Route = Struct.new(:name, :time, :duration, :exchange, :fare)

  def routes(from_st, to_st, route_st, gap_seconds)
    parse_to_routes(get_mechanize_res(from_st, to_st, route_st, gap_seconds))
  end

  def routes_specific(from_st, to_st, route_st, gap_seconds)
    routes(from_st, to_st, route_st, gap_seconds) << get_specific_route(from_st, to_st, route_st, gap_seconds)
  end

  def get_specific_route(from_st, to_st, route_st, gap_seconds)
    route_stations = []
    get_mechanize_res(from_st, to_st, route_st, gap_seconds).search("td").each do |td|
      next if (td.attributes["class"].nil?) || (td.attributes["class"].value != "nm")
      route_stations << td.text
      break if td.text == to_st
    end
    route_stations
  end

  def get_mechanize_res(from_st, to_st, route_st, gap_seconds)
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    search_page = agent.get 'http://www.jorudan.co.jp/norikae/'
    form = search_page.forms[0]

    target_time = (Time.now + gap_seconds)
    hour = target_time.hour.to_s
    min = target_time.min.to_s
    min1 = min.slice(0)
    min2 = min.slice(1)

    form.field_with(:name=>'eki1').value = from_st
    form.field_with(:name=>'eki2').value = to_st
    form.field_with(:name=>'eki3').value = route_st
    form.field_with(:name=>'Dhh').value = hour
    form.field_with(:name=>'Dmn1').value = min1
    form.field_with(:name=>'Dmn2').value = min2
    form.click_button
  end

  def parse_to_routes(mechanize_res)
    routes = []
    mechanize_res.search("tr").each do |tr|
      tds = tr.search("td")
      if(tds.count != 6) then break end
      routes << Route.new(tds[0].text, tds[1].text, tds[2].text, tds[3].text, tds[4].text)
    end
    routes
  end

  def route_home
    r = routes_specific("六本木一丁目", "ひばりヶ丘（東京）", "小竹向原", 300)
    result = r[0].time
    r[-1].each do |station|
      result += ("," + station)
    end
    result
  end

end