local guide = require 'parser.guide'
local util  = require 'utility'

local m = {}

---@alias location table
---@param uri string
---@param range range
---@return location
function m.location(uri, range)
    return {
        uri   = uri,
        range = range,
    }
end

---@alias locationLink table
---@param uri string
---@param range range
---@param selection range
---@param origin range
function m.locationLink(uri, range, selection, origin)
    return {
        targetUri            = uri,
        targetRange          = range,
        targetSelectionRange = selection,
        originSelectionRange = origin,
    }
end

function m.textEdit(range, newtext)
    return {
        range   = range,
        newText = newtext,
    }
end

--- 诊断等级
m.DiagnosticSeverity = {
    Error       = 1,
    Warning     = 2,
    Information = 3,
    Hint        = 4,
}

---@alias DiagnosticDefaultSeverity
---| '"Hint"'
---| '"Information"'
---| '"Warning"'
---| '"Error"'

--- 诊断类型与默认等级
---@type table<string, DiagnosticDefaultSeverity>
m.DiagnosticDefaultSeverity = {
    ['unused-local']            = 'Hint',
    ['unused-function']         = 'Hint',
    ['undefined-global']        = 'Warning',
    ['undefined-field']         = 'Warning',
    ['global-in-nil-env']       = 'Warning',
    ['unused-label']            = 'Hint',
    ['unused-vararg']           = 'Hint',
    ['trailing-space']          = 'Hint',
    ['redefined-local']         = 'Hint',
    ['newline-call']            = 'Information',
    ['newfield-call']           = 'Warning',
    ['redundant-parameter']     = 'Hint',
    ['ambiguity-1']             = 'Warning',
    ['lowercase-global']        = 'Information',
    ['undefined-env-child']     = 'Information',
    ['duplicate-index']         = 'Warning',
    ['empty-block']             = 'Hint',
    ['redundant-value']         = 'Hint',
    ['code-after-break']        = 'Hint',
    ['unbalanced-assignments']  = 'Warning',
    ['close-non-object']        = 'Warning',
    ['count-down-loop']         = 'Warning',

    ['duplicate-doc-class']     = 'Warning',
    ['undefined-doc-class']     = 'Warning',
    ['undefined-doc-name']      = 'Warning',
    ['circle-doc-class']        = 'Warning',
    ['undefined-doc-param']     = 'Warning',
    ['duplicate-doc-param']     = 'Warning',
    ['doc-field-no-class']      = 'Warning',
    ['duplicate-doc-field']     = 'Warning',
}

---@alias DiagnosticDefaultNeededFileStatus
---| '"Any"'
---| '"Opened"'

-- 文件状态
m.FileStatus = {
    Any     = 1,
    Opened  = 2,
}

--- 诊断类型与需要的文件状态(可以控制只分析打开的文件、还是所有文件)
---@type table<string, DiagnosticDefaultNeededFileStatus>
m.DiagnosticDefaultNeededFileStatus = {
    ['unused-local']            = 'Opened',
    ['unused-function']         = 'Opened',
    ['undefined-global']        = 'Any',
    ['undefined-field']         = 'Opened',
    ['global-in-nil-env']       = 'Any',
    ['unused-label']            = 'Opened',
    ['unused-vararg']           = 'Opened',
    ['trailing-space']          = 'Opened',
    ['redefined-local']         = 'Opened',
    ['newline-call']            = 'Any',
    ['newfield-call']           = 'Any',
    ['redundant-parameter']     = 'Opened',
    ['ambiguity-1']             = 'Any',
    ['lowercase-global']        = 'Any',
    ['undefined-env-child']     = 'Any',
    ['duplicate-index']         = 'Any',
    ['empty-block']             = 'Opened',
    ['redundant-value']         = 'Opened',
    ['code-after-break']        = 'Opened',
    ['unbalanced-assignments']  = 'Any',
    ['close-non-object']        = 'Any',
    ['count-down-loop']         = 'Any',

    ['duplicate-doc-class']     = 'Any',
    ['undefined-doc-class']     = 'Any',
    ['undefined-doc-name']      = 'Any',
    ['circle-doc-class']        = 'Any',
    ['undefined-doc-param']     = 'Any',
    ['duplicate-doc-param']     = 'Any',
    ['doc-field-no-class']      = 'Any',
    ['duplicate-doc-field']     = 'Any',
}

--- 诊断报告标签
m.DiagnosticTag = {
    Unnecessary = 1,
    Deprecated  = 2,
}

m.DocumentHighlightKind = {
    Text  = 1,
    Read  = 2,
    Write = 3,
}

m.MessageType = {
    Error   = 1,
    Warning = 2,
    Info    = 3,
    Log     = 4,
}

m.FileChangeType = {
    Created = 1,
    Changed = 2,
    Deleted = 3,
}

m.CompletionItemKind = {
    Text = 1,
    Method = 2,
    Function = 3,
    Constructor = 4,
    Field = 5,
    Variable = 6,
    Class = 7,
    Interface = 8,
    Module = 9,
    Property = 10,
    Unit = 11,
    Value = 12,
    Enum = 13,
    Keyword = 14,
    Snippet = 15,
    Color = 16,
    File = 17,
    Reference = 18,
    Folder = 19,
    EnumMember = 20,
    Constant = 21,
    Struct = 22,
    Event = 23,
    Operator = 24,
    TypeParameter = 25,
}

m.ErrorCodes = {
    -- Defined by JSON RPC
    ParseError           = -32700,
    InvalidRequest       = -32600,
    MethodNotFound       = -32601,
    InvalidParams        = -32602,
    InternalError        = -32603,
    serverErrorStart     = -32099,
    serverErrorEnd       = -32000,
    ServerNotInitialized = -32002,
    UnknownErrorCode     = -32001,

    -- Defined by the protocol.
    RequestCancelled     = -32800,
}

m.SymbolKind = {
    File = 1,
    Module = 2,
    Namespace = 3,
    Package = 4,
    Class = 5,
    Method = 6,
    Property = 7,
    Field = 8,
    Constructor = 9,
    Enum = 10,
    Interface = 11,
    Function = 12,
    Variable = 13,
    Constant = 14,
    String = 15,
    Number = 16,
    Boolean = 17,
    Array = 18,
    Object = 19,
    Key = 20,
    Null = 21,
    EnumMember = 22,
    Struct = 23,
    Event = 24,
    Operator = 25,
    TypeParameter = 26,
}

m.TokenModifiers = {
    ["declaration"]   = 1 << 0,
    ["documentation"] = 1 << 1,
    ["static"]        = 1 << 2,
    ["abstract"]      = 1 << 3,
    ["deprecated"]    = 1 << 4,
    ["readonly"]      = 1 << 5,
}

m.TokenTypes = {
    ["comment"]       = 0,
    ["keyword"]       = 1,
    ["number"]        = 2,
    ["regexp"]        = 3,
    ["operator"]      = 4,
    ["namespace"]     = 5,
    ["type"]          = 6,
    ["struct"]        = 7,
    ["class"]         = 8,
    ["interface"]     = 9,
    ["enum"]          = 10,
    ["typeParameter"] = 11,
    ["function"]      = 12,
    ["member"]        = 13,
    ["macro"]         = 14,
    ["variable"]      = 15,
    ["parameter"]     = 16,
    ["property"]      = 17,
    ["label"]         = 18,
}


return m
