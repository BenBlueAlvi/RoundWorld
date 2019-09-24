json = require 'json'
Class = require 'class'
require 'MPlayer'
require 'server'



love.physics.setMeter(32)
WORLD = love.physics.newWorld(0, 0, true) 



function generateWorldObject(x, y, radius)
	local wo = {}
	wo.body = love.physics.newBody(WORLD, x, y, 'dynamic')
	wo.shape = love.physics.newCircleShape(radius)
	wo.fixture = love.physics.newFixture(wo.body, wo.shape, 1)
	print('generated world object')
	return wo

end
function love.load()
	
	
	love.window.setTitle("Round World")
	
	local co = coroutine.create(function ()
		connect()
	end)
	-- insert it in the list
	table.insert(threads, co)
	coroutine.resume(co)
	
	
end


function love.update(dt)

	WORLD:update(dt)
	
	
	dispatcher()

end



--start dispatcher
