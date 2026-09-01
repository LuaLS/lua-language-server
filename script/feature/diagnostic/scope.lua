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

---@package
---@type Timer?
M.refreshTimer = nil

---@param sec number
function M:refreshAfter(sec)
    self.refreshTimer?:remove()
    self.refreshTimer = ls.timer.wait(sec, function ()
        self:refreshNow()
    end)
end

---@return Task
function M:refreshNow()
    self.refreshTimer?:remove()
    self.task?.reject(ls.task.REJECT_CANCELED)

    local scope = self.scope
    self.task = ls.task.create()
        ---@async
        : execute(function (task)
            ls.scope.waitReady(scope.uri)
            local prog <close> = ls.progress.create(scope.uri, ('正在诊断工作区: %s'):format(scope.name), 0.1)
            prog:onCancel(function ()
                task:reject(ls.task.REJECT_CANCELED)
            end)

            local vfiles = scope.vm.vfiles
            local total = #vfiles
            prog:setMessage('%d/%d' % { 0, total })

            ---@type table<Uri, Feature.Diagnostic[]>
            local results = {}

            for i, vfile in ipairs(vfiles) do
                results[vfile.uri] = vfile.diagnostic:refresh():await()

                prog:setMessage(('%d/%d'):format(i, total))
                prog:setPercentage(i / total * 100)
                task:delay()
            end

            task:resolve(results)
        end)

    return self.task
end
