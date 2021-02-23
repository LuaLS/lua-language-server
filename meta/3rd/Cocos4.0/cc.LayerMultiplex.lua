---@meta

---@class cc.LayerMultiplex :cc.Layer
local LayerMultiplex={ }
cc.LayerMultiplex=LayerMultiplex




---*  initializes a MultiplexLayer with an array of layers<br>
---* since v2.1
---@param arrayOfLayers array_table
---@return boolean
function LayerMultiplex:initWithArray (arrayOfLayers) end
---*  release the current layer and switches to another layer indexed by n.<br>
---* The current (old) layer will be removed from it's parent with 'cleanup=true'.<br>
---* param n The layer indexed by n will display.
---@param n int
---@return self
function LayerMultiplex:switchToAndReleaseMe (n) end
---*  Add a certain layer to LayerMultiplex.<br>
---* param layer A layer need to be added to the LayerMultiplex.
---@param layer cc.Layer
---@return self
function LayerMultiplex:addLayer (layer) end
---@overload fun(int:int,boolean:boolean):self
---@overload fun(int:int):self
---@param n int
---@param cleanup boolean
---@return self
function LayerMultiplex:switchTo (n,cleanup) end
---* 
---@return boolean
function LayerMultiplex:init () end
---* 
---@return string
function LayerMultiplex:getDescription () end
---* js ctor
---@return self
function LayerMultiplex:LayerMultiplex () end