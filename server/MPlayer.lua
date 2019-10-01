MPlayer = Class{}



function MPlayer:init(cn, conn, wo)
	self.PID = nil
	self.conn = conn
	self.cn = cn
	self.wo = wo
	self.chunk = 0
end

