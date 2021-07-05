---@meta

---@class cc.AsyncTaskPool 
local AsyncTaskPool={ }
cc.AsyncTaskPool=AsyncTaskPool




---@overload fun(int:int,function:function):self
---@overload fun(int:int,function:function,void:void,function:function):self
---@param type int
---@param callback function
---@param callbackParam void
---@param task function
---@return self
function AsyncTaskPool:enqueue (type,callback,callbackParam,task) end
---* Stop tasks.<br>
---* param type Task type you want to stop.
---@param type int
---@return self
function AsyncTaskPool:stopTasks (type) end
---* Destroys the async task pool.
---@return self
function AsyncTaskPool:destroyInstance () end
---* Returns the shared instance of the async task pool.
---@return self
function AsyncTaskPool:getInstance () end
---* 
---@return self
function AsyncTaskPool:AsyncTaskPool () end