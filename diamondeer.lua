turtle.select(1)
turtle.refuel()
turtle.select(2)

function dropper()
items={"minecraft:raw_iron","minecraft:raw_gold","minecraft:diamond","computercraft:turtle_normal"}
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

function tunnel()
for i=0, 50 do
	while turtle.dig()==true do end
	turtle.forward()
	turtle.digUp()
	if i%10==0 then turtle.turnRight();turtle.placeUp();turtle.turnLeft() end
end
turtle.turnRight() turtle.turnRight()
for i=0, 49 do turtle.digDown() turtle.forward() end
dropper();turtle.digDown() turtle.forward()
turtle.turnLeft()
end

--main
while true do
	while turtle.forward()==false do 
		bool,tab=turtle.inspect()
		if tab["name"]~="computercraft:turtle_normal" then 
			for i=0,4,1 do while turtle.dig() do end;turtle.forward();turtle.digUp() end 
			turtle.turnLeft()
			tunnel()
			break
		end
	end
	
end