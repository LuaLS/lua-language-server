local fs = require 'bee.filesystem'
local uric = require 'uri'
local fn   = require 'filename'

local FileChangeType = {
    Created = 1,
    Changed = 2,
    Deleted = 3,
}

--- @param lsp LSP
--- @param params table
return function (lsp, params)
    local needReset = {}
    local needRescan
    for _, change in ipairs(params.changes) do
        local ws = lsp:findWorkspaceFor(change.uri)
        if not ws then
            goto CONTINUE
        end
        local path = uric.decode(change.uri)
        if not path then
            goto CONTINUE
        end
        if change.type == FileChangeType.Created then
            ws:addFile(path)
            if lsp:getVM(change.uri) then
                needReset[ws] = true
            end
        elseif change.type == FileChangeType.Deleted then
            ws:removeFile(path)
            if lsp:getVM(change.uri) then
                needReset[ws] = true
            end
        end
        -- 排除类文件发生更改需要重新扫描
        local filename = path:filename():string()
        if fn.fileNameEq(filename, '.gitignore')
        or fn.fileNameEq(filename, '.gitmodules')
        then
            needRescan = true
        end
        ::CONTINUE::
    end
    if needRescan then
        lsp:reScanFiles()
    end
    -- 缓存过的文件发生变化后，重新计算
    for ws, _ in pairs(needReset) do
        ws:reset()
    end
end
