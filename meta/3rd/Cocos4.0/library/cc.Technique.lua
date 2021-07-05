---@meta

---@class cc.Technique :cc.Ref
local Technique={ }
cc.Technique=Technique




---*  Returns the number of Passes in the Technique 
---@return int
function Technique:getPassCount () end
---* 
---@param material cc.Material
---@return self
function Technique:setMaterial (material) end
---*  Returns a new clone of the Technique 
---@return self
function Technique:clone () end
---*  Adds a new pass to the Technique.<br>
---* Order matters. First added, first rendered
---@param pass cc.Pass
---@return self
function Technique:addPass (pass) end
---*  Returns the list of passes 
---@return array_table
function Technique:getPasses () end
---*  Returns the name of the Technique 
---@return string
function Technique:getName () end
---*  Returns the Pass at given index 
---@param index int
---@return cc.Pass
function Technique:getPassByIndex (index) end
---*  Creates a new Technique with a GLProgramState.<br>
---* Method added to support legacy code
---@param parent cc.Material
---@param state cc.backend.ProgramState
---@return self
function Technique:createWithProgramState (parent,state) end
---* 
---@param parent cc.Material
---@return self
function Technique:create (parent) end