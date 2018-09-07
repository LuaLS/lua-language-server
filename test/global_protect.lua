local mt = {}
setmetatable(_G, mt)

function mt:__index(k)
    error(('读取不存在的全局变量[%s]'):format(k), 2)
end

function mt:__newindex(k, v)
    error(('保存全局变量[%s] = [%s]'):format(k, v), 2)
end
