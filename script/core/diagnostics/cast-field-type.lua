local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'

---@async
return function (uri, callback)
    if not PREVIEW and not TEST then
        return
    end
    local state = files.getState(uri)
    if not state then
        return
    end

    local fieldNodeCache = {}

    local function getParentField(parent, key)
        if parent.type == 'getlocal' then
            parent = parent.node
        end
        if not fieldNodeCache[parent] then
            fieldNodeCache[parent] = {}
        end
        if fieldNodeCache[parent][key] then
            return fieldNodeCache[parent][key]
        end
        local fieldNode = vm.createNode()
        fieldNodeCache[parent][key] = fieldNode
        for _, class in ipairs(vm.getDefs(parent)) do
            if class.type == 'doc.class' then
                vm.getClassFields(uri, vm.getGlobal('type', class.class[1]), key, false, function (def)
                    if def.type == 'doc.field' then
                        fieldNode:merge(vm.compileNode(def))
                    end
                end)
            end
        end
        return fieldNode
    end

    ---@async
    guide.eachSourceTypes(state.ast, { 'setfield', 'setindex', 'setmethod', 'tablefield', 'tableindex' }, function (ref)
        await.delay()
        if not ref.value then
            return
        end
        local key = guide.getKeyName(ref)
        if not key then
            return nil
        end
        local parent = ref.node
        local fieldNode = getParentField(parent, key)
        if not fieldNode or fieldNode:isEmpty() then
            return
        end
        if vm.canCastType(uri, fieldNode, vm.compileNode(ref.value)) then
            return
        end
        callback {
            start   = ref.start,
            finish  = ref.finish,
            message = lang.script('DIAG_CAST_LOCAL_TYPE', {
                def = vm.getInfer(fieldNode):view(uri),
                ref = vm.getInfer(ref.value):view(uri),
            }),
        }
    end)
end
