test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.5')
test.scope:buildRoots({})

local metaRoot
for _, root in ipairs(test.scope.roots) do
    if root.kind == 'meta' then
        metaRoot = root
    end
end
assert(metaRoot, 'meta root not built')

local Table = ls.node.register 'Node.Table'
local origInfer = Table.inferGeneric
---@diagnostic disable-next-line
function Table:inferGeneric(other, result)
    local rt = self.scope.rt
    local knownKeys, knownValues = {}, {}
    for field in self.fields:pairsFast() do
        if not field.key.hasGeneric then
            knownKeys[#knownKeys+1] = field.key
        end
        if not field.value.hasGeneric then
            knownValues[#knownValues+1] = field.value
        end
    end
    local knownKey = rt.union(knownKeys)
    local knownValue = rt.union(knownValues)
    print(('INFER self=%s other=%s knownKey=%s(%s) knownValue=%s(%s) other.typeOfKey=%s(%s)'):format(
        self:view(), other:view(),
        knownKey:view(), knownKey.kind,
        knownValue:view(), knownValue.kind,
        other.typeOfKey and other.typeOfKey:view() or 'nil',
        other.typeOfKey and other.typeOfKey.kind or 'nil'))
    local _, otherKey = other.typeOfKey:narrow(knownKey)
    local _, otherValue = other:get(rt.ANY):narrow(knownValue)
    print(('  otherKey=%s(%s) otherValue=%s(%s)'):format(
        otherKey and otherKey:view() or 'nil', otherKey and otherKey.kind or 'nil',
        otherValue and otherValue:view() or 'nil', otherValue and otherValue.kind or 'nil'))
    origInfer(self, other, result)
    for g, v in pairs(result) do
        if g.kind == 'generic' then
            print(('BIND %s := %s (view=%s)'):format(tostring(g.name), v.kind, v:view()))
        end
    end
end

local closers = {}
for _, name in ipairs({ 'basic.lua', 'builtin.lua', 'coroutine.lua' }) do
    local uri = metaRoot.uri / name
    local text = ls.afs.read(uri)
    assert(text, name)
    closers[#closers+1] = ls.file.setServerText(uri, text)
    metaRoot.uriSet[uri] = true
    test.scope.vm:indexFile(uri)
end

local script = [[
---@param thread thread
function probe(thread) end

local wkmt = { __mode = 'k' }

---@class await
local m = {}
m.idMap = {}

local function setID(id, co, callback)
    if not m.idMap[id] then
        m.idMap[id] = setmetatable({}, wkmt)
    end
    m.idMap[id][co] = callback or true
end

function m.close(id)
    local map = m.idMap[id]
    if not map then
        return
    end
    for co, callback in pairs(map) do
        probe(co)
    end
end

m.setID('x')
]]

local file = ls.file.setServerText(test.fileUri, script)
ls.file.setClientText(test.fileUri, script, 1)
test.scope.vm:indexFile(test.fileUri)

local results = ls.feature.diagnostic(test.fileUri)
for _, diag in ipairs(results) do
    print(('%s@%d-%d %s'):format(diag.code, diag.start, diag.finish, diag.message))
end

for _, c in ipairs(closers) do
    c()
end
test.scope.config:set(test.rootUri, 'Lua.runtime.version', nil)
test.scope.roots = {}
