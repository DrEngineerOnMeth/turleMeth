rednet.open("back")
function coord()
rednet.host("Coordinator","PC")
if arg[1]==nil then print("Needs command!");return end
print("Coordinating with "..arg[1])
while true do
sender=rednet.receive("Coordinator")
print("Sent "..arg[1].."to "..tostring(sender))
rednet.send(sender,arg[1],"fastStart")
end
end
 
function repeater()
shell.run("repeat")
end
parallel.waitForAny(coord,repeater)