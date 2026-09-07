TEST_DIAGNOSTIC [[
---@return number
local function f()
    return <?'str'?>
end
f()
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@return number
local function f()
    return 1
end
f()
]] { '-return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@return number
---@return string
local function f()
    return 1, <?{}?>
end
f()
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class docUnion
---@field name string

local export = {}

export.makeDocObject = setmetatable({}, { __index = function (t, k)
    return function ()
    end
end })

export.makeDocObject['INIT'] = function (source, has_seen)
    return {
        type = source.cate or source.type,
        name = export.documentObject(source.name, has_seen),
    }
end

export.makeDocObject['doc.type.function'] = function (source, obj, has_seen)
    obj.args = export.documentObject(source.args, has_seen)
    obj.returns = export.documentObject(source.returns, has_seen)
end

export.makeDocObject['funcargs'] = function (source, obj, has_seen)
    local objs = {}
    for i, child in ipairs(source) do
        objs[i] = export.documentObject(child, has_seen)
    end
    return objs
end

---@return docUnion | [docUnion] | string | number | boolean | nil
function export.documentObject(source, has_seen)
    if type(source) ~= 'table' then
        return source
    end
    local obj = export.makeDocObject['INIT'](source, has_seen)
    local res = export.makeDocObject[obj.type](source, obj, has_seen)
    if res == false then
        return nil
    end
    return res or obj
end
export.documentObject({})
]] { '-return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class A
---@field name string

---@return A | [A] | string | number | boolean | nil
local function g(x)
    return nil
end

---@return A | [A] | string | number | boolean | nil
local function f(source)
    local objs = {}
    objs[1] = g(source)
    return <?objs?>
end
f(1)
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class A
---@field name string

---@return A | [A] | string | number | boolean | nil
local function g(x)
    return nil
end

---@return A | [A] | string | number | boolean | nil
local function f(source)
    local obj = {
        name = g(source),
    }
    return obj
end
f(1)
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class A
---@field name string

---@return A
local function g(x)
    return {
        name = 'x',
    }
end

---@return A[]
local function f(source)
    local objs = {}
    objs[1] = g(source)
    return objs
end
f(1)
]] { '-return-type-mismatch' }
