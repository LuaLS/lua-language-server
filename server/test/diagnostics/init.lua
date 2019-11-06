local core    = require 'core'
local buildVM = require 'vm'
local parser  = require 'parser'
local service = require 'service'
local config  = require 'config'

rawset(_G, 'TEST', true)

local function catch_target(script, ...)
    local list = {}
    local function catch(buf)
        local cur = 1
        local cut = 0
        while true do
            local start, finish  = buf:find('<!.-!>', cur)
            if not start then
                break
            end
            list[#list+1] = { start - cut, finish - 4 - cut }
            cur = finish + 1
            cut = cut + 4
        end
    end
    catch(script)
    if ... then
        for _, buf in ipairs {...} do
            catch(buf)
        end
    end
    local new_script = script:gsub('<!(.-)!>', '%1')
    return new_script, list
end

local function founded(targets, results)
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1] and target[2] == result[2] then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

function TEST(script, ...)
    local new_script, target = catch_target(script, ...)
    local lsp = service()
    local ast = parser:parse(new_script, 'lua', 'Lua 5.3')
    assert(ast)
    local lines = parser:lines(new_script)
    local vm = buildVM(ast, lsp, 'test')
    assert(vm)
    local datas = core.diagnostics(vm, lines, 'test')
    local results = {}
    for i, data in ipairs(datas) do
        results[i] = { data.start, data.finish }
    end

    if results[1] then
        if not founded(target, results) then
            error(('%s\n%s'):format(table.dump(target), table.dump(results)))
        end
    else
        assert(#target == 0)
    end
end

require 'diagnostics.normal'
require 'diagnostics.syntax'
