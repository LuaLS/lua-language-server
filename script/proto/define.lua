local m = {}

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
    ['redundant-parameter']     = 'Warning',
    ['redundant-return']        = 'Warning',
    ['ambiguity-1']             = 'Warning',
    ['lowercase-global']        = 'Information',
    ['undefined-env-child']     = 'Information',
    ['duplicate-index']         = 'Warning',
    ['duplicate-set-field']     = 'Warning',
    ['empty-block']             = 'Hint',
    ['redundant-value']         = 'Warning',
    ['code-after-break']        = 'Hint',
    ['unbalanced-assignments']  = 'Warning',
    ['close-non-object']        = 'Warning',
    ['count-down-loop']         = 'Warning',
    ['no-implicit-any']         = 'Information',
    ['deprecated']              = 'Warning',
    ['different-requires']      = 'Warning',
    ['await-in-sync']           = 'Warning',
    ['not-yieldable']           = 'Warning',
    ['discard-returns']         = 'Warning',
    ['type-check']              = 'Warning',

    ['duplicate-doc-class']     = 'Warning',
    ['undefined-doc-class']     = 'Warning',
    ['undefined-doc-name']      = 'Warning',
    ['circle-doc-class']        = 'Warning',
    ['undefined-doc-param']     = 'Warning',
    ['duplicate-doc-param']     = 'Warning',
    ['doc-field-no-class']      = 'Warning',
    ['duplicate-doc-field']     = 'Warning',
    ['unknown-diag-code']       = 'Waiting',
}

---@alias DiagnosticDefaultNeededFileStatus
---| '"Any"'
---| '"Opened"'
---| '"None"'

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
    ['redundant-return']        = 'Opened',
    ['ambiguity-1']             = 'Any',
    ['lowercase-global']        = 'Any',
    ['undefined-env-child']     = 'Any',
    ['duplicate-index']         = 'Any',
    ['duplicate-set-field']     = 'Any',
    ['empty-block']             = 'Opened',
    ['redundant-value']         = 'Opened',
    ['code-after-break']        = 'Opened',
    ['unbalanced-assignments']  = 'Any',
    ['close-non-object']        = 'Any',
    ['count-down-loop']         = 'Any',
    ['no-implicit-any']         = 'None',
    ['deprecated']              = 'Opened',
    ['different-requires']      = 'Any',
    ['await-in-sync']           = 'None',
    ['not-yieldable']           = 'None',
    ['discard-returns']         = 'Opened',
    ['type-check']              = 'None',

    ['duplicate-doc-class']     = 'Any',
    ['undefined-doc-class']     = 'Any',
    ['undefined-doc-name']      = 'Any',
    ['circle-doc-class']        = 'Any',
    ['undefined-doc-param']     = 'Any',
    ['duplicate-doc-param']     = 'Any',
    ['doc-field-no-class']      = 'Any',
    ['duplicate-doc-field']     = 'Any',
    ['unknown-diag-code']       = 'Any',
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
    ContentModified      = -32801,
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
    ["declaration"]    = 1 << 0,
    ["definition"]     = 1 << 1,
    ["readonly"]       = 1 << 2,
    ["static"]         = 1 << 3,
    ["deprecated"]     = 1 << 4,
    ["abstract"]       = 1 << 5,
    ["async"]          = 1 << 6,
    ["modification"]   = 1 << 7,
    ["documentation"]  = 1 << 8,
    ["defaultLibrary"] = 1 << 9,
}

m.TokenTypes = {
    ["namespace"]     = 00,
    ["type"]          = 01,
    ["class"]         = 02,
    ["enum"]          = 03,
    ["interface"]     = 04,
    ["struct"]        = 05,
    ["typeParameter"] = 06,
    ["parameter"]     = 07,
    ["variable"]      = 08,
    ["property"]      = 09,
    ["enumMember"]    = 10,
    ["event"]         = 11,
    ["function"]      = 12,
    ["method"]        = 13,
    ["macro"]         = 14,
    ["keyword"]       = 15,
    ["modifier"]      = 16,
    ["comment"]       = 17,
    ["string"]        = 18,
    ["number"]        = 19,
    ["regexp"]        = 20,
    ["operator"]      = 21,
}

m.BuiltIn = {
    ['basic']     = 'default',
    ['bit']       = 'default',
    ['bit32']     = 'default',
    ['builtin']   = 'default',
    ['coroutine'] = 'default',
    ['debug']     = 'default',
    ['ffi']       = 'default',
    ['io']        = 'default',
    ['jit']       = 'default',
    ['math']      = 'default',
    ['os']        = 'default',
    ['package']   = 'default',
    ['string']    = 'default',
    ['table']     = 'default',
    ['utf8']      = 'default',
}

m.BuiltinType = {
    ['unknown']       = true,
    ['any']           = true,
    ['nil']           = true,
    ['boolean']       = true,
    ['number']        = true,
    ['integer']       = true,
    ['thread']        = true,
    ['table']         = true,
    ['string']        = true,
    ['userdata']      = true,
    ['lightuserdata'] = true,
    ['function']      = true,
}

m.InlayHintKind = {
    Other     = 0,
    Type      = 1,
    Parameter = 2,
}

return m
