---@class VM.Coder
local M = Class 'VM.Coder'

M.code = '-- Not made yet --'
---@type function?
M.func = nil

---@alias VM.CoderProvider fun(coder: VM.Coder, source: LuaParser.Node.Base, saveKey?: string)

---@type table<string, VM.CoderProvider?>
M.providers = {}

---@param vfile VM.Vfile
function M:__init(vfile)
    self.vfile = vfile
    self.scope = vfile.scope
    self.env   = _G
    self.indentation = 0

    self.blockStack = {}
end

function M:__del()
    self:dispose()
end

---@param ast LuaParser.Ast
function M:makeFromAst(ast)
    self.buf = {}
    self.disposers = {}

    self:addLine('-- Middle Code: ' .. self.vfile.uri)
    self:addLine 'local coder = ...'
    self:addLine 'local node  = coder.scope.node'
    self:addLine 'local uri   = coder.vfile.uri'
    self:addLine 'local r     = {}'
    self:addLine 'node:lockCache()'
    self:addLine ''

    self:compile(ast.main)

    self:addLine 'node:unlockCache()'
    self:addLine ''
    self:addLine 'return function ()'
    self:addIndentation(1)
    self:addLine 'node:lockCache()'
    for i = #self.disposers, 1, -1 do
        self:addLine(self.disposers[i])
    end
    self:addLine 'node:unlockCache()'
    self:addIndentation(-1)
    self:addLine 'end'

    self.code = table.concat(self.buf)
    self.func = load(self.code, self.code, 't', self.env)
end

---@param code string
function M:addLine(code)
    local buf = self.buf
    if code == '' then
        buf[#buf+1] = '\n'
        return
    end
    if self.indentation > 0 then
        local indentation = string.rep('    ', self.indentation)
        buf[#buf+1] = indentation
        buf[#buf+1] = code:gsub('\n', '\n' .. indentation):gsub('%s+$', '')
    else
        buf[#buf+1] = code
    end
    buf[#buf+1] = '\n'
end

---@param code string
function M:addCode(code)
    local buf = self.buf
    buf[#buf+1] = code
end

---@param code string
function M:addDisposer(code)
    local disposers = self.disposers
    disposers[#disposers+1] = code
end

---@private
---@type function?
M.disposer = nil

function M:dispose()
    if self.disposer then
        self.disposer()
        self.disposer = nil
    end
end

function M:run()
    self:dispose()
    self.disposer = self.func(self)
end

---@param delta integer
function M:addIndentation(delta)
    self.indentation = self.indentation + delta
end

---@param source LuaParser.Node.Base
---@param saveKey? string
function M:compile(source, saveKey)
    local provider = M.providers[source.kind]
    if not provider then
        self:addLine('--[[Unsupported node kind: ' .. source.kind .. ']]')
        return
    end
    provider(self, source, saveKey)
end

function M:pushBlock()
    self.blockStack[#self.blockStack+1] = {}
end

function M:popBlock()
    self.blockStack[#self.blockStack] = nil
end

function M:currentBlock()
    return self.blockStack[#self.blockStack]
end

---@param callback function
function M:withNewBlock(callback)
    self:addLine 'do'
    self:addIndentation(1)
    self:pushBlock()
    callback()
    self:popBlock()
    self:addIndentation(-1)
    self:addLine 'end'
end

function M:setBlockKV(k, v)
    local block = self:currentBlock()
    if block then
        block[k] = v
    end
end

function M:getBlockKV(k)
    local block = self:currentBlock()
    if block then
        return block[k]
    end
end

function M:makeLocationCode(start, finish)
    return string.format('{ uri = uri, offset = %d, length = %d }'
        , start
        , finish - start
    )
end

---@param kind string
---@param name string
---@param row integer
---@param col integer
---@return string
function M:makeKeyCode(kind, name, row, col)
    return string.format('r[%q]', table.concat {kind, ':', name, '@', row, ':', col })
end

---@param vfile VM.Vfile
---@return VM.Coder
function ls.vm.createCoder(vfile)
    return New 'VM.Coder' (vfile)
end

---@param kind string
---@param callback VM.CoderProvider
function ls.vm.registerCoderProvider(kind, callback)
    M.providers[kind] = callback
end
