---@meta

---@class ccs.SceneReader 
local SceneReader={ }
ccs.SceneReader=SceneReader




---* 
---@param selector function
---@return self
function SceneReader:setTarget (selector) end
---* 
---@param fileName string
---@param attachComponent int
---@return cc.Node
function SceneReader:createNodeWithSceneFile (fileName,attachComponent) end
---* 
---@return int
function SceneReader:getAttachComponentType () end
---* 
---@param nTag int
---@return cc.Node
function SceneReader:getNodeByTag (nTag) end
---* js purge<br>
---* lua destroySceneReader
---@return self
function SceneReader:destroyInstance () end
---* 
---@return char
function SceneReader:sceneReaderVersion () end
---* 
---@return self
function SceneReader:getInstance () end