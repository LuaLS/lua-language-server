---@class API
local M = {}

---打开文件
---@param uri uri
---@param clientVersion integer?
function M.OpenFile(uri, clientVersion)
    log.info('API:Open File', uri, clientVersion)
    ls.file.manager:openFile(uri, clientVersion)
end

---关闭文件
---@param uri uri
function M.CloseFile(uri)
    log.info('API:Close File', uri)
    ls.file.manager:closeFile(uri)
end

---更新文件内容
---@param uri uri
---@param text string
---@param clientVersion integer?
function M.UpdateFile(uri, text, clientVersion)
    log.info('API:Update File', uri, #text, clientVersion)
    ls.file.manager:setText(uri, text, clientVersion)
end

return M
