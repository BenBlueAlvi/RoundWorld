MPlayer = Class{}



function MPlayer:init(cn, conn, wo)
	self.PID = nil
	self.conn = conn
	self.cn = cn
	self.wo = wo

end

function MPlayer:getWorldData()
	local x, y = self.wo.body:getPosition()
	local vx, vy = self.wo.body:getLinearVelocity()
	local jData = {}
	jData['id'] = 'MPPU'
	jData['x'] = math.floor(x)
	jData['y'] = math.floor(y)
	jData['vx'] = vx
	jData['vy'] = vy
	jData['a'] = self.wo.body:getAngle()
	jData['PID'] = self.PID
	return json.encode(jData)


end