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
        if change.type == FileChangeType.Created then
            lsp.workspace:addFile(change.uri)
        elseif change.type == FileChangeType.Deleted then
            lsp.workspace:removeFile(change.uri)
        end
        if lsp:getVM(change.uri) then
            needReset = true
        end
    end
    -- 缓存过的文件发生变化后，重新计算
    if needReset then
        lsp.workspace:reset()
    end
end
