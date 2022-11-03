---JSON API documentation
---Manipulation of JSON data strings.
---@class json
json = {}
---Decode a string of JSON data into a Lua table.
---A Lua error is raised for syntax errors.
---@param json string # json data
---@return table # decoded json
function json.decode(json) end

---Encode a lua table to a JSON string.
---A Lua error is raised for syntax errors.
---@param tbl table # lua table to encode
---@return string # encoded json
function json.encode(tbl) end




return json