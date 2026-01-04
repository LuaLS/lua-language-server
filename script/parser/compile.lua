local lexer = require 'parser.lexer'
require 'parser.ast.ast'

---@class LuaParser
local LuaParser = Class 'LuaParser'

---@alias LuaParser.LuaVersion
---| 'Lua 5.1'
---| 'Lua 5.2'
---| 'Lua 5.3'
---| 'Lua 5.4'

---@alias LuaParser.NonestandardSymbol
---|'//' | '/**/'
---|'`'
---|'+=' | '-=' | '*=' | '/=' | '%=' | '^=' | '//='
---|'|=' | '&=' | '<<=' | '>>='
---|'||' | '&&' | '!' | '!='
---|'continue',

---@class LuaParser.CompileOptions
---@field version? LuaParser.LuaVersion # Lua版本，默认为 'Lua 5.4'
---@field jit? boolean # 是否为LuaJIT，默认为 false
---@field nonestandardSymbols? LuaParser.NonestandardSymbol[] # 支持的非标准符号
---@field unicodeName? boolean # 是否支持Unicode标识符，默认为 false
---@field envMode? 'auto' | '_ENV' | '@fenv' # 环境模式，默认为 'auto'，会根据版本自动选择

-- 编译lua代码
---@param code string # lua代码
---@param source? string # 来源
---@param options? LuaParser.CompileOptions
---@return LuaParser.Ast
function LuaParser.compile(code, source, options)
    local ast = New 'LuaParser.Ast' (code, source, options)
    ast.main = ast:parseMain()

    ---@diagnostic disable-next-line: invisible
    ast:resolveAllGoto()
    ---@diagnostic disable-next-line: invisible
    ast:checkAssignConst()

    return ast
end

---@param str string
---@return boolean
function LuaParser.isName(str)
    return lexer.isWord(str)
end
