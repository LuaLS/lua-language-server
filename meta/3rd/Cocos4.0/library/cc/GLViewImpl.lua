---@meta

---@class cc.GLViewImpl :cc.GLView
local GLViewImpl={ }
cc.GLViewImpl=GLViewImpl




---* 
---@param viewName string
---@param rect rect_table
---@param frameZoomFactor float
---@return self
function GLViewImpl:createWithRect (viewName,rect,frameZoomFactor) end
---* 
---@param viewname string
---@return self
function GLViewImpl:create (viewname) end
---* 
---@param viewName string
---@return self
function GLViewImpl:createWithFullScreen (viewName) end
---* 
---@param bOpen boolean
---@return self
function GLViewImpl:setIMEKeyboardState (bOpen) end
---* 
---@return boolean
function GLViewImpl:isOpenGLReady () end
---* 
---@return rect_table
function GLViewImpl:getSafeAreaRect () end