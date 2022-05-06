local m          = require 'lpeglabel'
local re         = require 'parser.relabel'
local guide      = require 'parser.guide'
local parser     = require 'parser.newparser'
local util       = require 'utility'

local TokenTypes, TokenStarts, TokenFinishs, TokenContents, TokenMarks
local Ci, Offset, pushWarning, NextComment, Lines
local parseType, parseTypeUnit
---@type any
local Parser = re.compile([[
Main                <-  (Token / Sp)*
Sp                  <-  %s+
X16                 <-  [a-fA-F0-9]
Token               <-  Integer / Name / String / Symbol
Name                <-  ({} {%name} {})
                    ->  Name
Integer             <-  ({} {[0-9]+} !'.' {})
                    ->  Integer
String              <-  ({} StringDef {})
                    ->  String
StringDef           <-  {'"'}
                        {~(Esc / !'"' .)*~} -> 1
                        ('"'?)
                    /   {"'"}
                        {~(Esc / !"'" .)*~} -> 1
                        ("'"?)
                    /   '[' {:eq: '='* :} '['
                        =eq -> LongStringMark
                        {(!StringClose .)*} -> 1
                        StringClose?
StringClose         <-  ']' =eq ']'
Esc                 <-  '\' -> ''
                        EChar
EChar               <-  'a' -> ea
                    /   'b' -> eb
                    /   'f' -> ef
                    /   'n' -> en
                    /   'r' -> er
                    /   't' -> et
                    /   'v' -> ev
                    /   '\'
                    /   '"'
                    /   "'"
                    /   %nl
                    /   ('z' (%nl / %s)*)     -> ''
                    /   ('x' {X16 X16})       -> Char16
                    /   ([0-9] [0-9]? [0-9]?) -> Char10
                    /   ('u{' {X16*} '}')    -> CharUtf8
Symbol              <-  ({} {
                            [:|,<>()?+#`{}]
                        /   '[]'
                        /   '...'
                        /   '['
                        /   ']'
                        /   '-' !'-'
                        } {})
                    ->  Symbol
]], {
    s  = m.S' \t',
    ea = '\a',
    eb = '\b',
    ef = '\f',
    en = '\n',
    er = '\r',
    et = '\t',
    ev = '\v',
    name = (m.R('az', 'AZ', '09', '\x80\xff') + m.S('_')) * (m.R('az', 'AZ', '__', '09', '\x80\xff') + m.S('_.*-'))^0,
    Char10 = function (char)
        char = tonumber(char)
        if not char or char < 0 or char > 255 then
            return ''
        end
        return string.char(char)
    end,
    Char16 = function (char)
        return string.char(tonumber(char, 16))
    end,
    CharUtf8 = function (char)
        if #char == 0 then
            return ''
        end
        local v = tonumber(char, 16)
        if not v then
            return ''
        end
        if v >= 0 and v <= 0x10FFFF then
            return utf8.char(v)
        end
        return ''
    end,
    LongStringMark = function (back)
        return '[' .. back .. '['
    end,
    Name = function (start, content, finish)
        Ci = Ci + 1
        TokenTypes[Ci]    = 'name'
        TokenStarts[Ci]   = start
        TokenFinishs[Ci]  = finish - 1
        TokenContents[Ci] = content
    end,
    String = function (start, mark, content, finish)
        Ci = Ci + 1
        TokenTypes[Ci]    = 'string'
        TokenStarts[Ci]   = start
        TokenFinishs[Ci]  = finish - 1
        TokenContents[Ci] = content
        TokenMarks[Ci]    = mark
    end,
    Integer = function (start, content, finish)
        Ci = Ci + 1
        TokenTypes[Ci]    = 'integer'
        TokenStarts[Ci]   = start
        TokenFinishs[Ci]  = finish - 1
        TokenContents[Ci] = math.tointeger(content)
    end,
    Symbol = function (start, content, finish)
        Ci = Ci + 1
        TokenTypes[Ci]    = 'symbol'
        TokenStarts[Ci]   = start
        TokenFinishs[Ci]  = finish - 1
        TokenContents[Ci] = content
    end,
})

---@class parser.object
---@field literal boolean
---@field signs parser.object[]
---@field originalComment parser.object
---@field as? parser.object

local function trim(str)
    return str:match '^%s*(%S+)%s*$'
end

local function parseTokens(text, offset)
    Ci = 0
    Offset = offset
    TokenTypes    = {}
    TokenStarts   = {}
    TokenFinishs  = {}
    TokenContents = {}
    TokenMarks    = {}
    Parser:match(text)
    Ci = 0
end

local function peekToken()
    return TokenTypes[Ci+1], TokenContents[Ci+1]
end

local function nextToken()
    Ci = Ci + 1
    if not TokenTypes[Ci] then
        Ci = Ci - 1
        return nil
    end
    return TokenTypes[Ci], TokenContents[Ci]
end

local function checkToken(tp, content, offset)
    offset = offset or 0
    return  TokenTypes[Ci + offset] == tp
        and TokenContents[Ci + offset] == content
end

local function getStart()
    if Ci == 0 then
        return Offset
    end
    return TokenStarts[Ci] + Offset
end

local function getFinish()
    if Ci == 0 then
        return Offset
    end
    return TokenFinishs[Ci] + Offset + 1
end

local function getMark()
    return TokenMarks[Ci]
end

local function try(callback)
    local savePoint = Ci
    -- rollback
    local suc = callback()
    if not suc then
        Ci = savePoint
    end
    return suc
end

local function parseName(tp, parent)
    local nameTp, nameText = peekToken()
    if nameTp ~= 'name' then
        return nil
    end
    nextToken()
    local name = {
        type   = tp,
        start  = getStart(),
        finish = getFinish(),
        parent = parent,
        [1]    = nameText,
    }
    return name
end

local function nextSymbolOrError(symbol)
    if checkToken('symbol', symbol, 1) then
        nextToken()
        return true
    end
    pushWarning {
        type   = 'LUADOC_MISS_SYMBOL',
        start  = getFinish(),
        finish = getFinish(),
        info   = {
            symbol = symbol,
        }
    }
    return false
end

local function parseIndexField(tp, parent)
    if not checkToken('symbol', '[', 1) then
        return nil
    end
    nextToken()
    local start = getFinish() - 1
    local indexTP, index = peekToken()
    if indexTP == 'name' then
        local field = parseType(parent)
        nextSymbolOrError ']'
        return field
    else
        nextToken()
        local class = {
            type   = tp,
            start  = start,
            finish = getFinish(),
            parent = parent,
        }
        class[1] = index
        nextSymbolOrError ']'
        class.finish = getFinish()
        return class
    end
end

local function parseTable(parent)
    if not checkToken('symbol', '{', 1) then
        return nil
    end
    nextToken()
    local typeUnit = {
        type    = 'doc.type.table',
        start   = getStart(),
        parent  = parent,
        fields  = {},
    }

    while true do
        if checkToken('symbol', '}', 1) then
            nextToken()
            break
        end
        local field = {
            type   = 'doc.type.field',
            parent = typeUnit,
        }

        do
            field.name = parseName('doc.field.name', field)
                    or   parseIndexField('doc.field.name', field)
            if not field.name then
                pushWarning {
                    type   = 'LUADOC_MISS_FIELD_NAME',
                    start  = getFinish(),
                    finish = getFinish(),
                }
                break
            end
            if not field.start then
                field.start = field.name.start
            end
            if checkToken('symbol', '?', 1) then
                nextToken()
                field.optional = true
            end
            field.finish = getFinish()
            if not nextSymbolOrError(':') then
                break
            end
            field.extends = parseType(field)
            if not field.extends then
                break
            end
            field.finish = getFinish()
        end

        typeUnit.fields[#typeUnit.fields+1] = field
        if checkToken('symbol', ',', 1) then
            nextToken()
        else
            nextSymbolOrError('}')
            break
        end
    end
    typeUnit.finish = getFinish()
    return typeUnit
end

local function parseSigns(parent)
    if not checkToken('symbol', '<', 1) then
        return nil
    end
    nextToken()
    local signs = {}
    while true do
        local sign = parseName('doc.generic.name', parent)
        if not sign then
            pushWarning {
                type   = 'LUADOC_MISS_SIGN_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            break
        end
        signs[#signs+1] = sign
        if checkToken('symbol', ',', 1) then
            nextToken()
        else
            break
        end
    end
    nextSymbolOrError '>'
    return signs
end

local function parseDots(tp, parent)
    if not checkToken('symbol', '...', 1) then
        return
    end
    nextToken()
    local dots = {
        type   = tp,
        start  = getStart(),
        finish = getFinish(),
        parent = parent,
        [1]    = '...',
    }
    return dots
end

local function  parseTypeUnitFunction(parent)
    if not checkToken('name', 'fun', 1) then
        return nil
    end
    nextToken()
    local typeUnit = {
        type    = 'doc.type.function',
        parent  = parent,
        start   = getStart(),
        args    = {},
        returns = {},
    }
    if not nextSymbolOrError('(') then
        return nil
    end
    while true do
        if checkToken('symbol', ')', 1) then
            nextToken()
            break
        end
        local arg = {
            type   = 'doc.type.arg',
            parent = typeUnit,
        }
        arg.name = parseName('doc.type.arg.name', arg)
                or parseDots('doc.type.arg.name', arg)
        if not arg.name then
            pushWarning {
                type   = 'LUADOC_MISS_ARG_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            break
        end
        if not arg.start then
            arg.start = arg.name.start
        end
        if checkToken('symbol', '?', 1) then
            nextToken()
            arg.optional = true
        end
        arg.finish = getFinish()
        if checkToken('symbol', ':', 1) then
            nextToken()
            arg.extends = parseType(arg)
        end
        arg.finish = getFinish()
        typeUnit.args[#typeUnit.args+1] = arg
        if checkToken('symbol', ',', 1) then
            nextToken()
        else
            nextSymbolOrError(')')
            break
        end
    end
    if checkToken('symbol', ':', 1) then
        nextToken()
        while true do
            local rtn = parseType(typeUnit)
            if not rtn then
                break
            end
            if checkToken('symbol', '?', 1) then
                nextToken()
                rtn.optional = true
            end
            typeUnit.returns[#typeUnit.returns+1] = rtn
            if checkToken('symbol', ',', 1) then
                nextToken()
            else
                break
            end
        end
    end
    typeUnit.finish = getFinish()
    return typeUnit
end

local function parseFunction(parent)
    local _, content = peekToken()
    if content == 'async' then
        nextToken()
        local pos = getStart()
        local tp, cont = peekToken()
        if tp == 'name' then
            if cont == 'fun' then
                local func = parseTypeUnit(parent)
                if func then
                    func.async = true
                    func.asyncPos = pos
                    return func
                end
            end
        end
    end
    if content == 'fun' then
        return parseTypeUnitFunction(parent)
    end
end

local function parseTypeUnitArray(parent, node)
    if not checkToken('symbol', '[]', 1) then
        return nil
    end
    nextToken()
    local result = {
        type   = 'doc.type.array',
        start  = node.start,
        finish = getFinish(),
        node   = node,
        parent = parent,
    }
    node.parent = result
    return result
end

local function parseTypeUnitSign(parent, node)
    if not checkToken('symbol', '<', 1) then
        return nil
    end
    nextToken()
    local result = {
        type   = 'doc.type.sign',
        start  = node.start,
        finish = getFinish(),
        node   = node,
        parent = parent,
        signs  = {},
    }
    node.parent = result
    while true do
        local sign = parseType(result)
        if not sign then
            pushWarning {
                type   = 'LUA_DOC_MISS_SIGN',
                start  = getFinish(),
                finish = getFinish(),
            }
            break
        end
        result.signs[#result.signs+1] = sign
        if checkToken('symbol', ',', 1) then
            nextToken()
        else
            break
        end
    end
    nextSymbolOrError '>'
    result.finish = getFinish()
    return result
end

local function parseString(parent)
    local tp, content = peekToken()
    if not tp or tp ~= 'string' then
        return nil
    end

    nextToken()
    local mark = getMark()
    -- compatibility
    if content:sub(1, 1) == '"'
    or content:sub(1, 1) == "'" then
        if content:sub(1, 1) == content:sub(-1, -1) then
            mark = content:sub(1, 1)
            content = content:sub(2, -2)
        end
    end
    local str = {
        type   = 'doc.type.string',
        start  = getStart(),
        finish = getFinish(),
        parent = parent,
        [1]    = content,
        [2]    = mark,
    }
    return str
end

local function parseInteger(parent)
    local tp, content = peekToken()
    if not tp or tp ~= 'integer' then
        return nil
    end

    nextToken()
    local integer = {
        type   = 'doc.type.integer',
        start  = getStart(),
        finish = getFinish(),
        parent = parent,
        [1]    = content,
    }
    return integer
end

local function parseBoolean(parent)
    local tp, content = peekToken()
    if not tp
    or tp ~= 'name'
    or (content ~= 'true' and content ~= 'false') then
        return nil
    end

    nextToken()
    local boolean = {
        type   = 'doc.type.boolean',
        start  = getStart(),
        finish = getFinish(),
        parent = parent,
        [1]    = content == 'true' and true or false,
    }
    return boolean
end

local function parseParen(parent)
    if not checkToken('symbol', '(', 1) then
        return
    end
    nextToken()
    local tp = parseType(parent)
    nextSymbolOrError(')')
    return tp
end

function parseTypeUnit(parent)
    local result = parseFunction(parent)
                or parseTable(parent)
                or parseString(parent)
                or parseInteger(parent)
                or parseBoolean(parent)
                or parseDots('doc.type.name', parent)
                or parseParen(parent)
    if not result then
        local literal = checkToken('symbol', '`', 1)
        if literal then
            nextToken()
        end
        result = parseName('doc.type.name', parent)
        if not result then
            return nil
        end
        if literal then
            result.literal = true
            nextSymbolOrError '`'
        end
    end
    while true do
        local newResult = parseTypeUnitSign(parent, result)
        if not newResult then
            break
        end
        result = newResult
    end
    while true do
        local newResult = parseTypeUnitArray(parent, result)
        if not newResult then
            break
        end
        result = newResult
    end
    return result
end

local function parseResume(parent)
    local default, additional
    if checkToken('symbol', '>', 1) then
        nextToken()
        default = true
    end

    if checkToken('symbol', '+', 1) then
        nextToken()
        additional = true
    end

    local result = parseTypeUnit(parent)
    if result then
        result.default    = default
        result.additional = additional
    end

    return result
end

function parseType(parent)
    local result = {
        type    = 'doc.type',
        parent  = parent,
        types   = {},
    }
    while true do
        local typeUnit = parseTypeUnit(result)
        if not typeUnit then
            break
        end

        result.types[#result.types+1] = typeUnit
        if not result.start then
            result.start = typeUnit.start
        end

        if not checkToken('symbol', '|', 1) then
            break
        end
        nextToken()
    end
    if not result.start then
        result.start = getFinish()
    end
    if checkToken('symbol', '?', 1) then
        nextToken()
        result.optional = true
    end
    result.finish = getFinish()
    result.firstFinish = result.finish

    local row = guide.rowColOf(result.finish)

    local function pushResume()
        local comments
        for i = 0, 100 do
            local nextComm = NextComment(i,'peek')
            if not nextComm then
                return false
            end
            local nextCommRow = guide.rowColOf(nextComm.start)
            local currentRow = row + i + 1
            if currentRow < nextCommRow then
                return false
            end
            if nextComm.text:match '^%-%s*%@' then
                return false
            else
                local resumeHead = nextComm.text:match '^%-%s*%|'
                if resumeHead then
                    NextComment(i)
                    row = row + i + 1
                    local finishPos = nextComm.text:find('#', #resumeHead + 1) or #nextComm.text
                    parseTokens(nextComm.text:sub(#resumeHead + 1, finishPos), nextComm.start + #resumeHead + 1)
                    local resume = parseResume(result)
                    if resume then
                        if comments then
                            resume.comment = table.concat(comments, '\n')
                        else
                            resume.comment = nextComm.text:match('#%s*(.+)', #resumeHead + 1)
                        end
                        result.types[#result.types+1] = resume
                        result.finish = resume.finish
                    end
                    comments = nil
                    return true
                else
                    if not comments then
                        comments = {}
                    end
                    comments[#comments+1] = nextComm.text:sub(2)
                end
            end
        end
        return false
    end

    local checkResume = true
    local nsymbol, ncontent = peekToken()
    if nsymbol == 'symbol' then
        if ncontent == ','
        or ncontent == ':'
        or ncontent == '|'
        or ncontent == ')'
        or ncontent == '}' then
            checkResume = false
        end
    end

    if checkResume then
        while pushResume() do end
    end

    if #result.types == 0 then
        pushWarning {
            type   = 'LUADOC_MISS_TYPE_NAME',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    return result
end

local docSwitch = util.switch()
    : case 'class'
    : call(function ()
        local result = {
            type   = 'doc.class',
            fields = {},
        }
        result.class = parseName('doc.class.name', result)
        if not result.class then
            pushWarning {
                type   = 'LUADOC_MISS_CLASS_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        result.start  = getStart()
        result.finish = getFinish()
        result.signs  = parseSigns(result)
        if not checkToken('symbol', ':', 1) then
            return result
        end
        nextToken()

        result.extends = {}

        while true do
            local extend = parseName('doc.extends.name', result)
                        or parseTable(result)
            if not extend then
                pushWarning {
                    type   = 'LUADOC_MISS_CLASS_EXTENDS_NAME',
                    start  = getFinish(),
                    finish = getFinish(),
                }
                return result
            end
            result.extends[#result.extends+1] = extend
            result.finish = getFinish()
            if not checkToken('symbol', ',', 1) then
                break
            end
            nextToken()
        end
        return result
    end)
    : case 'type'
    : call(function ()
        return parseType()
    end)
    : case 'alias'
    : call(function ()
        local result = {
            type   = 'doc.alias',
        }
        result.alias = parseName('doc.alias.name', result)
        if not result.alias then
            pushWarning {
                type   = 'LUADOC_MISS_ALIAS_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        result.start  = getStart()
        result.signs  = parseSigns(result)
        result.extends = parseType(result)
        if not result.extends then
            pushWarning {
                type   = 'LUADOC_MISS_ALIAS_EXTENDS',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        result.finish = getFinish()
        return result
    end)
    : case 'param'
    : call(function ()
        local result = {
            type   = 'doc.param',
        }
        result.param = parseName('doc.param.name', result)
                    or parseDots('doc.param.name', result)
        if not result.param then
            pushWarning {
                type   = 'LUADOC_MISS_PARAM_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        if checkToken('symbol', '?', 1) then
            nextToken()
            result.optional = true
        end
        result.start  = result.param.start
        result.finish = getFinish()
        result.extends = parseType(result)
        if not result.extends then
            pushWarning {
                type   = 'LUADOC_MISS_PARAM_EXTENDS',
                start  = getFinish(),
                finish = getFinish(),
            }
            return result
        end
        result.finish = getFinish()
        result.firstFinish = result.extends.firstFinish
        return result
    end)
    : case 'return'
    : call(function ()
        local result = {
            type    = 'doc.return',
            returns = {},
        }
        while true do
            local docType = parseType(result)
            if not docType then
                break
            end
            if not result.start then
                result.start = docType.start
            end
            if checkToken('symbol', '?', 1) then
                nextToken()
                docType.optional = true
            end
            docType.name = parseName('doc.return.name', docType)
            result.returns[#result.returns+1] = docType
            if not checkToken('symbol', ',', 1) then
                break
            end
            nextToken()
        end
        if #result.returns == 0 then
            return nil
        end
        result.finish = getFinish()
        return result
    end)
    : case 'field'
    : call(function ()
        local result = {
            type = 'doc.field',
        }
        try(function ()
            local tp, value = nextToken()
            if tp == 'name' then
                if value == 'public'
                or value == 'protected'
                or value == 'private' then
                    result.visible = value
                    result.start = getStart()
                    return true
                end
            end
            return false
        end)
        result.field = parseName('doc.field.name', result)
                    or parseIndexField('doc.field.name', result)
        if not result.field then
            pushWarning {
                type   = 'LUADOC_MISS_FIELD_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        if not result.start then
            result.start = result.field.start
        end
        if checkToken('symbol', '?', 1) then
            nextToken()
            result.optional = true
        end
        result.extends = parseType(result)
        if not result.extends then
            pushWarning {
                type   = 'LUADOC_MISS_FIELD_EXTENDS',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        result.finish = getFinish()
        return result
    end)
    : case 'generic'
    : call(function ()
        local result = {
            type = 'doc.generic',
            generics = {},
        }
        while true do
            local object = {
                type = 'doc.generic.object',
                parent = result,
            }
            object.generic = parseName('doc.generic.name', object)
            if not object.generic then
                pushWarning {
                    type   = 'LUADOC_MISS_GENERIC_NAME',
                    start  = getFinish(),
                    finish = getFinish(),
                }
                return nil
            end
            object.start = object.generic.start
            if not result.start then
                result.start = object.start
            end
            if checkToken('symbol', ':', 1) then
                nextToken()
                object.extends = parseType(object)
            end
            object.finish = getFinish()
            result.generics[#result.generics+1] = object
            if not checkToken('symbol', ',', 1) then
                break
            end
            nextToken()
        end
        result.finish = getFinish()
        return result
    end)
    : case 'vararg'
    : call(function ()
        local result = {
            type = 'doc.vararg',
        }
        result.vararg = parseType(result)
        if not result.vararg then
            pushWarning {
                type   = 'LUADOC_MISS_VARARG_TYPE',
                start  = getFinish(),
                finish = getFinish(),
            }
            return
        end
        result.start = result.vararg.start
        result.finish = result.vararg.finish
        return result
    end)
    : case 'overload'
    : call(function ()
        local tp, name = peekToken()
        if tp ~= 'name'
        or (name ~= 'fun' and name ~= 'async') then
            pushWarning {
                type   = 'LUADOC_MISS_FUN_AFTER_OVERLOAD',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        local result = {
            type = 'doc.overload',
        }
        result.overload = parseFunction(result)
        if not result.overload then
            return nil
        end
        result.overload.parent = result
        result.start = result.overload.start
        result.finish = result.overload.finish
        return result
    end)
    : case 'deprecated'
    : call(function ()
        return {
            type   = 'doc.deprecated',
            start  = getFinish(),
            finish = getFinish(),
        }
    end)
    : case 'meta'
    : call(function ()
        return {
            type   = 'doc.meta',
            start  = getFinish(),
            finish = getFinish(),
        }
    end)
    : case 'version'
    : call(function ()
        local result = {
            type     = 'doc.version',
            versions = {},
        }
        while true do
            local tp, text = nextToken()
            if not tp then
                pushWarning {
                    type  = 'LUADOC_MISS_VERSION',
                    start  = getFinish(),
                    finish = getFinish(),
                }
                break
            end
            if not result.start then
                result.start = getStart()
            end
            local version = {
                type   = 'doc.version.unit',
                parent = result,
                start  = getStart(),
            }
            if tp == 'symbol' then
                if text == '>' then
                    version.ge = true
                elseif text == '<' then
                    version.le = true
                end
                tp, text = nextToken()
            end
            if tp ~= 'name' then
                pushWarning {
                    type  = 'LUADOC_MISS_VERSION',
                    start  = getStart(),
                    finish = getFinish(),
                }
                break
            end
            version.version = tonumber(text) or text
            version.finish = getFinish()
            result.versions[#result.versions+1] = version
            if not checkToken('symbol', ',', 1) then
                break
            end
            nextToken()
        end
        if #result.versions == 0 then
            return nil
        end
        result.finish = getFinish()
        return result
    end)
    : case 'see'
    : call(function ()
        local result = {
            type     = 'doc.see',
        }
        result.name = parseName('doc.see.name', result)
        if not result.name then
            return nil
        end
        result.start = result.name.start
        result.finish = result.name.finish
        if checkToken('symbol', '#', 1) then
            nextToken()
            result.field = parseName('doc.see.field', result)
            result.finish = getFinish()
        end
        return result
    end)
    : case 'diagnostic'
    : call(function ()
        local result = {
            type = 'doc.diagnostic',
        }
        local nextTP, mode = nextToken()
        if nextTP ~= 'name' then
            pushWarning {
                type   = 'LUADOC_MISS_DIAG_MODE',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        result.mode   = mode
        result.start  = getStart()
        result.finish = getFinish()
        if  mode ~= 'disable-next-line'
        and mode ~= 'disable-line'
        and mode ~= 'disable'
        and mode ~= 'enable' then
            pushWarning {
                type   = 'LUADOC_ERROR_DIAG_MODE',
                start  = result.start,
                finish = result.finish,
            }
        end

        if checkToken('symbol', ':', 1) then
            nextToken()
            result.names = {}
            while true do
                local name = parseName('doc.diagnostic.name', result)
                if not name then
                    pushWarning {
                        type   = 'LUADOC_MISS_DIAG_NAME',
                        start  = getFinish(),
                        finish = getFinish(),
                    }
                    return result
                end
                result.names[#result.names+1] = name
                if not checkToken('symbol', ',', 1) then
                    break
                end
                nextToken()
            end
        end

        result.finish = getFinish()

        return result
    end)
    : case 'module'
    : call(function ()
        local result = {
            type     = 'doc.module',
            start    = getFinish(),
            finish   = getFinish(),
        }
        local tp, content = peekToken()
        if tp == 'string' then
            result.module = content
            nextToken()
            result.start  = getStart()
            result.finish = getFinish()
            result.smark  = getMark()
        else
            pushWarning {
                type   = 'LUADOC_MISS_MODULE_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
        end
        return result
    end)
    : case 'async'
    : call(function ()
        return {
            type   = 'doc.async',
            start  = getFinish(),
            finish = getFinish(),
        }
    end)
    : case 'nodiscard'
    : call(function ()
        return {
            type   = 'doc.nodiscard',
            start  = getFinish(),
            finish = getFinish(),
        }
    end)
    : case 'as'
    : call(function ()
        local result = {
            type   = 'doc.as',
            start  = getFinish(),
            finish = getFinish(),
        }
        result.as     = parseType(result)
        result.finish = getFinish()
        return result
    end)
    : case 'cast'
    : call(function ()
        local result = {
            type   = 'doc.cast',
            start  = getFinish(),
            finish = getFinish(),
            casts  = {},
        }

        local loc = parseName('doc.cast.name', result)
        if not loc then
            pushWarning {
                type   = 'LUADOC_MISS_LOCAL_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            return result
        end

        result.loc    = loc
        result.finish = loc.finish

        while true do
            local block = {
                type   = 'doc.cast.block',
                parent = result,
                start  = getFinish(),
                finish = getFinish(),
            }
            if     checkToken('symbol', '+', 1) then
                block.mode = '+'
                nextToken()
                block.start  = getStart()
                block.finish = getFinish()
            elseif checkToken('symbol', '-', 1) then
                block.mode = '-'
                nextToken()
                block.start  = getStart()
                block.finish = getFinish()
            end

            if checkToken('symbol', '?', 1) then
                block.optional = true
                nextToken()
                block.start  = block.start or getStart()
                block.finish = block.finish
            else
                block.extends = parseType(block)
                if block.extends then
                    block.start  = block.start or block.extends.start
                    block.finish = block.extends.finish
                end
            end

            if block.optional or block.extends then
                result.casts[#result.casts+1] = block
            end

            if checkToken('symbol', ',', 1) then
                nextToken()
            else
                break
            end
        end

        return result
    end)

local function convertTokens()
    local tp, text = nextToken()
    if not tp then
        return
    end
    if tp ~= 'name' then
        pushWarning {
            type   = 'LUADOC_MISS_CATE_NAME',
            start  = getStart(),
            finish = getFinish(),
        }
        return nil
    end
    return docSwitch(text)
end

local function trimTailComment(text)
    local comment = text
    if text:sub(1, 1) == '@' then
        comment = text:sub(2)
    end
    if text:sub(1, 1) == '#' then
        comment = text:sub(2)
    end
    if text:sub(1, 2) == '--' then
        comment = text:sub(3)
    end
    if comment:find '^%s*[\'"[]' then
        local state = parser(comment:gsub('^%s+', ''), 'String')
        if state and state.ast then
            comment = state.ast[1]
        end
    end
    return comment
end

local function buildLuaDoc(comment)
    local text = comment.text
    local startPos = (comment.type == 'comment.short' and text:match '^%-%s*@()')
                  or (comment.type == 'comment.long'  and text:match '^@()')
    if not startPos then
        return {
            type    = 'doc.comment',
            start   = comment.start,
            finish  = comment.finish,
            range   = comment.finish,
            comment = comment,
        }
    end

    local doc = text:sub(startPos)

    parseTokens(doc, comment.start + startPos)
    local result = convertTokens()
    if result then
        result.range = comment.finish
        local cstart = text:find('%S', (result.firstFinish or result.finish) - comment.start)
        if cstart and cstart < comment.finish then
            result.comment = {
                type   = 'doc.tailcomment',
                start  = cstart + comment.start,
                finish = comment.finish,
                parent = result,
                text   = trimTailComment(text:sub(cstart)),
            }
        end
    end

    if result then
        return result
    end

    return {
        type    = 'doc.comment',
        start   = comment.start,
        finish  = comment.finish,
        range   = comment.finish,
        comment = comment,
    }
end

local function isTailComment(text, binded)
    local lastDoc       = binded[#binded]
    local left          = lastDoc.originalComment.start
    local row, col      = guide.rowColOf(left)
    local lineStart     = Lines[row] or 0
    local hasCodeBefore = text:sub(lineStart, lineStart + col):find '[%w_]'
    return hasCodeBefore
end

local function isNextLine(binded, doc)
    if not binded then
        return false
    end
    local lastDoc = binded[#binded]
    if lastDoc.type == 'doc.type'
    or lastDoc.type == 'doc.module' then
        return false
    end
    if lastDoc.type == 'doc.class'
    or lastDoc.type == 'doc.field' then
        if  doc.type ~= 'doc.field'
        and doc.type ~= 'doc.comment'
        and doc.type ~= 'doc.overload' then
            return false
        end
    end
    if doc.type == 'doc.cast' then
        return false
    end
    local lastRow = guide.rowColOf(lastDoc.finish)
    local newRow  = guide.rowColOf(doc.start)
    return newRow - lastRow == 1
end

local function bindGeneric(binded)
    local generics = {}
    for _, doc in ipairs(binded) do
        if doc.type == 'doc.generic' then
            for _, obj in ipairs(doc.generics) do
                local name = obj.generic[1]
                generics[name] = true
            end
        end
        if doc.type == 'doc.class'
        or doc.type == 'doc.alias' then
            if doc.signs then
                for _, sign in ipairs(doc.signs) do
                    local name = sign[1]
                    generics[name] = true
                end
            end
        end
        if doc.type == 'doc.param'
        or doc.type == 'doc.return'
        or doc.type == 'doc.type'
        or doc.type == 'doc.class'
        or doc.type == 'doc.alias' then
            guide.eachSourceType(doc, 'doc.type.name', function (src)
                local name = src[1]
                if generics[name] then
                    src.type = 'doc.generic.name'
                end
            end)
        end
    end
end

local function bindDocsBetween(sources, binded, bindSources, start, finish)
    -- 用二分法找到第一个
    local max = #sources
    local index
    local left  = 1
    local right = max
    for _ = 1, 1000 do
        index = left + (right - left) // 2
        if index <= left then
            index = left
            break
        elseif index >= right then
            index = right
            break
        end
        local src = sources[index]
        if src.start < start then
            left = index + 1
        else
            right = index
        end
    end

    -- 从前往后进行绑定
    for i = index, max do
        local src = sources[i]
        if src and src.start >= start then
            if src.start >= finish then
                break
            end
            -- 遇到table后中断，处理以下情况：
            -- ---@type AAA
            -- local t = {x = 1, y = 2}
            if src.type == 'table' then
                break
            end
            if src.start >= start then
                if src.type == 'local'
                or src.type == 'self'
                or src.type == 'setlocal'
                or src.type == 'setglobal'
                or src.type == 'tablefield'
                or src.type == 'tableindex'
                or src.type == 'setfield'
                or src.type == 'setindex'
                or src.type == 'setmethod'
                or src.type == 'function' then
                    src.bindDocs = binded
                    bindSources[#bindSources+1] = src
                end
            end
        end
    end
end

local function bindReturnIndex(binded)
    local returnIndex = 0
    for _, doc in ipairs(binded) do
        if doc.type == 'doc.return' then
            for _, rtn in ipairs(doc.returns) do
                returnIndex = returnIndex + 1
                rtn.returnIndex = returnIndex
            end
        end
    end
end

local function bindClassAndFields(binded)
    local class
    for _, doc in ipairs(binded) do
        if doc.type == 'doc.class' then
            -- 多个class连续写在一起，只有最后一个class可以绑定source
            if class then
                class.bindSources = nil
            end
            class = doc
        elseif doc.type == 'doc.field' then
            if class then
                class.fields[#class.fields+1] = doc
                doc.class = class
            end
        end
    end
end

local function bindDoc(sources, binded)
    if not binded then
        return
    end
    local lastDoc = binded[#binded]
    if not lastDoc then
        return
    end
    local bindSources = {}
    for _, doc in ipairs(binded) do
        doc.bindGroup = binded
        doc.bindSources = bindSources
    end
    bindGeneric(binded)
    local row = guide.rowColOf(lastDoc.finish)
    bindDocsBetween(sources, binded, bindSources, guide.positionOf(row, 0), lastDoc.start)
    if #bindSources == 0 then
        bindDocsBetween(sources, binded, bindSources, guide.positionOf(row + 1, 0), guide.positionOf(row + 2, 0))
    end
    bindReturnIndex(binded)
    bindClassAndFields(binded)
end

local bindDocAccept = {
    'local'     , 'setlocal'  , 'setglobal',
    'setfield'  , 'setmethod' , 'setindex' ,
    'tablefield', 'tableindex', 'self'     ,
    'function'  , 'table'     , '...'      ,
}

local function bindDocs(state)
    local text = state.lua
    local sources = {}
    guide.eachSourceTypes(state.ast, bindDocAccept, function (src)
        sources[#sources+1] = src
    end)
    table.sort(sources, function (a, b)
        return a.start < b.start
    end)
    local binded
    for _, doc in ipairs(state.ast.docs) do
        if not isNextLine(binded, doc) then
            bindDoc(sources, binded)
            binded = {}
            state.ast.docs.groups[#state.ast.docs.groups+1] = binded
        end
        binded[#binded+1] = doc
        if isTailComment(text, binded) then
            bindDoc(sources, binded)
            binded = nil
        end
    end
    bindDoc(sources, binded)
end

return function (state)
    local ast = state.ast
    local comments = state.comms
    table.sort(comments, function (a, b)
        return a.start < b.start
    end)
    ast.docs = {
        type   = 'doc',
        parent = ast,
        groups = {},
    }

    pushWarning = function (err)
        err.level = err.level or 'Warning'
        state.pushError(err)
    end
    Lines       = state.lines

    local ci = 1
    NextComment = function (offset, peek)
        local comment = comments[ci + (offset or 0)]
        if not peek then
            ci = ci + 1 + (offset or 0)
        end
        return comment
    end

    while true do
        local comment = NextComment()
        if not comment then
            break
        end
        local doc = buildLuaDoc(comment)
        if doc then
            ast.docs[#ast.docs+1] = doc
            doc.parent = ast.docs
            if ast.start > doc.start then
                ast.start = doc.start
            end
            if ast.finish < doc.finish then
                ast.finish = doc.finish
            end
            doc.originalComment = comment
        end
    end

    if #ast.docs == 0 then
        return
    end

    bindDocs(state)
end
