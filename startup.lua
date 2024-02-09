turtle.select(1);turtle.refuel()
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
turtle.suck(1)
turtle.refuel()
turtle.up()