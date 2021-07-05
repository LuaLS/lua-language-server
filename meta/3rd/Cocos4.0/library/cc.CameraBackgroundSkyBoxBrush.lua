---@meta

---@class cc.CameraBackgroundSkyBoxBrush :cc.CameraBackgroundBrush
local CameraBackgroundSkyBoxBrush={ }
cc.CameraBackgroundSkyBoxBrush=CameraBackgroundSkyBoxBrush




---* 
---@param valid boolean
---@return self
function CameraBackgroundSkyBoxBrush:setTextureValid (valid) end
---* Set skybox texture <br>
---* param texture Skybox texture
---@param texture cc.TextureCube
---@return self
function CameraBackgroundSkyBoxBrush:setTexture (texture) end
---* 
---@param actived boolean
---@return self
function CameraBackgroundSkyBoxBrush:setActived (actived) end
---* 
---@return boolean
function CameraBackgroundSkyBoxBrush:isActived () end
---@overload fun():self
---@overload fun(string:string,string:string,string:string,string:string,string:string,string:string):self
---@param positive_x string
---@param negative_x string
---@param positive_y string
---@param negative_y string
---@param positive_z string
---@param negative_z string
---@return self
function CameraBackgroundSkyBoxBrush:create (positive_x,negative_x,positive_y,negative_y,positive_z,negative_z) end
---* Get brush type. Should be BrushType::SKYBOX<br>
---* return brush type
---@return int
function CameraBackgroundSkyBoxBrush:getBrushType () end
---* Draw background
---@param camera cc.Camera
---@return self
function CameraBackgroundSkyBoxBrush:drawBackground (camera) end
---* init Skybox.
---@return boolean
function CameraBackgroundSkyBoxBrush:init () end
---* 
---@return boolean
function CameraBackgroundSkyBoxBrush:isValid () end
---* 
---@return self
function CameraBackgroundSkyBoxBrush:CameraBackgroundSkyBoxBrush () end