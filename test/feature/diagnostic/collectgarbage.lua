test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.5')
test.scope:buildRoots({})

local metaRoot
for _, root in ipairs(test.scope.roots) do
    if root.kind == 'meta' then
        metaRoot = root
    end
end
assert(metaRoot, 'meta root not built')

local baseUri = metaRoot.uri / 'basic.lua'
local content = ls.afs.read(baseUri)
assert(content)
assert(content:find('"param"', 1, true), '5.5 meta basic.lua should contain param')

local metaFile <close> = ls.file.setServerText(baseUri, content)
metaRoot.uriSet[baseUri] = true
test.scope.vm:indexFile(baseUri)

local gc = test.scope.rt.type('gcoptions')
assert(gc and gc.value, 'gcoptions alias missing')
assert(gc.value:view():find('"param"', 1, true), 'gcoptions should contain param')
assert(gc.value:view():find('"collect"', 1, true), 'gcoptions should contain collect')

local script = [[
collectgarbage('param', 'pause', 200)
collectgarbage('incremental', 200, 200)
collectgarbage('stop')
collectgarbage('not-an-opt')
]]
local file <close> = ls.file.setServerText(test.fileUri, script)
ls.file.setClientText(test.fileUri, script, 1)
test.scope.vm:indexFile(test.fileUri)

local results = ls.feature.diagnostic(test.fileUri)
local mismatches = {}
for _, diag in ipairs(results) do
    if diag.code == 'param-type-mismatch' then
        mismatches[#mismatches+1] = diag
    end
end
assert(#mismatches == 1,
    ('expected 1 param-type-mismatch, actual %d\n%s'):format(#mismatches,
        table.concat((function()
            local m = {}
            for _, d in ipairs(mismatches) do m[#m+1] = d.message end
            return m
        end)(), '\n')))

local doc = assert(test.scope:getDocument(test.fileUri))
local ast = assert(doc.ast)
local strings = ast.nodesMap['string']
assert(strings and strings[1], 'string literal not found')
local src = strings[1]

local hover = ls.feature.hover(test.fileUri, src.start)
local sentinel
if hover then
    for _, item in ipairs(hover.items) do
        if item.description and item.description:find('cgopt', 1, true) then
            sentinel = item.description
        end
    end
end
assert(sentinel, ('expected enum hover description, got nil\nvalue:%s'):format(hover and hover.value or 'nil'))

test.scope.config:set(test.rootUri, 'Lua.runtime.version', nil)
test.scope.roots = {}
