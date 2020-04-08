require 'ruby2d'
require_relative 'union'

class Frame 
	def initialize()
		@border1 = Rectangle.new(
			x: 0, y: $headerSize,
			width: $maxx + $leftBorder * 2, height: 1,
			color: 'black',
			z: 10
		)
		
		@border2 = Rectangle.new(
			x: 0, y: $maxy + $headerSize,
			width: $maxx + $leftBorder * 2, height: 1,
			color: 'black',
			z: 10
		)
		
		#@ncFile = Text.new(
		#	$temp[3].gsub(".txt", ".LST"),
		#	x: 5, y: 3 + $headerSize,
		#	size: 10,
		#	color: '#1c2a36',
		#	rotate: 0,
		#	z: 10
		#)
		
		@frame1 = Rectangle.new(
			x: -$leftBorder, y: 0,
			width: $leftBorder, height: $maxy + 50 + $headerSize,
			color: '#f1f1f1',
			z: 9
		)
		
		@frame2 = Rectangle.new(
			x: 0, y: 0,
			width: $maxx + $leftBorder * 2, height: $headerSize,
			color: '#f1f1f1',
			z: 9
		)
		
		#@frame3 = Rectangle.new(
		#	x: $leftBorder + $maxx, y: 0,
		#	width: $leftBorder, height: $maxy + 50 + $headerSize,
		#	color: '#f1f1f1',
		#	z: 9
		#)
		
		@frame4 = Rectangle.new(
			x: 0, y: $headerSize + $maxy,
			width: $maxx + 50 + $headerSize, height: 50 + $headerSize,
			color: '#f1f1f1',
			z: 9
		)
		
		@warningOutline = Triangle.new(
			x1: 25,  y1: $headerSize + $maxy + 10, #top point
			x2: 10, y2: $headerSize + $maxy + 40, # bottom left 
			x3: 40,   y3: $headerSize + $maxy + 40, # bottom right
			color: 'orange',
			z: 19,
			opacity: 0
		)
		
		@warningInternal = Triangle.new(
			x1: 25,  y1: $headerSize + $maxy + 13, #top point
			x2: 12, y2: $headerSize + $maxy + 39, # bottom left 
			x3: 38,   y3: $headerSize + $maxy + 39, # bottom right
			color: 'yellow',
			z: 20,
			opacity: 0
		)
		
		@warning = Text.new(
			" ",
			x: 42, y: $headerSize + $maxy + 26,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20,
			opacity: 0
		)
		
		@button = Union.new([@border1, @border2, @frame1, @frame2, @frame4, @warningOutline, @warningInternal])
	end
	
	def contains?(x_position,y_position)
		# return @button.contains?(x_position,y_position)
		if (x_position > $maxx - 420 + $leftBorder * 2) && (x_position < $maxx - 420 + $leftBorder * 2 + 150) && (y_position > $maxy + 10 + $headerSize) && (y_position < $maxy + 10 + $headerSize + 30) 
			return true
		else 
			return false
		end
	end
	
	def warning(booly, error) 
		if booly 
			@warningOutline.opacity = 100
			@warningInternal.opacity = 100
			
			@warning.remove
			@warning = Text.new(
				error,
				x: 42, y: $headerSize + $maxy + 22,
				size: 10,
				color: '#1c2a36',
				rotate: 0,
				z: 20,
			)
		else 
			@warningOutline.opacity = 0
			@warningInternal.opacity = 0
			
			@warning.remove
			@warning = Text.new(
				" ",
				x: 42, y: $headerSize + $maxy + 22,
				size: 10,
				color: '#1c2a36',
				rotate: 0,
				z: 0,
			)
		end 
	end
	
	def toggleLeftPanel()
		if @frame1.x ==	0 
			@frame1.x = -$leftBorder
		else 
			@frame1.x = 0
		end
	end
	
end