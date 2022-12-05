---@meta

---@class cc.ParticleSnow :cc.ParticleSystemQuad
local ParticleSnow={ }
cc.ParticleSnow=ParticleSnow




---* 
---@return boolean
function ParticleSnow:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleSnow:initWithTotalParticles (numberOfParticles) end
---*  Create a snow particle system.<br>
---* return An autoreleased ParticleSnow object.
---@return self
function ParticleSnow:create () end
---*  Create a snow particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleSnow object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleSnow:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleSnow:ParticleSnow () end