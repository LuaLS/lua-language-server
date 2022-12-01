---@meta

---@class cc.ParticleExplosion :cc.ParticleSystemQuad
local ParticleExplosion={ }
cc.ParticleExplosion=ParticleExplosion




---* 
---@return boolean
function ParticleExplosion:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleExplosion:initWithTotalParticles (numberOfParticles) end
---*  Create a explosion particle system.<br>
---* return An autoreleased ParticleExplosion object.
---@return self
function ParticleExplosion:create () end
---*  Create a explosion particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleExplosion object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleExplosion:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleExplosion:ParticleExplosion () end