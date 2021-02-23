---@meta

---@class ccui.LinearLayoutParameter :ccui.LayoutParameter
local LinearLayoutParameter={ }
ccui.LinearLayoutParameter=LinearLayoutParameter




---* Sets LinearGravity parameter for LayoutParameter.<br>
---* see LinearGravity<br>
---* param gravity Gravity in LinearGravity.
---@param gravity int
---@return self
function LinearLayoutParameter:setGravity (gravity) end
---* Gets LinearGravity parameter for LayoutParameter.<br>
---* see LinearGravity<br>
---* return LinearGravity
---@return int
function LinearLayoutParameter:getGravity () end
---* Create a empty LinearLayoutParameter instance.<br>
---* return A initialized LayoutParameter which is marked as "autorelease".
---@return self
function LinearLayoutParameter:create () end
---* 
---@return ccui.LayoutParameter
function LinearLayoutParameter:createCloneInstance () end
---* 
---@param model ccui.LayoutParameter
---@return self
function LinearLayoutParameter:copyProperties (model) end
---* Default constructor.<br>
---* lua new
---@return self
function LinearLayoutParameter:LinearLayoutParameter () end