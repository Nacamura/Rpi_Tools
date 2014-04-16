load 'DropboxUtil.rb'
require 'fileutils'

class DropboxUploader
	def initialize(extname)
		@extname = extname
		@dropbox = DropboxUtil.new
	end

	def call
		Dir.new('./').each do |file|
			if(File.extname(file) == @extname)
				@dropbox.upload('/', './', file)
				FileUtils.mv(file, "archive")
			end
		end
	end
end