local m          = require 'lpeglabel'
local re         = require 'parser.relabel'
local lines      = require 'parser.lines'
local guide      = require 'parser.guide'

local TokenTypes, TokenStarts, TokenFinishs, TokenContents
local Ci, Offset, pushError
local parseType
local Parser = re.compile([[
Main                <-  (Token / Sp)*
Sp                  <-  %s+
X16                 <-  [a-fA-F0-9]
Word                <-  [a-zA-Z0-9_]
Token               <-  Name / String / Symbol
Name                <-  ({} {[a-zA-Z_] [a-zA-Z0-9_.]*} {})
                    ->  Name
String              <-  ({} StringDef {})
                    ->  String
StringDef           <-  '"'
                        {~(Esc / !'"' .)*~} -> 1
                        ('"'?)
                    /   "'"
                        {~(Esc / !"'" .)*~} -> 1
                        ("'"?)
                    /   ('[' {:eq: '='* :} '['
                        {(!StringClose .)*} -> 1
                        (StringClose?))
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
                    /   ('u{' {Word*} '}')    -> CharUtf8
Symbol              <-  ({} {
                            ':'
                        /   '|'
                        /   ','
                        /   '[]'
                        /   '<'
                        /   '>'
                        /   '('
                        /   ')'
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
    Name = function (start, content, finish)
        Ci = Ci + 1
        TokenTypes[Ci]    = 'name'
        TokenStarts[Ci]   = start
        TokenFinishs[Ci]  = finish - 1
        TokenContents[Ci] = content
    end,
    String = function (start, content, finish)
        Ci = Ci + 1
        TokenTypes[Ci]    = 'string'
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

local function parseTokens(text)
    Ci = 0
    TokenTypes    = {}
    TokenStarts   = {}
    TokenFinishs  = {}
    TokenContents = {}
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
    return TokenStarts[Ci] + Offset
end

local function getFinish()
    return TokenFinishs[Ci] + Offset
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

local function parseClass(parent)
    local result = {
        type   = 'doc.class',
        parent = parent,
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
    nextToken()
    if not checkToken('symbol', ':') then
        pushError {
            type   = 'LUADOC_MISS_EXTENDS_SYMBOL',
            start  = result.finish + 1,
            finish = getStart() - 1,
        }
        return result
    end
    result.extends = parseName('doc.extends.name', result)
    if not result.extends then
        pushError {
            type   = 'LUADOC_MISS_EXTENDS_NAME',
            start  = getFinish(),
            finish = getFinish(),
        }
        return result
    end
    result.finish = getFinish()
    return result
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

local function parseTypeUnitGeneric(typeUnit)
    if not checkToken('symbol', '<', 1) then
        return nil
    end
    if not nextSymbolOrError('<') then
        return nil
    end
    local key = parseType(typeUnit)
    if not key or not nextSymbolOrError(',') then
        return nil
    end
    local value = parseType(typeUnit)
    if not value then
        return nil
    end
    nextSymbolOrError('>')
    typeUnit.generic= true
    typeUnit.key    = key
    typeUnit.value  = value
    typeUnit.finish = getFinish()
    return typeUnit
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
        arg.finish = getFinish()
        if not nextSymbolOrError(':') then
            break
        end
        arg.extends = parseType(arg)
        if not arg.extends then
            break
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
            local rtn = parseType(arg)
            if not rtn then
                break
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

local function parseTypeUnit(parent, content)
    local typeUnit
    if content == 'fun' then
        typeUnit = parseTypeUnitFunction()
    end
    if not typeUnit then
        typeUnit = {
            type   = 'doc.type.name',
            start  = getStart(),
            finish = getFinish(),
            [1]    = content,
        }
    end
    if not typeUnit then
        return nil
    end
    typeUnit.parent = parent
    if checkToken('symbol', '[]', 1) then
        nextToken()
        typeUnit.array = true
        typeUnit.finish = getFinish()
    else
        parseTypeUnitGeneric(typeUnit)
    end
    return typeUnit
end

function parseType(parent)
    if not peekToken() then
        pushError {
            type   = 'LUADOC_MISS_TYPE_NAME',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    local result = {
        type   = 'doc.type',
        parent = parent,
        types  = {},
        enums  = {},
    }
    while true do
        local tp, content = peekToken()
        if not tp then
            break
        end
        if tp == 'name' then
            nextToken()
            local typeUnit = parseTypeUnit(result, content)
            if not typeUnit then
                break
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
        end
        if not checkToken('symbol', '|', 1) then
            break
        end
        nextToken()
    end
    result.finish = getFinish()
    if #result.types == 0 and #result.enums == 0 then
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
    if not result.param then
        pushError {
            type   = 'LUADOC_MISS_PARAM_NAME',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    result.start = getStart()
    result.extends = parseType(result)
    if not result.extends then
        pushError {
            type   = 'LUADOC_MISS_PARAM_EXTENDS',
            start  = getFinish(),
            finish = getFinish(),
        }
        return nil
    end
    result.finish = getFinish()
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
            object.extends = parseName('doc.extends.name', object)
            if not object.extends then
                pushError {
                    type   = 'LUADOC_MISS_EXTENDS_NAME',
                    start  = getFinish(),
                    finish = getFinish(),
                }
                return nil
            end
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

local function convertTokens()
    local tp, text = nextToken()
    if not tp then
        return
    end
    if tp ~= 'name' then
        pushError {
            type  = 'LUADOC_MISS_CATE_NAME',
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
    end
end

local function buildLuaDoc(comment)
    Offset = comment.start + 1
    local text = comment.text
    if text:sub(1, 2) ~= '-@' then
        return
    end
    local finishPos = text:find('@', 3)
    local doc, lastComment
    if finishPos then
        doc = text:sub(3, finishPos - 1)
        lastComment = text:sub(finishPos)
    else
        doc = text:sub(3)
    end
    parseTokens(doc)
    local result = convertTokens()
    if result then
        result.comment = lastComment
    end
    return result
end

local function isNextLine(lns, binded, doc)
    if not binded then
        return false
    end
    local lastDoc = binded[#binded]
    local lastRow = guide.positionOf(lns, lastDoc.start)
    local newRow  = guide.positionOf(lns, doc.start)
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
        or     doc.type == 'doc.return' then
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

local function bindDoc(state, lns, binded)
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
    local row = guide.positionOf(lns, lastDoc.start)
    local start, finish = guide.lineRange(lns, row + 1)
    if start >= finish then
        -- 空行
        return
    end
    guide.eachSourceBetween(state.ast, start, finish, function (src)
        if src.start and src.start < start then
            return
        end
        if src.type == 'local'
        or src.type == 'setlocal'
        or src.type == 'setglobal'
        or src.type == 'setfield'
        or src.type == 'setmethod'
        or src.type == 'setindex'
        or src.type == 'tablefield'
        or src.type == 'tableindex'
        or src.type == 'function'
        or src.type == '...' then
            src.bindDocs = binded
            bindSources[#bindSources+1] = src
        end
    end)
end

local function bindDocs(state)
    local lns = lines(nil, state.lua)
    local binded
    for _, doc in ipairs(state.ast.docs) do
        if not isNextLine(lns, binded, doc) then
            bindDoc(state, lns, binded)
            binded = {}
            state.ast.docs.groups[#state.ast.docs.groups+1] = binded
        end
        binded[#binded+1] = doc
    end
    bindDoc(state, lns, binded)
end

return function (_, state)
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

    for _, comment in ipairs(comments) do
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
        end
    end

    if #ast.docs == 0 then
        return
    end

    bindDocs(state)
end
