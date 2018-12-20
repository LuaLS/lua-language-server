local FileChangeType = {
    Created = 1,
    Changed = 2,
    Deleted = 3,
}

return function (lsp, params)
    if not lsp.workspace then
        return
    end
    for _, change in ipairs(params.changes) do
        if change.type == FileChangeType.Created then
            lsp.workspace:addFile(change.uri)
        elseif change.type == FileChangeType.Deleted then
            lsp.workspace:removeFile(change.uri)
            -- 删除文件后，清除该文件的诊断
            lsp:clearDiagnostics(change.uri)
        end
    end
    -- 发生任何文件变化后，重新计算当前的打开文件
end
