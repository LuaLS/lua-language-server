
local files = require 'files'
local code  = require 'plugins.ffi.searchCode'
local cdefRerence = require 'plugins.ffi.cdefRerence'

rawset(_G, 'TEST', true)

function TEST(wanted)
    ---@async
    return function (script)
        files.setText(TESTURI, script)
        local codeResults = code(cdefRerence(), TESTURI)
        assert(codeResults)
        table.sort(codeResults)
        assert(table.concat(codeResults, '|') == wanted, table.concat(codeResults, '|') .. ' ~= ' .. wanted)
        files.remove(TESTURI)
    end
end

TEST 'aaa|bbb' [[
local ffi = require 'ffi'
local cdef = ffi.cdef
cdef('aaa')
cdef = function ()
end
cdef('bbb')
]]

TEST 'aaa' [[
local ffi = require 'ffi'

ffi.cdef('aaa')
]]

TEST 'aa.aa' [[
local ffi = require 'ffi'
local t1 = ffi

t1.cdef"aa.aa"
]]

TEST 'aaa' [[
local ffi = require 'ffi'
local code = 'aaa'
ffi.cdef(code)
]]

TEST 'aaa|bbb' [[
local ffi = require 'ffi'
local code = 'aaa'
code = 'bbb'
local t1 = ffi
t1.cdef(code)
]]

TEST 'aa.aa' [[
local ffi = require 'ffi'
local cdef = ffi.cdef

cdef"aa.aa"
]]
