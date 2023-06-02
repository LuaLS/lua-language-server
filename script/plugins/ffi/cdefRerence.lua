local files     = require 'files'
local guide     = require 'parser.guide'
local vm        = require 'vm'
local reference = require 'core.reference'
local find      = string.find
local remove    = table.remove

local function getCdefSourcePosition(ffi_state)
    local cdef_position = ffi_state.ast.returns[1][1]
    local source = vm.getFields(cdef_position)
    for index, value in ipairs(source) do
        local name = guide.getKeyName(value)
        if name == 'cdef' then
            return value.field.start
        end
    end
end

---@async
return function ()
    local ffi_state
    for uri in files.eachFile() do
        if find(uri, "ffi.lua", 0, true) and find(uri, "meta", 0, true) then
            ffi_state = files.getState(uri)
            break
        end
    end
    if ffi_state then
        local res = reference(ffi_state.uri, getCdefSourcePosition(ffi_state), true)
        if res then
            if res[1].uri == ffi_state.uri then
                remove(res, 1)
            end
            return res
        end
    end
end
