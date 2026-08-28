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
            ls.scope.waitReady(scope.uri)
            local prog <close> = ls.progress.create(scope.uri, ('正在诊断工作区: %s'):format(scope.name), 1)
            prog:onCancel(function ()
                task:reject(ls.task.REJECT_CANCELED)
            end)
            local results = {}
            local vfiles = {}
            for uri, vfile in pairs(scope.vm.vfiles) do
                vfiles[#vfiles+1] = { uri = uri, vfile = vfile }
            end
            local total = #vfiles
            local done = 0
            for _, item in ipairs(vfiles) do
                done = done + 1
                prog:setMessage(('%d/%d'):format(done, total))
                prog:setPercentage(done / total * 100)
                local file = File.get(item.vfile)
                file:refresh()
                local merged = file:merge()
                if #merged > 0 then
                    results[item.uri] = merged
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
