Chat = Class{}


function Chat:init()
	self.lines = {}
	self.typeLine = ""
end


function Chat:update()
	
	--check for relevent data
	if CLIENT.data[1] then
		print(string.sub(CLIENT.data[1], 1, 2))
		if string.sub(CLIENT.data[1], 1, 2) == "C{" then
			table.insert(self.lines, string.sub(table.remove(CLIENT.data, 1), 3))
		else
			table.remove(CLIENT.data, 1)
		end
		--TODO and chat limit
	end
	
	--check for key input
	for k, v in pairs(love.keyboard.keysPressed) do
		if v  and k ~= 'return' then
			new = k
			if k == 'space' then
				new = ' '
			end
			self.typeLine = self.typeLine .. new
		
		end
	end
	
	--send it
	if love.keyboard.wasPressed('return') then
		CLIENT:send("C{" .. self.typeLine)
		self.typeLine = ""
	end
	
end


function Chat:draw()
	
	n = table.getn(self.lines)
	for k, v in pairs(self.lines) do
		love.graphics.printf(':' .. v, 0, VIRTUAL_HEIGHT - 10 * (n - k + 1) - 10, VIRTUAL_WIDTH, 'right')
		
	end
	love.graphics.printf('>>>' .. self.typeLine, 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, 'right')
end