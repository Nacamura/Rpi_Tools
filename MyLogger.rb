require 'logger'

module MyLogger
	@@logger
	def get_logger
		@@logger ||= Logger.new('info.log')
	end
end