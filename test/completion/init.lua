local core   = require 'core.completion'
local files  = require 'files'
local catch  = require 'catch'
local guide  = require 'parser.guide'

EXISTS = {'EXISTS'}

local function eq(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        local mark = {}
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
                return false
            end
            mark[k] = true
        end
        for k in pairs(b) do
            if not mark[k] then
                return false
            end
        end
        return true
    end
    return a == b
end

local function include(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
                return false
            end
        end
        return true
    end
    return a == b
end

rawset(_G, 'TEST', true)

Cared = {
    ['label']               = true,
    ['kind']                = true,
    ['textEdit']            = true,
    ['additionalTextEdits'] = true,
    ['deprecated']          = true,
}

IgnoreFunction = false
ContinueTyping = false

function TEST(script)
    return function (expect)
        ---@diagnostic disable: await-in-sync
        local newScript, catched = catch(script, '?')

        files.setText('', newScript)
        local state = files.getState('')
        local inputPos = catched['?'][1][2]
        if ContinueTyping then
            local triggerCharacter = script:sub(inputPos - 1, inputPos - 1)
            if triggerCharacter == '\n'
            or triggerCharacter:find '%w_' then
                triggerCharacter = nil
            end
            core.completion('', inputPos, triggerCharacter)
        end
        local offset = guide.positionToOffset(state, inputPos)
        local triggerCharacter = script:sub(offset, offset)
        if triggerCharacter == '\n'
        or triggerCharacter:find '%w_' then
            triggerCharacter = nil
        end
        local result = core.completion('', inputPos, triggerCharacter)

        if not expect then
            assert(result == nil)
            return
        end
        assert(result ~= nil)
        result.enableCommon = nil
        for _, item in ipairs(result) do
            if item.id then
                local r = core.resolve(item.id)
                for k, v in pairs(r or {}) do
                    item[k] = v
                end
            end
            for k in pairs(item) do
                if not Cared[k] then
                    item[k] = nil
                end
            end
            if item.description then
                item.description = tostring(item.description)
            end
        end
        if IgnoreFunction then
            for i = #result, 1, -1 do
                local item = result[i]
                if item.label:find '%('
                and not item.label:find 'function' then
                    result[i] = result[#result]
                    result[#result] = nil
                end
            end
        end
        assert(result)
        result.complete = nil
        if type(expect) == 'function' then
            expect(result)
        else
            if expect.include then
                expect.include = nil
                assert(include(expect, result))
            else
                assert(eq(expect, result))
            end
        end
        files.remove('')
    end
end

require 'completion.common'
require 'completion.continue'
