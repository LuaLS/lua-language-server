---@meta

---@class cc.EventListenerAssetsManagerEx :cc.EventListenerCustom
local EventListenerAssetsManagerEx={ }
cc.EventListenerAssetsManagerEx=EventListenerAssetsManagerEx




---*  Initializes event with type and callback function 
---@param AssetsManagerEx cc.AssetsManagerEx
---@param callback function
---@return boolean
function EventListenerAssetsManagerEx:init (AssetsManagerEx,callback) end
---* 
---@return self
function EventListenerAssetsManagerEx:clone () end
---* / Overrides
---@return boolean
function EventListenerAssetsManagerEx:checkAvailable () end
---*  Constructor 
---@return self
function EventListenerAssetsManagerEx:EventListenerAssetsManagerEx () end