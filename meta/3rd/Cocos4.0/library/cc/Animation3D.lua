---@meta

---@class cc.Animation3D :cc.Ref
local Animation3D={ }
cc.Animation3D=Animation3D




---* init Animation3D with file name and animation name
---@param filename string
---@param animationName string
---@return boolean
function Animation3D:initWithFile (filename,animationName) end
---* init Animation3D from bundle data
---@param data cc.Animation3DData
---@return boolean
function Animation3D:init (data) end
---* get duration
---@return float
function Animation3D:getDuration () end
---* read all animation or only the animation with given animationName? animationName == "" read the first.
---@param filename string
---@param animationName string
---@return self
function Animation3D:create (filename,animationName) end
---* 
---@return self
function Animation3D:Animation3D () end