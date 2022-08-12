---@meta

---@class cc.ParticleSpiral :cc.ParticleSystemQuad
local ParticleSpiral={ }
cc.ParticleSpiral=ParticleSpiral




---* 
---@return boolean
function ParticleSpiral:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleSpiral:initWithTotalParticles (numberOfParticles) end
---*  Create a spiral particle system.<br>
---* return An autoreleased ParticleSpiral object.
---@return self
function ParticleSpiral:create () end
---*  Create a spiral particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleSpiral object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleSpiral:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleSpiral:ParticleSpiral () end