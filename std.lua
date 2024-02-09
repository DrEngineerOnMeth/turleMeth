
local NAME=...

local std={}

--BEGIN FUNCTION DECLARATION--

function dropper()
items={"minecraft:iron_ore","minecraft:gold_ore","minecraft:diamond","computercraft:turtle_normal","minecraft:ancient_debris","miencraft:torch"}
for i=1,16,1 do
turtle.select(i)
item=turtle.getItemDetail()
if item~=nil then
	flag=0
	for x,v in ipairs(items) do if item["name"]==v then flag=1 end end
	if flag==0 then turtle.dropDown() end
end
end
turtle.select(1)
end

function prospector()
items={"minecraft:iron_ore","minecraft:gold_ore","minecraft:diamond_ore","minecraft:ancient_debris","minecraft:emerald_ore","minecraft:coal_ore","minecraft:obsidian"}
bool,tab=turtle.inspectDown()
if tab~=nil then
	for x,v in ipairs(items) do if tab["name"]==v then turtle.digDown() break end end
end
bool,tab=turtle.inspectUp()
if tab~=nil then
	for x,v in ipairs(items) do if tab["name"]==v then turtle.digUp() break end end
end
end

function simpleTunnel(lenght,torch)
for i=0, lenght-1 do
	while turtle.dig()==true do end
	turtle.forward()
	turtle.digUp()
	if i%10==0 and torch==1 then turtle.turnRight();turtle.placeUp();turtle.turnLeft() end
end
turtle.turnRight() turtle.turnRight()
for i=0, lenght-2 do turtle.digDown() turtle.forward() end
turtle.digDown();dropper();turtle.forward()
end

function trench(lenght)
for i=0,lenght-1,1 do
while turtle.dig()==true do end
while turtle.forward()==false do turtle.dig() end
turtle.digDown()
end
turtle.digUp()
turtle.up()
turtle.turnLeft() turtle.turnLeft()
for i=0,lenght-1,1 do
turtle.digUp()
while turtle.dig()==true do end
turtle.forward()
end
dropper()
while turtle.down()==false do bool,tab=turtle.inspectDown()
if tab["name"]~="computercraft:turtle_normal" then turtle.digDown() end end
end

function prospect(lenght) --Changes operating layer
for i=0,lenght-1,1 do
while turtle.dig()==true do end
turtle.forward()
prospector()
end
turtle.turnRight()
while turtle.dig()==true do end
turtle.forward()
turtle.turnRight()
prospector()
for i=0,lenght-2,1 do
while turtle.dig()==true do end
turtle.forward()
prospector()
end
while turtle.forward()==false do end
dropper()
end

function scrape(lenght,width,depth)
width=width or lenght
depth=depth or 1
turner=0
while depth~=0 do
	for i=1,width,1 do
		for v=1,lenght-1,1 do
			turtle.digDown()
			turtle.forward()
		end
		turtle.digDown()
		if i~=width then
		if (turner+i)%2==1 then
			turtle.turnRight()
			turtle.forward()
			turtle.turnRight()
		else
			turtle.turnLeft()
			turtle.forward()
			turtle.turnLeft()
		end end
	end
	turtle.digDown()
	turtle.turnLeft()
	turtle.turnLeft()
	dropper()
	turtle.down()
	if width%2==0 then turner=turner+1 end
	depth=depth-1
end end

function carve(lenght,width,turner)
width=width or lenght
turner=turner or 0
for i=1,width,1 do
	for v=1,lenght-1,1 do
		turtle.digDown()
		turtle.digUp()
		while turtle.dig()==true do end
		turtle.forward()
	end
	turtle.digDown()
	turtle.digUp()
	if i~=width then
	if (i+turner)%2==1 then
		turtle.turnRight()
		while turtle.dig()==true do end
		turtle.forward()
		turtle.turnRight()
	else
		turtle.turnLeft()
		while turtle.dig()==true do end
		turtle.forward()
		turtle.turnLeft()
	end end
end
turtle.digDown()
turtle.digUp()
dropper()

end

--END FUCNTION DECLARATION--

--BEGIN FUNCTION LINKING--
std.dropper=dropper
std.prospector=prospector
std.simpleTunnel=simpleTunnel
std.trench=trench
std.prospect=prospect
std.scrape=scrape
std.carve=carve
--END FUNCTION LINKING--
return std