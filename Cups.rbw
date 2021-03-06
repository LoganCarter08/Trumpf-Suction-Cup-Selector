require 'ruby2d'
require_relative 'union'
require_relative 'button'
require_relative 'headerButton'
require_relative 'frame'
require_relative 'moveForm'
require_relative 'updater'
require_relative 'about'
require_relative 'confirm'
require 'fileutils'
require 'win32ole'
require 'launchy'

$version = '0.4.15.20'


network=WIN32OLE.new("Wscript.Network")
tempPath = ".//"

me = Dir.open "C:\\Users\\" + network.username + "\\AppData\\Local\\Temp\\"
me.each do |file|
    if file.start_with?("ocr") 
		subFolder = Dir.open "C:\\Users\\" + network.username + "\\AppData\\Local\\Temp\\" + file
		subFolder.each do |fil| 
			if fil.start_with?("src")
				suby = Dir.open "C:\\Users\\" + network.username + "\\AppData\\Local\\Temp\\" + file + "\\src"
				suby.each do |fi|
					if fi.start_with?("Cups.rbw")
						tempPath = "C:\\Users\\" + network.username + "\\AppData\\Local\\Temp\\" + file + "\\src\\"
						break
					end
				end
			end
		end
	end
end


#pic = tempPath + "PartHandlerGUI.jpg"
#Image.new(
#  pic,
#  x: 400, y: 200,
#  width: 50, height: 25,
#  color: [1.0, 0.5, 0.2, 1.0],
#  rotate: 90,
#  z: 100
#)




$selectedCup = -1
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
$menuActive = false

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
	$temp = "TRUMPF_TruLaser_XXXX_S_Cups.txt;60;60; ;2"
	$params = $temp
	#exit(0)
else 
	$temp = ARGV[0]
	$params = ARGV[0]
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

def saveCupFile()
	newCupFile = Array.new 
	i = 0
	while i < $cupList.length()
		newCupFile.push($cupList[i].getFileFormat())
		i = i + 1
	end
	File.open($cupFile, 'w') do |file|
		file.puts newCupFile
	end
end

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


aboutMenu = About.new()
aboutMenu.hide(true)

cupConfirm = Confirm.new("Are you sure you want to overwrite your cup file?")
cupConfirm.hide(true)

update = Updater.new(true)
save = Button.new($maxx - 125 + $leftBorder * 2, $maxy + 10 + $headerSize, 115, 30, "OK", 15, 47, 7, 10) #SaveButton.new()
cancel = Button.new($maxx - 255 + $leftBorder * 2, $maxy + 10 + $headerSize, 115, 30, "Cancel", 15, 35, 7, 10) #CancelButton.new()
setAsDefault = Button.new($maxx - 420 + $leftBorder * 2, $maxy + 10 + $headerSize, 150, 30, "Set as Default", 15, 32, 7, 10)#SetAsDefaultButton.new()
about = HeaderButton.new($maxx + $leftBorder - 50, 3, 50, $headerSize - 8, "About", 5, $headerSize - 25, tempPath + "img/about.png")
help = HeaderButton.new($maxx + $leftBorder + 15, 3, 50, $headerSize - 8, "Help", 9, $headerSize - 25, tempPath + "img/help.png")

move = HeaderButton.new(($maxx + $leftBorder * 2) / 2 - 70, 3, 50, $headerSize - 8, "Move", 7, $headerSize - 25, tempPath + "img/move.png")
loadDefault = HeaderButton.new(($maxx + $leftBorder * 2) / 2, 3, 50, $headerSize - 8, "Default", 3, $headerSize - 25, tempPath + "img/default.png")
auto = HeaderButton.new(($maxx + $leftBorder * 2) / 2 - 140, 3, 50, $headerSize - 8, "Auto", 9, $headerSize - 25, tempPath + "img/auto.png")
saveToCups = HeaderButton.new(($maxx + $leftBorder * 2) / 2 - 210, 3, 50, $headerSize - 8, "Save", 9, $headerSize - 25, tempPath + "img/save.png")

moveForm = MoveForm.new()
frame = Frame.new()
moveScreen(-$leftBorder, 0, true)



def setCups(cupies)
	cupies = cupies.split(',')
	i = 0
	begin
		while i < cupies.length() do
			$colorList[i] = cupies[i].to_i
			if $colorList[i] == 0
				$cupList[i].setColor('blue')
			else
				$cupList[i].setColor('red')
			end
			i = i+1
		end
	rescue 
	
	end
end


$firstRun = true

def checkErrors(frame)
	FileUtils.mkdir_p $cupFile.gsub("_Cups.txt", "") + " Suction Cups\\"
	found = false
	
	file = File.open($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt", "a+")
	file.close
	
	found = true
	lines = IO.readlines($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt").map do |line|
		temp = line.split(";")
		if (temp[0].to_i == $sizex / $multiplier) && (temp[1].to_i == $sizey / $multiplier)
			if $firstRun
				setCups(temp[3])
				$firstRun = false
			end
			found = false
		end
	end
	
	
	
	error = false
	i = 0
	while i < $cupList.length()  do
		if (!$cupList[i].inSheet()) && ($colorList[i] == 1) # active, but not on sheet 
			error = true;
		end
		i +=1
	end
	
	if error
		frame.warning(error, "Cup or cup in a group is active, but not on sheet.")
	else 
		frame.warning(found, "No default cup pattern found for this sheet size")
	end
end


checkErrors(frame)


def autoCups(fram)
	i = 0
	while i < $cupList.length() do 
		if $cupList[i].inSheet() 
			$cupList[i].setColor('red')
			$colorList[i] = 1
		else 
			$cupList[i].setColor('blue')
			$colorList[i] = 0
		end 
		i = i + 1
	end
	checkErrors(fram)
end


def readDefaults(fram)
	begin
		lines = IO.readlines($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt").map do |line|
			temp = line.split(";")
			if (temp[0].to_i == $sizex / $multiplier) && (temp[1].to_i == $sizey / $multiplier)
				setCups(temp[3])
			end
		end
	rescue 
	end
	checkErrors(fram)
end

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
	
	hex = String.new
	i = 0
	while i < binGroup.length()
		j = 0
		sum = 0
		while j < 4 do 
			sum = sum + ((binGroup[i][j]).to_i * 2 ** (4 - j - 1));
			j = j + 1
		end
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
			line.gsub(line, ($sizex / $multiplier).to_s + ";" + ($sizey / $multiplier).to_s + ";" + hex + ";" + $colorList.to_s.tr('[', '').tr(']', '').tr(' ', ''))
		end
	end
	
	if found
		File.open($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt", 'w') do |file|
			file.puts lines
		end
	else 
		File.open($cupFile.gsub("_Cups.txt", "") + " Suction Cups\\Defaults.txt", 'a') { |f|
			f.puts ($sizex / $multiplier).to_s + ";" + ($sizey / $multiplier).to_s + ";" + hex + ";" + $colorList.to_s.tr('[', '').tr(']', '').tr(' ', '')
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
xx = -100
yy = -100
def confirmCupMove(x, y, rad, xPos, yPos, i)
	# following section is used on move confirm command 
	if $cupList[i - 1].move(x,y,rad,xPos,yPos) 
		$cupList[i - 1].setColor('red')
		$colorList[i - 1] = 1
	else 
		$cupList[i - 1].setColor('blue')
		$colorList[i - 1] = 0
	end
	$cupOutline.opacity = 0
end


on :mouse_down do |event|
	case event.button
	when :left
		if !$menuActive
			if save.contains?(event.x, event.y)
				if ARGV.length != 0 
					writeTolst(getHexValue())
				end
				update = Updater.new(false)
			elsif setAsDefault.contains?(event.x, event.y)
				writeDefaults(getHexValue())
				checkErrors(frame)
			elsif cancel.contains?(event.x, event.y)
				cancel.notActive()
				update = Updater.new(false)
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
			elsif about.contains?(event.x, event.y)
				aboutMenu = About.new()
				about.notActive()
			elsif help.contains?(event.x, event.y)
				Launchy.open("http://info.sigmatek.net/downloads/TrumpfCups/index.html")
			elsif loadDefault.contains?(event.x, event.y)
				readDefaults(frame)
			elsif auto.contains?(event.x, event.y)
				autoCups(frame)
			elsif saveToCups.contains?(event.x, event.y)
				cupConfirm = Confirm.new("Are you sure you want to overwrite your cup file?")
				saveToCups.notActive()
			elsif moveForm.containsClick(event.x, event.y) != 0
				moveForm.setActive(moveForm.containsClick(event.x, event.y))
				if (moveForm.containsClick(event.x, event.y) == 1) and ($selectedCup != -1)
					confirmCupMove(moveForm.getInput()[0].to_f, moveForm.getInput()[1].to_f, moveForm.getInput()[2].to_f, xx, yy, moveForm.getInput()[3].to_i)
					moveForm.reset()
					$selectedCup = -1
				end
			else
				i = 0
				error = false
				while i < $cupList.length()  do
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
							xx = event.x
							yy = event.y 
							moveForm.setText($selectedCup.getCupInfo(xx, yy))
						end
					end
					#
					# Produce error if cup is off sheet 
					#
					i +=1
				end
				#frame.warning(error, "Cup or cup in a group is active, but not on sheet.")
				checkErrors(frame)
			end
		else 
			if update.contains(event.x, event.y) != -1
				update.clicked(event.x, event.y)
			elsif aboutMenu.contains(event.x, event.y) != -1
				aboutMenu.clicked(event.x, event.y)
			elsif cupConfirm.contains(event.x, event.y) != -1
				if cupConfirm.clicked(event.x, event.y)
					saveCupFile()
				end
			end
		end
	
	
	
	when :middle
		if !$menuActive
			# Middle mouse button pressed down
			$movement = true
			$xOrig = event.x
			$yOrig = event.y
		end
	
	when :right
		# Right mouse button pressed down
	end
	
end

on :mouse_move do |event| 
	if !$menuActive
		moveScreen(Window.mouse_x, Window.mouse_y, false)
		
		
		if save.contains?(event.x, event.y) 
			save.setActive()
		elsif setAsDefault.contains?(event.x, event.y)
			setAsDefault.setActive()
		elsif cancel.contains?(event.x, event.y)
			cancel.setActive()
		elsif move.contains?(event.x, event.y) 
			move.setActive()
		elsif about.contains?(event.x, event.y)
			about.setActive()
		elsif help.contains?(event.x, event.y)
			help.setActive()
		elsif loadDefault.contains?(event.x, event.y) 
			loadDefault.setActive()
		elsif auto.contains?(event.x, event.y) 
			auto.setActive()
		elsif saveToCups.contains?(event.x, event.y) 
			saveToCups.setActive()
		elsif moveForm.containsMove(event.x, event.y) != 0
			moveForm.setActiveMove(moveForm.containsMove(event.x, event.y))
		else
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
	else 
		if update.contains(event.x, event.y) != -1
			update.setActive(update.contains(event.x, event.y))
		elsif aboutMenu.contains(event.x, event.y) != -1
			aboutMenu.setActive(aboutMenu.contains(event.x, event.y))
		elsif cupConfirm.contains(event.x, event.y) != -1
			cupConfirm.setActive(cupConfirm.contains(event.x, event.y))
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

on :key_down do |event|
  moveForm.keyPress(event.key)
end

show