json = require 'json'
Class = require 'class'
require 'MPlayer'
function connect()
	-- load namespace
	local socket = require("socket")
	-- create a TCP socket and bind it to the local host, at any port
	local server = assert(socket.bind("*", 7777))
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



function receive (cn)
	players[cn].conn:settimeout(0)   -- do not block
	local s, status = players[cn].conn:receive()
	
	if status == "timeout" then
		
		coroutine.yield(cn)
	end
	return s, status
end

threads = {}    -- list of all live threads
players = {}
CLIENTN = 0
function addClient(conn)
	-- create coroutine
	
	CLIENTN = CLIENTN + 1
	local cn = CLIENTN
	
	local mp = MPlayer(cn, conn)
	print('building thread')
	
	table.insert(players, mp)
	
	local co = coroutine.create(function ()
		clientThread(cn)
	end)
	-- insert it in the list
	table.insert(threads, co)
	
	
	
	
end



function dispatcher ()
	while 1 do
		
		local n = table.getn(threads)
		if n == 0 then 
			print('dispatcher halt')
			 
		end    -- no more threads to run
		local connections = {}
		for i=1,n do
			local status, res = coroutine.resume(threads[i])
			if not res and i ~= 1 then    -- thread finished its task?
				table.remove(threads, i)
				table.remove(players, i-1)
				CLIENTN = CLIENTN - 1
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


function clientThread (cn)
	
    while true do
		
		local s, status = receive(cn)
		
		if not status then 
			
			--decode data
			local sData = json.decode(s)
			
			if sData['id'] == 'playerConnect' then
				print('connection recieved')
				players[cn].PID = sData['PID']
				for k, v in pairs(players) do
					
					local jData = {
						['PID'] = players[cn].PID,
						['id'] = 'playerConnect',
						['chunk'] = players[cn].chunk
					}
					if v.chunk == players[cn].chunk then
						v.conn:send(json.encode(jData) .. '\n')
						if v.PID ~= players[cn].PID then
							local jData = {
								['id'] = 'getPos'
							}
						
							players[cn].conn:send(json.encode(jData) .. '\n')
						end
					end
				end
				
			
				
				
			--get position
			elseif sData['id'] == 'pos' then
				for k, v in pairs(players) do
					--check for revlevent chunk
					if v.chunk == players[cn].chunk then
						--check to make sure we aren't double spawning
						if v.PID ~= players[cn].PID then
						--spawn player
							local jData = {
								['id'] = 'plaSpawn',
								['x'] = sData['x'],
								['y'] = sData['y'],
								['PID'] = sData['PID']
							}
						
							players[cn].conn:send(json.encode(jData) .. '\n')
						end
					end	
				end
			
			
			elseif sData['id'] == 'hb' then
				--todo
			
			else
			 
				--Client processing goes here!
				for k, v in pairs(players) do	
					v.conn:send(s.. '\n')
				end
			end
			
		end
	
		
		
		
		if s == 'E{close' then
			players[cn].conn:close()
		end
		
		if status == "closed" then break end
		coroutine.yield(cn)
    end
    players[cn].conn:close()

end


function getClientThread(client)
	return threads[client + 1]
end

local co = coroutine.create(function ()
		connect()
	end)
-- insert it in the list
table.insert(threads, co)
coroutine.resume(co)

dispatcher()


