require 'ruby2d'
require_relative 'union'
require 'net/http'
require 'uri'
require "fileutils"

class Updater
	def initialize(firstStart)
		if !firstStart 
			version = $version.split('.')
			vers = version[0].to_i * 1000 + version[1].to_i * 100 + version[2].to_i* 10 + version[3].to_i # essentially hash this to get a unique integer for version
			@frame = Rectangle.new(
				x: ($maxx + $leftBorder * 2) / 2 - 151, y: ($maxy + 50 + $headerSize) / 2 - 51,
				width: 302, height: 102,
				color: 'black',
				z: 30
			)
			
			@box = Rectangle.new(
				x: ($maxx + $leftBorder * 2) / 2 - 150, y: ($maxy + 50 + $headerSize) / 2 - 50,
				width: 300, height: 100,
				color: '#f1f1f1',
				z: 30
			)
			
			@text = Text.new(
				'An update is available. Would you like to update now?',
				x: ($maxx + $leftBorder * 2) / 2 - 132 , y: ($maxy + 50 + $headerSize) / 2 - 5,
				size: 10,
				color: '#1c2a36',
				rotate: 0,
				z: 31
			)
			
			@confirm = Button.new(@box.x + 230, @box.y + 75, 60, 20, "OK", 10, 22, 4, 31)
			@cancel = Button.new(@box.x + 160, @box.y + 75, 60, 20, "Cancel", 10, 15, 4, 31)
			#set width: $maxx + $leftBorder * 2
			#set height: $maxy + 50 + $headerSize
		
			checkIfUpdate(vers)
		end
	end
	
	def hide(pos)
		#if pos 
		#	# move off screen
		#	@frame.remove
		#	@box.remove
		#	@confirm.remove()
		#	@cancel.remove()
		#	@text.remove
		#	$menuActive = false
		#else 
			# move on screen
			$menuActive = true
		#end
		
	end
	
	def clicked(x, y) 
		if contains(x,y) == 1
			initUpdate()
		elsif contains(x, y) == 2
			#hide(true)
			exit(0)
		end
	end
	
	def contains(x_position,y_position)
		if @confirm.contains?(x_position,y_position)
			return 1
		elsif @cancel.contains?(x_position,y_position)
			return 2
		else 
			return -1
		end
	end
	
	def setActive(num)
		if num == 1 
			@confirm.setActive()
			@cancel.notActive()
		elsif num == 2
			@cancel.setActive()
			@confirm.notActive()
		else 
			@confirm.notActive()
			@cancel.notActive()
		end
	end
	
	def open(url)
		Net::HTTP.get(URI.parse(url))
	end
	
	def checkIfUpdate(num) 
		begin
			if File.exists?('updater.exe') 
				@page_content = open('http://info.sigmatek.net/downloads/TrumpfCups/version.txt')
				remoteVersion = @page_content.split('.')
				remoteVersionNum = remoteVersion[0].to_i * 1000 + remoteVersion[1].to_i * 100 + remoteVersion[2].to_i * 10 + remoteVersion[3].to_i
				hide(num == remoteVersionNum)
			else 
				hide(true)
			end
		rescue 
			hide(true)
		end
	end
	
	def initUpdate()
		#createInstaller()
		system("start \"\" \"updater.exe\" \"" + $params + "\" " + @page_content + "\"")
		exit(0)
	end
	
	
	
	
	
	
	def createInstaller()
		#File.open('installer.exe', 'w') do |file|
		#	file.print ''
		#end
		
		#Net::HTTP.start("https://github.com") do |http|
		#	resp = http.get("/LoganCarter08/Trumpf-Suction-Cup-Selector/releases/download/InstallerV1/installer.exe")
		#	open("installer.exe", "wb") do |file|
		#		file.write(resp.body)
		#	end
		#end
		
	end
end