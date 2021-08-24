local util        = require 'utility'
local files       = require 'files'
local autoRequire = require 'core.command.autoRequire'
local client      = require 'client'

local findInsertOffset = util.getUpvalue(autoRequire, 'findInsertOffset')
local applyAutoRequire = util.getUpvalue(autoRequire, 'applyAutoRequire')

local originEditText = client.editText
local EditResult

client.editText = function (uri, edits)
    EditResult = edits[1]
end

function TEST(text)
    return function (name)
        return function (expect)
            files.removeAll()
            files.setText('', text)
            EditResult = nil
            local offset, fmt = findInsertOffset('')
            applyAutoRequire('', offset, name, name, fmt)
            assert(util.equal(EditResult, expect))
        end
    end
end

-- TODO change to position
TEST '' 'test' {
    start  = 0,
    finish = -1,
    text   = '\nlocal test = require "test"\n'
}

client.editText = originEditText
