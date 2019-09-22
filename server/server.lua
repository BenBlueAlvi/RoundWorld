
function connect()
	-- load namespace
	local socket = require("socket")
	-- create a TCP socket and bind it to the local host, at any port
	local server = assert(socket.bind("192.168.0.12", 7777))
	server:settimeout(0.1)
	-- find out which port the OS chose for us
	local ip, port = server:getsockname()
	-- print a message informing what's up
	print("Server running on port: " .. port)

	-- loop forever waiting for clients
	while 1 do
		-- wait for a connection from any client
		local client, err = server:accept()
		if err ~= 'timeout' then
		
			-- make sure we don't block waiting for this client's line
			print('client connect')
			addClient(client)
			-- receive the line
		end
		coroutine.yield()
		
	end
	
end



function receive (connection)
	connection:settimeout(0.1)   -- do not block
	local s, status = connection:receive()
	if status == "timeout" then
		coroutine.yield(connection)
	end
	return s, status
end

threads = {}    -- list of all live threads
clients = {} -- allClients

function addClient(conn)
	-- create coroutine
	local co = coroutine.create(function ()
		clientThread(conn)
	end)
	-- insert it in the list
	table.insert(threads, co)
	table.insert(clients, conn)
end



function dispatcher ()
	while 1 do
		local n = table.getn(threads)
		if n == 0 then break end    -- no more threads to run
		local connections = {}
		for i=1,n do
			local status, res = coroutine.resume(threads[i])
			if not res and i ~= 1 then    -- thread finished its task?
				table.remove(threads, i)
				table.remove(clients, i-1)
				break
			else    -- timeout
				table.insert(connections, res)
			end
		end
		if table.getn(connections) == n then
			socket.select(connections)
		end
		
	end
end


function clientThread (connection)
	
    while true do
	
		local s, status = receive(connection)
		
		if not status then 
			
			--Client processing goes here!
			local n = table.getn(clients)
			for i = 1, n do
				print("SENDING to " .. i)
				clients[i]:send(s .. "\n") 
			end
			
		end
		if s then
			print(s)
			print("client count: " .. table.getn(clients))
		end
		
		if s == 'E{close' then
			client:close()
		end
		coroutine.yield(connection)
		if status == "closed" then break end
    end
    connection:close()

end


function getClientThread(client)
	return threads[client + 1]
end




local co = coroutine.create(function ()
	connect()
end)
-- insert it in the list
table.insert(threads, co)

--start dispatcher
dispatcher()
