std = require "std"

--main
while true do
	while turtle.forward()==false do 
		bool,tab=turtle.inspect()
		if tab["name"]~="computercraft:turtle_normal" then 
			for i=0,4,1 do while turtle.dig() do end;turtle.forward();turtle.digUp() end 
			turtle.turnLeft()
			std.simpleTunnel(50,1)
			turtle.turnLeft()
			break
		end
	end

end