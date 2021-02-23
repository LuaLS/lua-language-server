---@meta

---@class cc.ParticleFireworks :cc.ParticleSystemQuad
local ParticleFireworks={ }
cc.ParticleFireworks=ParticleFireworks




---* 
---@return boolean
function ParticleFireworks:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleFireworks:initWithTotalParticles (numberOfParticles) end
---*  Create a fireworks particle system.<br>
---* return An autoreleased ParticleFireworks object.
---@return self
function ParticleFireworks:create () end
---*  Create a fireworks particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleFireworks object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleFireworks:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleFireworks:ParticleFireworks () end