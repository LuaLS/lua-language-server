---@diagnostic disable: await-in-sync

local function founded(targets, results)
    targets = targets or {}
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

---@param script string
function TEST_IMPL(script)
    local ranges, catched = TEST_FRAME(script, function (catched)
        local results = ls.feature.implementation(test.fileUri, catched['?'][1][1])

        local ranges = ls.util.map(results, function (v)
            return v.range
        end)

        return ranges
    end)
    if not founded(catched['!'], ranges) then
        print('FAILED TEST_IMPL:')
        print(script)
        print('Expected:', ls.util.dump(catched['!'] or {}))
        print('Got:', ls.util.dump(ranges))
        ls.fs.write(ls.env.ROOT_URI / 'tmp' / 'LAST_CODE', LAST_CODE)
        ls.fs.write(ls.env.ROOT_URI / 'tmp' / 'LAST_FLOW', LAST_FLOW)
        ls.fs.write(ls.env.ROOT_URI / 'tmp' / 'LAST_PMAP', LAST_PMAP)
        assert(false)
    end
end

test.require 'test.feature.implementation.local'
test.require 'test.feature.implementation.field'
test.require 'test.feature.implementation.method'
test.require 'test.feature.implementation.interface'
