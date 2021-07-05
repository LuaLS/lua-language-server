---@meta

---@class cc.Grid3D :cc.GridBase
local Grid3D={ }
cc.Grid3D=Grid3D




---* 
---@return boolean
function Grid3D:getNeedDepthTestForBlit () end
---* Getter and Setter for depth test state when blit.<br>
---* js NA
---@param neededDepthTest boolean
---@return self
function Grid3D:setNeedDepthTestForBlit (neededDepthTest) end
---@overload fun(size_table:size_table,cc.Texture2D1:rect_table):self
---@overload fun(size_table:size_table):self
---@overload fun(size_table:size_table,cc.Texture2D:cc.Texture2D,boolean:boolean):self
---@overload fun(size_table:size_table,cc.Texture2D:cc.Texture2D,boolean:boolean,rect_table:rect_table):self
---@param gridSize size_table
---@param texture cc.Texture2D
---@param flipped boolean
---@param rect rect_table
---@return self
function Grid3D:create (gridSize,texture,flipped,rect) end
---* 
---@return self
function Grid3D:calculateVertexPoints () end
---* Implementations for interfaces in base class.
---@return self
function Grid3D:beforeBlit () end
---* 
---@return self
function Grid3D:afterBlit () end
---* 
---@return self
function Grid3D:reuse () end
---* 
---@return self
function Grid3D:blit () end
---* Constructor.<br>
---* js ctor
---@return self
function Grid3D:Grid3D () end