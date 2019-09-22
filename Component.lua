Component = Class{}

function Component:init(t, args)
	if t == 'physics' then
		self.x = args['x']
		self.y = args['y']
		self.shape = args['shape']
		if self.shape == 'circle' then
		
			self.radius = args['radius']
			
		elseif self.shape == 'rectangle' then
		
			self.width = args['width']
			self.height = args['height']
			
		elseif self.shape == 'polygon' then
			self.verts = args['verts']
		end
		
		self.density = args['density']
		self.interaction = args['interaction']
	
	
	
	
	elseif t == 'texture' then
		self.texture = args['texture']
		self.width = self.texture:getWidth()
		self.height = self.texture:getHeight()
		
	--use to render physics objects 
	elseif t == 'renderable' then
		self.color = args['color']
		self.isPoly = args['isPoly']
		
	end
	
	self.t = t
end