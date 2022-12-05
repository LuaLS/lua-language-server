---@meta

---@class ccs.GUIReader :cc.Ref
local GUIReader={ }
ccs.GUIReader=GUIReader




---* 
---@param strFilePath string
---@return self
function GUIReader:setFilePath (strFilePath) end
---* 
---@param fileName char
---@return ccui.Widget
function GUIReader:widgetFromJsonFile (fileName) end
---* 
---@return string
function GUIReader:getFilePath () end
---* 
---@param fileName char
---@return ccui.Widget
function GUIReader:widgetFromBinaryFile (fileName) end
---* 
---@param str char
---@return int
function GUIReader:getVersionInteger (str) end
---* 
---@return self
function GUIReader:destroyInstance () end
---* 
---@return self
function GUIReader:getInstance () end