---@meta

---@class ccs.ComAttribute :cc.Component
local ComAttribute={ }
ccs.ComAttribute=ComAttribute




---* 
---@param key string
---@param def float
---@return float
function ComAttribute:getFloat (key,def) end
---* 
---@param key string
---@param def string
---@return string
function ComAttribute:getString (key,def) end
---* 
---@param key string
---@param value float
---@return self
function ComAttribute:setFloat (key,value) end
---* 
---@param key string
---@param value string
---@return self
function ComAttribute:setString (key,value) end
---* 
---@param key string
---@param def boolean
---@return boolean
function ComAttribute:getBool (key,def) end
---* 
---@param key string
---@param value int
---@return self
function ComAttribute:setInt (key,value) end
---* 
---@param jsonFile string
---@return boolean
function ComAttribute:parse (jsonFile) end
---* 
---@param key string
---@param def int
---@return int
function ComAttribute:getInt (key,def) end
---* 
---@param key string
---@param value boolean
---@return self
function ComAttribute:setBool (key,value) end
---* 
---@return self
function ComAttribute:create () end
---* 
---@return cc.Ref
function ComAttribute:createInstance () end
---* 
---@return boolean
function ComAttribute:init () end
---* 
---@param r void
---@return boolean
function ComAttribute:serialize (r) end