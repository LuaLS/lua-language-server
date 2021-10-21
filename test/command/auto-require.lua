local util        = require 'utility'
local files       = require 'files'
local autoRequire = require 'core.command.autoRequire'
local client      = require 'client'

local findInsertRow = util.getUpvalue(autoRequire, 'findInsertRow')
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
            local row, fmt = findInsertRow('')
            applyAutoRequire('', row, name, name, fmt)
            assert(util.equal(EditResult, expect))
        end
    end
end

TEST '' 'test' {
    start  = 0,
    finish = 0,
    text   = 'local test = require "test"\n'
}

TEST [[
local aaaaaa = require 'aaa'
]] 'test' {
    start  = 10000,
    finish = 10000,
    text   = 'local test   = require \'test\'\n'
}

TEST [[
local DEBUG = true
local aaaaaa = require 'aaa'
]] 'test' {
    start  = 20000,
    finish = 20000,
    text   = 'local test   = require \'test\'\n'
}

TEST [[
-- comment
-- comment
local aaaaaa = require 'aaa'
]] 'test' {
    start  = 30000,
    finish = 30000,
    text   = 'local test   = require \'test\'\n'
}

TEST [[
--[=[
comment chunk
]=]
local aaaaaa = require 'aaa'
]] 'test' {
    start  = 40000,
    finish = 40000,
    text   = 'local test   = require \'test\'\n'
}

TEST [[
local offset
local space_size

---@class A
---@field a string
---@field b string
local M = {}

---@return A
function M.new()
end
]] 'test' {
    start  = 0,
    finish = 0,
    text   = 'local test = require "test"\n'
}

client.editText = originEditText
