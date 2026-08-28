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
    return ls.await.yield(function (resume)
        local scope = self.scope
        if self.task then
            self.task:reject(ls.task.REJECT_CANCELED)
        end
        self.task = ls.task.create({ scope = scope }, function (result, err)
            resume(result or {})
        end)
        ---@async
        : execute(function (task)
            local prog <close> = ls.progress.create(scope.uri, '正在诊断工作区', 1)
            prog:onCancel(function ()
                task:reject(ls.task.REJECT_CANCELED)
            end)
            local results = {}
            local total = 0
            for _ in pairs(scope.vm.vfiles) do
                total = total + 1
            end
            local done = 0
            for uri, vfile in pairs(scope.vm.vfiles) do
                done = done + 1
                prog:setPercentage(done / total * 100)
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
