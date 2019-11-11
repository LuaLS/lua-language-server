local platform   = require 'bee.platform'
local config     = require 'config'
local glob       = require 'glob'
local furi       = require 'file-uri'
local parser     = require 'parser'
local searcher   = require 'searcher.searcher'
local guide      = require 'parser.guide'

local m = {}

m.openMap = {}
m.fileMap = {}
m.assocVersion = -1
m.assocMatcher = nil
m.globalVersion = 0

--- 打开文件
---@param uri string
function m.open(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    m.openMap[uri] = true
end

--- 关闭文件
---@param uri string
function m.close(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    m.openMap[uri] = nil
end

--- 是否打开
---@param uri string
---@return boolean
function m.isOpen(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    return m.openMap[uri] == true
end

--- 是否存在
---@return boolean
function m.exists(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    return m.fileMap[uri] ~= nil
end

--- 设置文件文本
---@param uri string
---@param text string
function m.setText(uri, text)
    local originUri = uri
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    if not m.fileMap[uri] then
        m.fileMap[uri] = {
            uri = originUri,
        }
    end
    local file = m.fileMap[uri]
    if file.text == text then
        return
    end
    file.text = text
    file.searcher = nil
    file.lines = nil
    file.ast = nil
    file.globals = nil
    file.links = nil
    m.globalVersion = m.globalVersion + 1
    searcher.refreshCache()

    local diagnostic = require 'provider.diagnostic'
    diagnostic.refresh(originUri)
end

--- 监听编译完成
function m.onCompiled(uri, callback)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    local file = m.fileMap[uri]
    if not file then
        return
    end
    if not file.onCompiledList then
        file.onCompiledList = {}
    end
    file.onCompiledList[#file.onCompiledList+1] = callback
end

--- 获取文件文本
---@param uri string
---@return string text
function m.getText(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    return file.text
end

--- 移除文件
---@param uri string
function m.remove(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    local file = m.fileMap[uri]
    if not file then
        return
    end
    m.fileMap[uri] = nil

    m.globalVersion = m.globalVersion + 1
    searcher.refreshCache()

    local diagnostic = require 'service.diagnostic'
    diagnostic.refresh(file.uri)
end

--- 移除所有文件
function m.removeAll()
    for uri in pairs(m.fileMap) do
        m.fileMap[uri] = nil
    end
    m.globalVersion = m.globalVersion + 1
    searcher.refreshCache()
end

--- 遍历文件
function m.eachFile()
    return pairs(m.fileMap)
end

--- 获取文件语法树
---@param uri string
---@return table ast
function m.getAst(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    local file = m.fileMap[uri]
    if file.ast == nil then
        local state, err = parser:compile(file.text, 'lua', config.config.runtime.version)
        if state then
            state.uri = file.uri
            state.ast.uri = file.uri
            file.ast = state
        else
            log.error(err)
            file.ast = false
            return nil
        end
    end
    return file.ast
end

--- 获取文件行信息
---@param uri string
---@return table lines
function m.getLines(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    if not file.lines then
        file.lines = parser:lines(file.text)
    end
    return file.lines
end

--- 获取原始uri
function m.getOriginUri(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    return file.uri
end

--- 寻找全局变量
function m.findGlobals(name)
    local uris = {}
    for uri, file in pairs(m.fileMap) do
        if not file.globals then
            file.globals = {}
            local ast = m.getAst(uri)
            if ast then
                local globals = searcher.getGlobals(ast.ast)
                for name in pairs(globals) do
                    file.globals[name] = true
                end
            end
        end
        if file.globals[name] then
            uris[#uris+1] = file.uri
        end
    end
    return uris
end

--- 寻找link自己的其他文件
function m.findLinkTo(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    local result = {}
    for _, file in pairs(m.fileMap) do
        if file.links == nil then
            local ast = m.getAst(uri)
            if ast then
                file.links = searcher.getLinks(ast.ast)
            else
                file.links = false
            end
        end
        if file.links and file.links[uri] then
            result[#result+1] = file.uri
        end
    end
    return result
end

--- 判断文件名相等
function m.eq(a, b)
    if platform.OS == 'Windows' then
        return a:lower() == b:lower()
    else
        return a == b
    end
end

--- 获取文件关联
function m.getAssoc()
    if m.assocVersion == config.version then
        return m.assocMatcher
    end
    m.assocVersion = config.version
    local patt = {}
    for k, v in pairs(config.other.associations) do
        if m.eq(v, 'lua') then
            patt[#patt+1] = k
        end
    end
    m.assocMatcher = glob.glob(patt)
    if platform.OS == 'Windows' then
        m.assocMatcher:setOption 'ignoreCase'
    end
    return m.assocMatcher
end

--- 判断是否是Lua文件
---@param uri string
---@return boolean
function m.isLua(uri)
    local ext = uri:match '%.([^%.%/%\\]-)$'
    if not ext then
        return false
    end
    if m.eq(ext, 'lua') then
        return true
    end
    local matcher = m.getAssoc()
    local path = furi.decode(uri)
    return matcher(path)
end

return m
