test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.5')
test.scope:buildRoots({})

local metaRoot
for _, root in ipairs(test.scope.roots) do
    if root.kind == 'meta' then
        metaRoot = root
    end
end
assert(metaRoot, 'meta root not built')

for _, name in ipairs({ 'basic.lua', 'io.lua', 'package.lua' }) do
    local uri = metaRoot.uri / name
    local content = ls.afs.read(uri)
    if content then
        local metaFile <close> = ls.file.setServerText(uri, content)
        metaRoot.uriSet[uri] = true
        test.scope.vm:indexFile(uri)
    end
end

local script = [[
local function search(name)
    local filename, err = package.searchpath(name, package.path)
    if not filename then
        return err
    end
    io.open(filename)
end
]]
local file <close> = ls.file.setServerText(test.fileUri, script)
ls.file.setClientText(test.fileUri, script, 1)
test.scope.vm:indexFile(test.fileUri)

local results = ls.feature.diagnostic(test.fileUri)
for _, diag in ipairs(results) do
    assert(diag.code ~= 'param-type-mismatch',
        ('param-type-mismatch should NOT fire: %s'):format(diag.message))
end

test.scope.config:set(test.rootUri, 'Lua.runtime.version', nil)
test.scope.roots = {}
