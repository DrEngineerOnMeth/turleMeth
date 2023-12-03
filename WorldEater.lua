--Global Variable Declaration
cur=0
tar=0

matA={}
matA["n"]=0
matA["nx"]=1
matB={}
matB["n"]=0
matB["nx"]=1
matC={}
matC["n"]=0
matC["nx"]=1

function handleMatrix(ident)
a=matA["n"]
b=matB["n"]
c=matC["n"]
if a<=b and a<=c then table.insert(matA,ident) matA["n"]=matA["n"]+1 return 0
elseif b<=a and b<=c then table.insert(matB,ident) matB["n"]=matB["n"]+1 return 4
else table.insert(matC,ident) matC["n"]=matC["n"]+1 return 8
end
end

function handleTar(ident)
for i,v in ipairs(matA) do
	if ident==v then
		rednet.send(ident,matA["nx"],"tar")
		matA["nx"]=matA["nx"]+1
		return matA["nx"]-1
	end
end
for i,v in ipairs(matB) do
	if ident==v then
		rednet.send(ident,matB["nx"],"tar")
		matB["nx"]=matB["nx"]+1
		return matB["nx"]-1
	end
end
for i,v in ipairs(matC) do
	if ident==v then
		rednet.send(ident,matC["nx"],"tar")
		matC["nx"]=matC["nx"]+1
		return matC["nx"]-1
	end
end
end


function hostServer()
rednet.host("WorldEater","Director")
print("Commencing Director Protocol")

while true do
	sender,message,prot=rednet.receive()
	if prot=="Syn" then
		rednet.send(sender,handleMatrix(sender),"Syn")
	elseif prot=="tar" then
		handleTar(sender)
	elseif prot=="Control" then 
		if message=="estop" then break end
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
end

function tunnel()
for i=0,99,1 do
while turtle.dig()==true do end
turtle.forward()
turtle.digDown()
end
turtle.digUp()
turtle.up()
turtle.turnLeft() turtle.turnLeft()
for i=0,99,1 do
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
if server~=nil then
rednet.send(server,"","Syn")
sender,mssg,prot=rednet.receive("Syn")
for i=1,mssg,1 do turtle.digUp() turtle.up() end
else handleMatrix(os.getComputerID())
end
while true do
if server~=nil then
	rednet.send(server,"","tar")
	server,tar,prot=rednet.receive("tar")
else
	tar=matA["nx"];matA["nx"]=matA["nx"]+1
end
getthere()
tunnel()
end
end


--Main code block
rednet.open("left")
server=rednet.lookup("WorldEater","Director")
if server~=nil then print("Director at "..server) turt()
else parallel.waitForAll(hostServer,turt) end