---@meta

---@class cc.ParticleFire :cc.ParticleSystemQuad
local ParticleFire={ }
cc.ParticleFire=ParticleFire




---*  Create a fire particle system.<br>
---* return An autoreleased ParticleFire object.
---@return self
function ParticleFire:create () end
---*  Create a fire particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleFire object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleFire:createWithTotalParticles (numberOfParticles) end
---* 
---@return boolean
function ParticleFire:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleFire:initWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleFire:ParticleFire () end