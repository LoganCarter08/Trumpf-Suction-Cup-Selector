require 'ruby2d'
require_relative 'union'

class Button 
	def initialize(x,y,l,w,text,size,offx,offy)
		@Outline = Rectangle.new(
			x: x, y: y,
			width: l, height: w,
			color: '#c0c0c0',
			z:10
		)
		
		@Main = Rectangle.new(
			x: x + 2, y: y + 2,
			width: l - 4, height: w - 4,
			color: '#e1e1e1',
			z:11
		)
		
		@text = Text.new(
			text,
			x: x + offx, y: y + offy,
			size: size,
			color: '#1c2a36',
			rotate: 0,
			z: 12
		)
		
		@button = Union.new([@Outline, @Main, @text])
	end
	
	def contains?(x_position,y_position)
		# return @button.contains?(x_position,y_position)
		if (x_position > @Outline.x) && (x_position < @Outline.x + @Outline.width) && (y_position > @Outline.y) && (y_position < @Outline.y + @Outline.height) 
			return true
		else 
			return false
		end
	end
	
	def notActive() 
		@Main.color = '#e1e1e1'
		@Outline.color = '#c0c0c0'
	end
	
	def setActive() 
		@Main.color = '#e5f1fb'
		@Outline.color = '#3090dc'
	end
	
	def move(x)
		@button.shift(x)
	end
end