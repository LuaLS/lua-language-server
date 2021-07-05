---@meta

---@class cc.ParticleMeteor :cc.ParticleSystemQuad
local ParticleMeteor={ }
cc.ParticleMeteor=ParticleMeteor




---* 
---@return boolean
function ParticleMeteor:init () end
---* 
---@param numberOfParticles int
---@return boolean
function ParticleMeteor:initWithTotalParticles (numberOfParticles) end
---*  Create a meteor particle system.<br>
---* return An autoreleased ParticleMeteor object.
---@return self
function ParticleMeteor:create () end
---*  Create a meteor particle system withe a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleMeteor object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleMeteor:createWithTotalParticles (numberOfParticles) end
---* js ctor
---@return self
function ParticleMeteor:ParticleMeteor () end