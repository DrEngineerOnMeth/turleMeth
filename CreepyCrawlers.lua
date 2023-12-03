--Global Variable Declaration
cur=0
tar=0
estop=0

matA={}
matA["n"]=0
matA["nx"]=1
matB={}
matB["n"]=0
matB["nx"]=1


function handleMatrix(ident)
a=matA["n"]
b=matB["n"]
if a<=b then table.insert(matA,ident) matA["n"]=matA["n"]+1 return 0
else table.insert(matB,ident) matB["n"]=matB["n"]+1 return 3
end
end

function handleTar(ident)
for i,v in ipairs(matA) do
	if ident==v then
		rednet.send(ident,matA["nx"],"tar")
		matA["nx"]=matA["nx"]+2
		return matA["nx"]-2
	end
end
for i,v in ipairs(matB) do
	if ident==v then
		rednet.send(ident,matB["nx"],"tar")
		matB["nx"]=matB["nx"]+2
		return matB["nx"]-2
	end
end
end


function hostServer()
rednet.host("creepyCrawlers","Director")
print("Commencing Director Protocol")

while estop==0 do
	sender,message,prot=rednet.receive()
	if prot=="Syn" then
		rednet.send(sender,handleMatrix(sender),"Syn")
	elseif prot=="tar" then
		handleTar(sender)
	elseif prot=="Control" then 
		if message=="estop" then estop=1 end
	end
end
end

function dropper()
for i=1,16,1 do
turtle.select(i)
item=turtle.getItemDetail()
if item~=nil then
	if item["name"]~="minecraft:ancient_debris" and tab["name"]~="computercraft:turtle_normal" then turtle.dropDown() end
end
end
end

function prospector()
bool,tab=turtle.inspectDown()
if tab["name"]=="minecraft:ancient_debris" then turtle.digDown() end
bool,tab=turtle.inspectUp()
if tab["name"]=="minecraft:ancient_debris" then turtle.digUp() end
end

function tunnel()
for i=0,49,1 do
while turtle.dig()==true do end
turtle.forward()
prospector()
end
turtle.turnRight() 
while turtle.dig()==true do end
turtle.forward();cur=cur+1
turtle.turnRight()
for i=0,48,1 do
while turtle.dig()==true do end
turtle.forward()
prospector()
end
while turtle.forward()==false do end
turtle.turnLeft()
dropper()
if turtle.getFuelLevel()<150 then turtle.turnRight();turtle.back();estop=1 end
end


function getthere()
while true do
	if turtle.forward()==true then cur=cur+1;turtle.digUp()
	else
		bool,tab=turtle.inspect()
		if tab["name"]~="computercraft:turtle_normal" then turtle.dig() end end
if cur==tar then break end


end
turtle.turnLeft()
end


function turt()
if server~=nil then
rednet.send(server,"","Syn")
sender,mssg,prot=rednet.receive("Syn")
for i=1,mssg,1 do turtle.digUp() turtle.up() end
else handleMatrix(os.getComputerID())
end
while estop==0 do
if server~=nil then
	rednet.send(server,"","tar")
	server,tar,prot=rednet.receive("tar")
else
	tar=matA["nx"];matA["nx"]=matA["nx"]+2
end
getthere()
tunnel()
end
end


--Main code block
rednet.open("left")
server=rednet.lookup("creepyCrawlers","Director")
if server~=nil then print("Director at "..server) turt()
else parallel.waitForAll(hostServer,turt) end