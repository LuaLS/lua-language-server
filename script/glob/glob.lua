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
    ['Slash']       = m.P('/')^1,
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
    ['RangeWord']   = 1 - m.P']',
    ['Range']       = m.P'[' * m.Ct(m.V'RangeUnit'^0) * m.P']'^-1,
    ['RangeUnit']   = m.Ct(m.C(m.V'RangeWord') * m.P'-' * m.C(m.V'RangeWord'))
                    + m.V'RangeWord',
}

local mt = {}
mt.__index = mt
mt.__name = 'glob'

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
        if state.neg then
            self.refused[#self.refused+1] = matcher(state)
        else
            self.passed[#self.passed+1] = matcher(state)
        end
    end
end

function mt:setOption(op, val)
    if val == nil then
        val = true
    end
    self.options[op] = val
end

function mt:__call(path)
    if self.options.ignoreCase then
        path = path:lower()
    end
    path = path:gsub('^[/\\]+', '')
    for _, refused in ipairs(self.refused) do
        if refused(path) then
            return false
        end
    end
    for _, passed in ipairs(self.passed) do
        if passed(path) then
            return true
        end
    end
    return false
end

return function (pattern, options)
    local self = setmetatable({
        pattern = {},
        options = {},
        passed  = {},
        refused = {},
        errors  = {},
    }, mt)

    if type(pattern) == 'table' then
        for _, pat in ipairs(pattern) do
            self:addPattern(pat)
        end
    else
        self:addPattern(pattern)
    end

    if type(options) == 'table' then
        for op, val in pairs(options) do
            self:setOption(op, val)
        end
    end
    return self
end
