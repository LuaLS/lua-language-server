---@meta

---@class ccs.ComAudio :cc.Component@all parent class: Component,PlayableProtocol
local ComAudio={ }
ccs.ComAudio=ComAudio




---* 
---@return self
function ComAudio:stopAllEffects () end
---* 
---@return float
function ComAudio:getEffectsVolume () end
---* 
---@param nSoundId unsigned_int
---@return self
function ComAudio:stopEffect (nSoundId) end
---* 
---@return float
function ComAudio:getBackgroundMusicVolume () end
---* 
---@return boolean
function ComAudio:willPlayBackgroundMusic () end
---* 
---@param volume float
---@return self
function ComAudio:setBackgroundMusicVolume (volume) end
---* / @{/ @name implement Playable Protocol
---@return self
function ComAudio:start () end
---@overload fun():self
---@overload fun(boolean:boolean):self
---@param bReleaseData boolean
---@return self
function ComAudio:stopBackgroundMusic (bReleaseData) end
---* 
---@return self
function ComAudio:pauseBackgroundMusic () end
---* 
---@return boolean
function ComAudio:isBackgroundMusicPlaying () end
---* 
---@return boolean
function ComAudio:isLoop () end
---* 
---@return self
function ComAudio:resumeAllEffects () end
---* 
---@return self
function ComAudio:pauseAllEffects () end
---* 
---@param pszFilePath char
---@return self
function ComAudio:preloadBackgroundMusic (pszFilePath) end
---@overload fun(char:char):self
---@overload fun(char:char,boolean:boolean):self
---@overload fun():self
---@param pszFilePath char
---@param bLoop boolean
---@return self
function ComAudio:playBackgroundMusic (pszFilePath,bLoop) end
---* 
---@return self
function ComAudio:stop () end
---* lua endToLua
---@return self
function ComAudio:endToLua () end
---@overload fun(char:char):self
---@overload fun(char:char,boolean:boolean):self
---@overload fun():self
---@param pszFilePath char
---@param bLoop boolean
---@return unsigned_int
function ComAudio:playEffect (pszFilePath,bLoop) end
---* 
---@param pszFilePath char
---@return self
function ComAudio:preloadEffect (pszFilePath) end
---* 
---@param bLoop boolean
---@return self
function ComAudio:setLoop (bLoop) end
---* 
---@param pszFilePath char
---@return self
function ComAudio:unloadEffect (pszFilePath) end
---* 
---@return self
function ComAudio:rewindBackgroundMusic () end
---* 
---@param nSoundId unsigned_int
---@return self
function ComAudio:pauseEffect (nSoundId) end
---* 
---@return self
function ComAudio:resumeBackgroundMusic () end
---* 
---@param pszFilePath char
---@return self
function ComAudio:setFile (pszFilePath) end
---* 
---@param volume float
---@return self
function ComAudio:setEffectsVolume (volume) end
---* 
---@return char
function ComAudio:getFile () end
---* 
---@param nSoundId unsigned_int
---@return self
function ComAudio:resumeEffect (nSoundId) end
---* 
---@return self
function ComAudio:create () end
---* 
---@return cc.Ref
function ComAudio:createInstance () end
---* js NA<br>
---* lua NA
---@return self
function ComAudio:onRemove () end
---* 
---@param r void
---@return boolean
function ComAudio:serialize (r) end
---* 
---@return boolean
function ComAudio:init () end
---* js NA<br>
---* lua NA
---@return self
function ComAudio:onAdd () end