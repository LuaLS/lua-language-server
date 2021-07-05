---@meta

---@class cc.ParticleSystem :cc.Node@all parent class: Node,TextureProtocol,PlayableProtocol
local ParticleSystem={ }
cc.ParticleSystem=ParticleSystem




---*  Gets the start size variance in pixels of each particle.<br>
---* return The start size variance in pixels of each particle.
---@return float
function ParticleSystem:getStartSizeVar () end
---* 
---@return cc.Texture2D
function ParticleSystem:getTexture () end
---*  Whether or not the system is full.<br>
---* return True if the system is full.
---@return boolean
function ParticleSystem:isFull () end
---*  Gets the batch node.<br>
---* return The batch node.
---@return cc.ParticleBatchNode
function ParticleSystem:getBatchNode () end
---*  Gets the start color of each particle.<br>
---* return The start color of each particle.
---@return color4f_table
function ParticleSystem:getStartColor () end
---*  Gets the particles movement type: Free or Grouped.<br>
---* since v0.8<br>
---* return The particles movement type.
---@return int
function ParticleSystem:getPositionType () end
---*  Sets the position variance of the emitter.<br>
---* param pos The position variance of the emitter.
---@param pos vec2_table
---@return self
function ParticleSystem:setPosVar (pos) end
---*  Gets the end spin of each particle.<br>
---* return The end spin of each particle.
---@return float
function ParticleSystem:getEndSpin () end
---*  Sets the rotate per second variance.<br>
---* param degrees The rotate per second variance.
---@param degrees float
---@return self
function ParticleSystem:setRotatePerSecondVar (degrees) end
---* / @} end of PlayableProtocol
---@param sourcePositionCompatible boolean
---@return self
function ParticleSystem:setSourcePositionCompatible (sourcePositionCompatible) end
---*  Gets the start spin variance of each particle.<br>
---* return The start spin variance of each particle.
---@return float
function ParticleSystem:getStartSpinVar () end
---*  Gets the radial acceleration variance.<br>
---* return The radial acceleration variance.
---@return float
function ParticleSystem:getRadialAccelVar () end
---*  Gets the end size variance in pixels of each particle.<br>
---* return The end size variance in pixels of each particle.
---@return float
function ParticleSystem:getEndSizeVar () end
---*  Sets the tangential acceleration.<br>
---* param t The tangential acceleration.
---@param t float
---@return self
function ParticleSystem:setTangentialAccel (t) end
---*  Gets the radial acceleration.<br>
---* return The radial acceleration.
---@return float
function ParticleSystem:getRadialAccel () end
---*  Sets the start radius.<br>
---* param startRadius The start radius.
---@param startRadius float
---@return self
function ParticleSystem:setStartRadius (startRadius) end
---*  Sets the number of degrees to rotate a particle around the source pos per second.<br>
---* param degrees The number of degrees to rotate a particle around the source pos per second.
---@param degrees float
---@return self
function ParticleSystem:setRotatePerSecond (degrees) end
---*  Sets the end size in pixels of each particle.<br>
---* param endSize The end size in pixels of each particle.
---@param endSize float
---@return self
function ParticleSystem:setEndSize (endSize) end
---*  Gets the gravity.<br>
---* return The gravity.
---@return vec2_table
function ParticleSystem:getGravity () end
---* 
---@return self
function ParticleSystem:resumeEmissions () end
---*  Gets the tangential acceleration.<br>
---* return The tangential acceleration.
---@return float
function ParticleSystem:getTangentialAccel () end
---*  Sets the end radius.<br>
---* param endRadius The end radius.
---@param endRadius float
---@return self
function ParticleSystem:setEndRadius (endRadius) end
---*  Gets the speed.<br>
---* return The speed.
---@return float
function ParticleSystem:getSpeed () end
---* 
---@return self
function ParticleSystem:pauseEmissions () end
---*  Gets the angle of each particle. <br>
---* return The angle of each particle.
---@return float
function ParticleSystem:getAngle () end
---*  Sets the end color and end color variation of each particle.<br>
---* param color The end color and end color variation of each particle.
---@param color color4f_table
---@return self
function ParticleSystem:setEndColor (color) end
---*  Sets the start spin of each particle.<br>
---* param spin The start spin of each particle.
---@param spin float
---@return self
function ParticleSystem:setStartSpin (spin) end
---*  Sets how many seconds the emitter will run. -1 means 'forever'.<br>
---* param duration The seconds that the emitter will run. -1 means 'forever'.
---@param duration float
---@return self
function ParticleSystem:setDuration (duration) end
---*  Initializes a system with a fixed number of particles
---@param numberOfParticles int
---@return boolean
function ParticleSystem:initWithTotalParticles (numberOfParticles) end
---* 
---@param count int
---@return self
function ParticleSystem:addParticles (count) end
---* 
---@param texture cc.Texture2D
---@return self
function ParticleSystem:setTexture (texture) end
---*  Gets the position variance of the emitter.<br>
---* return The position variance of the emitter.
---@return vec2_table
function ParticleSystem:getPosVar () end
---*  Call the update method with no time..
---@return self
function ParticleSystem:updateWithNoTime () end
---*  Whether or not the particle system is blend additive.<br>
---* return True if the particle system is blend additive.
---@return boolean
function ParticleSystem:isBlendAdditive () end
---*  Gets the speed variance.<br>
---* return The speed variance.
---@return float
function ParticleSystem:getSpeedVar () end
---*  Sets the particles movement type: Free or Grouped.<br>
---* since v0.8<br>
---* param type The particles movement type.
---@param type int
---@return self
function ParticleSystem:setPositionType (type) end
---* 
---@return self
function ParticleSystem:stopSystem () end
---*  Gets the source position of the emitter.<br>
---* return The source position of the emitter.
---@return vec2_table
function ParticleSystem:getSourcePosition () end
---*  Sets the life variance of each particle.<br>
---* param lifeVar The life variance of each particle.
---@param lifeVar float
---@return self
function ParticleSystem:setLifeVar (lifeVar) end
---*  Sets the maximum particles of the system.<br>
---* param totalParticles The maximum particles of the system.
---@param totalParticles int
---@return self
function ParticleSystem:setTotalParticles (totalParticles) end
---*  Sets the end color variance of each particle.<br>
---* param color The end color variance of each particle.
---@param color color4f_table
---@return self
function ParticleSystem:setEndColorVar (color) end
---*  Gets the index of system in batch node array.<br>
---* return The index of system in batch node array.
---@return int
function ParticleSystem:getAtlasIndex () end
---*  Gets the start size in pixels of each particle.<br>
---* return The start size in pixels of each particle.
---@return float
function ParticleSystem:getStartSize () end
---*  Sets the start spin variance of each particle.<br>
---* param pinVar The start spin variance of each particle.
---@param pinVar float
---@return self
function ParticleSystem:setStartSpinVar (pinVar) end
---*  Kill all living particles.
---@return self
function ParticleSystem:resetSystem () end
---*  Sets the index of system in batch node array.<br>
---* param index The index of system in batch node array.
---@param index int
---@return self
function ParticleSystem:setAtlasIndex (index) end
---*  Sets the tangential acceleration variance.<br>
---* param t The tangential acceleration variance.
---@param t float
---@return self
function ParticleSystem:setTangentialAccelVar (t) end
---*  Sets the end radius variance.<br>
---* param endRadiusVar The end radius variance.
---@param endRadiusVar float
---@return self
function ParticleSystem:setEndRadiusVar (endRadiusVar) end
---*  Gets the end radius.<br>
---* return The end radius.
---@return float
function ParticleSystem:getEndRadius () end
---*  Whether or not the particle system is active.<br>
---* return True if the particle system is active.
---@return boolean
function ParticleSystem:isActive () end
---*  Sets the radial acceleration variance.<br>
---* param t The radial acceleration variance.
---@param t float
---@return self
function ParticleSystem:setRadialAccelVar (t) end
---*  Sets the start size in pixels of each particle.<br>
---* param startSize The start size in pixels of each particle.
---@param startSize float
---@return self
function ParticleSystem:setStartSize (startSize) end
---*  Sets the speed.<br>
---* param speed The speed.
---@param speed float
---@return self
function ParticleSystem:setSpeed (speed) end
---*  Gets the start spin of each particle.<br>
---* return The start spin of each particle.
---@return float
function ParticleSystem:getStartSpin () end
---* 
---@return string
function ParticleSystem:getResourceFile () end
---*  Gets the number of degrees to rotate a particle around the source pos per second.<br>
---* return The number of degrees to rotate a particle around the source pos per second.
---@return float
function ParticleSystem:getRotatePerSecond () end
---*  Sets the mode of the emitter.<br>
---* param mode The mode of the emitter.
---@param mode int
---@return self
function ParticleSystem:setEmitterMode (mode) end
---*  Gets how many seconds the emitter will run. -1 means 'forever'.<br>
---* return The seconds that the emitter will run. -1 means 'forever'.
---@return float
function ParticleSystem:getDuration () end
---*  Sets the source position of the emitter.<br>
---* param pos The source position of the emitter.
---@param pos vec2_table
---@return self
function ParticleSystem:setSourcePosition (pos) end
---* 
---@return self
function ParticleSystem:stop () end
---*  Update the verts position data of particle,<br>
---* should be overridden by subclasses. 
---@return self
function ParticleSystem:updateParticleQuads () end
---*  Gets the end spin variance of each particle.<br>
---* return The end spin variance of each particle.
---@return float
function ParticleSystem:getEndSpinVar () end
---*  Sets the particle system blend additive.<br>
---* param value True if the particle system is blend additive.
---@param value boolean
---@return self
function ParticleSystem:setBlendAdditive (value) end
---*  Sets the life of each particle.<br>
---* param life The life of each particle.
---@param life float
---@return self
function ParticleSystem:setLife (life) end
---*  Sets the angle variance of each particle.<br>
---* param angleVar The angle variance of each particle.
---@param angleVar float
---@return self
function ParticleSystem:setAngleVar (angleVar) end
---*  Sets the rotation of each particle to its direction.<br>
---* param t True if the rotation is the direction.
---@param t boolean
---@return self
function ParticleSystem:setRotationIsDir (t) end
---* / @{/ @name implement Playable Protocol
---@return self
function ParticleSystem:start () end
---*  Sets the end size variance in pixels of each particle.<br>
---* param sizeVar The end size variance in pixels of each particle.
---@param sizeVar float
---@return self
function ParticleSystem:setEndSizeVar (sizeVar) end
---*  Sets the angle of each particle.<br>
---* param angle The angle of each particle.
---@param angle float
---@return self
function ParticleSystem:setAngle (angle) end
---*  Sets the batch node.<br>
---* param batchNode The batch node.
---@param batchNode cc.ParticleBatchNode
---@return self
function ParticleSystem:setBatchNode (batchNode) end
---*  Gets the tangential acceleration variance.<br>
---* return The tangential acceleration variance.
---@return float
function ParticleSystem:getTangentialAccelVar () end
---*  Switch between different kind of emitter modes:<br>
---* - kParticleModeGravity: uses gravity, speed, radial and tangential acceleration.<br>
---* - kParticleModeRadius: uses radius movement + rotation.<br>
---* return The mode of the emitter.
---@return int
function ParticleSystem:getEmitterMode () end
---*  Sets the end spin variance of each particle.<br>
---* param endSpinVar The end spin variance of each particle.
---@param endSpinVar float
---@return self
function ParticleSystem:setEndSpinVar (endSpinVar) end
---*  initializes a ParticleSystem from a plist file.<br>
---* This plist files can be created manually or with Particle Designer:<br>
---* http:particledesigner.71squared.com/<br>
---* since v0.99.3
---@param plistFile string
---@return boolean
function ParticleSystem:initWithFile (plistFile) end
---*  Gets the angle variance of each particle.<br>
---* return The angle variance of each particle.
---@return float
function ParticleSystem:getAngleVar () end
---*  Sets the start color of each particle.<br>
---* param color The start color of each particle.
---@param color color4f_table
---@return self
function ParticleSystem:setStartColor (color) end
---*  Gets the rotate per second variance.<br>
---* return The rotate per second variance.
---@return float
function ParticleSystem:getRotatePerSecondVar () end
---*  Gets the end size in pixels of each particle.<br>
---* return The end size in pixels of each particle.
---@return float
function ParticleSystem:getEndSize () end
---*  Gets the life of each particle.<br>
---* return The life of each particle.
---@return float
function ParticleSystem:getLife () end
---*  Are the emissions paused<br>
---* return True if the emissions are paused, else false
---@return boolean
function ParticleSystem:isPaused () end
---*  Sets the speed variance.<br>
---* param speed The speed variance.
---@param speed float
---@return self
function ParticleSystem:setSpeedVar (speed) end
---*  Set the particle system auto removed it self on finish.<br>
---* param var True if the particle system removed self on finish.
---@param var boolean
---@return self
function ParticleSystem:setAutoRemoveOnFinish (var) end
---*  Sets the gravity.<br>
---* param g The gravity.
---@param g vec2_table
---@return self
function ParticleSystem:setGravity (g) end
---*  Update the VBO verts buffer which does not use batch node,<br>
---* should be overridden by subclasses. 
---@return self
function ParticleSystem:postStep () end
---*  Sets the emission rate of the particles.<br>
---* param rate The emission rate of the particles.
---@param rate float
---@return self
function ParticleSystem:setEmissionRate (rate) end
---*  Gets the end color variance of each particle.<br>
---* return The end color variance of each particle.
---@return color4f_table
function ParticleSystem:getEndColorVar () end
---*  Whether or not the rotation of each particle to its direction.<br>
---* return True if the rotation is the direction.
---@return boolean
function ParticleSystem:getRotationIsDir () end
---*  Gets the emission rate of the particles.<br>
---* return The emission rate of the particles.
---@return float
function ParticleSystem:getEmissionRate () end
---*  Gets the end color and end color variation of each particle.<br>
---* return The end color and end color variation of each particle.
---@return color4f_table
function ParticleSystem:getEndColor () end
---*  Gets the life variance of each particle.<br>
---* return The life variance of each particle.
---@return float
function ParticleSystem:getLifeVar () end
---*  Sets the start size variance in pixels of each particle.<br>
---* param sizeVar The start size variance in pixels of each particle.
---@param sizeVar float
---@return self
function ParticleSystem:setStartSizeVar (sizeVar) end
---*  Gets the start radius.<br>
---* return The start radius.
---@return float
function ParticleSystem:getStartRadius () end
---*  Gets the Quantity of particles that are being simulated at the moment.<br>
---* return The Quantity of particles that are being simulated at the moment.
---@return unsigned_int
function ParticleSystem:getParticleCount () end
---*  Gets the start radius variance.<br>
---* return The start radius variance.
---@return float
function ParticleSystem:getStartRadiusVar () end
---* js NA<br>
---* lua NA
---@return cc.BlendFunc
function ParticleSystem:getBlendFunc () end
---*  Sets the start color variance of each particle.<br>
---* param color The start color variance of each particle.
---@param color color4f_table
---@return self
function ParticleSystem:setStartColorVar (color) end
---*  Sets the end spin of each particle.<br>
---* param endSpin The end spin of each particle.
---@param endSpin float
---@return self
function ParticleSystem:setEndSpin (endSpin) end
---*  Sets the radial acceleration.<br>
---* param t The radial acceleration.
---@param t float
---@return self
function ParticleSystem:setRadialAccel (t) end
---@overload fun(map_table:map_table,string:string):self
---@overload fun(map_table:map_table):self
---@param dictionary map_table
---@param dirname string
---@return boolean
function ParticleSystem:initWithDictionary (dictionary,dirname) end
---*  Whether or not the particle system removed self on finish.<br>
---* return True if the particle system removed self on finish.
---@return boolean
function ParticleSystem:isAutoRemoveOnFinish () end
---* 
---@return boolean
function ParticleSystem:isSourcePositionCompatible () end
---*  Gets the maximum particles of the system.<br>
---* return The maximum particles of the system.
---@return int
function ParticleSystem:getTotalParticles () end
---*  Sets the start radius variance.<br>
---* param startRadiusVar The start radius variance.
---@param startRadiusVar float
---@return self
function ParticleSystem:setStartRadiusVar (startRadiusVar) end
---* code<br>
---* When this function bound into js or lua,the parameter will be changed<br>
---* In js: var setBlendFunc(var src, var dst)<br>
---* In lua: local setBlendFunc(local src, local dst)<br>
---* endcode
---@param blendFunc cc.BlendFunc
---@return self
function ParticleSystem:setBlendFunc (blendFunc) end
---*  Gets the end radius variance.<br>
---* return The end radius variance.
---@return float
function ParticleSystem:getEndRadiusVar () end
---*  Gets the start color variance of each particle.<br>
---* return The start color variance of each particle.
---@return color4f_table
function ParticleSystem:getStartColorVar () end
---*  Creates an initializes a ParticleSystem from a plist file.<br>
---* This plist files can be created manually or with Particle Designer:<br>
---* http:particledesigner.71squared.com/<br>
---* since v2.0<br>
---* param plistFile Particle plist file name.<br>
---* return An autoreleased ParticleSystem object.
---@param plistFile string
---@return self
function ParticleSystem:create (plistFile) end
---*  Create a system with a fixed number of particles.<br>
---* param numberOfParticles A given number of particles.<br>
---* return An autoreleased ParticleSystemQuad object.<br>
---* js NA
---@param numberOfParticles int
---@return self
function ParticleSystem:createWithTotalParticles (numberOfParticles) end
---*  Gets all ParticleSystem references
---@return array_table
function ParticleSystem:getAllParticleSystems () end
---* 
---@param newScaleY float
---@return self
function ParticleSystem:setScaleY (newScaleY) end
---* 
---@param newScaleX float
---@return self
function ParticleSystem:setScaleX (newScaleX) end
---* 
---@return boolean
function ParticleSystem:isOpacityModifyRGB () end
---*  does the alpha value modify color 
---@param opacityModifyRGB boolean
---@return self
function ParticleSystem:setOpacityModifyRGB (opacityModifyRGB) end
---* 
---@param s float
---@return self
function ParticleSystem:setScale (s) end
---* 
---@param dt float
---@return self
function ParticleSystem:update (dt) end
---*  initializes a ParticleSystem
---@return boolean
function ParticleSystem:init () end
---* 
---@param newRotation float
---@return self
function ParticleSystem:setRotation (newRotation) end
---* js ctor
---@return self
function ParticleSystem:ParticleSystem () end