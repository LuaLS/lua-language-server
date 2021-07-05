---@meta

---@class cc.LabelAtlas :cc.AtlasNode@all parent class: AtlasNode,LabelProtocol
local LabelAtlas={ }
cc.LabelAtlas=LabelAtlas




---* 
---@param label string
---@return self
function LabelAtlas:setString (label) end
---@overload fun(string:string,cc.Texture2D1:string):self
---@overload fun(string:string,cc.Texture2D1:string,int:int,int:int,int:int):self
---@overload fun(string:string,cc.Texture2D:cc.Texture2D,int:int,int:int,int:int):self
---@param string string
---@param texture cc.Texture2D
---@param itemWidth int
---@param itemHeight int
---@param startCharMap int
---@return boolean
function LabelAtlas:initWithString (string,texture,itemWidth,itemHeight,startCharMap) end
---* 
---@return string
function LabelAtlas:getString () end
---@overload fun(string:string,string:string,int:int,int:int,int:int):self
---@overload fun():self
---@overload fun(string:string,string:string):self
---@param string string
---@param charMapFile string
---@param itemWidth int
---@param itemHeight int
---@param startCharMap int
---@return self
function LabelAtlas:create (string,charMapFile,itemWidth,itemHeight,startCharMap) end
---* 
---@return self
function LabelAtlas:updateAtlasValues () end
---* js NA
---@return string
function LabelAtlas:getDescription () end
---* 
---@return self
function LabelAtlas:LabelAtlas () end