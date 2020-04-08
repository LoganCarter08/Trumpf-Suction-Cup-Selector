require 'ruby2d'
require_relative 'union'
require_relative 'button'
require_relative 'headerButton'
require_relative 'frame'
require_relative 'moveForm'
require 'fileutils'


$sizex = 0
$sizey = 0
$cupFile = " "
$lst = String.new
$multiplier = 4
$headerSize = 60
$leftBorder = 90
$moveCup = false 
$xMovement = 0
$yMovement = 0
$movement = false
$moveOriginX = 0
$scaleRate = 0.5
$xOrig = 0
$yOrig = 0

#File.open("CustomCups.txt", "r") do |f|
#	f.each_line do |line|
#		if (line.include? "Sheet X: ")
#			$sizex = line.split(':')[1].to_i * 4
#		elsif (line.include? "Sheet Y: ")
#			$sizey = line.split(':')[1].to_i * 4
#		elsif (line.include? "Cup File: ")
#			$cupFile = line.split(': ')[1]
#		elsif (line.include? "LST: ")
#			$lst = line.split(': ')[1].strip
#		elsif (line.include? "Units: ")
#			unit = line.split(': ')[1].to_i
#			if unit == 0 
#				$multiplier = 1/25.4
#			end
#		end
#	end
#end

if ARGV.length == 0 
	$temp = "TRUMPF_TruLaser_XXXX_S_Cups.txt;60;60;13.txt;2"
	#exit(0)
else 
	$temp = ARGV[0]
end
$temp = $temp.split(';')
$cupFile = $temp[0]
$sizex = $temp[1].to_i
$sizey = $temp[2].to_i
# line.gsub("XXXXXXXXX", hex)
$lst = $cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Temp Files\\" + $temp[3] 
units = $temp[4].to_i

if units == 1 
	$multiplier = 4/25.4
end



$sizex = $sizex * $multiplier
$sizey = $sizey * $multiplier

set background: '#f1f1f1' #'#022952'
set width: 1066
set height: 600
set title: "Cup Selector - " + $temp[3].gsub(".txt", ".LST")

# Need to do external (border) of color #3e91c3
# Internal of sheet should be color #5679bb

$sheetInt = Rectangle.new(
    x: 2 + $leftBorder + $xMovement, y: 2 + $headerSize,
    width: $sizex-4, height: $sizey-4,
    color: '#5679bb',
    z:3
)

$sheetExt = Rectangle.new(
    x: 0 + $leftBorder + $xMovement, y: $headerSize,
    width: $sizex, height: $sizey,
    color: '#3e91c3',
    z:2
)

cup = Union.new([$sheetInt, $sheetExt])

def insideSheet(cup1)
	begin # non union, used while building cups
		if (cup1.x - cup1.radius > $sheetExt.x) && (cup1.x + cup1.radius < $sheetExt.x + $sheetExt.width) && (cup1.y - cup1.radius > $sheetExt.y) && (cup1.y + cup1.radius < $sheetExt.y + $sheetExt.height) 
			return true
		else 
			return false
		end
	rescue
		return cup1.inSheet()
	end
end

$cupList = Array.new
$colorList = Array.new
$testList = Array.new
$i = 0
$j = 0
$maxx = 0
$maxy = 0


File.open($cupFile.strip, "r") do |f|
  f.each_line do |line|
    #puts line
	temp = line.split(';')
	if (!line.include? "//")
			$j = $j + 1
		subcupList = Array.new
		$i = 0
		$num = temp.length() / 3
		color = 1
		while $i < $num do 
			x = temp[0 + $i * 3].to_i / 25.4 * 4 + $leftBorder
			y = temp[1 + $i * 3].to_i / 25.4 * 4 + $headerSize
			rad = temp[2 + $i * 3].to_i / 25.4 / 2 * 4
			if (!line.include? "X")
				cup = Circle.new(
					x: x, y: y,
					radius: rad,
					sectors: 60,
					color: 'red',
					z: 4
				)
				if x + rad > $maxx 
					$maxx = x + rad + 30
				end 
				if y + rad > $maxy
					$maxy = y + rad
				end 
				txt = Text.new(
					$j,
					x: x + rad + 2, y: y - rad/2,
					size: 15,
					color: '#e1e1e1',
					rotate: 0,
					z: 4
				)
			else 
				x = -40
				y = -40
				rad = 1
				cup = Circle.new(
					x: x, y: y,
					radius: rad,
					sectors: 60,
					color: '#37adad',
					z: 4
				)
				txt = Text.new(
					$j,
					x: x, y: y,
					size: 15,
					color: '#e1e1e1',
					rotate: 0,
					z: 4
				)
				color = 0
			end
			
			if (!insideSheet(cup)) || (color == 0)
				color = 0
			end
			 
			$i += 1
			subcupList.push(cup)
			subcupList.push(txt)
		end
		cup = Union.new(subcupList)
		if (color == 0) || (line.include? "X")
			$colorList.push(0)
			cup.setColor('blue')
		else 
			$colorList.push(1)
		end
		$cupList.push(cup)
	end
  end 
end

def moveScreen(x, y, doMove) 
	if ($movement) || (doMove) 
		$xMovement = x - $xOrig
		$yMovement = y - $yOrig
		$sheetInt.x = $sheetInt.x + $xMovement 
		$sheetExt.x = $sheetExt.x + $xMovement 
		
		$sheetInt.y = $sheetInt.y + $yMovement 
		$sheetExt.y = $sheetExt.y + $yMovement 
		
		i = 0
		num = $cupList.length()
		while i < num  do
			$cupList[i].totalMove($xMovement, $yMovement)
			i +=1
		end
		
		$xOrig = x
		$yOrig = y
		
	end 
end

set width: $maxx + $leftBorder * 2
set height: $maxy + 50 + $headerSize


blueBack = Rectangle.new(
    x: 0 , y: $headerSize,
    width: $maxx + $leftBorder * 2, height: $maxy,
    color: '#022952',
    z:1
)


# Union.new([$sheetInt, $sheetExt])
# button outline: #c0c0c0
# button main: #e1e1e1
# text: #1c2a36 or maybe black
# check box: #008000

save = Button.new($maxx - 125 + $leftBorder * 2, $maxy + 10 + $headerSize, 115, 30, "OK", 15, 47, 7) #SaveButton.new()
cancel = Button.new($maxx - 255 + $leftBorder * 2, $maxy + 10 + $headerSize, 115, 30, "Cancel", 15, 35, 7) #CancelButton.new()
setAsDefault = Button.new($maxx - 420 + $leftBorder * 2, $maxy + 10 + $headerSize, 150, 30, "Set as Default", 15, 32, 7)#SetAsDefaultButton.new()
move = HeaderButton.new(180, 5, 50, $headerSize - 10, "Move", 7, $headerSize - 30)
moveForm = MoveForm.new()
frame = Frame.new()
moveScreen(-$leftBorder, 0, true)


def checkErrors(frame)
	found = true
	lines = IO.readlines($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt").map do |line|
		temp = line.split(";")
		if (temp[0].to_i == $sizex / $multiplier) && (temp[1].to_i == $sizey / $multiplier)
			found = false
		end
	end
	
	frame.warning(found, "No default cup pattern found for this sheet size")
end

checkErrors(frame)


$cupOutline = Circle.new(
	x: 0, y: 0,
	radius: 0,
	sectors: 90,
	color: 'white',
	z: 3,
	opacity: 0
)


def getHexValue()
	binList = String.new
	i = 0
	num = $colorList.length()
	while i < num  do
		if $colorList[i] == 1
			binList = binList + "1"
		else 
			binList = binList + "0"
		end
		i = i + 1
	end
	
	while binList.length % 4 != 0
		binList = binList + "0"
	end
	
	tempBinList = String.new
	
	j = binList.length - 1
	k = 0
	while j > -1 do 
		tempBinList[k] = binList[j]
		j = j -1
		k = k+1
	end
	
	binList = tempBinList
	
	binGroup = Array.new 
	i = 0
	while i < binList.length / 4 do
		binGroup.push(binList[i + i * 3] + binList[i + i * 3 + 1] + binList[i + i * 3 + 2] + binList[i + i * 3 + 3])
		i = i + 1
	end
	
	#print "\n"
	#i = 0
	#while i < binList.length do 
	#	print binList[i]
	#	i = i + 1
	#end
	hex = String.new
	i = 0
	while i < binGroup.length()
		#print binGroup[i] + " "
		j = 0
		sum = 0
		while j < 4 do 
			sum = sum + ((binGroup[i][j]).to_i * 2 ** (4 - j - 1));
			j = j + 1
		end
		#print sum.to_s(16).capitalize() + " "
		hex = hex + sum.to_s(16).capitalize()
		i = i + 1
	end
	while hex.length % 9 != 0 do
		hex = "0" + hex
	end
	return hex
end


def writeTolst(hex) 
	FileUtils.mkdir_p $cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Temp Files\\"
	
	File.open($lst, 'w') do |file|
		file.puts getHexValue()
	end
end 

def writeDefaults(hex)
	FileUtils.mkdir_p $cupFile.gsub("_Cups.txt", "") + " Suction Cups\\"
	found = false
	
	file = File.open($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt", "a+")
	file.close
	
	lines = IO.readlines($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt").map do |line|
		temp = line.split(";")
		if (temp[0].to_i == $sizex / $multiplier) && (temp[1].to_i == $sizey / $multiplier)
			found = true 
			line.gsub(line, ($sizex / $multiplier).to_s + ";" + ($sizey / $multiplier).to_s + ";" + hex + ";" + $colorList.to_s)
		end
	end
	
	if found
		File.open($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt", 'w') do |file|
			file.puts lines
		end
	else 
		File.open($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt", 'a') { |f|
			f.puts ($sizex / $multiplier).to_s + ";" + ($sizey / $multiplier).to_s + ";" + hex + ";" + $colorList.to_s
		}
	end
end

def findActiveCups()
	i = 0
	num = $cupList.length()
	while i < num  do
		if insideSheet($cupList[i])
			$cupList[i].setColor('red')
			$colorList[i] = 1
		else 
			$cupList[i].setColor('blue')
			$colorList[i] = 0
		end
		i += 1
	end
end

def confirmCupMove()
	# following section is used on move confirm command 
	if $cupList[i].move(50,50,10,event.x,event.y) 
		$cupList[i].setColor('red')
		$colorList[i] = 1
	else 
		$cupList[i].setColor('blue')
		$colorList[i] = 0
	end
	$cupOutline.opacity = 0
end




on :mouse_down do |event|
	case event.button
	when :left
		i = 0
		num = $cupList.length()
		error = false
		while i < num  do
			if $cupList[i].contains?(event.x, event.y)
				if !$moveCup
					if $colorList[i] == 1
						$cupList[i].setColor('blue')
						$colorList[i] = 0
					else
						$cupList[i].setColor('red')
						$colorList[i] = 1
					end
				else 
					$selectedCup = $cupList[i] 
					moveForm.setText($selectedCup.getText())
				end
			end
			#
			# Produce error if cup is off sheet 
			#
			if (!$cupList[i].inSheet()) && ($colorList[i] == 1) # active, but not on sheet 
				error = true;
			end
			i +=1
		end
		frame.warning(error, "Cup or cup in a group is active, but not on sheet.")
	if save.contains?(event.x, event.y)
		if ARGV.length != 0 
			writeTolst(getHexValue())
		end
		exit(0)
	elsif setAsDefault.contains?(event.x, event.y)
		# if $moveCup 
		# 	$moveCup = false 
		# else 
		# 	$moveCup = true
		# end
		writeDefaults(getHexValue())
		checkErrors(frame)
	elsif cancel.contains?(event.x, event.y)
		exit(0)
	elsif move.contains?(event.x, event.y)
		tempXOrig = $xOrig
		tempYOrig = $yOrig
		$xOrig = 0
		$yOrig = 0
		if !$moveCup 
			moveScreen($leftBorder, 0, true)
		else 
			moveScreen(-$leftBorder, 0, true)
		end
		frame.toggleLeftPanel()
		moveForm.toggleLeftPanel()
		$moveCup = !$moveCup
		$xOrig = tempXOrig
		$yOrig = tempYOrig
	end
	
	when :middle
		# Middle mouse button pressed down
		$movement = true
		$xOrig = event.x
		$yOrig = event.y
	when :right
		# Right mouse button pressed down
	end
	
end

on :mouse_move do |event| 
	moveScreen(Window.mouse_x, Window.mouse_y, false)
	
	
	if save.contains?(event.x, event.y) 
		save.setActive()
	elsif setAsDefault.contains?(event.x, event.y)
		setAsDefault.setActive()
	elsif cancel.contains?(event.x, event.y)
		cancel.setActive()
	elsif move.contains?(event.x, event.y) 
		move.setActive()
	else
		moveForm.setActive(moveForm.contains(event.x, event.y))
		save.notActive()
		cancel.notActive()
		setAsDefault.notActive()
		move.notActive()
		
		i = 0
		num = $cupList.length()
		while i < num  do
			if $cupList[i].contains?(event.x, event.y)
				cuppy = $cupList[i].getOverlap(event.x,event.y)
				if cuppy != nil
					$cupOutline.x = $cupList[i].getOverlap(event.x,event.y).x
					$cupOutline.y = $cupList[i].getOverlap(event.x,event.y).y
					$cupOutline.radius = $cupList[i].getOverlap(event.x,event.y).radius + 1
					$cupOutline.opacity = 100
					break
				end
			else 
				$cupOutline.opacity = 0
			end
			i +=1
		end
	end 
end 


		
on :mouse_up do |event|

  # Read the button event
  case event.button
  when :left
    # Left mouse button released
  when :middle
    $movement = false
	# findActiveCups() used when move sheet option is added
  when :right
    # Right mouse button released
  end
end

on :mouse_scroll do |event|
  # Change in the x and y coordinates
  # find center of all things, 
  # pos = part - center * scale + center 
	#puts event.delta_y
	#if !$movement 
	#	$averageX = 0
	#	$averageY = 0
	#	itemCount = 0
	#	i = 0
	#	num = $cupList.length()
	#	while i < num  do
	#		$cupList[i].averages()
	#		itemCount = itemCount + $cupList[i].length()
	#		i +=1
	#	end
	#	$averageX = $averageX + $sheetExt.x
	#	$averageY = $averageY + $sheetExt.y
	#	itemCount = itemCount + 2
	#	
	#	$averageX = $averageX / itemCount
	#	$averageY = $averageY / itemCount
	#	
	#	i = 0
	#	num = $cupList.length()
	#	while i < num  do
	#		$cupList[i].resize(event.delta_y) #= $cupList[i].radius + 0.1 * event.delta_y
	#		i +=1
	#	end
	#	
	#	$sheetExt.width = $sheetExt.width * $scaleRate * event.delta_y
	#	$sheetExt.height = $sheetExt.height * $scaleRate * event.delta_y
	#	$sheetExt.x = $sheetExt.x - $scaleRate * event.delta_y
	#	$sheetExt.y = $sheetExt.x - $scaleRate * event.delta_y
	#	
	#	$sheetInt.width = $sheetInt.width * $scaleRate * event.delta_y
	#	$sheetInt.height = $sheetInt.height * $scaleRate * event.delta_y
	#	$sheetInt.x = $sheetInt.x - $averageX * $scaleRate * event.delta_y + $averageX
	#	$sheetInt.y = $sheetInt.y - $averageY * $scaleRate * event.delta_y + $averageY
	#end
end

show