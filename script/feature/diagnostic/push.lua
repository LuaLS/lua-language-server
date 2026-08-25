local File = require 'feature.diagnostic.file'

---@class Feature.Diagnostic.Push
local M = {}

---@param uri Uri
local function refresh(uri)
    local scope = ls.scope.find(uri)
    if not scope then
        return
    end
    local vfile = scope.vm:getFile(uri)
               or scope.vm:createFile(uri)
    ---@async
    ls.await.call(function ()
        File.get(vfile):refresh()
    end)
end

function M.watchFiles()
    ls.file.onDidChange:on(function (uri)
        refresh(uri)
    end)
    ls.file.onDidRemove:on(function (uri)
        local scope = ls.scope.find(uri)
        if not scope then
            return
        end
        local vfile = scope.vm:getFile(uri)
        if vfile then
            File.get(vfile):dispose()
        end
    end)
    ls.scope.onDidLoad:on(function (scope)
        for uri in pairs(scope.vm.vfiles) do
            refresh(uri)
        end
    end)
end

return M
