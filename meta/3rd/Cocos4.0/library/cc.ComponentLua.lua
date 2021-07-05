---@meta

---@class cc.ComponentLua :cc.Component
local ComponentLua={ }
cc.ComponentLua=ComponentLua




---* This function is used to be invoked from lua side to get the corresponding script object of this component.
---@return void
function ComponentLua:getScriptObject () end
---* 
---@param dt float
---@return self
function ComponentLua:update (dt) end
---* 
---@param scriptFileName string
---@return self
function ComponentLua:create (scriptFileName) end
---* 
---@param scriptFileName string
---@return self
function ComponentLua:ComponentLua (scriptFileName) end