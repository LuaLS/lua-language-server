---@meta

---@class cc.EaseElasticOut :cc.EaseElastic
local EaseElasticOut={ }
cc.EaseElasticOut=EaseElasticOut




---* 
---@param action cc.ActionInterval
---@param rate float
---@return self
function EaseElasticOut:create (action,rate) end
---* 
---@return self
function EaseElasticOut:clone () end
---* 
---@param time float
---@return self
function EaseElasticOut:update (time) end
---* 
---@return cc.EaseElastic
function EaseElasticOut:reverse () end
---* 
---@return self
function EaseElasticOut:EaseElasticOut () end