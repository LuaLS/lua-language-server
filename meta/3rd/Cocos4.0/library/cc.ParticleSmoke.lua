---@meta

---@class cc.ParticleSmoke :cc.ParticleSystemQuad
local ParticleSmoke={ }
cc.ParticleSmoke=ParticleSmoke




---* 
---@return boolean
function ParticleSmoke:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleSmoke:initWithTotalParticles (numberOfParticles) end
---*  Create a smoke particle system.<br>
---* return An autoreleased ParticleSmoke object.
---@return self
function ParticleSmoke:create () end
---*  Create a smoke particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleSmoke object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleSmoke:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleSmoke:ParticleSmoke () end