--Global Variable Declaration
cur=0
tar=0


function query()
rednet.broadcast
end

function history()

end

function rednetHandler()
while true do
	sender,message,prot=rednet.receive()
	if prot=="Control" then estop=1 end
	if prot=="History" then
		if message<tar then
			rednet.send(sender,tar,"Response")
		end
	end
	if prot=="Query" then
		if message==tar then
			rednet.send(sender,true,"Response")
		end
	end
end
end

function dropper()
for i=1,16,1 do
turtle.select(i)
item=turtle.getItemDetail()
if item~=nil then
	if item["name"]~="minecraft:ancient_debris" then turtle.dropDown() end
end
end
turtle.select(1)
end

function tunnel()
for i=0,49,1 do
while turtle.dig()==true do end
turtle.forward()
turtle.digDown()
end
turtle.digUp()
turtle.up()
turtle.turnLeft() turtle.turnLeft()
for i=0,49,1 do
turtle.digUp()
while turtle.dig()==true do end
turtle.forward()
end
turtle.turnLeft()
dropper()
while turtle.down()==false do bool,tab=turtle.inspectDown()
if tab["name"]~="computercraft:turtle_normal" then turtle.digDown() end end
end


function getthere()
while true do
	if turtle.forward()==true then cur=cur+1
	else
		bool,tab=turtle.inspect()
		if tab["name"]~="computercraft:turtle_normal" then turtle.dig() end end
if cur==tar then break end


end
turtle.turnLeft()
end


function turt()
while true do
if server~=nil then
	rednet.send(server,"tar","swarmer")
	server,tar,prot=rednet.receive("swarmer")
else
	tar=prox
	prox=prox+1
end
getthere()
tunnel()
end
end


--Main code block
rednet.open("left")
server=rednet.lookup("swarmer","Director")
if server~=nil then print("Director at "..server) turt()
else parallel.waitForAll(hostServer,turt) end