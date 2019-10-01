GameObj = Class{}


function GameObj:init(name)
	self.name = name
	self.components = {}

end

function GameObj:addComponent(comp)
	table.insert(self.components, comp)
	
	if comp.t == 'physics' then
		self.body = love.physics.newBody(WORLD, comp.x, comp.y, comp.interaction)
		
		if comp.shape == 'circle' then
			
			self.shape = love.physics.newCircleShape(comp.radius)
			
		elseif comp.shape == 'rectangle' then
			
			self.shape = love.physics.newRectangleShape(comp.width, comp.height)
			
		end	
		
		self.fixture = love.physics.newFixture(self.body, self.shape, comp.density)
		self.fixture:setRestitution(0)
		self.fixture:setFriction(0.5)
		
		
	elseif comp.t == 'renderable' then
		self.color = comp.color
		self.isPoly = comp.isPoly
		self.renderable = true
	
	end
end

function GameObj:getComponent(name)
	--TODO make this binary search
	for k, v in pairs(self.components) do
		if v.t == name then
			return v
		end
	end
	
	return nil
end

function GameObj:update(dt)


end


function GameObj:draw()
	
	if self.renderable ~= nil and self.body ~= nil then
		love.graphics.setColor(self.color) -- set the drawing color 
		if self.isPoly then
			love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
		else
			love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
		end
	end
	



end