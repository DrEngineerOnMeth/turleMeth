turtle.select(1);turtle.refuel()
shell.run("set","motd.enable","false")
str="Fuel:";print(str..tostring(turtle.getFuelLevel()))
if disk.isPresent("bottom")==false then return end
rootFiles=fs.list("/")
files=fs.list("disk/turtles/")

for i,target in ipairs(files) do
	if fs.exists(target)==true then
		fs.delete(target)
	end
	path=fs.combine("disk/turtles/",target)
	fs.copy(path,target)
end
if turtle.getFuelLevel()<10000 then
turtle.suck(1)
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