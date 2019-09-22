Client = Class{}

socket = require("socket")

function Client:init(host, port)
	self.host = host
	self.port = port
	self.tcp = assert(socket.tcp())

	
	self.tcp:settimeout(0)

	self.data = {}
	self.last = 'none'
	
	print('test')
	
	self.receive = coroutine.create(function()
		local i = 0
		while true do
			--get data
			local s, status, partial = self.tcp:receive()
			if status == "closed" then 
				--if closed, disconnect
				self.connected = false
				self.tcp:close()
				coroutine.yield()
				break
			end
			
			--make sure it exisits
			if s then 
				print("got: " .. s)
				table.insert(self.data, s) 
				self.last = s
			end
			
	
			

			coroutine.yield()
			
			
		end
		

	end)
	
end

function Client:connect(pName)
	
	self.tcp:connect(self.host, self.port)
	self.tcp:send('P{' .. pName .. '\n')
	self.connected = true
	coroutine.resume(self.receive)
	--self.last = coroutine.status(self.receive)

end

function Client:update()
	if self.connected then
		coroutine.resume(self.receive)
		
		
	end
end

function Client:send(s)
	self.tcp:send(s .. '\n')

end

function Client:conntest()
	local host, port = "127.0.0.1", 7777
	local tcp = assert(socket.tcp())

	tcp:connect(host, port);
	--note the newline below
	tcp:send("hello world\n");

	
	tcp:close()
end

--greedy gets remove data that doesn't match
function Client:getCommand(id, greedy)
		
	--check for relevent data
	print(self.data[1])
	if self.data[1] then
		print('t:' .. string.sub(self.data[1], 1, 2))
		print(id)
		if string.sub(self.data[1], 1, 2) == id then
			return string.sub(table.remove(self.data, 1), 3)
		elseif greedy then
			table.remove(self.data, 1)
		end
		--TODO and chat limit
	end
	

end






