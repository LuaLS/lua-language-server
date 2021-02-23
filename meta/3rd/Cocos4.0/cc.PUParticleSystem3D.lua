---@meta

---@class cc.PUParticleSystem3D :cc.ParticleSystem3D
local PUParticleSystem3D={ }
cc.PUParticleSystem3D=PUParticleSystem3D




---* 
---@param filePath string
---@return boolean
function PUParticleSystem3D:initWithFilePath (filePath) end
---* Returns the velocity scale, defined in the particle system, but passed to the technique for convenience.
---@return float
function PUParticleSystem3D:getParticleSystemScaleVelocity () end
---* 
---@param quota unsigned_int
---@return self
function PUParticleSystem3D:setEmittedSystemQuota (quota) end
---* default particle depth
---@return float
function PUParticleSystem3D:getDefaultDepth () end
---* 
---@return unsigned_int
function PUParticleSystem3D:getEmittedSystemQuota () end
---* 
---@param filePath string
---@param materialPath string
---@return boolean
function PUParticleSystem3D:initWithFilePathAndMaterialPath (filePath,materialPath) end
---* 
---@return self
function PUParticleSystem3D:clearAllParticles () end
---* 
---@return string
function PUParticleSystem3D:getMaterialName () end
---* 
---@return self
function PUParticleSystem3D:calulateRotationOffset () end
---* Return the maximum velocity a particle can have, even if the velocity of the particle has been set higher (either by initialisation of the particle or by means of an affector).
---@return float
function PUParticleSystem3D:getMaxVelocity () end
---* 
---@param delta float
---@return self
function PUParticleSystem3D:forceUpdate (delta) end
---* 
---@return float
function PUParticleSystem3D:getTimeElapsedSinceStart () end
---* 
---@return self
function PUParticleSystem3D:removeAllBehaviourTemplate () end
---* 
---@return unsigned_int
function PUParticleSystem3D:getEmittedEmitterQuota () end
---*  Forces emission of particles.<br>
---* remarks The number of requested particles are the exact number that are emitted. No down-scaling is applied.
---@param emitter cc.PUEmitter
---@param requested unsigned_int
---@return self
function PUParticleSystem3D:forceEmission (emitter,requested) end
---* 
---@param listener cc.PUListener
---@return self
function PUParticleSystem3D:addListener (listener) end
---* 
---@return boolean
function PUParticleSystem3D:isMarkedForEmission () end
---* default particle width
---@return float
function PUParticleSystem3D:getDefaultWidth () end
---* 
---@param quota unsigned_int
---@return self
function PUParticleSystem3D:setEmittedEmitterQuota (quota) end
---* 
---@param isMarked boolean
---@return self
function PUParticleSystem3D:setMarkedForEmission (isMarked) end
---* 
---@return self
function PUParticleSystem3D:clone () end
---* add particle affector
---@param emitter cc.PUEmitter
---@return self
function PUParticleSystem3D:addEmitter (emitter) end
---* 
---@param behaviour cc.PUBehaviour
---@return self
function PUParticleSystem3D:addBehaviourTemplate (behaviour) end
---* 
---@param width float
---@return self
function PUParticleSystem3D:setDefaultWidth (width) end
---* 
---@param system cc.PUParticleSystem3D
---@return self
function PUParticleSystem3D:copyAttributesTo (system) end
---* 
---@param name string
---@return self
function PUParticleSystem3D:setMaterialName (name) end
---* 
---@return self
function PUParticleSystem3D:getParentParticleSystem () end
---* 
---@param listener cc.PUListener
---@return self
function PUParticleSystem3D:removeListener (listener) end
---* Set the maximum velocity a particle can have.
---@param maxVelocity float
---@return self
function PUParticleSystem3D:setMaxVelocity (maxVelocity) end
---* default particle height
---@return float
function PUParticleSystem3D:getDefaultHeight () end
---* 
---@return vec3_table
function PUParticleSystem3D:getDerivedPosition () end
---* If the orientation of the particle system has been changed since the last update, the passed vector is rotated accordingly.
---@param pos vec3_table
---@return self
function PUParticleSystem3D:rotationOffset (pos) end
---* 
---@return self
function PUParticleSystem3D:removeAllEmitter () end
---* 
---@param scaleVelocity float
---@return self
function PUParticleSystem3D:setParticleSystemScaleVelocity (scaleVelocity) end
---* 
---@return vec3_table
function PUParticleSystem3D:getDerivedScale () end
---* 
---@param height float
---@return self
function PUParticleSystem3D:setDefaultHeight (height) end
---* 
---@return self
function PUParticleSystem3D:removeAllListener () end
---* 
---@param filePath string
---@return boolean
function PUParticleSystem3D:initSystem (filePath) end
---* 
---@param particle cc.PUParticle3D
---@return boolean
function PUParticleSystem3D:makeParticleLocal (particle) end
---* 
---@return self
function PUParticleSystem3D:removerAllObserver () end
---* 
---@param depth float
---@return self
function PUParticleSystem3D:setDefaultDepth (depth) end
---* 
---@param observer cc.PUObserver
---@return self
function PUParticleSystem3D:addObserver (observer) end
---@overload fun(string:string):self
---@overload fun():self
---@overload fun(string:string,string:string):self
---@param filePath string
---@param materialPath string
---@return self
function PUParticleSystem3D:create (filePath,materialPath) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function PUParticleSystem3D:draw (renderer,transform,flags) end
---* particle system play control
---@return self
function PUParticleSystem3D:startParticleSystem () end
---* stop particle
---@return self
function PUParticleSystem3D:stopParticleSystem () end
---* 
---@param delta float
---@return self
function PUParticleSystem3D:update (delta) end
---* pause particle
---@return self
function PUParticleSystem3D:pauseParticleSystem () end
---* resume particle
---@return self
function PUParticleSystem3D:resumeParticleSystem () end
---* 
---@return int
function PUParticleSystem3D:getAliveParticleCount () end
---* 
---@return self
function PUParticleSystem3D:PUParticleSystem3D () end