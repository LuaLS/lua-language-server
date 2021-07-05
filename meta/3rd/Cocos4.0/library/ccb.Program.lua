---@meta

---@class ccb.Program :cc.Ref
local Program={ }
ccb.Program=Program




---* Get maximum vertex location.<br>
---* return Maximum vertex locaiton.
---@return int
function Program:getMaxVertexLocation () end
---* Get maximum fragment location.<br>
---* return Maximum fragment location.
---@return int
function Program:getMaxFragmentLocation () end
---* Get fragment shader.<br>
---* Fragment shader.
---@return string
function Program:getFragmentShader () end
---* Get uniform buffer size in bytes that can hold all the uniforms.<br>
---* param stage Specifies the shader stage. The symbolic constant can be either VERTEX or FRAGMENT.<br>
---* return The uniform buffer size in bytes.
---@param stage int
---@return unsigned_int
function Program:getUniformBufferSize (stage) end
---@overload fun(string0:int):self
---@overload fun(string:string):self
---@param uniform string
---@return cc.backend.UniformLocation
function Program:getUniformLocation (uniform) end
---* Get engine built-in program type.<br>
---* return The built-in program type.
---@return int
function Program:getProgramType () end
---* Get active vertex attributes.<br>
---* return Active vertex attributes. key is active attribute name, Value is corresponding attribute info.
---@return map_table
function Program:getActiveAttributes () end
---@overload fun(string0:int):self
---@overload fun(string:string):self
---@param name string
---@return int
function Program:getAttributeLocation (name) end
---* Get vertex shader.<br>
---* return Vertex shader.
---@return string
function Program:getVertexShader () end
---* Get engine built-in program.<br>
---* param type Specifies the built-in program type.
---@param type int
---@return cc.backend.Program
function Program:getBuiltinProgram (type) end