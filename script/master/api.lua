---@class API
local M = {}

--打开文件
---@param uri uri
function M.OpenFile(uri)
    log.info('API:Open File', uri)
    ls.files:openFile(uri)
end

--关闭文件
---@param uri uri
function M.CloseFile(uri)
    log.info('API:Close File', uri)
    ls.files:closeFile(uri)
end

--更新文件内容
function M.UpdateFile(uri, text)
    log.info('API:Update File', uri, #text)
    ls.files:setText(uri, text)
    ls.files:flushDelay(1)
end

return M
