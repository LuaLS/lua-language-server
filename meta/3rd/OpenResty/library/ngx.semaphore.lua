---@meta
ngx_semaphore={}
function ngx_semaphore.count(self) end
function ngx_semaphore.new(n) end
function ngx_semaphore.wait(self, seconds) end
function ngx_semaphore.post(self, n) end
ngx_semaphore.version="0.1.17"
return ngx_semaphore