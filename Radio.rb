class Radio
	def initialize(type, channel, duration, start_time, file_name)
		@type = type
		@channel = channel
		@duration = duration
		@start_time = start_time
		@file_name = file_name
	end

	def call
		running = `ps -ef |grep #{@file_name} |grep -v grep`
		return if running != ""
		shell = get_shell_name
		system("#{shell} #{@channel} #{@duration} #{@start_time} #{@file_name} &")
	end

	def get_shell_name
		case(@type)
		when "Radiko"
			"./rtmp/Radiko.sh"
		when "Rajiru"
			"./mplayer/Rajiru.sh"
		when "AandG"
			"./rtmp/AandG.sh"
		end
	end

	def self.temp_schedule(lines)
		params = lines.drop(2).map(&:strip)
		Radio.new(*params).call
	end
end