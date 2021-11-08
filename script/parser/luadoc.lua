local m          = require 'lpeglabel'
local re         = require 'parser.relabel'
local guide      = require 'parser.guide'
local parser     = require 'parser.newparser'

local TokenTypes, TokenStarts, TokenFinishs, TokenContents, TokenMarks
local Ci, Offset, pushError, NextComment, Lines
local parseType
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
    local class = {
        type   = tp,
        start  = getStart(),
        finish = getFinish(),
        parent = parent,
        [1]    = nameText,
    }
    return class
end

local function nextSymbolOrError(symbol)
    if checkToken('symbol', symbol, 1) then
        nextToken()
        return true
    end
    pushError {
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
    local class = {
        type   = tp,
        start  = getStart(),
        finish = getFinish(),
        parent = parent,
    }
    local indexTP, index = nextToken()
    if  indexTP ~= 'integer'
    and indexTP ~= 'string' then
        pushError {
            type   = 'LUADOC_INDEX_MUST_INT',
            start  = getStart(),
            finish = getFinish(),
        }
    end
    class[1] = index
    nextSymbolOrError ']'
    class.finish = getFinish()
    return class
end

local function parseClass(parent)
    local result = {
        type   = 'doc.class',
        parent = parent,
        fields = {},
    }
    result.class = parseName('doc.class.name', result)
    if not result.class then
        pushError {
            type   = 'LUADOC_MISS_CLASS_NAME',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    result.start  = getStart()
    result.finish = getFinish()
    if not peekToken() then
        return result
    end
    if not checkToken('symbol', ':', 1) then
        pushError {
            type   = 'LUADOC_MISS_EXTENDS_SYMBOL',
            start  = result.finish + 1,
            finish = getStart(),
        }
        return result
    end
    nextToken()

    result.extends = {}

    while true do
        local extend = parseName('doc.extends.name', result)
        if not extend then
            pushError {
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

local function parseTypeUnitTable(parent, node)
    if not checkToken('symbol', '<', 1) then
        return nil
    end
    if not nextSymbolOrError('<') then
        return nil
    end

    local result = {
        type   = 'doc.type.table',
        start  = node.start,
        node   = node,
        parent = parent,
    }

    local key = parseType(result)
    if not key or not nextSymbolOrError(',') then
        return nil
    end
    local value = parseType(result)
    if not value then
        return nil
    end
    nextSymbolOrError('>')

    node.parent = result
    result.finish = getFinish()
    result.tkey = key
    result.tvalue = value

    return result
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

local function  parseTypeUnitFunction()
    local typeUnit = {
        type    = 'doc.type.function',
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
        arg.name = parseName('doc.type.name', arg)
                or parseDots('doc.type.name', arg)
        if not arg.name then
            pushError {
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

local function parseTypeUnitLiteralTable()
    local typeUnit = {
        type    = 'doc.type.ltable',
        start   = getStart(),
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
                pushError {
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

local function parseTypeUnit(parent, content)
    if content == 'async' then
        local tp, cont = peekToken()
        if tp == 'name' then
            if cont == 'fun' then
                nextToken()
                local func = parseTypeUnit(parent, cont)
                if func then
                    func.async = true
                    return func
                end
            end
        end
    end
    local result
    if content == 'fun' then
        result = parseTypeUnitFunction()
    end
    if content == '{' then
        result = parseTypeUnitLiteralTable()
    end
    if not result then
        result = {
            type   = 'doc.type.name',
            start  = getStart(),
            finish = getFinish(),
            [1]    = content,
        }
    end
    if not result then
        return nil
    end
    result.parent = parent
    while true do
        local newResult = parseTypeUnitArray(parent, result)
                    or    parseTypeUnitTable(parent, result)
        if not newResult then
            break
        end
        result = newResult
    end
    return result
end

local function parseResume(parent)
    local result = {
        type   = 'doc.resume',
        parent = parent,
    }

    if checkToken('symbol', '>', 1) then
        nextToken()
        result.default = true
    end

    if checkToken('symbol', '+', 1) then
        nextToken()
        result.additional = true
    end

    local tp = peekToken()
    if tp ~= 'string' then
        pushError {
            type   = 'LUADOC_MISS_STRING',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    local _, str = nextToken()
    result[1] = str
    result.start = getStart()
    result.finish = getFinish()
    return result
end

function parseType(parent)
    local result = {
        type    = 'doc.type',
        parent  = parent,
        types   = {},
        enums   = {},
        resumes = {},
    }
    while true do
        local tp, content = peekToken()
        if not tp then
            break
        end

        -- 处理 `T` 的情况
        local typeLiteral = nil
        if tp == 'symbol' and content == '`' then
            nextToken()
            if not checkToken('symbol', '`', 2) then
                break
            end
            tp, content = peekToken()
            if not tp then
                break
            end
            -- TypeLiteral，指代类型的字面值。比如，对于类 Cat 来说，它的 TypeLiteral 是 "Cat"
            typeLiteral = true
        end

        if tp == 'name' then
            nextToken()
            local typeUnit = parseTypeUnit(result, content)
            if not typeUnit then
                break
            end
            if typeLiteral then
                nextToken()
                typeUnit.literal = true
            end
            result.types[#result.types+1] = typeUnit
            if not result.start then
                result.start = typeUnit.start
            end
        elseif tp == 'string' then
            nextToken()
            local typeEnum = {
                type   = 'doc.type.enum',
                start  = getStart(),
                finish = getFinish(),
                parent = result,
                [1]    = content,
            }
            result.enums[#result.enums+1] = typeEnum
            if not result.start then
                result.start = typeEnum.start
            end
        elseif tp == 'symbol' and content == '{' then
            nextToken()
            local typeUnit = parseTypeUnit(result, content)
            if not typeUnit then
                break
            end
            result.types[#result.types+1] = typeUnit
            if not result.start then
                result.start = typeUnit.start
            end
        elseif tp == 'symbol' and content == '...' then
            nextToken()
            local vararg = {
                type   = 'doc.type.name',
                start  = getStart(),
                finish = getFinish(),
                parent = result,
                [1]    = content,
            }
            result.types[#result.types+1] = vararg
            if not result.start then
                result.start = vararg.start
            end
        end
        if not checkToken('symbol', '|', 1) then
            break
        end
        nextToken()
    end
    if not result.start then
        result.start = getFinish()
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
            if nextComm.text:sub(1, 2) == '-@' then
                return false
            else
                if nextComm.text:sub(1, 2) == '-|' then
                    NextComment(i)
                    row = row + i + 1
                    local finishPos = nextComm.text:find('#', 3) or #nextComm.text
                    parseTokens(nextComm.text:sub(3, finishPos), nextComm.start + 3)
                    local resume = parseResume(result)
                    if resume then
                        if comments then
                            resume.comment = table.concat(comments, '\n')
                        else
                            resume.comment = nextComm.text:match('#%s*(.+)', 3)
                        end
                        result.resumes[#result.resumes+1] = resume
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

    if #result.types == 0 and #result.enums == 0 and #result.resumes == 0 then
        pushError {
            type   = 'LUADOC_MISS_TYPE_NAME',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    return result
end

local function parseAlias()
    local result = {
        type   = 'doc.alias',
    }
    result.alias = parseName('doc.alias.name', result)
    if not result.alias then
        pushError {
            type   = 'LUADOC_MISS_ALIAS_NAME',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    result.start  = getStart()
    result.extends = parseType(result)
    if not result.extends then
        pushError {
            type   = 'LUADOC_MISS_ALIAS_EXTENDS',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    result.finish = getFinish()
    return result
end

local function parseParam()
    local result = {
        type   = 'doc.param',
    }
    result.param = parseName('doc.param.name', result)
                or parseDots('doc.param.name', result)
    if not result.param then
        pushError {
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
        pushError {
            type   = 'LUADOC_MISS_PARAM_EXTENDS',
            start  = getFinish(),
            finish = getFinish(),
        }
        return result
    end
    result.finish = getFinish()
    result.firstFinish = result.extends.firstFinish
    return result
end

local function parseReturn()
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
end

local function parseField()
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
        pushError {
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
        pushError {
            type   = 'LUADOC_MISS_FIELD_EXTENDS',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    result.finish = getFinish()
    return result
end

local function parseGeneric()
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
            pushError {
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
end

local function parseVararg()
    local result = {
        type = 'doc.vararg',
    }
    result.vararg = parseType(result)
    if not result.vararg then
        pushError {
            type   = 'LUADOC_MISS_VARARG_TYPE',
            start  = getFinish(),
            finish = getFinish(),
        }
        return
    end
    result.start = result.vararg.start
    result.finish = result.vararg.finish
    return result
end

local function parseOverload()
    local tp, name = peekToken()
    if tp ~= 'name' or name ~= 'fun' then
        pushError {
            type   = 'LUADOC_MISS_FUN_AFTER_OVERLOAD',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    nextToken()
    local result = {
        type = 'doc.overload',
    }
    result.overload = parseTypeUnitFunction()
    if not result.overload then
        return nil
    end
    result.overload.parent = result
    result.start = result.overload.start
    result.finish = result.overload.finish
    return result
end

local function parseDeprecated()
    return {
        type   = 'doc.deprecated',
        start  = getFinish(),
        finish = getFinish(),
    }
end

local function parseMeta()
    return {
        type   = 'doc.meta',
        start  = getFinish(),
        finish = getFinish(),
    }
end

local function parseVersion()
    local result = {
        type     = 'doc.version',
        versions = {},
    }
    while true do
        local tp, text = nextToken()
        if not tp then
            pushError {
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
            pushError {
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
end

local function parseSee()
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
end

local function parseDiagnostic()
    local result = {
        type = 'doc.diagnostic',
    }
    local nextTP, mode = nextToken()
    if nextTP ~= 'name' then
        pushError {
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
        pushError {
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
                pushError {
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
end

local function parseModule()
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
        pushError {
            type   = 'LUADOC_MISS_MODULE_NAME',
            start  = getFinish(),
            finish = getFinish(),
        }
    end
    return result
end

local function parseAsync()
    return {
        type   = 'doc.async',
        start  = getFinish(),
        finish = getFinish(),
    }
end

local function parseNoDiscard()
    return {
        type   = 'doc.nodiscard',
        start  = getFinish(),
        finish = getFinish(),
    }
end

local function convertTokens()
    local tp, text = nextToken()
    if not tp then
        return
    end
    if tp ~= 'name' then
        pushError {
            type   = 'LUADOC_MISS_CATE_NAME',
            start  = getStart(),
            finish = getFinish(),
        }
        return nil
    end
    if     text == 'class' then
        return parseClass()
    elseif text == 'type' then
        return parseType()
    elseif text == 'alias' then
        return parseAlias()
    elseif text == 'param' then
        return parseParam()
    elseif text == 'return' then
        return parseReturn()
    elseif text == 'field' then
        return parseField()
    elseif text == 'generic' then
        return parseGeneric()
    elseif text == 'vararg' then
        return parseVararg()
    elseif text == 'overload' then
        return parseOverload()
    elseif text == 'deprecated' then
        return parseDeprecated()
    elseif text == 'meta' then
        return parseMeta()
    elseif text == 'version' then
        return parseVersion()
    elseif text == 'see' then
        return parseSee()
    elseif text == 'diagnostic' then
        return parseDiagnostic()
    elseif text == 'module' then
        return parseModule()
    elseif text == 'async' then
        return parseAsync()
    elseif text == 'nodiscard' then
        return parseNoDiscard()
    end
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
    local _, startPos = text:find('^%-%s*@')
    if not startPos then
        return {
            type    = 'doc.comment',
            start   = comment.start,
            finish  = comment.finish,
            range   = comment.finish,
            comment = comment,
        }
    end

    local doc = text:sub(startPos + 1)

    parseTokens(doc, comment.start + startPos + 1)
    local result = convertTokens()
    if result then
        result.range = comment.finish
        local cstart = text:find('%S', (result.firstFinish or result.finish) - comment.start)
        if cstart and cstart < comment.finish then
            result.comment = {
                type   = 'doc.tailcomment',
                start  = cstart + comment.start,
                finish = comment.finish,
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
    local lastRow = guide.rowColOf(lastDoc.finish)
    local newRow  = guide.rowColOf(doc.start)
    return newRow - lastRow == 1
end

local function bindGeneric(binded)
    local generics = {}
    for _, doc in ipairs(binded) do
        if     doc.type == 'doc.generic' then
            for _, obj in ipairs(doc.generics) do
                local name = obj.generic[1]
                generics[name] = {}
            end
        elseif doc.type == 'doc.param'
        or     doc.type == 'doc.return'
        or     doc.type == 'doc.type' then
            guide.eachSourceType(doc, 'doc.type.name', function (src)
                local name = src[1]
                if generics[name] then
                    generics[name][#generics[name]+1] = src
                    src.typeGeneric = generics
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
                or src.type == 'setglobal'
                or src.type == 'tablefield'
                or src.type == 'tableindex'
                or src.type == 'setfield'
                or src.type == 'setindex'
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
    'tablefield', 'tableindex',
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

    pushError = state.pushError
    Lines     = state.lines

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
