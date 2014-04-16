load 'JorudanSearch.rb'

class TrainSearch
  include MyLogger

  @jorudan

  def route_home
    @jorudan ||= JorudanSearch.new
    @jorudan.route_home
  end

end