local fs = require 'bee.filesystem'
local uric = require 'uri'

local FileChangeType = {
    Created = 1,
    Changed = 2,
    Deleted = 3,
}

return function (lsp, params)
    if not lsp.workspace then
        return
    end
    local needReset
    for _, change in ipairs(params.changes) do
        local path = uric.decode(change.uri)
        if not path then
            goto CONTINUE
        end
        if change.type == FileChangeType.Created then
            lsp.workspace:addFile(path)
            if lsp:getVM(change.uri) then
                needReset = true
            end
        elseif change.type == FileChangeType.Deleted then
            lsp.workspace:removeFile(path)
            if lsp:getVM(change.uri) then
                needReset = true
            end
        end
        -- 排除类文件发生更改需要重新扫描
        local filename = path:filename():string()
        if lsp.workspace:fileNameEq(filename, '.gitignore')
        or lsp.workspace:fileNameEq(filename, '.gitmodules')
        then
            lsp:reScanFiles()
        end
        ::CONTINUE::
    end
    -- 缓存过的文件发生变化后，重新计算
    if needReset then
        lsp.workspace:reset()
    end
end
