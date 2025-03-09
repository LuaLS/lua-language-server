local m          = require 'lpeglabel'
local re         = require 'parser.relabel'
local guide      = require 'parser.guide'
local compile    = require 'parser.compile'
local util       = require 'utility'

local TokenTypes, TokenStarts, TokenFinishs, TokenContents, TokenMarks
---@type integer
local Ci
---@type integer
local Offset
local pushWarning, NextComment, Lines
local parseType, parseTypeUnit
---@type any
local Parser = re.compile([[
Main                <-  (Token / Sp)*
Sp                  <-  %s+
X16                 <-  [a-fA-F0-9]
Token               <-  Integer / Name / String / Code / Symbol
Name                <-  ({} {%name} {})
                    ->  Name
Integer             <-  ({} {'-'? [0-9]+} !'.' {})
                    ->  Integer
Code                <-  ({} '`' { (!'`' .)*} '`' {})
                    ->  Code
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
                            [:|,;<>()?+#{}*]
                        /   '[]'
                        /   '...'
                        /   '['
                        /   ']'
                        /   '-' !'-'
                        /   '.' !'..'
                        } {})
                    ->  Symbol
]], {
    s  = m.S' \t\v\f',
    ea = '\a',
    eb = '\b',
    ef = '\f',
    en = '\n',
    er = '\r',
    et = '\t',
    ev = '\v',
    name = (m.R('az', 'AZ', '09', '\x80\xff') + m.S('_')) * (m.R('az', 'AZ', '09', '\x80\xff') + m.S('_.*-'))^0,
    Char10 = function (char)
        ---@type integer?
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
    Code = function (start, content, finish)
        Ci = Ci + 1
        TokenTypes[Ci]    = 'code'
        TokenStarts[Ci]   = start
        TokenFinishs[Ci]  = finish - 1
        TokenContents[Ci] = content
    end,
    Symbol = function (start, content, finish)
        Ci = Ci + 1
        TokenTypes[Ci]    = 'symbol'
        TokenStarts[Ci]   = start
        TokenFinishs[Ci]  = finish - 1
        TokenContents[Ci] = content
    end,
})

---@alias parser.visibleType 'public' | 'protected' | 'private' | 'package'

---@class parser.object
---@field literal           boolean
---@field signs             parser.object[]
---@field originalComment   parser.object
---@field as?               parser.object
---@field touch?            integer
---@field module?           string
---@field async?            boolean
---@field versions?         table[]
---@field names?            parser.object[]
---@field path?             string
---@field bindComments?     parser.object[]
---@field visible?          parser.visibleType
---@field operators?        parser.object[]
---@field calls?            parser.object[]
---@field generics?         parser.object[]
---@field generic?          parser.object
---@field docAttr?          parser.object
---@field pattern?          string

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

local function peekToken(offset)
    offset = offset or 1
    return TokenTypes[Ci + offset], TokenContents[Ci + offset]
end

---@return string? tokenType
---@return string? tokenContent
local function nextToken()
    Ci = Ci + 1
    if not TokenTypes[Ci] then
        Ci = Ci - 1
        return nil, nil
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

---@return integer
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

local function parseDocAttr(parent)
    if not checkToken('symbol', '(', 1) then
        return nil
    end
    nextToken()

    local attrs = {
        type   = 'doc.attr',
        parent = parent,
        start  = getStart(),
        finish = getStart(),
        names  = {},
    }

    while true do
        if checkToken('symbol', ',', 1) then
            nextToken()
            goto continue
        end
        local name = parseName('doc.attr.name', attrs)
        if not name then
            break
        end
        attrs.names[#attrs.names+1] = name
        attrs.finish = name.finish
        ::continue::
    end

    nextSymbolOrError(')')
    attrs.finish = getFinish()

    return attrs
end

local function parseIndexField(parent)
    if not checkToken('symbol', '[', 1) then
        return nil
    end
    nextToken()
    local field = parseType(parent)
    nextSymbolOrError ']'
    return field
end

local function slideToNextLine()
    if peekToken() then
        return
    end
    local nextComment = NextComment(0, true)
    if not nextComment then
        return
    end
    local currentComment = NextComment(-1, true)
    local currentLine = guide.rowColOf(currentComment.start)
    local nextLine = guide.rowColOf(nextComment.start)
    if currentLine + 1 ~= nextLine then
        return
    end
    if nextComment.text:sub(1, 1) ~= '-' then
        return
    end
    if nextComment.text:match '^%-%s*%@' then
        return
    end
    NextComment()
    parseTokens(nextComment.text:sub(2), nextComment.start + 2)
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
        slideToNextLine()
        if checkToken('symbol', '}', 1) then
            nextToken()
            break
        end
        local field = {
            type   = 'doc.type.field',
            parent = typeUnit,
        }

        do
            local needCloseParen
            if checkToken('symbol', '(', 1) then
                nextToken()
                needCloseParen = true
            end
            field.name = parseName('doc.field.name', field)
                    or   parseIndexField(field)
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
            if needCloseParen then
                nextSymbolOrError ')'
            end
        end

        typeUnit.fields[#typeUnit.fields+1] = field
        if checkToken('symbol', ',', 1)
        or checkToken('symbol', ';', 1) then
            nextToken()
        else
            nextSymbolOrError('}')
            break
        end
    end
    typeUnit.finish = getFinish()
    return typeUnit
end

local function parseTuple(parent)
    if not checkToken('symbol', '[', 1) then
        return nil
    end
    nextToken()
    local typeUnit = {
        type    = 'doc.type.table',
        start   = getStart(),
        parent  = parent,
        fields  = {},
        isTuple = true,
    }

    local index = 1
    while true do
        slideToNextLine()
        if checkToken('symbol', ']', 1) then
            nextToken()
            break
        end
        local field = {
            type   = 'doc.type.field',
            parent = typeUnit,
        }

        do
            local needCloseParen
            if checkToken('symbol', '(', 1) then
                nextToken()
                needCloseParen = true
            end
            field.name = {
                type        = 'doc.type',
                start       = getFinish(),
                firstFinish = getFinish(),
                finish      = getFinish(),
                parent      = field,
            }
            field.name.types = {
                [1] = {
                    type   = 'doc.type.integer',
                    start  = getFinish(),
                    finish = getFinish(),
                    parent = field.name,
                    [1]    = index,
                }
            }
            index          = index + 1
            field.extends  = parseType(field)
            if not field.extends then
                break
            end
            field.optional = field.extends.optional
            field.start    = field.extends.start
            field.finish   = field.extends.finish
            if needCloseParen then
                nextSymbolOrError ')'
            end
        end

        typeUnit.fields[#typeUnit.fields+1] = field
        if checkToken('symbol', ',', 1)
        or checkToken('symbol', ';', 1) then
            nextToken()
        else
            nextSymbolOrError(']')
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
        slideToNextLine()
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
    slideToNextLine()
    if checkToken('symbol', ':', 1) then
        nextToken()
        slideToNextLine()
        local needCloseParen
        if checkToken('symbol', '(', 1) then
            nextToken()
            needCloseParen = true
        end
        while true do
            slideToNextLine()
            local name
            try(function ()
                local returnName = parseName('doc.return.name', typeUnit)
                                or parseDots('doc.return.name', typeUnit)
                if not returnName then
                    return false
                end
                if checkToken('symbol', ':', 1) then
                    nextToken()
                    name = returnName
                    return true
                end
                if returnName[1] == '...' then
                    name = returnName
                    return false
                end
                return false
            end)
            local rtn = parseType(typeUnit)
            if not rtn then
                break
            end
            rtn.name = name
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
        if needCloseParen then
            nextSymbolOrError ')'
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
        if #content > 1 and content:sub(1, 1) == content:sub(-1, -1) then
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

local function parseCodePattern(parent)
    local tp, pattern = peekToken()
    if not tp or (tp ~= 'name' and tp ~= 'code') then
        return nil
    end
    local codeOffset
    local content
    local i = 1
    if tp == 'code' then
        codeOffset = i
        content = pattern
        pattern = '%s'
    end
    while true do
        i = i+1
        local nextTp, nextContent = peekToken(i)
        if not nextTp or TokenFinishs[Ci+i-1] + 1 ~= TokenStarts[Ci+i] then
            ---不连续的name，无效的
            break
        end
        if nextTp == 'name' then
            pattern = pattern .. nextContent
        elseif nextTp == 'code' then
            if codeOffset then
                -- 暂时不支持多generic
                break
            end
            codeOffset = i
            pattern = pattern .. '%s'
            content = nextContent
        elseif codeOffset then
            -- should be match with Parser "name" mask
            if nextTp == 'integer' then
                pattern = pattern .. nextContent
            elseif nextTp == 'symbol' and (nextContent == '.' or nextContent == '*' or nextContent == '-') then
                pattern = pattern .. nextContent
            else
                break
            end
        else
            break
        end
    end
    if not codeOffset then
        return nil
    end
    nextToken()
    local start = getStart()
    local finishOffset = i-1
    if finishOffset == 1 then
        -- code only, no pattern
        pattern = nil
    else
        for _ = 2, finishOffset do
            nextToken()
        end
    end
    local code = {
        type   = 'doc.type.code',
        start  = start,
        finish = getFinish(),
        parent = parent,
        pattern = pattern,
        [1]    = content,
    }
    return code
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
                or parseTuple(parent)
                or parseString(parent)
                or parseInteger(parent)
                or parseBoolean(parent)
                or parseParen(parent)
                or parseCodePattern(parent)
    if not result then
        result = parseName('doc.type.name', parent)
              or parseDots('doc.type.name', parent)
        if not result then
            return nil
        end
        if result[1] == '...' then
            result[1] = 'unknown'
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

local lockResume = false

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
            local nextComm = NextComment(i, true)
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
                            resume.comment = nextComm.text:match('%s*#?%s*(.+)', resume.finish - nextComm.start)
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

    if not lockResume then
        lockResume = true
        while pushResume() do end
        lockResume = false
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
            type      = 'doc.class',
            fields    = {},
            operators = {},
            calls     = {},
        }
        result.docAttr = parseDocAttr(result)
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
                        or parseTuple(result)
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
        local first = parseType()
        if not first then
            return nil
        end
        local rests
        while checkToken('symbol', ',', 1) do
            nextToken()
            local rest = parseType()
            if not rests then
                rests = {}
            end
            rests[#rests+1] = rest
        end
        return first, rests
    end)
    : case 'alias'
    : call(function ()
        local result = {
            type   = 'doc.alias',
        }
        result.docAttr = parseDocAttr(result)
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
            local dots = parseDots('doc.return.name')
            if dots then
                Ci = Ci - 1
            end
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
            if dots then
                docType.name = dots
                dots.parent  = docType
            else
                docType.name = parseName('doc.return.name', docType)
                            or parseDots('doc.return.name', docType)
            end
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
                or value == 'private'
                or value == 'package' then
                    local tp2 = peekToken(1)
                    local tp3 = peekToken(2)
                    if tp2 == 'name' and not tp3 then
                        return false
                    end
                    result.visible = value
                    result.start = getStart()
                    return true
                end
            end
            return false
        end)
        result.field = parseName('doc.field.name', result)
                    or parseIndexField(result)
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
        local meta = {
            type   = 'doc.meta',
            start  = getFinish(),
            finish = getFinish(),
        }
        meta.name = parseName('doc.meta.name', meta)
        return meta
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
            pushWarning {
                type  = 'LUADOC_MISS_SEE_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        result.start  = result.name.start
        result.finish = result.name.finish
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

        result.name   = loc
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
                block.finish = getFinish()
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
            result.finish = block.finish

            if checkToken('symbol', ',', 1) then
                nextToken()
            else
                break
            end
        end

        return result
    end)
    : case 'operator'
    : call(function ()
        local result = {
            type   = 'doc.operator',
            start  = getFinish(),
            finish = getFinish(),
        }

        local op = parseName('doc.operator.name', result)
        if not op then
            pushWarning {
                type   = 'LUADOC_MISS_OPERATOR_NAME',
                start  = getFinish(),
                finish = getFinish(),
            }
            return nil
        end
        result.op = op
        result.finish = op.finish

        if checkToken('symbol', '(', 1) then
            nextToken()
            if checkToken('symbol', ')', 1) then
                nextToken()
            else
                local exp = parseType(result)
                if exp then
                    result.exp = exp
                    result.finish = exp.finish
                end
                nextSymbolOrError ')'
            end
        end

        nextSymbolOrError ':'

        local ret = parseType(result)
        if ret then
            result.extends = ret
            result.finish  = ret.finish
        end

        return result
    end)
    : case 'source'
    : call(function (doc)
        local fullSource = doc:sub(#'source' + 1)
        if not fullSource or fullSource == '' then
            return
        end
        fullSource = util.trim(fullSource)
        if fullSource == '' then
            return
        end
        local source, line, char = fullSource:match('^(.-):?(%d*):?(%d*)$')
        source = source or fullSource
        line   = tonumber(line) or 1
        char   = tonumber(char) or 0
        local result = {
            type   = 'doc.source',
            start  = getStart(),
            finish = getFinish(),
            path   = source,
            line   = line,
            char   = char,
        }
        return result
    end)
    : case 'enum'
    : call(function ()
        local attr = parseDocAttr()
        local name = parseName('doc.enum.name')
        if not name then
            return nil
        end
        local result = {
            type    = 'doc.enum',
            start   = name.start,
            finish  = name.finish,
            enum    = name,
            docAttr = attr,
        }
        name.parent = result
        if attr then
            attr.parent = result
        end
        return result
    end)
    : case 'private'
    : call(function ()
        return {
            type   = 'doc.private',
            start  = getFinish(),
            finish = getFinish(),
        }
    end)
    : case 'protected'
    : call(function ()
        return {
            type   = 'doc.protected',
            start  = getFinish(),
            finish = getFinish(),
        }
    end)
    : case 'public'
    : call(function ()
        return {
            type   = 'doc.public',
            start  = getFinish(),
            finish = getFinish(),
        }
    end)
    : case 'package'
    : call(function ()
        return {
            type   = 'doc.package',
            start  = getFinish(),
            finish = getFinish(),
        }
    end)

local function convertTokens(doc)
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
    return docSwitch(text, doc)
end

local function trimTailComment(text)
    local comment = text
    if text:sub(1, 1) == '@' then
        comment = util.trim(text:sub(2))
    end
    if text:sub(1, 1) == '#' then
        comment = util.trim(text:sub(2))
    end
    if text:sub(1, 2) == '--' then
        comment = util.trim(text:sub(3))
    end
    if  comment:find '^%s*[\'"[]'
    and comment:find '[\'"%]]%s*$' then
        local state = compile(comment:gsub('^%s+', ''), 'String')
        if state and state.ast then
            comment = state.ast[1] --[[@as string]]
        end
    end
    return util.trim(comment)
end

local function buildLuaDoc(comment)
    local headPos = (comment.type == 'comment.short' and comment.text:match '^%-%s*@()')
                 or (comment.type == 'comment.long'  and comment.text:match '^%s*@()')
    if not headPos then
        return {
            type    = 'doc.comment',
            start   = comment.start,
            finish  = comment.finish,
            range   = comment.finish,
            comment = comment,
        }
    end
    -- absolute position of `@` symbol
    local startOffset = comment.start + headPos
    if comment.type == 'comment.long' then
        startOffset = comment.start + headPos + #comment.mark - 2
    end

    local doc = comment.text:sub(headPos)

    parseTokens(doc, startOffset)
    local result, rests = convertTokens(doc)
    if result then
        result.range = math.max(comment.finish, result.finish)
        local finish = result.firstFinish or result.finish
        if rests then
            for _, rest in ipairs(rests) do
                rest.range = math.max(comment.finish, rest.finish)
                finish = rest.firstFinish or rest.finish
            end
        end

        -- `result` can be a multiline annotation or an alias, while `doc` is the first line, so we can't parse comment
        if finish >= comment.finish then
            return result, rests
        end

        local cstart = doc:find('%S', finish - startOffset)
        if cstart then
            result.comment = {
                type   = 'doc.tailcomment',
                start  = startOffset + cstart,
                finish = comment.finish,
                parent = result,
                text   = trimTailComment(doc:sub(cstart)),
            }
            if rests then
                for _, rest in ipairs(rests) do
                    rest.comment = result.comment
                end
            end
        end

        return result, rests
    end

    return {
        type    = 'doc.comment',
        start   = comment.start,
        finish  = comment.finish,
        range   = comment.finish,
        comment = comment,
    }
end

local function isTailComment(text, doc)
    if not doc then
        return false
    end
    local left          = doc.originalComment.start
    local row, col      = guide.rowColOf(left)
    local lineStart     = Lines[row] or 0
    local hasCodeBefore = text:sub(lineStart, lineStart + col):find '[%w_]'
    return hasCodeBefore
end

local function isContinuedDoc(lastDoc, nextDoc)
    if not nextDoc then
        return false
    end
    if nextDoc.type == 'doc.diagnostic' then
        return true
    end
    if lastDoc.type == 'doc.type'
    or lastDoc.type == 'doc.module'
    or lastDoc.type == 'doc.enum' then
        if nextDoc.type ~= 'doc.comment' then
            return false
        end
    end
    if lastDoc.type == 'doc.class'
    or lastDoc.type == 'doc.field'
    or lastDoc.type == 'doc.operator' then
        if  nextDoc.type ~= 'doc.field'
        and nextDoc.type ~= 'doc.operator'
        and nextDoc.type ~= 'doc.comment'
        and nextDoc.type ~= 'doc.overload'
        and nextDoc.type ~= 'doc.source' then
            return false
        end
    end
    if nextDoc.type == 'doc.cast' then
        return false
    end
    return true
end

local function isNextLine(lastDoc, nextDoc)
    if not nextDoc then
        return false
    end
    local lastRow = guide.rowColOf(lastDoc.finish)
    local newRow  = guide.rowColOf(nextDoc.start)
    return newRow - lastRow == 1
end

local function bindGeneric(binded)
    local generics = {}
    for _, doc in ipairs(binded) do
        if doc.type == 'doc.generic' then
            for _, obj in ipairs(doc.generics) do
                local name = obj.generic[1]
                generics[name] = obj
            end
        end
        if doc.type == 'doc.class'
        or doc.type == 'doc.alias' then
            if doc.signs then
                for _, sign in ipairs(doc.signs) do
                    local name = sign[1]
                    generics[name] = sign
                end
            end
        end
        if doc.type == 'doc.param'
        or doc.type == 'doc.vararg'
        or doc.type == 'doc.return'
        or doc.type == 'doc.type'
        or doc.type == 'doc.class'
        or doc.type == 'doc.alias' then
            guide.eachSourceType(doc, 'doc.type.name', function (src)
                local name = src[1]
                if generics[name] then
                    src.type = 'doc.generic.name'
                    src.generic = generics[name]
                end
            end)
            guide.eachSourceType(doc, 'doc.type.code', function (src)
                local name = src[1]
                if generics[name] then
                    src.type = 'doc.generic.name'
                    src.literal = true
                end
            end)
        end
    end
end

local function bindDocWithSource(doc, source)
    if not source.bindDocs then
        source.bindDocs = {}
    end
    if source.bindDocs[#source.bindDocs] ~= doc then
        source.bindDocs[#source.bindDocs+1] = doc
    end
    doc.bindSource = source
end

local function bindDoc(source, binded)
    local isParam = source.type == 'self'
                or  source.type == 'local'
                and (source.parent.type == 'funcargs'
                        or (    source.parent.type == 'in'
                            and source.finish <= source.parent.keys.finish
                        )
                    )
    local ok = false
    for _, doc in ipairs(binded) do
        if doc.bindSource then
            goto CONTINUE
        end
        if doc.type == 'doc.class'
        or doc.type == 'doc.deprecated'
        or doc.type == 'doc.version'
        or doc.type == 'doc.module'
        or doc.type == 'doc.source'
        or doc.type == 'doc.private'
        or doc.type == 'doc.protected'
        or doc.type == 'doc.public'
        or doc.type == 'doc.package'
        or doc.type == 'doc.see' then
            if source.type == 'function'
            or isParam then
                goto CONTINUE
            end
            bindDocWithSource(doc, source)
            ok = true
        elseif doc.type == 'doc.type' then
            if source.type == 'function'
            or isParam
            or source._bindedDocType then
                goto CONTINUE
            end
            source._bindedDocType = true
            bindDocWithSource(doc, source)
            ok = true
        elseif doc.type == 'doc.overload' then
            if not source.bindDocs then
                source.bindDocs = {}
            end
            source.bindDocs[#source.bindDocs+1] = doc
            if source.type == 'function' then
                bindDocWithSource(doc, source)
            end
            ok = true
        elseif doc.type == 'doc.param' then
            if  isParam
            and doc.param[1] == source[1] then
                bindDocWithSource(doc, source)
                ok = true
            elseif source.type == '...'
            and    doc.param[1] == '...' then
                bindDocWithSource(doc, source)
                ok = true
            elseif source.type == 'self'
            and    doc.param[1] == 'self' then
                bindDocWithSource(doc, source)
                ok = true
            elseif source.type == 'function' then
                if not source.bindDocs then
                    source.bindDocs = {}
                end
                source.bindDocs[#source.bindDocs + 1] = doc
                if source.args then
                    for _, arg in ipairs(source.args) do
                        if arg[1] == doc.param[1] then
                            bindDocWithSource(doc, arg)
                            break
                        end
                    end
                end
            end
        elseif doc.type == 'doc.vararg' then
            if source.type == '...' then
                bindDocWithSource(doc, source)
                ok = true
            end
        elseif doc.type == 'doc.return'
        or     doc.type == 'doc.generic'
        or     doc.type == 'doc.async'
        or     doc.type == 'doc.nodiscard' then
            if source.type == 'function' then
                bindDocWithSource(doc, source)
                ok = true
            end
        elseif doc.type == 'doc.enum' then
            if source.type == 'table' then
                bindDocWithSource(doc, source)
                ok = true
            end
            if source.value and source.value.type == 'table' then
                bindDocWithSource(doc, source.value)
                goto CONTINUE
            end
        elseif doc.type == 'doc.comment' then
            bindDocWithSource(doc, source)
            ok = true
        end
        ::CONTINUE::
    end
    return ok
end

local function bindDocsBetween(sources, binded, start, finish)
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

    local ok = false
    -- 从前往后进行绑定
    for i = index, max do
        local src = sources[i]
        if src and src.start >= start then
            if src.start >= finish then
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
                or src.type == 'function'
                or src.type == 'return'
                or src.type == '...'
                or src.type == 'call'   -- for `rawset`
                then
                    if bindDoc(src, binded) then
                        ok = true
                    end
                end
            end
        end
    end

    return ok
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

local function bindCommentsToDoc(doc, comments)
    doc.bindComments = comments
    for _, comment in ipairs(comments) do
        comment.bindSource = doc
    end
end

local function bindCommentsAndFields(binded)
    local class
    local comments = {}
    local source
    for _, doc in ipairs(binded) do
        if doc.type == 'doc.class' then
            -- 多个class连续写在一起，只有最后一个class可以绑定source
            if class then
                class.bindSource = nil
            end
            if source then
                doc.source = source
                source.bindSource = doc
            end
            class = doc
            bindCommentsToDoc(doc, comments)
            comments = {}
        elseif doc.type == 'doc.field' then
            if class then
                class.fields[#class.fields+1] = doc
                doc.class = class
            end
            if source then
                doc.source = source
                source.bindSource = doc
            end
            bindCommentsToDoc(doc, comments)
            comments = {}
        elseif doc.type == 'doc.operator' then
            if class then
                class.operators[#class.operators+1] = doc
                doc.class = class
            end
            bindCommentsToDoc(doc, comments)
            comments = {}
        elseif doc.type == 'doc.overload' then
            if class then
                class.calls[#class.calls+1] = doc
                doc.class = class
            end
        elseif doc.type == 'doc.alias'
        or     doc.type == 'doc.enum' then
            bindCommentsToDoc(doc, comments)
            comments = {}
        elseif doc.type == 'doc.comment' then
            comments[#comments+1] = doc
        elseif doc.type == 'doc.source' then
            source = doc
            goto CONTINUE
        end
        source = nil
        ::CONTINUE::
    end
end

local function bindDocWithSources(sources, binded)
    if not binded then
        return
    end
    local lastDoc = binded[#binded]
    if not lastDoc then
        return
    end
    for _, doc in ipairs(binded) do
        doc.bindGroup = binded
    end
    bindGeneric(binded)
    bindCommentsAndFields(binded)
    bindReturnIndex(binded)

    -- doc is special node
    if lastDoc.special then
        if bindDoc(lastDoc.special, binded) then
            return
        end
    end

    local row = guide.rowColOf(lastDoc.finish)
    local suc = bindDocsBetween(sources, binded, guide.positionOf(row, 0), lastDoc.start)
    if not suc then
        bindDocsBetween(sources, binded, guide.positionOf(row + 1, 0), guide.positionOf(row + 2, 0))
    end
end

local bindDocAccept = {
    'local'     , 'setlocal'  , 'setglobal',
    'setfield'  , 'setmethod' , 'setindex' ,
    'tablefield', 'tableindex', 'self'     ,
    'function'  , 'return'     , '...'      ,
    'call',
}

local function bindDocs(state)
    local text = state.lua
    local sources = {}
    guide.eachSourceTypes(state.ast, bindDocAccept, function (src)
        -- allow binding docs with rawset(_G, "key", value)
        if src.type == 'call' then
            if src.node.special ~= 'rawset' or not src.args then
                return
            end
            local g, key = src.args[1], src.args[2]
            if not g or not key or g.special ~= '_G' then
                return
            end
        end
        sources[#sources+1] = src
    end)
    table.sort(sources, function (a, b)
        return a.start < b.start
    end)
    local binded
    for i, doc in ipairs(state.ast.docs) do
        if not binded then
            binded = {}
            state.ast.docs.groups[#state.ast.docs.groups+1] = binded
        end
        binded[#binded+1] = doc
        if doc.specialBindGroup then
            bindDocWithSources(sources, doc.specialBindGroup)
            binded = nil
        elseif isTailComment(text, doc) and doc.type ~= "doc.field" then
            bindDocWithSources(sources, binded)
            binded = nil
        else
            local nextDoc = state.ast.docs[i+1]
            if nextDoc and nextDoc.special
            or not isNextLine(doc, nextDoc) then
                bindDocWithSources(sources, binded)
                binded = nil
            end
            if  not isContinuedDoc(doc, nextDoc)
            and not isTailComment(text, nextDoc) then
                bindDocWithSources(sources, binded)
                binded = nil
            end
        end
    end
end

local function findTouch(state, doc)
    local text = state.lua
    local pos  = guide.positionToOffset(state, doc.originalComment.start)
    for i = pos - 2, 1, -1 do
        local c = text:sub(i, i)
        if c == '\r'
        or c == '\n' then
            break
        elseif c ~= ' '
        and    c ~= '\t' then
            doc.touch = guide.offsetToPosition(state, i)
            break
        end
    end
end

local function luadoc(state)
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
        local errs = state.errs
        if err.finish < err.start then
            err.finish = err.start
        end
        local last = errs[#errs]
        if last then
            if last.start <= err.start and last.finish >= err.finish then
                return
            end
        end
        err.level = err.level or 'Warning'
        errs[#errs+1] = err
        return err
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

    local function insertDoc(doc, comment)
        ast.docs[#ast.docs+1] = doc
        doc.parent = ast.docs
        if ast.start > doc.start then
            ast.start = doc.start
        end
        if ast.finish < doc.finish then
            ast.finish = doc.finish
        end
        doc.originalComment = comment
        if comment.type == 'comment.long' then
            findTouch(state, doc)
        end
    end

    while true do
        local comment = NextComment()
        if not comment then
            break
        end
        lockResume = false
        local doc, rests = buildLuaDoc(comment)
        if doc then
            insertDoc(doc, comment)
            if rests then
                for _, rest in ipairs(rests) do
                    insertDoc(rest, comment)
                end
            end
        end
    end

    if ast.state.pluginDocs then
        for _, doc in ipairs(ast.state.pluginDocs) do
            insertDoc(doc, doc.originalComment)
        end
        ---@param a unknown
        ---@param b unknown
        table.sort(ast.docs, function (a, b)
            return a.start < b.start
        end)
        ast.state.pluginDocs = nil
    end

    ast.docs.start  = ast.start
    ast.docs.finish = ast.finish

    if #ast.docs == 0 then
        return
    end

    bindDocs(state)
end

return {
    buildAndBindDoc = function (ast, src, comment, group)
        local doc = buildLuaDoc(comment)
        if doc then
            local pluginDocs = ast.state.pluginDocs or {}
            pluginDocs[#pluginDocs+1] = doc
            doc.special = src
            doc.originalComment = comment
            doc.virtual = true
            doc.specialBindGroup = group
            ast.state.pluginDocs = pluginDocs
            return doc
        end
        return nil
    end,
    luadoc = luadoc
}
