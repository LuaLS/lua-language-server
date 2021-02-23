---@meta

---@class cc.EaseElasticInOut :cc.EaseElastic
local EaseElasticInOut={ }
cc.EaseElasticInOut=EaseElasticInOut




---* 
---@param action cc.ActionInterval
---@param rate float
---@return self
function EaseElasticInOut:create (action,rate) end
---* 
---@return self
function EaseElasticInOut:clone () end
---* 
---@param time float
---@return self
function EaseElasticInOut:update (time) end
---* 
---@return cc.EaseElastic
function EaseElasticInOut:reverse () end
---* 
---@return self
function EaseElasticInOut:EaseElasticInOut () end