---@meta

---@class cc.EaseElasticIn :cc.EaseElastic
local EaseElasticIn={ }
cc.EaseElasticIn=EaseElasticIn




---* 
---@param action cc.ActionInterval
---@param rate float
---@return self
function EaseElasticIn:create (action,rate) end
---* 
---@return self
function EaseElasticIn:clone () end
---* 
---@param time float
---@return self
function EaseElasticIn:update (time) end
---* 
---@return cc.EaseElastic
function EaseElasticIn:reverse () end
---* 
---@return self
function EaseElasticIn:EaseElasticIn () end