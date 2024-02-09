--Global Variable Declaration
cur=0
tar=0
prox=1
interval=1 --Controls next layer

std=require "std"

function hostServer()
rednet.host("swarmer","Director")
print("Commencing Director Protocol")
while true do
	sender,message,prot=rednet.receive("swarmer")
	if message=="estop" then print("estop") server=os.computerID() break end
	rednet.send(sender,prox,"swarmer")
	prox=prox+interval

end
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
	prox=prox+interval
end
getthere()
std.trench(50)
turtle.turnLeft()
end
end


--Main code block
rednet.open("left")
server=rednet.lookup("swarmer","Director")
if server~=nil then print("Director at "..server) turt()
else parallel.waitForAll(hostServer,turt) end