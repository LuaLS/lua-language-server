---@meta

---@class ccs.ActionTimelineCache 
local ActionTimelineCache={ }
ccs.ActionTimelineCache=ActionTimelineCache




---*  Clone a action with the specified name from the container. 
---@param fileName string
---@return ccs.ActionTimeline
function ActionTimelineCache:createActionFromJson (fileName) end
---* 
---@param fileName string
---@return ccs.ActionTimeline
function ActionTimelineCache:createActionWithFlatBuffersFile (fileName) end
---* 
---@param fileName string
---@return ccs.ActionTimeline
function ActionTimelineCache:loadAnimationActionWithFlatBuffersFile (fileName) end
---* 
---@param fileName string
---@param content string
---@return ccs.ActionTimeline
function ActionTimelineCache:createActionFromContent (fileName,content) end
---* 
---@return self
function ActionTimelineCache:purge () end
---* 
---@return self
function ActionTimelineCache:init () end
---* 
---@param fileName string
---@param content string
---@return ccs.ActionTimeline
function ActionTimelineCache:loadAnimationActionWithContent (fileName,content) end
---* 
---@param fileName string
---@return ccs.ActionTimeline
function ActionTimelineCache:loadAnimationActionWithFile (fileName) end
---*  Remove action with filename, and also remove other resource relate with this file 
---@param fileName string
---@return self
function ActionTimelineCache:removeAction (fileName) end
---* 
---@param fileName string
---@return ccs.ActionTimeline
function ActionTimelineCache:createActionWithFlatBuffersForSimulator (fileName) end
---*  Destroys the singleton 
---@return self
function ActionTimelineCache:destroyInstance () end
---* 
---@param fileName string
---@return ccs.ActionTimeline
function ActionTimelineCache:createAction (fileName) end