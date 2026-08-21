---@class LuaParser.Guide
local M = Class 'LuaParser.Guide'

local keyWordMap = {
    ['and']      = true,
    ['break']    = true,
    ['do']       = true,
    ['else']     = true,
    ['elseif']   = true,
    ['end']      = true,
    ['for']      = true,
    ['function'] = true,
    ['if']       = true,
    ['in']       = true,
    ['local']    = true,
    ['not']      = true,
    ['or']       = true,
    ['repeat']   = true,
    ['return']   = true,
    ['then']     = true,
    ['until']    = true,
    ['while']    = true,
}

local reservedWordMap = {
    ['true']  = true,
    ['false'] = true,
    ['nil']   = true,
}

local softKeywordMap = {
    ['continue'] = true,
    ['goto']     = true,
}

--- 判断字符串是否为合法的 Lua 标识符。
--- 保留字与保留字面量（true/false/nil）恒为不合法；
--- 软关键字（`goto`、`continue`）默认合法，可通过 `softKeyword = false` 排除。
---@param str string
---@param utf8? boolean # 允许高位字节（UTF-8）标识符
---@param softKeyword? boolean # 允许软关键字（goto/continue）作为标识符，默认允许
---@return boolean
function M.isLegalName(str, utf8, softKeyword)
    if keyWordMap[str]
    or reservedWordMap[str] then
        return false
    end
    if softKeyword == false and softKeywordMap[str] then
        return false
    end
    if utf8 then
        return str:match '^[%a_\x80-\xff][%w_\x80-\xff]*$' ~= nil
    end
    return str:match '^[%a_][%w_]*$' ~= nil
end

--- 判断单个字符是否属于标识符字符集（含高位字节，供逐字符扫描使用）。
---@param ch string
---@return boolean
function M.isWordChar(ch)
    local byte = ch:byte()
    if not byte then
        return false
    end
    return ch == '_'
        or (ch >= 'a' and ch <= 'z')
        or (ch >= 'A' and ch <= 'Z')
        or (ch >= '0' and ch <= '9')
        or byte >= 0x80
end

--- 返回在指定位置（offset）可见的所有局部变量（local 和 param）。
--- 从 source 所在的 block 开始，逐层向上遍历父 block，
--- 收集所有 effectStart <= offset 的局部变量声明，
--- 内层声明会遮蔽外层同名声明（内层优先，外层被跳过）。
---
---@param source LuaParser.Node.Base  # 当前光标所在的节点
---@param offset integer               # 光标偏移量
---@return (LuaParser.Node.Local | LuaParser.Node.Param)[]
function M.getVisibleLocals(source, offset)
    ---@type table<string, true>
    local seen   = {}
    ---@type (LuaParser.Node.Local | LuaParser.Node.Param)[]
    local result = {}

    local block = source.parentBlock
    while block do
        -- 倒序遍历：越靠后声明的越"内层"，优先加入，外层同名的会被 seen 跳过
        local locals = block.locals
        for i = #locals, 1, -1 do
            local loc = locals[i]
            if loc.effectStart <= offset then
                local name = loc.id
                if type(name) == 'string' and not seen[name] then
                    seen[name] = true
                    result[#result+1] = loc
                end
            end
        end
        -- 函数的 param 挂在函数节点上，需要特殊处理
        if block.isFunction then
            ---@cast block LuaParser.Node.Function
            local params = block.params
            if params then
                for i = #params, 1, -1 do
                    local param = params[i]
                    local name = param.id
                    if type(name) == 'string' and not seen[name] then
                        seen[name] = true
                        result[#result+1] = param
                    end
                end
            end
        end
        -- 向上找父 block
        block = block.parentBlock
    end

    return result
end

--- 从 source 所在的 AST 中，找到在 offset 处可见的指定名字的局部变量节点。
--- 从最内层 block 向外查找，返回第一个匹配的（即最近的遮蔽者）。
---
---@param id     string               # 要查找的局部变量名（如 `'_ENV'`）
---@param offset integer              # 光标偏移量
---@param ast    LuaParser.Ast        # 语法树（内部会自动读取 ast.envMode 等信息）
---@return (LuaParser.Node.Local | LuaParser.Node.Param)?
function M.getLocal(ast, offset, id)
    -- 从 main block 向内找到包含 offset 的最深 block
    local innerBlock = ast.main
    local function findDeepest(block)
        for _, child in ipairs(block.childs) do
            if  child.isBlock
            and child.start <= offset
            and offset      <= child.finish then
                innerBlock = child
                findDeepest(child)
                return
            end
        end
    end
    findDeepest(ast.main)

    -- 从最内层向外遍历，返回第一个匹配的（即最近的遮蔽者）
    ---@type LuaParser.Node.Block | false
    local b = innerBlock
    while b do
        local locals = b.locals
        for i = #locals, 1, -1 do
            local loc = locals[i]
            if loc.id == id and loc.effectStart <= offset then
                return loc
            end
        end
        if b.isFunction then
            ---@cast b LuaParser.Node.Function
            local params = b.params
            if params then
                for i = #params, 1, -1 do
                    local param = params[i]
                    if param.id == id then
                        return param
                    end
                end
            end
        end
        b = b.parentBlock
    end

    return nil
end

--- 找到在 offset 处可见的 _ENV local 节点（自动使用 ast.envMode）。
---
---@param offset integer
---@param ast    LuaParser.Ast
---@return (LuaParser.Node.Local | LuaParser.Node.Param)?
function M.getEnvLocal(ast, offset)
    return M.getLocal(ast, offset, ast.envMode)
end

return M
