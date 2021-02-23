---@meta

---@class cc.ParticleGalaxy :cc.ParticleSystemQuad
local ParticleGalaxy={ }
cc.ParticleGalaxy=ParticleGalaxy




---* 
---@return boolean
function ParticleGalaxy:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleGalaxy:initWithTotalParticles (numberOfParticles) end
---*  Create a galaxy particle system.<br>
---* return An autoreleased ParticleGalaxy object.
---@return self
function ParticleGalaxy:create () end
---*  Create a galaxy particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleGalaxy object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleGalaxy:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleGalaxy:ParticleGalaxy () end