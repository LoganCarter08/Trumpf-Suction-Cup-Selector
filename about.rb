require 'ruby2d'
require_relative 'union'

class About
	def initialize()
		
		
		@frame = Rectangle.new(
			x: ($maxx + $leftBorder * 2) / 2 - 151, y: ($maxy + 50 + $headerSize) / 2 - 101,
			width: 302, height: 202,
			color: 'black',
			z: 30
		)
		
		@box = Rectangle.new(
			x: ($maxx + $leftBorder * 2) / 2 - 150, y: ($maxy + 50 + $headerSize) / 2 - 100,
			width: 300, height: 200,
			color: '#f1f1f1',
			z: 30
		)
		
		@text = Text.new(
			'This program is a product of SigmaNEST MTG department.',
			x: ($maxx + $leftBorder * 2) / 2 - 132 , y: ($maxy + 50 + $headerSize) / 2 - 30,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 31
		)
		
		@text2 = Text.new(
			'For any feature requests or potential defects please',
			x: ($maxx + $leftBorder * 2) / 2 - 132 , y: ($maxy + 50 + $headerSize) / 2 - 20,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 31
		)
		
		@text3 = Text.new(
			'contact SigmaNEST support or visit the help page.',
			x: ($maxx + $leftBorder * 2) / 2 - 132 , y: ($maxy + 50 + $headerSize) / 2 - 10,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 31
		)
		
		@text4 = Text.new(
			'Author: Logan Carter ',
			x: @box.x + 20 , y: @box.y + 185,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 31
		)
		
		@text5 = Text.new(
			'Version: ' + $version,
			x: @box.x + 20 , y: @box.y + 175,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 31
		)
		
		@confirm = Button.new(@box.x + 230, @box.y + 175, 60, 20, "OK", 10, 22, 4, 31)
		$menuActive = true
	end
	
	def hide(pos)
		if pos 
			# move off screen
			@frame.remove
			@box.remove
			@confirm.remove()
			@text.remove
			@text2.remove
			@text3.remove
			@text4.remove
			@text5.remove
			$menuActive = false
		else 
			# move on screen
			$menuActive = true
		end
		
	end
	
	def clicked(x, y) 
		if contains(x,y) == 1
			hide(true)
		end
	end
	
	def contains(x_position,y_position)
		if @confirm.contains?(x_position,y_position)
			return 1
		else 
			return -1
		end
	end
	
	def setActive(num)
		if num == 1 
			@confirm.setActive()
		else 
			@confirm.notActive()
		end
	end
	
end