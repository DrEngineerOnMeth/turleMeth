--Global Variable Declaration
cur=0
tar=0
estop=0
indexOffset=0


size=arg[1] or 50
layers=arg[2] or 3
masterArray={}

std=require "std"

function initializeSupermatrix()
for i=1,layers,1 do
	masterArray[i]={}
	masterArray[i]["n"]=0
	masterArray[i]["nx"]=1
end
end

function handleMatrix(ident)
function getSmallest()
	out=1
	min=65535 --If you use 16 bits worth of turtles in a matrix you deserve this breaking
	for i,v in ipairs(masterArray) do
		if masterArray[i]["n"]<min then out=i;min=masterArray[i]["n"] end
	end
	return out
end
matIndex=getSmallest()
table.insert(masterArray[matIndex],ident)
masterArray[matIndex]["n"]=masterArray[matIndex]["n"]+1
return (matIndex-1)*3
end

function getTar(ident)
for matIndex=1,layers,1 do
	for i,v in ipairs(masterArray[matIndex]) do
		if ident==v then
			masterArray[matIndex]["nx"]=masterArray[matIndex]["nx"]+2
			return masterArray[matIndex]["nx"]-2
		end
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
		rednet.send(sender,getTar(sender),"tar")
	elseif prot=="Control" then 
		if message=="estop" then estop=1 end
	end
end
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
indexOffset=mssg
for i=1,mssg,1 do turtle.digUp() turtle.up() end
else initializeSupermatrix();handleMatrix(os.getComputerID())
end
while estop==0 do
if server~=nil then
	rednet.send(server,"","tar")
	server,tar,prot=rednet.receive("tar",3)
	if server==nil then break end
else
	tar=getTar(os.getComputerID())
end
getthere()
std.prospect(size,0)
cur=cur+1
std.prospect(size,0)
cur=cur-1
turtle.turnRight()
if turtle.getFuelLevel()<310 then turtle.turnLeft();turtle.back();estop=1 end
end
while indexOffset~=0 do
bool,tab=turtle.inspectDown()
if bool==false then
	turtle.down()
	indexOffset=indexOffset-1
elseif bool==true and tab["name"]~="computercraft:turtle_normal" then
	turtle.digDown()
else
	break
end
end
end


--Main code block
rednet.open("left")
server=rednet.lookup("creepyCrawlers","Director")
if server~=nil then print("Director at "..server) turt()
else parallel.waitForAll(hostServer,turt) end
