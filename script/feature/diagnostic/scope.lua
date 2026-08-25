local File = require 'feature.diagnostic.file'

---@class Feature.Diagnostic.Scope: Class.Base
---@field scope Scope
local M = Class 'Feature.Diagnostic.Scope'

---@type Scope
M.scope = nil
---@type Task?
M.task = nil

---@param scope Scope
function M:__init(scope)
    self.scope = scope
end

---@async
---@return table<Uri, Feature.Diagnostic[]>
function M:fetchAll()
    local scope = self.scope
    if self.task then
        self.task:reject(ls.task.REJECT_CANCELED)
        self.task = nil
    end
    local task = ls.task.create { scope = scope }
    self.task = task
    return ls.await.yield(function (resume)
        task.callback = function (result, err)
            if err then
                resume({})
            else
                resume(result)
            end
        end
        ---@async
        task:execute(function ()
            local results = {}
            for uri, vfile in pairs(scope.vm.vfiles) do
                local file = File.get(vfile)
                file:refresh()
                local merged = file:merge()
                if #merged > 0 then
                    results[uri] = merged
                end
            end
            task:resolve(results)
        end)
    end)
end

---@param scope Scope
---@return Feature.Diagnostic.Scope
function M.get(scope)
    if not scope.diagnostic then
        scope.diagnostic = New 'Feature.Diagnostic.Scope' (scope)
    end
    return scope.diagnostic
end

return M
