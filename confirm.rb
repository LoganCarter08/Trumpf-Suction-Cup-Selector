require 'ruby2d'
require_relative 'union'

class Confirm
	def initialize(words)
		
		
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
			words,
			x: ($maxx + $leftBorder * 2) / 2 - (words.length() + 70) , y: ($maxy + 50 + $headerSize) / 2 - 10,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 31
		)
	
		
		@confirm = Button.new(@box.x + 230, @box.y + 75, 60, 20, "OK", 10, 22, 4, 31)
		@cancel = Button.new(@box.x + 155, @box.y + 75, 60, 20, "Cancel", 10, 15, 4, 31)
		$menuActive = true
	end
	
	def hide(pos)
		if pos 
			# move off screen
			@frame.remove
			@box.remove
			@confirm.remove()
			@cancel.remove()
			@text.remove
			$menuActive = false
		else 
			# move on screen
			$menuActive = true
		end
		
	end
	
	def clicked(x, y) 
		if contains(x,y) == 1
			hide(true)
			return 1
		elsif contains(x,y) == 2
			hide(true)
			return 2
		end
	end
	
	def contains(x_position,y_position)
		if @confirm.contains?(x_position,y_position)
			return 1
		elsif @cancel.contains?(x_position, y_position)
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
			@confirm.notActive()
			@cancel.setActive()
		else 
			@confirm.notActive()
			@cancel.notActive()
		end
	end
	
end