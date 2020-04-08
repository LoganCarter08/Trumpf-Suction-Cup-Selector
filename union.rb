class Union
  # A class that behaves like the mathematical union

  # @param sets [array] An array of shapes
  def initialize(sets)
    @sets = sets
  end

  # @param x_position [int] An x coordinate on the screen
  # @param y_position [int] An y coordinate on the screen
  # @return [bool] True if one of the shapes in sets contains the position
  def contains?(x_position,y_position)
    @sets.each do |set|
		begin
			set.radius = set.radius
			if set.contains?(x_position,y_position)
				return true
		end
		rescue 
		end
    end
		return false
  end
  
  def getOverlap(x,y) 
	@sets.each do |set|
      if set.contains?(x,y)
		begin 
			set.radius = set.radius
			return set
		rescue 
		end
      end
    end
	return nil
  end
  
  def setColor(col)
	@sets.each do |set| 
		begin 
			set.text = set.text
		rescue
			set.color = col
		end
	end
  end
  
  def getText() 
	@sets.each do |set|
		begin 
			return set.text
		rescue 
		end
	end
  end
  
  def inSheet() 
	count = 0
	for i in 0..@sets.length() - 1
	
		begin 
			if (@sets[i].x - @sets[i].radius > $sheetExt.x) && (@sets[i].x + @sets[i].radius < $sheetExt.x + $sheetExt.width) && (@sets[i].y - @sets[i].radius > $sheetExt.y) && (@sets[i].y + @sets[i].radius < $sheetExt.y + $sheetExt.height) 
				count += 1
			end 
		rescue 
			
		end
	end
	if count == @sets.length() / 2
		return true
	end
	return false
  end
  
  
  def move(x,y,rad,xPos,yPos)
	for i in 0..@sets.length() - 1
		if @sets[i].contains?(xPos,yPos)

			@sets[i].x = x * 4 + $sheetExt.x
			@sets[i].y = y * 4 + $sheetExt.y
			begin 
				@sets[i].radius = rad 
			rescue 
			end
			begin
				@sets[i + 1].x = x * 4 + rad + 2 + $sheetExt.x
				@sets[i + 1].y = y * 4 - rad + $sheetExt.y
			rescue 
			end
		end
	end
	return inSheet()
  end
  
  def totalMove(x,y)
	for i in 0..@sets.length() - 1
		@sets[i].x = @sets[i].x + $xMovement
		@sets[i].y = @sets[i].y + $yMovement
	end
  end

  def resize(scale) 
	newOffset = 0
	oldRad = 0
	for i in 0..@sets.length() - 1
		begin 
			oldRad = @sets[i].radius
			@sets[i].radius = @sets[i].radius - $scaleRate * scale
			newOffset = @sets[i].radius - oldRad
		rescue 
			text = @sets[i].text
			x = @sets[i].x + newOffset
			y = @sets[i].y
			size = @sets[i].size
			# color: '#e1e1e1',
			# z: 4
			@sets[i].remove
			@sets[i] = Text.new(
				text,
				x: x, y: y,
				size: size - $scaleRate * scale,
				color: '#e1e1e1',
				rotate: 0,
				z: 4
			)
			
			
		end
	end
  end
  
  def averages()
	for i in 0..@sets.length() - 1
		$averageX = $averageX + @sets[i].x
		$averageY = $averageY + @sets[i].y
	end
  end
  
  def length()
	return @sets.length()
  end
  
  def shift(x) # only to be used with moveForm
	@sets[0].x = x 
	@sets[1].x = x + 2
	@sets[2].x = x + 7
  end
  
end