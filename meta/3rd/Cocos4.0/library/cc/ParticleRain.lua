---@meta

---@class cc.ParticleRain :cc.ParticleSystemQuad
local ParticleRain={ }
cc.ParticleRain=ParticleRain




---* 
---@return boolean
function ParticleRain:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleRain:initWithTotalParticles (numberOfParticles) end
---*  Create a rain particle system.<br>
---* return An autoreleased ParticleRain object.
---@return self
function ParticleRain:create () end
---*  Create a rain particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleRain object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleRain:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleRain:ParticleRain () end