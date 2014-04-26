load 'DropboxUtil.rb'
require 'fileutils'

class DropboxUploader
	def initialize(extname, archive_dir)
		@extname = extname
		@dropbox = DropboxUtil.new
		@archive_dir = archive_dir
	end

	def call
		Dir.new('./').each do |file|
			if(File.extname(file) == @extname)
				@dropbox.upload('/', './', file)
				FileUtils.mv(file, @archive_dir) if (Dir.exists? @archive_dir)
			end
		end
	end
end