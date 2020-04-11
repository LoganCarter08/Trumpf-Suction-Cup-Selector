require 'ruby2d'
require_relative 'union'

class TextBox
	def initialize(x,y,l,w,text,size,offx,offy, z)
		@Outline = Rectangle.new(
			x: x, y: y,
			width: l, height: w,
			color: '#c0c0c0',
			z: z
		)
		
		@Main = Rectangle.new(
			x: x + 2, y: y + 2,
			width: l - 4, height: w - 4,
			color: 'white',
			z: z + 1
		)
		
		@text = Text.new(
			text,
			x: x + offx, y: y + offy,
			size: size,
			color: 'black',
			rotate: 0,
			z: z + 2
		)
		
		@button = Union.new([@Outline, @Main, @text])
		@active = false
	end
	
	def contains?(x_position,y_position)
		# return @button.contains?(x_position,y_position)
		if (x_position > @Outline.x) && (x_position < @Outline.x + @Outline.width) && (y_position > @Outline.y) && (y_position < @Outline.y + @Outline.height) 
			@active = true
			return true
		else 
			@active = false
			return false
		end
	end
	
	def updateText(chr, force)
		if (@active) || (force) 
			currentText = @text.text
			if force 
				currentText = chr
			elsif chr.eql?("backspace")
				currentText = currentText[0...-1]
			elsif chr.scan(/\D/).empty? || (chr.eql?(".") && currentText.scan(/\D/).empty?)
				currentText = currentText + chr
			end
			x = @text.x 
			y = @text.y
			size = @text.size
			z = @text.z
			@text.remove
			@text = Text.new(
				currentText,
				x: x, y: y,
				size: size,
				color: 'black',
				rotate: 0,
				z: z
			)
		end
	end
	
	def clearText()
		x = @text.x 
		y = @text.y
		size = @text.size
		z = @text.z
		@text.remove
		@text = Text.new(
			"",
			x: x, y: y,
			size: size,
			color: 'black',
			rotate: 0,
			z: z
		)
	end
	
	def notActive() 
		@Main.color = 'white'
		@Outline.color = '#c0c0c0'
		@active = false
	end
	
	def setActive() 
		@Main.color = 'white'
		@Outline.color = '#3090dc'
		@active = true
	end
	
	def move(x)
		@button.shift(x)
		@text.remove
		y = @text.y
		size = @text.size
		z = @text.z
		@text = Text.new(
			'',
			x: x + 5, y: y,
			size: size,
			color: 'black',
			rotate: 0,
			z: z
		)
		@text.remove
		notActive()
	end
	
	def remove()
		@Outline.remove
		@Main.remove
		@text.remove
	end
	
	def getText()
		return @text.text
	end
	
end