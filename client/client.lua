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
			
			local s, status, partial = self.tcp:receive()
			if status == "closed" then 
				self.connected = false
				self.tcp:close()
				coroutine.yield()
				break
			end
			
			if s then 
				print("got: " .. s)
				table.insert(self.data, s) 
				self.last = s
			end
			
	
			

			coroutine.yield()
			
			
		end
		

	end)
	
end

function Client:connect()
	
	self.tcp:connect(self.host, self.port)
	self.tcp:send('HELLO OVER THERE\n')
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






