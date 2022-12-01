---@meta

---@class cc.ParticleData 
local ParticleData={ }
cc.ParticleData=ParticleData




---* 
---@return self
function ParticleData:release () end
---* 
---@return unsigned_int
function ParticleData:getMaxCount () end
---* 
---@param count int
---@return boolean
function ParticleData:init (count) end
---* 
---@param p1 int
---@param p2 int
---@return self
function ParticleData:copyParticle (p1,p2) end
---* 
---@return self
function ParticleData:ParticleData () end