require 'ruby2d'
require_relative 'union'
require_relative 'button'

class MoveForm 
	def initialize()	
		#@ncFile = Text.new(
		#	$temp[3].gsub(".txt", ".LST"),
		#	x: 5, y: 3 + $headerSize,
		#	size: 10,
		#	color: '#1c2a36',
		#	rotate: 0,
		#	z: 10
		#)
		
		#@frame1 = Rectangle.new(
		#	x: -$leftBorder, y: 0,
		#	width: $leftBorder, height: $maxy + 50 + $headerSize,
		#	color: '#f1f1f1',
		#	z: 9
		#)
		
		@boxTitle = Text.new(
			"Move",
			x: -$leftBorder + $leftBorder/2 - 10, y: 2 + $headerSize,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20
		)
		
		@xPosTitle = Text.new(
			"X Position",
			x: -$leftBorder + $leftBorder/2 - 10, y: 30 + $headerSize,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20
		)
		
		@yPosTitle = Text.new(
			"Y Position",
			x: -$leftBorder + $leftBorder/2 - 10, y: 70 + $headerSize,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20
		)
		
		@radTitle = Text.new(
			"Radius",
			x: -$leftBorder + $leftBorder/2 - 10, y: 110 + $headerSize,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20
		)
		
		@confirm = Button.new(-$leftBorder + $leftBorder/2 - 10, 150 + $headerSize, 50, 20, "Confirm", 10, 3, 3, 10)
		#
		#@button = Union.new([@border1, @border2, @frame1, @frame2, @frame4, @warningOutline, @warningInternal])
	end
	
	def contains(x_position,y_position)
		if @confirm.contains?(x_position,y_position)
			return 1
		end 
		return 0
	end
	
	def setActive(num)
		if num == 1 
			@confirm.setActive()
		else 
			@confirm.notActive()
		end
	end
	
	def toggleLeftPanel()
		if @boxTitle.x == $leftBorder/2 - 15
			@xPosTitle.x = -$leftBorder
			@yPosTitle.x = -$leftBorder
			@radTitle.x = -$leftBorder
			@boxTitle.remove
			@boxTitle = Text.new(
				"Move",
				x: -$leftBorder, y: 2 + $headerSize,
				size: 10,
				color: '#1c2a36',
				rotate: 0,
				z: 20
			)
			@confirm.move(-$leftBorder)
		else 
			@boxTitle.x = 0  + $leftBorder/2 - 15
			@xPosTitle.x = 0  + $leftBorder/2 - 25
			@yPosTitle.x = 0  + $leftBorder/2 - 25
			@radTitle.x = 0  + $leftBorder/2 - 18
			@confirm.move($leftBorder/2 - 25)
		end
	end
	
	def setText(txt) 
		@boxTitle.remove
		@boxTitle = Text.new(
			"Move " + txt,
			x: $leftBorder/2 - 15, y: 2 + $headerSize,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20
		)
	end
	
end