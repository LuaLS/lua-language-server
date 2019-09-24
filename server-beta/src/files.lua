local platform = require 'bee.platform'
local pub      = require 'pub'
local task     = require 'task'
local config   = require 'config'
local glob     = require 'glob'
local furi     = require 'file-uri'

local m = {}

m.openMap = {}
m.fileMap = {}
m.assocVersion = -1
m.assocMatcher = nil

--- 打开文件
function m.open(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    m.openMap[uri] = true
end

--- 关闭文件
function m.close(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    m.openMap[uri] = nil
end

--- 设置文件文本
function m.setText(uri, text)
    local originUri = uri
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    if not m.fileMap[uri] then
        m.fileMap[uri] = {}
    end
    local file = m.fileMap[uri]
    if file.text == text then
        return
    end
    file.text = text
    if file.compiling then
        pub.removeTask(file.compiling)
    end
    file.compiling = pub.syncTask('compile', text, function (ast)
        file.compiling = nil
        file.ast = ast
        if ast then
            ast.uri = originUri
        end
        local onCompiledList = file.onCompiledList
        if onCompiledList then
            file.onCompiledList = nil
            for _, callback in ipairs(onCompiledList) do
                callback()
            end
        end
    end)
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

function m.remove(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    m.fileMap[uri] = nil
end

--- 获取文件语法树（异步）
function m.getAst(uri)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    local file = m.fileMap[uri]
    if not file.compiling then
        return file.ast
    end
    pub.jumpQueue(file.compiling)
    task.wait(function (waker)
        m.onCompiled(file, waker)
    end)
    return file.ast
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
function m.isLua(uri)
    local ext = uri:match '%.(.-)$'
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
