local platform = require 'bee.platform'

local m = {}

m.openMap = {}
m.textMap = {}
m.astMap = {}

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
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    m.textMap[uri] = text
end

--- 设置文件语法树
function m.setAst(uri, ast)
    if platform.OS == 'Windows' then
        uri = uri:lower()
    end
    m.astMap[uri] = ast
end

return m
