local m = require 'lpeglabel'
local matcher = require 'glob.matcher'

local function prop(name, pat)
    return m.Cg(m.Cc(true), name) * pat
end

local function object(type, pat)
    return m.Ct(
        m.Cg(m.Cc(type), 'type') *
        m.Cg(pat, 'value')
    )
end

local function expect(p, err)
    return p + m.T(err)
end

local parser = m.P {
    'Main',
    ['Sp']          = m.S(' \t')^0,
    ['Slash']       = m.S('/')^1,
    ['Main']        = m.Ct(m.V'Sp' * m.P'{' * m.V'Pattern' * (',' * expect(m.V'Pattern', 'Miss exp after ","'))^0 * m.P'}')
                    + m.Ct(m.V'Pattern')
                    + m.T'Main Failed'
                    ,
    ['Pattern']     = m.Ct(m.V'Sp' * prop('neg', m.P'!') * expect(m.V'Unit', 'Miss exp after "!"'))
                    + m.Ct(m.V'Unit')
                    ,
    ['NeedRoot']    = prop('root', (m.P'.' * m.V'Slash' + m.V'Slash')),
    ['Unit']        = m.V'Sp' * m.V'NeedRoot'^-1 * expect(m.V'Exp', 'Miss exp') * m.V'Sp',
    ['Exp']         = m.V'Sp' * (m.V'FSymbol' + object('/', m.V'Slash') + m.V'Word')^0 * m.V'Sp',
    ['Word']        = object('word', m.Ct((m.V'CSymbol' + m.V'Char' - m.V'FSymbol')^1)),
    ['CSymbol']     = object('*',    m.P'*')
                    + object('?',    m.P'?')
                    + object('[]',   m.V'Range')
                    ,
    ['SimpleChar']  = m.P(1) - m.S',{}[]*?/',
    ['EscChar']     = m.P'\\' / '' * m.P(1),
    ['Char']        = object('char', m.Cs((m.V'EscChar' + m.V'SimpleChar')^1)),
    ['FSymbol']     = object('**', m.P'**'),
    ['Range']       = m.P'[' * m.Ct(m.V'RangeUnit'^0) * m.P']'^-1,
    ['RangeUnit']   = m.Ct(- m.P']' * m.C(m.P(1)) * (m.P'-' * - m.P']' * m.C(m.P(1)))^-1),
}

---@class gitignore
---@field pattern string[]
---@field options table
---@field errors table[]
---@field matcher table
---@field interface function[]
local mt = {}
mt.__index = mt
mt.__name = 'gitignore'

function mt:addPattern(pat)
    if type(pat) ~= 'string' then
        return
    end
    self.pattern[#self.pattern+1] = pat
    if self.options.ignoreCase then
        pat = pat:lower()
    end
    local states, err = parser:match(pat)
    if not states then
        self.errors[#self.errors+1] = {
            pattern = pat,
            message = err
        }
        return
    end
    for _, state in ipairs(states) do
        self.matcher[#self.matcher+1] = matcher(state)
    end
end

function mt:setOption(op, val)
    if val == nil then
        val = true
    end
    self.options[op] = val
end

---@param key string | "'type'" | "'list'"
---@param func function | "function (path) end"
function mt:setInterface(key, func)
    if type(func) ~= 'function' then
        return
    end
    self.interface[key] = func
end

function mt:callInterface(name, ...)
    local func = self.interface[name]
    return func(...)
end

function mt:hasInterface(name)
    return self.interface[name] ~= nil
end

function mt:checkDirectory(catch, path, matcher)
    if not self:hasInterface 'type' then
        return true
    end
    if not matcher:isNeedDirectory() then
        return true
    end
    if #catch < #path then
        -- if path is 'a/b/c' and catch is 'a/b'
        -- then the catch must be a directory
        return true
    else
        return self:callInterface('type', path) == 'directory'
    end
end

function mt:simpleMatch(path)
    path = self:getRelativePath(path)
    for i = #self.matcher, 1, -1 do
        local matcher = self.matcher[i]
        local catch = matcher(path)
        if catch and self:checkDirectory(catch, path, matcher) then
            if matcher:isNegative() then
                return false
            else
                return true
            end
        end
    end
    return nil
end

function mt:finishMatch(path)
    local paths = {}
    for filename in path:gmatch '[^/\\]+' do
        paths[#paths+1] = filename
    end
    for i = 1, #paths do
        local newPath = table.concat(paths, '/', 1, i)
        local passed = self:simpleMatch(newPath)
        if passed == true then
            return true
        elseif passed == false then
            return false
        end
    end
    return false
end

function mt:getRelativePath(path)
    local root = self.options.root or ''
    if self.options.ignoreCase then
        path = path:lower()
        root = root:lower()
    end
    path = path:gsub('^[/\\]+', ''):gsub('[/\\]+', '/')
    root = root:gsub('^[/\\]+', ''):gsub('[/\\]+', '/')
    if path:sub(1, #root) == root then
        path = path:sub(#root + 1)
        path = path:gsub('^[/\\]+', '')
    end
    return path
end

---@param callback async fun()
---@async
function mt:scan(path, callback)
    local files = {}
    if type(callback) ~= 'function' then
        callback = nil
    end
    local list = {}

    ---@async
    local function check(current)
        local fileType = self:callInterface('type', current)
        if fileType == 'file' then
            if callback then
                callback(current)
            end
            files[#files+1] = current
        elseif fileType == 'directory' then
            local result = self:callInterface('list', current)
            if type(result) == 'table' then
                for _, path in ipairs(result) do
                    local filename = path:match '([^/\\]+)[/\\]*$'
                    if  filename
                    and filename ~= '.'
                    and filename ~= '..' then
                        list[#list+1] = path
                    end
                end
            end
        end
    end
    if not self:simpleMatch(path) then
        check(path)
    end
    while #list > 0 do
        local current = list[#list]
        if not current then
            break
        end
        list[#list] = nil
        if not self:simpleMatch(current) then
            check(current)
        end
    end
    return files
end

function mt:__call(path)
    path = self:getRelativePath(path)
    return self:finishMatch(path)
end

return function (pattern, options, interface)
    local self = setmetatable({
        pattern   = {},
        options   = {},
        matcher   = {},
        errors    = {},
        interface = {},
    }, mt)

    if type(options) == 'table' then
        for op, val in pairs(options) do
            self:setOption(op, val)
        end
    end

    if type(pattern) == 'table' then
        for _, pat in ipairs(pattern) do
            self:addPattern(pat)
        end
    else
        self:addPattern(pattern)
    end

    if type(interface) == 'table' then
        for key, func in pairs(interface) do
            self:setInterface(key, func)
        end
    end

    return self
end
