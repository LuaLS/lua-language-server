---@meta

---@class cc.CameraBackgroundDepthBrush :cc.CameraBackgroundBrush
local CameraBackgroundDepthBrush={ }
cc.CameraBackgroundDepthBrush=CameraBackgroundDepthBrush




---* Set depth<br>
---* param depth Depth used to clear depth buffer
---@param depth float
---@return self
function CameraBackgroundDepthBrush:setDepth (depth) end
---* Create a depth brush<br>
---* param depth Depth used to clear the depth buffer<br>
---* return Created brush
---@param depth float
---@return self
function CameraBackgroundDepthBrush:create (depth) end
---* Get brush type. Should be BrushType::DEPTH<br>
---* return brush type
---@return int
function CameraBackgroundDepthBrush:getBrushType () end
---* Draw background
---@param camera cc.Camera
---@return self
function CameraBackgroundDepthBrush:drawBackground (camera) end
---* 
---@return boolean
function CameraBackgroundDepthBrush:init () end
---* 
---@return self
function CameraBackgroundDepthBrush:CameraBackgroundDepthBrush () end