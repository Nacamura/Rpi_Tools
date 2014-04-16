require 'logger'

module MyLogger
	@@logger
	def get_logger
		@@logger ||= Logger.new('log.txt')
	end
end