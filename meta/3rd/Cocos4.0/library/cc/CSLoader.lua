---@meta

---@class cc.CSLoader 
local CSLoader={ }
cc.CSLoader=CSLoader




---* 
---@param filename string
---@return cc.Node
function CSLoader:createNodeFromJson (filename) end
---* 
---@param filename string
---@return cc.Node
function CSLoader:createNodeWithFlatBuffersFile (filename) end
---* 
---@param fileName string
---@return cc.Node
function CSLoader:loadNodeWithFile (fileName) end
---* 
---@param callbackName string
---@param callbackType string
---@param sender ccui.Widget
---@param handler cc.Node
---@return boolean
function CSLoader:bindCallback (callbackName,callbackType,sender,handler) end
---* 
---@param jsonPath string
---@return self
function CSLoader:setJsonPath (jsonPath) end
---* 
---@return self
function CSLoader:init () end
---* 
---@param content string
---@return cc.Node
function CSLoader:loadNodeWithContent (content) end
---* 
---@return boolean
function CSLoader:isRecordJsonPath () end
---* 
---@return string
function CSLoader:getJsonPath () end
---* 
---@param record boolean
---@return self
function CSLoader:setRecordJsonPath (record) end
---* 
---@param filename string
---@return cc.Node
function CSLoader:createNodeWithFlatBuffersForSimulator (filename) end
---* 
---@return self
function CSLoader:destroyInstance () end
---@overload fun(string:string,function:function):self
---@overload fun(string:string):self
---@param filename string
---@param callback function
---@return cc.Node
function CSLoader:createNodeWithVisibleSize (filename,callback) end
---* 
---@return self
function CSLoader:getInstance () end
---* 
---@return self
function CSLoader:CSLoader () end