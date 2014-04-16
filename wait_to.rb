start_time = ARGV[0]

until(start_time == Time.now.strftime("%H%M"))
	sleep 1
end