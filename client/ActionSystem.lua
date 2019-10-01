function ActionSystem()
		local actionStart = CLIENT:getCommand('actS', false)
		if actionStart then
			for k, v in pairs(GAMEOBJS) do
				if v.name == actionStart['PID'] then
					movementStart(actionStart, v)
				end
			end
		end
		
		local actionEnd = CLIENT:getCommand('actE', false)
		if actionEnd then
			for k, v in pairs(GAMEOBJS) do
				if v.name == actionStart['PID'] then
					movementEnd(actionEnd, v)
						
				end
			end
		end

end

function movementStart(actionStart, v)
	if actionStart['aid'] == 0 then
						
		local vx, vy = v.body:getLinearVelocity()
		v.body:setLinearVelocity(vx, vy - 100)
		
	elseif actionStart['aid'] == 1 then
		
		local vx, vy = v.body:getLinearVelocity()
		v.body:setLinearVelocity(vx + 100, vy)
		
	elseif actionStart['aid'] == 2 then
		
		local vx, vy = v.body:getLinearVelocity()
		v.body:setLinearVelocity(vx, vy + 100)
		
	elseif actionStart['aid'] == 3 then
		
		local vx, vy = v.body:getLinearVelocity()
		v.body:setLinearVelocity(vx - 100, vy)
	end
end

function movementEnd(actionStart, v)
	if actionStart['aid'] == 0 then
						
		local vx, vy = v.body:getLinearVelocity()
		v.body:setLinearVelocity(vx, vy + 100)
		
	elseif actionStart['aid'] == 1 then
		
		local vx, vy = v.body:getLinearVelocity()
		v.body:setLinearVelocity(vx - 100, vy)
		
	elseif actionStart['aid'] == 2 then
		
		local vx, vy = v.body:getLinearVelocity()
		v.body:setLinearVelocity(vx, vy - 100)
		
	elseif actionStart['aid'] == 3 then
		
		local vx, vy = v.body:getLinearVelocity()
		v.body:setLinearVelocity(vx + 100, vy)
	end
end