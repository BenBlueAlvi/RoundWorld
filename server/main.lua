json = require 'json'
Class = require 'class'
require 'MPlayer'
require 'server'



love.physics.setMeter(32)
WORLD = love.physics.newWorld(0, 0, true) 


worldObjs = {}
function generateWorldObject()
	local wo = {}
	wo.body = love.physics.newBody(WORLD, comp.x, comp.y, 'dynamic')
	wo.shape = love.physics.newCircleShape(comp.radius)
	wo.fixture = love.physics.newFixture(self.body, self.shape, comp.density)
	table.insert(worldObjs, wo)

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
