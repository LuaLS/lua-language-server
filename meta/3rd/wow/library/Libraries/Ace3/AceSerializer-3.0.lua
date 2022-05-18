---@meta
---@class AceSerializer-3.0
local AceSerializer = {}

---@param str string The serialized data (from :Serialize)
---@return boolean -- true followed by a list of values, OR false followed by an error message
---@return ... -- List of values or error message
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-serializer-3-0#title-1)
function AceSerializer:Deserialize(str)end

---@param ... any List of values to serialize
---@return string -- The data in its serialized form (string)
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-serializer-3-0#title-2)
function AceSerializer:Serialize(...) end
