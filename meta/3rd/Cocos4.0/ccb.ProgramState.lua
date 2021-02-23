---@meta

---@class ccb.ProgramState :cc.Ref
local ProgramState={ }
ccb.ProgramState=ProgramState




---* Set texture.<br>
---* param uniformLocation Specifies texture location.<br>
---* param slot Specifies texture slot selector.<br>
---* param texture Specifies a pointer to backend texture.
---@param uniformLocation cc.backend.UniformLocation
---@param slot unsigned_int
---@param texture cc.backend.TextureBackend
---@return cc.backend.ProgramState
function ProgramState:setTexture (uniformLocation,slot,texture) end
---* Deep clone ProgramState
---@return cc.backend.ProgramState
function ProgramState:clone () end
---* Sets a uniform auto-binding.<br>
---* This method parses the passed in autoBinding string and attempts to convert it<br>
---* to an enumeration value. If it matches to one of the predefined strings, it will create a<br>
---* callback to get the correct value at runtime.<br>
---* param uniformName The name of the material parameter to store an auto-binding for.<br>
---* param autoBinding A string matching one of the built-in AutoBinding enum constants.
---@param uniformName string
---@param autoBinding string
---@return cc.backend.ProgramState
function ProgramState:setParameterAutoBinding (uniformName,autoBinding) end
---* Get the program object.
---@return cc.backend.Program
function ProgramState:getProgram () end
---@overload fun(string0:int):self
---@overload fun(string:string):self
---@param name string
---@return int
function ProgramState:getAttributeLocation (name) end
---* param program Specifies the program.
---@param program cc.backend.Program
---@return cc.backend.ProgramState
function ProgramState:ProgramState (program) end