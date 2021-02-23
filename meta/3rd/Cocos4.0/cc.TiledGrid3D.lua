---@meta

---@class cc.TiledGrid3D :cc.GridBase
local TiledGrid3D={ }
cc.TiledGrid3D=TiledGrid3D




---@overload fun(size_table:size_table,cc.Texture2D1:rect_table):self
---@overload fun(size_table:size_table):self
---@overload fun(size_table:size_table,cc.Texture2D:cc.Texture2D,boolean:boolean):self
---@overload fun(size_table:size_table,cc.Texture2D:cc.Texture2D,boolean:boolean,rect_table:rect_table):self
---@param gridSize size_table
---@param texture cc.Texture2D
---@param flipped boolean
---@param rect rect_table
---@return self
function TiledGrid3D:create (gridSize,texture,flipped,rect) end
---* 
---@return self
function TiledGrid3D:calculateVertexPoints () end
---* Implementations for interfaces in base class.
---@return self
function TiledGrid3D:blit () end
---* 
---@return self
function TiledGrid3D:reuse () end