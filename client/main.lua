push = require 'push'
Class = require 'class'
json = require 'json'
require 'Component'
require 'GameObj'
require 'client'
require 'Chat'

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


--CLIENT = Client("192.168.0.12", 7777)
CLIENT = Client("127.0.0.1", 7777)

love.physics.setMeter(32)
WORLD = love.physics.newWorld(0, 0, true) 
GAMEOBJS = {}
PLAYER = nil

PID = tostring(math.random(0, 1000))
connTimer = 1

function addGameObject(obj) 

	table.insert(GAMEOBJS, obj)

end


function buildPlayer(name)
	print("building player" .. name)
	player = GameObj(name)
	player:addComponent(Component('physics', {
		['x'] = 50,
		['y'] = 50,
		['shape'] = 'circle',
		['radius'] = 5,
		['density'] = 1,
		['interaction'] = 'dynamic'
		
	}))
	
	player:addComponent(Component('renderable', {
		['color'] = {math.random(50, 255), math.random(50, 255), math.random(50, 255)},
		['isPoly'] = false
	}))
	addGameObject(player)
	if name == PID then
		PLAYER = player
	end
end

function love.load()
	love.keyboard.keysPressed = {}
	love.window.setTitle("Round World")
	math.randomseed(os.time())
	PID = tostring(math.random(0, 1000))
	
	
	--set up rendering and scaling filter
	love.graphics.setDefaultFilter("nearest", "nearest")
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

	love.graphics.setFont(love.graphics.newFont("font.ttf", 8))
	
	
	
	CLIENT:connect(PID)
	
	chat = Chat()
	
	
	
	
	ground = GameObj('ground')
	
	ground:addComponent(Component('physics', {
		['x'] = 0,
		['y'] = VIRTUAL_HEIGHT,
		['shape'] = 'rectangle',
		['width'] = VIRTUAL_WIDTH,
		['height'] = 10,
		['density'] = 1,
		['interaction'] = 'static'
		
	}))
	
	ground:addComponent(Component('renderable', {
		['color'] = {0, 255, 0},
		['isPoly'] = true
	}))
	
	
	addGameObject(ground)
	tic = 0

end


function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
	--put held down key logic here
	if key == 'lshift' or key == 'rshift' then
		love.keyboard.shift = true
		print("Shift Pressed")
	end
end

function love.keyreleased(key)
	if key == 'lshift' or key == 'rshift' then
		love.keyboard.shift = false
		print("Shift Released")

	elseif key == 'a' then
		CLIENT:sendKeyUp('a')
		
	elseif key == 'd' then
		CLIENT:sendKeyUp('d')
		
	elseif key == 'w' then
		CLIENT:sendKeyUp('w')
		
	elseif key	== 's' then
		CLIENT:sendKeyUp('s')
	
		
	end
	
	
end

--use for getting if key just pressed
function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end


--resize function, don't modify
function love.resize(w, h)
	push:resize(w, h)
end

function love.update(dt)
	CLIENT:update()
	chat:update()
	WORLD:update(dt)
	tic = dt + tic
	
	--player heartbeats
	if PLAYER then
		
		if tic > 0.06 then
			CLIENT:sendHB()
			tic = 0
		end
		
		--get pos data from server
		local MPPUdata = CLIENT:getCommand('MPPU', false)
		if MPPUdata then
			for k, v in pairs(GAMEOBJS) do
				if v.name == MPPUdata['PID'] then
					v.body:setX(MPPUdata['x'])
					v.body:setY(MPPUdata['y'])
					--v.body:setLinearVelocity(MPPUdata['vx'], MPPUdata['vy'])
					v.body:setAngle(MPPUdata['a'])
				end
			end
		end
		
		
	end
	
	
	--check for player
	local pData = CLIENT:getCommand('playerConnect', true)
	
	if pData then
		buildPlayer(pData['PID'])
		chat:addMessage('player' .. pData['PID'] .. 'joined the server!')
	end
	
	

	
	
	if love.keyboard.wasPressed('a') and PLAYER then
		
		CLIENT:sendKeyDown('a')
		
		
	elseif love.keyboard.wasPressed('d') and PLAYER then
		
		
		CLIENT:sendKeyDown('d')
		
	elseif love.keyboard.wasPressed('w') and PLAYER then
		CLIENT:sendKeyDown('w')
		
		
	elseif love.keyboard.wasPressed('s') and PLAYER then
		CLIENT:sendKeyDown('s')
		
	
		
		
	end
	
	
	
	if connTimer > 0 then --set to whatever key you want to use
		connTimer = connTimer - dt
		print(connTimer)
		if connTimer <= 0 then
			CLIENT:sendPlayerConnect()
		end
	end
	
	
	for k, v in pairs(GAMEOBJS) do
		v:update(dt)
	end
	--reset keysPressed table
	love.keyboard.keysPressed = {}
end

function love.draw()
	love.graphics.clear(0,0,0,1)
	push:apply('start')
	
	love.graphics.printf("recieved", 0, 10, VIRTUAL_WIDTH, 'center')
	love.graphics.printf(':' .. CLIENT.last, 0, 50, VIRTUAL_WIDTH, 'center')
	
	
	--render code goes here
	for k, v in pairs(GAMEOBJS) do
		v:draw()
	end
	
	
	
	
	if CLIENT.connected then
		love.graphics.printf("connected!", 0, 10, VIRTUAL_WIDTH, 'left')
	else
		love.graphics.printf("disconnected!", 0, 10, VIRTUAL_WIDTH, 'left')
	end
	
	chat:draw()
	
	displayFPS()

	push:apply('end')
end

function displayFPS()
    -- simple FPS display across all states
   
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, VIRTUAL_HEIGHT - 18)
end


