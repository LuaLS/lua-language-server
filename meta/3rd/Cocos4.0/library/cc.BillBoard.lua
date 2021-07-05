---@meta

---@class cc.BillBoard :cc.Sprite
local BillBoard={ }
cc.BillBoard=BillBoard




---*  Get the billboard rotation mode. 
---@return int
function BillBoard:getMode () end
---*  Set the billboard rotation mode. 
---@param mode int
---@return self
function BillBoard:setMode (mode) end
---@overload fun(string:string,rect_table1:int):self
---@overload fun(string0:int):self
---@overload fun(string:string,rect_table:rect_table,int:int):self
---@param filename string
---@param rect rect_table
---@param mode int
---@return self
function BillBoard:create (filename,rect,mode) end
---* Creates a BillBoard with a Texture2D object.<br>
---* After creation, the rect will be the size of the texture, and the offset will be (0,0).<br>
---* param   texture    A pointer to a Texture2D object.<br>
---* return  An autoreleased BillBoard object
---@param texture cc.Texture2D
---@param mode int
---@return self
function BillBoard:createWithTexture (texture,mode) end
---*  update billboard's transform and turn it towards camera 
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function BillBoard:visit (renderer,parentTransform,parentFlags) end
---* 
---@return self
function BillBoard:BillBoard () end