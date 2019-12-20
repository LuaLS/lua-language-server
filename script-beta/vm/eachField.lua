local guide   = require 'parser.guide'
local files   = require 'files'
local vm      = require 'vm.vm'

local function checkNext(source)
    local nextSrc = source.next
    if not nextSrc then
        return nil
    end
    local ntype = nextSrc.type
    if     ntype == 'setfield'
    or     ntype == 'setmethod'
    or     ntype == 'setindex' then
        return nextSrc, 'set'
    elseif ntype == 'getfield'
    or     ntype == 'getmethod'
    or     ntype == 'getindex' then
        return nextSrc, 'get'
    end
    return nil
end

local function ofENV(source, callback)
    local refs = source.ref
    if not refs then
        return
    end
    for i = 1, #refs do
        local ref = refs[i]
        if ref.type == 'getglobal' then
            callback {
                source = ref,
                key    = guide.getKeyName(ref),
                mode   = 'get',
            }
        elseif ref.type == 'setglobal' then
            callback {
                source = ref,
                key    = guide.getKeyName(ref),
                mode   = 'set',
            }
        end
    end
end

local function ofLocal(source, callback)
    if source.tag == '_ENV' then
        ofENV(source, callback)
    else
        vm.eachRef(source, function (info)
            local src = info.source
            local nextSrc, mode = checkNext(src)
            if not nextSrc then
                return
            end
            callback {
                source = nextSrc,
                key    = guide.getKeyName(nextSrc),
                mode   = mode,
            }
        end)
    end
end

function vm.eachField(source, callback)
    local stype = source.type
    if     stype == 'local' then
        ofLocal(source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(source.node, callback)
    elseif stype == 'getglobal' then
    end
end
