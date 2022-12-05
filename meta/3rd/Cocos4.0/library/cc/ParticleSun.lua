---@meta

---@class cc.ParticleSun :cc.ParticleSystemQuad
local ParticleSun={ }
cc.ParticleSun=ParticleSun




---* 
---@return boolean
function ParticleSun:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleSun:initWithTotalParticles (numberOfParticles) end
---*  Create a sun particle system.<br>
---* return An autoreleased ParticleSun object.
---@return self
function ParticleSun:create () end
---*  Create a sun particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleSun object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleSun:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleSun:ParticleSun () end