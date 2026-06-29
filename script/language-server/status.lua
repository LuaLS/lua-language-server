---@class LanguageServer
local M = Class 'LanguageServer'

---@type table?
local lastReporting
---@type Timer?
local lastTimer

local function makeToolTips()
    local document = require 'scope.document'
    local vfile = require 'vm.virtual_file'
    local lines = {}
    lines[#lines+1] = '内存占用：{%.f}MB' % { collectgarbage('count') / 1024 }
    lines[#lines+1] = '文件数量：{}/{}' % { ls.util.countTable(ls.file.all), ls.util.countTable(ls.file.traceMap) }
    lines[#lines+1] = '文档数量：{}' % { ls.util.countTable(document.traceDocumentMap) }
    lines[#lines+1] = '语法树数量：{}' % { ls.util.countTable(document.traceAstMap) }
    lines[#lines+1] = '虚拟文件数量：{}' % { ls.util.countTable(vfile.traceMap) }

    lines[#lines+1] = '工作区：'
    for i, scope in ipairs(ls.scope.all) do
        lines[#lines+1] = ('%d. %s'):format(i, scope.name)
        for _, root in ipairs(scope.roots) do
            lines[#lines+1] = '  - ' .. ls.uri.decode(root.uri)
        end
    end

    return table.concat(lines, '\n')
end

local function makeReporting()
    local idleTime = ls.eventLoop.getIdleTime()

    local result = {
        text = idleTime < 0.5 and '$(loading~spin)Lua'
            or idleTime < 60 and '😺Lua'
            or '💤Lua',
        tooltip = makeToolTips(),
    }

    if ls.util.equal(lastReporting, result) then
        return nil
    end

    lastReporting = result
    return result
end

function M:refreshStatusReporting()
    if not self.client.params.initializationOptions.statusBar then
        return
    end

    self.client:notify('$/status/show', {})

    if lastTimer then
        lastTimer:remove()
    end

    lastTimer = nil
    lastReporting = nil
    lastTimer = ls.timer.loop(1, function ()
        local reporting = makeReporting()
        if not reporting then
            return
        end
        self.client:notify('$/status/report', reporting)
    end)
end
