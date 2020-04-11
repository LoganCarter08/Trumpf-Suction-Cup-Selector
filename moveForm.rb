require 'ruby2d'
require_relative 'union'
require_relative 'button'
require_relative 'textBox'

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
		
		@xBox = TextBox.new(-$leftBorder + $leftBorder/2 - 100, 45 + $headerSize, 60, 18,"", 10, 3, 3, 20)
		
		@yPosTitle = Text.new(
			"Y Position",
			x: -$leftBorder + $leftBorder/2 - 10, y: 70 + $headerSize,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20
		)
		
		@yBox = TextBox.new(-$leftBorder + $leftBorder/2 - 100, 85 + $headerSize, 60, 18,"", 10, 3, 3, 20)
		
		@radTitle = Text.new(
			"Radius",
			x: -$leftBorder + $leftBorder/2 - 10, y: 110 + $headerSize,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20
		)
		
		@radBox = TextBox.new(-$leftBorder + $leftBorder/2 - 100, 125 + $headerSize, 60, 18,"", 10, 3, 3, 20)
		
		@confirm = Button.new(-$leftBorder + $leftBorder/2 - 10, 160 + $headerSize, 50, 20, "Confirm", 10, 3, 3, 10)
		#
		#@button = Union.new([@border1, @border2, @frame1, @frame2, @frame4, @warningOutline, @warningInternal])
	end
	
	def containsMove(x_position,y_position)
		if @confirm.contains?(x_position,y_position)
			return 1
		else 
			return 0
		end
	end
	
	def containsClick(x_position,y_position)
		if @confirm.contains?(x_position,y_position)
			return 1
		elsif @xBox.contains?(x_position, y_position)
			return 2
		elsif @yBox.contains?(x_position, y_position)
			return 3
		elsif @radBox.contains?(x_position, y_position)
			return 4
		else
			return 0
		end
	end
	
	def setActiveMove(num)
		if num == 1
			@confirm.setActive()
		end
	end
	
	def setActive(num)
		if num == 1 
			@confirm.setActive()
		elsif num == 2 
			@xBox.setActive()
			@confirm.notActive()
			@yBox.notActive()
			@radBox.notActive()
		elsif num == 3
			@yBox.setActive()
			@confirm.notActive()
			@xBox.notActive()
			@radBox.notActive()
		elsif num == 4
			@radBox.setActive()
			@confirm.notActive()
			@xBox.notActive()
			@yBox.notActive()
		end
	end
	
	def toggleLeftPanel()
		$selectedCup = -1
		if @boxTitle.x == $leftBorder/2 - 15
			@xPosTitle.x = -$leftBorder
			@xBox.move(-$leftBorder)
			@yBox.move(-$leftBorder)
			@radBox.move(-$leftBorder)
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
			@xBox.move($leftBorder/2 - 30)
			@yBox.move($leftBorder/2 - 30)
			@radBox.move($leftBorder/2 - 30)
			@yPosTitle.x = 0  + $leftBorder/2 - 25
			@radTitle.x = 0  + $leftBorder/2 - 18
			@confirm.move($leftBorder/2 - 25)
		end
	end
	
	def setText(txt) 
		@xBox.updateText(txt[0].to_s, true)
		@yBox.updateText(txt[1].to_s, true)
		@radBox.updateText(txt[2].to_s, true)
		@boxTitle.remove
		@boxTitle = Text.new(
			"Move " + txt[3],
			x: $leftBorder/2 - 15, y: 2 + $headerSize,
			size: 10,
			color: '#1c2a36',
			rotate: 0,
			z: 20
		)
	end
	
	def keyPress(key)
		@xBox.updateText(key, false)
		@yBox.updateText(key, false)
		@radBox.updateText(key, false)
	end
	
	def getInput()
		return [@xBox.getText(), @yBox.getText(), @radBox.getText()]
	end
	
	def reset()
		setText(["","","",""])
		@xBox.clearText()
		@yBox.clearText()
		@radBox.clearText()
	end
	
end