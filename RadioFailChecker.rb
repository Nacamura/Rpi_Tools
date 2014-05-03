load 'MyGmail.rb'

class RadioFailChecker	
	PATH = '/tmp/'

	def call
		Dir.foreach(PATH) do |file|
			filepath = PATH + file
			if (FileTest.size(filepath) == 0)
				MyGmail.new.send('RadioAlert', '/tmp/に0バイトのファイルがあります')
			end
		end
  end
  
end