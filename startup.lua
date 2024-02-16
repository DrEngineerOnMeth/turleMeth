turtle.select(1);turtle.refuel()
shell.run("set","motd.enable","false")
str="Fuel:";print(str..tostring(turtle.getFuelLevel()))

if disk.isPresent("bottom")==true then
rootFiles=fs.list("/")
files=fs.list("disk/turtles/")

for i,target in ipairs(files) do
	if fs.exists(target)==true then
		fs.delete(target)
	end
	path=fs.combine("disk/turtles/",target)
	fs.copy(path,target)
end
foo=math.floor((turtle.getFuelLimit()-turtle.getFuelLevel())/6400)
if foo~=0 then
turtle.suck(foo)
turtle.refuel()
end
turtle.up()
os.sleep(1)
turtle.up()
while true do
turtle.digDown()
turtle.drop()
os.sleep(1)
end
return
end

--Fast hive code
rednet.open("left")
server=rednet.lookup("Coordinator","PC")
if server==nil then
	print("Engaging manual control")
	return
else
	print("Contacting coordinator...")
	rednet.send(server,"","Coordinator")
	server,command,prot=rednet.receive("fastStart")
	if server==nil then print("Lost contact with Coordinator, returning to manual") return end
	print("Reveived command, running '"..command.."'")
	shell.run(command)
end