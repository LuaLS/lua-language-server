---@meta

---@class cc.ParticleFlower :cc.ParticleSystemQuad
local ParticleFlower={ }
cc.ParticleFlower=ParticleFlower




---* 
---@return boolean
function ParticleFlower:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleFlower:initWithTotalParticles (numberOfParticles) end
---*  Create a flower particle system.<br>
---* return An autoreleased ParticleFlower object.
---@return self
function ParticleFlower:create () end
---*  Create a flower particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleFlower object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleFlower:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleFlower:ParticleFlower () end