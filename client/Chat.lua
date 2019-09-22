Chat = Class{}


function Chat:init()
	self.lines = {}
	self.typeLine = ""
	self.highCase = {
		["1"] = '!',
		["2"] = '@',
		["3"] = '#',
		["4"] = '$',
		["5"] = '%',
		["6"] = '^',
		["7"] = '&',
		["8"] = '*',
		["9"] = '(',
		["0"] = ')',
		["`"] = '~',
		["-"] = '_',
		["="] = '+',
		["["] = '{',
		["]"] = '}',
		["\\"] = '|',
		[";"] = ':',
		["'"] = '"',
		[","] = '<',
		["."] = '>',
		["/"] = '?',
		["q"] = 'Q',
		["w"] = 'W',
		["e"] = 'E',
		["r"] = 'R',
		["t"] = 'T',
		["y"] = 'Y',
		["u"] = 'U',
		["i"] = 'I',
		["o"] = 'O',
		["p"] = 'P',
		["a"] = 'A',
		["s"] = 'S',
		["d"] = 'D',
		["f"] = 'F',
		["g"] = 'G',
		["h"] = 'H',
		["j"] = 'J',
		["k"] = 'K',
		["l"] = 'L',
		["z"] = 'Z',
		["x"] = 'X',
		["c"] = 'C',
		["v"] = 'V',
		["b"] = 'B',
		["n"] = 'N',
		["m"] = 'M',
	}
		
end


function Chat:update()
	
	--check for relevent data
	if CLIENT.data[1] then
		print(string.sub(CLIENT.data[1], 1, 2))
		if string.sub(CLIENT.data[1], 1, 2) == "C{" then
			table.insert(self.lines, string.sub(table.remove(CLIENT.data, 1), 3))
		
		end
		--TODO and chat limit
	end
	
	--check for key input 
	for k, v in pairs(love.keyboard.keysPressed) do
	
	
		if v and k ~= 'return' then
			new = k
			if love.keyboard.shiftDown then
				new = string.upper(new)
			end
			if k == 'space' then
				new = ' ' 
			end
			if k == 'lshift' or k == 'rshift' or k == 'lctrl' or k == 'rctrl' then
				new = ''
			end
			if love.keyboard.shift and string.len(new) > 0 then
				print("Checkpoint 2")
				new = self.highCase[new]
				print("Checkpoint 3")
			end
			
			self.typeLine = self.typeLine .. new
		
		end
		
	end
	
	--send it
	if love.keyboard.wasPressed('return') then
		CLIENT:send("C{" .. self.typeLine)
		--clear typing line
		self.typeLine = ""
	end
	
end


function Chat:draw()
	
	--
	n = table.getn(self.lines)
	for k, v in pairs(self.lines) do
		love.graphics.printf(':' .. v, 0, VIRTUAL_HEIGHT - 10 * (n - k + 1) - 10, VIRTUAL_WIDTH, 'right')
		
	end
	love.graphics.printf('>>>' .. self.typeLine, 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, 'right')
end

function Chat:addMessage(m)
	table.insert(self.lines, '[' .. m .. ']')
end