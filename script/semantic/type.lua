local guide = require 'parser.guide'

---@alias Type.Category 'class'|'alias'|'enum'|'unknown'

---@class SType
---@overload fun(name: string): self
---@field private name string
---@field private subMgr SubMgr
---@field private cate Type.Category|nil
local Type = Class 'SType'

---@private
---@type table<string, SType>
Type.allTypes = LS.util.multiTable(2, function (name)
    return New 'Type' (name)
end)

---@private
---@type table<uri, table<string, boolean>>
Type.uriSubs = LS.util.multTable(2)

---@param name string
function Type:__call(name)
    self.name = name
    self.subMgr = New 'SubMgr' ()
    return self
end

-- 获取类型名称
---@return string
function Type:getName()
    return self.name
end

-- 获取类型的分类（根据可见性）
---@param suri uri
---@return Type.Category
function Type:getCate(suri)
    if self.cate then
        return self.cate
    end
    self.cate = 'unknown'
    for _, set in ipairs(self.subMgr:getSets(suri)) do
        if set.type == 'doc.class' then
            self.cate = 'class'
            break
        end
        if set.type == 'doc.alias' then
            self.cate = 'alias'
            break
        end
        if set.type == 'doc.enum' then
            self.cate = 'enum'
            break
        end
    end
    return self.cate
end

-- 添加一个订阅（赋值）
---@param uri uri
---@param obj parser.object
function Type:addSet(uri, obj)
    self.subMgr:addSet(uri, obj)
    Type.uriSubs[uri][self.name] = true
end

-- 添加一个订阅（获取）
function Type:addGet(uri, obj)
    self.subMgr:addGet(uri, obj)
    Type.uriSubs[uri][self.name] = true
end

-- 丢弃链接，如果没有任何链接则移除整个类型
---@package
---@param uri uri
function Type:dropUri(uri)
    self:clearCache()
    self.subMgr:dropUri(uri)
    if not self.subMgr:hasAnyLink() then
        Type.allTypes[self.name] = nil
    end
end

---@private
function Type:clearCache()
    self.cate = nil
end

-- 预编译语法树，绑定所有类型
---@param source parser.object
function Type.compileAst(source)
    local uri = guide.getUri(source)
    guide.eachSourceTypes(source.docs, {
        'doc.class',
        'doc.alias',
        'doc.enum',
     }, function (src)
        local name = guide.getKeyName(src)
        if not name then
            return
        end
        local type = Type.get(name)
        type:addSet(uri, src)
    end)
end

-- 获取一个类型
---@param name string
---@return SType
function Type.get(name)
    return Type.allTypes[name]
end

-- 丢弃整个文件内的所有订阅
---@param uri uri
function Type.dropByUri(uri)
    local subs = Type.uriSubs[uri]
    Type.uriSubs[uri] = nil
    for name in pairs(subs) do
        local subType = Type.allTypes[name]
        subType:dropUri(uri)
    end
end
