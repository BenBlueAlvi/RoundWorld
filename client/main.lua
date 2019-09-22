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


CLIENT = Client("192.168.0.12", 7777)

love.physics.setMeter(32)
WORLD = love.physics.newWorld(0, 9.8 * 32, true) 
GAMEOBJS = {}
PLAYER = nil

PID = tostring(math.random(0, 1000))

function addGameObject(obj) 

	table.insert(GAMEOBJS, obj)

end


function buildPlayer(name)
	print("building player" .. name)
	player = GameObj("player" .. name)
	player:addComponent(Component('physics', {
		['x'] = 50,
		['y'] = 50,
		['shape'] = 'circle',
		['radius'] = 5,
		['density'] = 1,
		['interaction'] = 'dynamic'
		
	}))
	
	player:addComponent(Component('renderable', {
		['color'] = {255, 0, 255},
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

	
	local pData = CLIENT:getCommand('P{', true)
	
	if pData then
		buildPlayer(pData)
	end
	
	if love.keyboard.wasPressed('a') then
		PLAYER.body:setLinearVelocity(0, -100)
		--CLIENT:conntest()
		
		
	end
	
	if love.keyboard.wasPressed("d") then --set to whatever key you want to use
		
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


