-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/

---@class LSP
local M = {}

---@alias decimal number
---@alias uinteger integer

---@alias LSP.Any LSP.Object | LSP.Array | string | number | boolean | nil
---@alias LSP.Object table<string, LSP.Any>
---@alias LSP.Array LSP.Any[]


---@class LSP.Message
---@field jsonrpc "2.0"


---@class LSP.RequestMessage : LSP.Message
--- The request id.
---@field id integer | string
--- The method to be invoked.
---@field method string
--- The method's params.
---@field params? LSP.Array | LSP.Object


---@class LSP.ResponseMessage : LSP.Message
--- The request id.
---@field id integer | string | nil;
--- The result of a request. This member is REQUIRED on success.
--- This member MUST NOT exist if there was an error invoking the method.
---@field result? LSP.Any
--- The error object in case a request fails.
---@field error? LSP.ResponseError


---@class LSP.ResponseError
--- A number indicating the error type that occurred.
---@field code number
--- A string providing a short description of the error.
---@field message string
--- A Primitive or Structured value that contains additional information about the error.
---@field data? LSP.Any


M.ErrorCodes = {
    --- Defined by JSON-RPC
    ParseError = -32700,
    InvalidRequest = -32600,
    MethodNotFound = -32601,
    InvalidParams = -32602,
    InternalError = -32603,

    --- This is the start range of JSON-RPC reserved error codes.
    --- It doesn't denote a real error code. No LSP error codes should
    --- be defined between the start and end range. For backwards
    --- compatibility the `ServerNotInitialized` and the `UnknownErrorCode`
    --- are left in the range.
    ---
    ---@since 3.16.0
    jsonrpcReservedErrorRangeStart = -32099,
    ---@deprecated use jsonrpcReservedErrorRangeStart
    serverErrorStart = -32099,

    --- Error code indicating that a server received a notification or
    --- request before the server has received the `initialize` request.
    ServerNotInitialized = -32002,
    UnknownErrorCode = -32001,

    --- This is the end range of JSON-RPC reserved error codes.
    --- It doesn't denote a real error code.
    ---
    ---@since 3.16.0
    jsonrpcReservedErrorRangeEnd = -32000,
    ---@deprecated use jsonrpcReservedErrorRangeEnd
    serverErrorEnd = -32000,

    --- This is the start range of LSP reserved error codes.
    --- It doesn't denote a real error code.
    ---
    ---@since 3.16.0
    lspReservedErrorRangeStart = -32899,

    --- A request failed but it was syntactically correct, e.g the
    --- method name was known and the parameters were valid. The error
    --- message should contain human readable information about why
    --- the request failed.
    ---
    ---@since 3.17.0
    RequestFailed = -32803,

    --- The server cancelled the request. This error code should
    --- only be used for requests that explicitly support being
    --- server cancellable.
    ---
    ---@since 3.17.0
    ServerCancelled = -32802,

    --- The server detected that the content of a document got
    --- modified outside normal conditions. A server should
    --- NOT send this error code if it detects a content change
    --- in its unprocessed messages. The result even computed
    --- on an older state might still be useful for the client.
    ---
    --- If a client decides that a result is not of any use anymore
    --- the client should cancel the request.
    ContentModified = -32801,

    --- The client has canceled a request and a server has detected
    --- the cancel.
    RequestCancelled = -32800,

    --- This is the end range of LSP reserved error codes.
    --- It doesn't denote a real error code.
    ---
    ---@since 3.16.0
    lspReservedErrorRangeEnd = -32800,
}


---@class LSP.NotificationMessage : LSP.Message
--- The method to be invoked.
---@field method string
--- The notification's params.
---@field params? LSP.Array | LSP.Object


---@class LSP.CancelParams
--- The request id to cancel.
---@field id integer | string


---@alias ProgressToken integer | string


---@class LSP.ProgressParams
--- The progress token provided by the client or server.
---@field token ProgressToken
--- The progress data.
---@field value LSP.Any


---@alias LSP.DocumentUri string
---@alias LSP.URI string


---@class LSP.RegularExpressionsClientCapabilities
--- The engine's name.
---@field engine string
--- The engine's version.
---@field version? string


M.EOL = { '\n', '\r\n', '\r' }


---@class LSP.Position
--- Line position in a document (zero-based).
---@field line uinteger
--- Character offset on a line in a document (zero-based). The meaning of this
--- offset is determined by the negotiated `PositionEncodingKind`.
--- 
--- If the character value is greater than the line length it defaults back
--- to the line length.
---@field character uinteger


--- A type indicating how positions are encoded,
--- specifically what column offsets mean.
--- 
---@since 3.17.0
---@alias LSP.PositionEncodingKind string

--- A set of predefined position encoding kinds.
--- 
---@since 3.17.0
M.PositionEncodingKind = {
    --- Character offsets count UTF-8 code units (i.e. bytes).
    UTF8 = 'utf-8',

    --- Character offsets count UTF-16 code units.
    --- 
    --- This is the default and must always be supported
    --- by servers.
    UTF16 = 'utf-16',

    --- Character offsets count UTF-32 code units.
    --- 
    --- Implementation note: these are the same as Unicode code points,
    --- so this `PositionEncodingKind` may also be used for an
    --- encoding-agnostic representation of character offsets.
    UTF32 = 'utf-32'
}


---@class LSP.Range
--- The range's start position.
---@field start LSP.Position
--- The range's end position.
---@field end LSP.Position


---@class LSP.TextDocumentItem
--- The text document's URI.
---@field uri LSP.DocumentUri
--- The text document's language identifier.
---@field languageId string
--- The version number of this document (it will strictly increase after each
--- change, including undo/redo).
---@field version integer
--- The content of the opened text document.
---@field text string


---@class LSP.TextDocumentIdentifier
--- The text document's URI.
---@field uri LSP.DocumentUri


---@class LSP.VersionedTextDocumentIdentifier : LSP.TextDocumentIdentifier
--- The version number of this document.
---
--- The version number of a document will increase after each change,
--- including undo/redo. The number doesn't need to be consecutive.
---@field version integer


---@class LSP.OptionalVersionedTextDocumentIdentifier : LSP.TextDocumentIdentifier
--- The version number of this document. If an optional versioned text document
--- identifier is sent from the server to the client and the file is not
--- open in the editor (the server has not received an open notification
--- before) the server can send `nil` to indicate that the version is
--- known and the content on disk is the master (as specified with document
--- content ownership).
---
--- The version number of a document will increase after each change,
--- including undo/redo. The number doesn't need to be consecutive.
---@field version integer | nil


---@class LSP.TextDocumentPositionParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier
--- The position inside the text document.
---@field position LSP.Position


--- The pattern to watch relative to the base path. Glob patterns can have
--- the following syntax:
--- - `*` to match one or more characters in a path segment
--- - `?` to match on one character in a path segment
--- - `**` to match any number of path segments, including none
--- - `{}` to group conditions (e.g. `**​/*.{ts,js}` matches all TypeScript
---   and JavaScript files)
--- - `[]` to declare a range of characters to match in a path segment
---   (e.g., `example.[0-9]` to match on `example.0`, `example.1`, …)
--- - `[!...]` to negate a range of characters to match in a path segment
---   (e.g., `example.[!0-9]` to match on `example.a`, `example.b`,
---   but not `example.0`)
---
---@since 3.17.0
---@alias LSP.Pattern string


---@class LSP.RelativePattern
--- A workpsace folder or a base URI to which this pattern will be matched
--- against relatively.
---@field baseUri LSP.WorkspaceFolder | LSP.URI
--- The actual pattern
---@field pattern LSP.Pattern


---@alias LSP.GlobPattern LSP.Pattern | LSP.RelativePattern


---@class LSP.DocumentFilter
--- A language id, like `typescript`.
---@field language? string
--- A Uri scheme, like `file` or `untitled`.
---@field scheme? string
--- A pattern, like `*.{ts,js}` or a pattern relative to a workspace folders.
---
--- See GlobPattern.
---
--- Whether clients support relative patterns depends on the client
--- capability `textDocuments.filters.relativePatternSupport`.
---@field pattern? LSP.GlobPattern


---@alias LSP.DocumentSelector LSP.DocumentFilter[]


--- A string value used as a snippet is a template which allows to insert text
--- and to control the editor cursor when insertion happens.
---
--- A snippet can define tab stops and placeholders with `$1`, `$2`
--- and `${3:foo}`. `$0` defines the final tab stop, it defaults to
--- the end of the snippet. Variables are defined with `$name` and
--- `${name:default value}`.
---
---@since 3.18.0
---@class LSP.StringValue
--- The kind of string value.
---@field kind "snippet"
--- The snippet string.
---@field value string


---@class LSP.TextEdit
--- The range of the text document to be manipulated. To insert
--- text into a document, create a range where start === end.
---@field range LSP.Range
--- The string to be inserted. For delete operations, use an
--- empty string.
---@field newText string


---@class LSP.ChangeAnnotation
--- A human-readable string describing the actual change. The string
--- is rendered prominently in the user interface.
---@field label string
--- A flag which indicates that user confirmation is needed
--- before applying the change.
---@field needsConfirmation? boolean
--- A human-readable string which is rendered less prominently in
--- the user interface.
---@field description? string


---@alias LSP.ChangeAnnotationIdentifier string


---@class LSP.AnnotatedTextEdit : LSP.TextEdit
--- The actual annotation identifier.
---@field annotationId LSP.ChangeAnnotationIdentifier


---@class LSP.SnippetTextEdit
--- The range of the text document to be manipulated.
---@field range LSP.Range
--- The snippet to be inserted.
---@field snippet LSP.StringValue
--- The actual identifier of the snippet edit.
---@field annotationId? LSP.ChangeAnnotationIdentifier


---@class LSP.TextDocumentEdit
--- The text document to change.
---@field textDocument LSP.OptionalVersionedTextDocumentIdentifier
--- The edits to be applied.
--- 
---@since 3.16.0 - support for AnnotatedTextEdit. This is guarded by the
--- client capability `workspace.workspaceEdit.changeAnnotationSupport`
--- 
---@since 3.18.0 - support for SnippetTextEdit. This is guarded by the
--- client capability `workspace.workspaceEdit.snippetEditSupport`
---@field edits (LSP.TextEdit | LSP.AnnotatedTextEdit | LSP.SnippetTextEdit)[]


---@class LSP.Location
---@field uri LSP.DocumentUri
---@field range LSP.Range


---@class LSP.LocationLink
--- Span of the origin of this link.
---
--- Used as the underlined span for mouse interaction. Defaults to the word
--- range at the mouse position.
---@field originSelectionRange? LSP.Range
--- The target resource identifier of this link.
---@field targetUri LSP.DocumentUri
--- The full target range of this link. If the target is, for example, a
--- symbol, then the target range is the range enclosing this symbol not
--- including leading/trailing whitespace but everything else like comments.
--- This information is typically used to highlight the range in the editor.
---@field targetRange LSP.Range
--- The range that should be selected and revealed when this link is being
--- followed, e.g., the name of a function. Must be contained by the
--- `targetRange`. See also `DocumentSymbol#range`
---@field targetSelectionRange LSP.Range


---@class LSP.Diagnostic
--- The range at which the message applies.
---@field range LSP.Range
--- The diagnostic's severity. To avoid interpretation mismatches when a
--- server is used with different clients it is highly recommended that
--- servers always provide a severity value. If omitted, it’s recommended
--- for the client to interpret it as an Error severity.
---@field severity? LSP.DiagnosticSeverity
--- The diagnostic's code, which might appear in the user interface.
---@field code? integer | string
--- An optional property to describe the error code.
---@since 3.16.0
---@field codeDescription? LSP.CodeDescription
--- A human-readable string describing the source of this
--- diagnostic, e.g. 'typescript' or 'super lint'.
---@field source? string
--- The diagnostic's message.
---@since 3.18.0 - support for MarkupContent. This is guarded by the client
--- capability `textDocument.diagnostic.markupMessageSupport`.
---@field message string | LSP.MarkupContent
--- Additional metadata about the diagnostic.
---@since 3.15.0
---@field tags? LSP.DiagnosticTag[]
--- An array of related diagnostic information, e.g. when symbol-names within
--- a scope collide all definitions can be marked via this property.
---@field relatedInformation? LSP.DiagnosticRelatedInformation[]
--- A data entry field that is preserved between a
--- `textDocument/publishDiagnostics` notification and
--- `textDocument/codeAction` request.
---@since 3.16.0
---@field data? LSP.Any


---@enum LSP.DiagnosticSeverity
M.DiagnosticSeverity = {
    --- Reports an error.
    Error = 1,
    --- Reports a warning.
    Warning = 2,
    --- Reports an information.
    Information = 3,
    --- Reports a hint.
    Hint = 4,
}


---@enum LSP.DiagnosticTag
M.DiagnosticTag = {
    --- Unused or unnecessary code.
    ---
    --- Clients are allowed to render diagnostics with this tag faded out
    --- instead of having an error squiggle.
    Unnecessary = 1,
    --- Deprecated or obsolete code.
    ---
    --- Clients are allowed to render diagnostics with this tag strike through.
    Deprecated = 2,
}


---@class LSP.DiagnosticRelatedInformation
--- The location of this related diagnostic information.
---@field location LSP.Location
--- The message of this related diagnostic information.
---@field message string


---@class LSP.CodeDescription
--- A URI to open with more information about the diagnostic error.
---@field href LSP.URI


---@class LSP.Command
--- Title of the command, like `save`.
---@field title string
--- An optional tooltip.
---@field tooltip? string
--- The identifier of the actual command handler.
---@field command string
--- Arguments that the command handler should be invoked with.
---@field arguments? LSP.Any[]


---@enum LSP.MarkupKind
M.MarkupKind = {
    --- Plain text is supported as a content format.
    PlainText = 'plaintext',

    --- Markdown is supported as a content format.
    Markdown = 'markdown',
}


---@class LSP.MarkupContent
--- The type of the Markup.
---@field kind LSP.MarkupKind
--- The content itself.
---@field value string


--- Client capabilities specific to the used markdown parser.
---
---@since 3.16.0
---@class LSP.MarkdownClientCapabilities
--- The name of the parser.
---@field parser string
--- The version of the parser.
---@field version? string
--- A list of HTML tags that the client allows / supports in
--- Markdown.
---
---@since 3.17.0
---@field allowedTags? string[]


--- Options to create a file.
---@class LSP.CreateFileOptions  
--- Overwrite existing file. Overwrite wins over `ignoreIfExists`.
---@field overwrite? boolean
--- Ignore if exists.
---@field ignoreIfExists? boolean


--- Create file operation
---@class LSP.CreateFile
--- This is a create operation.
---@field kind 'create'
--- The resource to create.
---@field uri LSP.DocumentUri
--- Additional options.
---@field options? LSP.CreateFileOptions
--- An optional annotation identifier describing the operation.
---
---@since 3.16.0
---@field annotationId? LSP.ChangeAnnotationIdentifier


---@class LSP.RenameFileOptions
--- Overwrite target if existing. Overwrite wins over `ignoreIfExists`.
---@field overwrite? boolean
--- Ignores if target exists.
---@field ignoreIfExists? boolean


---@class LSP.RenameFile
--- This is a rename operation.
---@field kind 'rename'
--- The old (existing) location.
---@field oldUri LSP.DocumentUri
--- The new location.
---@field newUri LSP.DocumentUri
--- Rename options.
---@field options? LSP.RenameFileOptions
--- An optional annotation identifier describing the operation.
---
---@since 3.16.0
---@field annotationId? LSP.ChangeAnnotationIdentifier


--- Delete file options
---@class LSP.DeleteFileOptions
--- Delete the content recursively if a folder is denoted.
---@field recursive? boolean
--- Ignore the operation if the file doesn't exist.
---@field ignoreIfNotExists? boolean


--- Delete file operation
---@class LSP.DeleteFile
--- This is a delete operation.
---@field kind 'delete'
--- The file to delete.
---@field uri LSP.DocumentUri
--- Delete options.
---@field options? LSP.DeleteFileOptions
--- An optional annotation identifier describing the operation.
---
---@since 3.16.0
---@field annotationId? LSP.ChangeAnnotationIdentifier


---@class LSP.WorkspaceEdit 
--- Holds changes to existing resources.
---@field changes? { [LSP.DocumentUri]: LSP.TextEdit[] }
--- Depending on the client capability
--- `workspace.workspaceEdit.resourceOperations` document changes are either
--- an array of `TextDocumentEdit`s to express changes to n different text
--- documents where each text document edit addresses a specific version of
--- a text document. Or it can contain above `TextDocumentEdit`s mixed with
--- create, rename and delete file / folder operations.
---
--- Whether a client supports versioned document edits is expressed via
--- `workspace.workspaceEdit.documentChanges` client capability.
---
--- If a client neither supports `documentChanges` nor
--- `workspace.workspaceEdit.resourceOperations` then only plain `TextEdit`s
--- using the `changes` property are supported.
---@field documentChanges? (LSP.TextDocumentEdit[] | (LSP.TextDocumentEdit | LSP.CreateFile | LSP.RenameFile | LSP.DeleteFile)[] )
--- A map of change annotations that can be referenced in
--- `AnnotatedTextEdit`s or create, rename and delete file / folder
--- operations.
---
--- Whether clients honor this property depends on the client capability
--- `workspace.changeAnnotationSupport`.
---
---@since 3.16.0
---@field changeAnnotations? { [string]: LSP.ChangeAnnotation }


---@class LSP.WorkspaceEditClientCapabilities 
--- The client supports versioned document changes in `WorkspaceEdit`s.
---@field documentChanges? boolean
--- The resource operations the client supports. Clients should at least
--- support 'create', 'rename', and 'delete' for files and folders.
---
---@since 3.13.0
---@field resourceOperations? LSP.ResourceOperationKind[]
--- The failure handling strategy of a client if applying the workspace edit
--- fails.
---
---@since 3.13.0
---@field failureHandling? LSP.FailureHandlingKind
--- Whether the client normalizes line endings to the client specific
--- setting.
--- If set to `true`, the client will normalize line ending characters
--- in a workspace edit to the client specific new line character(s).
---
---@since 3.16.0
---@field normalizesLineEndings? boolean
--- Whether the client in general supports change annotations on text edits,
--- create file, rename file, and delete file changes.
---
---@since 3.16.0
---@field changeAnnotationSupport? {
--- groupsOnLabel?: boolean,
---}
--- Whether the client supports `WorkspaceEditMetadata` in `WorkspaceEdit`s.
---
---@since 3.18.0
---@proposed
---@field metadataSupport? boolean
--- Whether the client supports snippets as text edits.
---
---@since 3.18.0
---@proposed
---@field snippetEditSupport? boolean


---The kind of resource operations supported by the client.
---@enum LSP.ResourceOperationKind
M.ResourceOperationKind = {
    --- Supports creating new files and folders.
    Create = 'create',
    --- Supports renaming existing files and folders.
    Rename = 'rename',
    --- Supports deleting existing files and folders.
    Delete = 'delete',
}


---@enum LSP.FailureHandlingKind
M.FailureHandlingKind = {
    --- Applying the workspace change is simply aborted if one of the changes
    --- provided fails. All operations executed before the failing operation
    --- stay executed.
    Abort = 'abort',
    --- All operations are executed transactionally. That means they either all
    --- succeed or no changes at all are applied to the workspace.
    Transactional = 'transactional',
    --- If the workspace edit contains only textual file changes they are
    --- executed transactionally. If resource changes (create, rename or delete
    --- file) are part of the change the failure handling strategy is abort.
    TextOnlyTransactional = 'textOnlyTransactional',
    --- The client tries to undo the operations already executed. But there is no
    --- guarantee that
    Undo = 'undo',
}


---@class LSP.WorkDoneProgressBegin 
---@field kind 'begin'
--- Mandatory title of the progress operation. Used to briefly inform about
--- the kind of operation being performed.
---
--- ---@field Examples "Indexing" or "Linking dependencies".
---@field title string
--- Controls if a cancel button should be shown to allow the user to cancel
--- the long running operation. Clients that don't support cancellation are
--- allowed to ignore the setting.
---@field cancellable? boolean
--- Optional, more detailed associated progress message. Contains
--- complementary information to the `title`.
---
--- ---@field Examples "3/25 files", "project/src/module2", "node_modules/some_dep".
--- If unset, the previous progress message (if any) is still valid.
---@field message? string
--- Optional progress percentage to display (value 100 is considered 100%).
--- If not provided infinite progress is assumed and clients are allowed
--- to ignore the `percentage` value in subsequent report notifications.
---
--- The value should be steadily rising. Clients are free to ignore values
--- that are not following this rule. The value range is [0, 100].
---@field percentage? uinteger


---@class LSP.WorkDoneProgressReport 
---@field kind 'report'
--- Controls enablement state of a cancel button. This property is only valid
--- if a cancel button got requested in the `WorkDoneProgressBegin` payload.
---
--- Clients that don't support cancellation or don't support controlling the
--- button's enablement state are allowed to ignore the setting.
---@field cancellable? boolean
--- Optional, more detailed associated progress message. Contains
--- complementary information to the `title`.
---
--- ---@field Examples "3/25 files", "project/src/module2", "node_modules/some_dep".
--- If unset, the previous progress message (if any) is still valid.
---@field message? string
--- Optional progress percentage to display (value 100 is considered 100%).
--- If not provided infinite progress is assumed and clients are allowed
--- to ignore the `percentage` value in subsequent report notifications.
---
--- The value should be steadily rising. Clients are free to ignore values
--- that are not following this rule. The value range is [0, 100].
---@field percentage? uinteger


---@class LSP.WorkDoneProgressEnd 
---@field kind 'end'
--- Optional, a final message indicating, for example,
--- the outcome of the operation.
---@field message? string


---@class LSP.WorkDoneProgressParams 
--- An optional token that a server can use to report work done progress.
---@field workDoneToken? ProgressToken


---@class LSP.WorkDoneProgressOptions 
---@field workDoneProgress? boolean


---@class LSP.PartialResultParams 
--- An optional token that a server can use to report partial results (e.g.
--- streaming) to the client.
---@field partialResultToken? ProgressToken


---@alias LSP.TraceValue 'off' | 'messages' | 'verbose'


---@class LSP.InitializeParams : LSP.WorkDoneProgressParams 
--- The process Id of the parent process that started the server. Is null if
--- the process has not been started by another process. If the parent
--- process is not alive then the server should exit (see exit notification)
--- its process.
---@field processId integer | nil
--- Information about the client
---
---@since 3.15.0
---@field clientInfo? { name: string, version?: string }
--- The locale the client is currently showing the user interface
--- in. This must not necessarily be the locale of the operating
--- system.
---
--- Uses IETF language tags as the value's syntax
--- (See https://en.wikipedia.org/wiki/IETF_language_tag)
---
---@since 3.16.0
---@field locale? string
--- The rootPath of the workspace. Is null
--- if no folder is open.
---
--- @deprecated in favour of `rootUri`.
---@field rootPath? string | nil
--- The rootUri of the workspace. Is null if no
--- folder is open. If both `rootPath` and `rootUri` are set
--- `rootUri` wins.
---
--- @deprecated in favour of `workspaceFolders`
---@field rootUri LSP.DocumentUri | nil
--- User provided initialization options.
---@field initializationOptions? LSP.Any
--- The capabilities provided by the client (editor or tool)
---@field capabilities LSP.ClientCapabilities
--- The initial trace setting. If omitted trace is disabled ('off').
---@field trace? LSP.TraceValue
--- The workspace folders configured in the client when the server starts.
--- This property is only available if the client supports workspace folders.
--- It can be `null` if the client supports workspace folders but none are
--- configured.
---
---@since 3.6.0
---@field workspaceFolders? LSP.WorkspaceFolder[] | nil


--- Text document specific client capabilities.
---@class LSP.TextDocumentClientCapabilities
--- Defines which synchronization capabilities the client supports.
---@field synchronization? LSP.TextDocumentSyncClientCapabilities
--- Defines which filters the client supports.
---
---@since 3.18.0
---@field filters? LSP.TextDocumentFilterClientCapabilities
--- Capabilities specific to the `textDocument/completion` request.
---@field completion? LSP.CompletionClientCapabilities
--- Capabilities specific to the `textDocument/hover` request.
---@field hover? LSP.HoverClientCapabilities
--- Capabilities specific to the `textDocument/signatureHelp` request.
---@field signatureHelp? LSP.SignatureHelpClientCapabilities
--- Capabilities specific to the `textDocument/declaration` request.
---
---@since 3.14.0
---@field declaration? LSP.DeclarationClientCapabilities
--- Capabilities specific to the `textDocument/definition` request.
---@field definition? LSP.DefinitionClientCapabilities
--- Capabilities specific to the `textDocument/typeDefinition` request.
---
---@since 3.6.0
---@field typeDefinition? LSP.TypeDefinitionClientCapabilities
--- Capabilities specific to the `textDocument/implementation` request.
---
---@since 3.6.0
---@field implementation? LSP.ImplementationClientCapabilities
--- Capabilities specific to the `textDocument/references` request.
---@field references? LSP.ReferenceClientCapabilities
--- Capabilities specific to the `textDocument/documentHighlight` request.
---@field documentHighlight? LSP.DocumentHighlightClientCapabilities
--- Capabilities specific to the `textDocument/documentSymbol` request.
---@field documentSymbol? LSP.DocumentSymbolClientCapabilities
--- Capabilities specific to the `textDocument/codeAction` request.
---@field codeAction? LSP.CodeActionClientCapabilities
--- Capabilities specific to the `textDocument/codeLens` request.
---@field codeLens? LSP.CodeLensClientCapabilities
--- Capabilities specific to the `textDocument/documentLink` request.
---@field documentLink? LSP.DocumentLinkClientCapabilities
--- Capabilities specific to the `textDocument/documentColor` and the
--- `textDocument/colorPresentation` request.
---
---@since 3.6.0
---@field colorProvider? LSP.DocumentColorClientCapabilities
--- Capabilities specific to the `textDocument/formatting` request.
---@field formatting? LSP.DocumentFormattingClientCapabilities
--- Capabilities specific to the `textDocument/rangeFormatting` and
--- `textDocument/rangesFormatting requests.
---@field rangeFormatting? LSP.DocumentRangeFormattingClientCapabilities
--- Capabilities specific to the `textDocument/onTypeFormatting` request.
---@field onTypeFormatting? LSP.DocumentOnTypeFormattingClientCapabilities
--- Capabilities specific to the `textDocument/rename` request.
---@field rename? LSP.RenameClientCapabilities
--- Capabilities specific to the `textDocument/publishDiagnostics`
--- notification.
---@field publishDiagnostics? LSP.PublishDiagnosticsClientCapabilities
--- Capabilities specific to the `textDocument/foldingRange` request.
---
---@since 3.10.0
---@field foldingRange? LSP.FoldingRangeClientCapabilities
--- Capabilities specific to the `textDocument/selectionRange` request.
---
---@since 3.15.0
---@field selectionRange? LSP.SelectionRangeClientCapabilities
--- Capabilities specific to the `textDocument/linkedEditingRange` request.
---
---@since 3.16.0
---@field linkedEditingRange? LSP.LinkedEditingRangeClientCapabilities
--- Capabilities specific to the various call hierarchy requests.
---
---@since 3.16.0
---@field callHierarchy? LSP.CallHierarchyClientCapabilities
--- Capabilities specific to the various semantic token requests.
---
---@since 3.16.0
---@field semanticTokens? LSP.SemanticTokensClientCapabilities
--- Capabilities specific to the `textDocument/moniker` request.
---
---@since 3.16.0
---@field moniker? LSP.MonikerClientCapabilities
--- Capabilities specific to the various type hierarchy requests.
---
---@since 3.17.0
---@field typeHierarchy? LSP.TypeHierarchyClientCapabilities
--- Capabilities specific to the `textDocument/inlineValue` request.
---
---@since 3.17.0
---@field inlineValue? LSP.InlineValueClientCapabilities
--- Capabilities specific to the `textDocument/inlayHint` request.
---
---@since 3.17.0
---@field inlayHint? LSP.InlayHintClientCapabilities
--- Capabilities specific to the diagnostic pull model.
---
---@since 3.17.0
---@field diagnostic? LSP.DiagnosticClientCapabilities
--- Capabilities specific to the `textDocument/inlineCompletion` request.
---
---@since 3.18.0
---@field inlineCompletion? LSP.InlineCompletionClientCapabilities


---@class LSP.TextDocumentFilterClientCapabilities 
--- The client supports Relative Patterns.
---
---@since 3.18.0
---@field relativePatternSupport? boolean


---@class LSP.ClientCapabilities 
--- Workspace specific client capabilities.
---@field workspace? LSP.ClientCapabilities.Workspace
--- Text document specific client capabilities.
---@field textDocument? LSP.TextDocumentClientCapabilities
--- Capabilities specific to the notebook document support.
---
---@since 3.17.0
---@field notebookDocument? LSP.NotebookDocumentClientCapabilities
--- Window specific client capabilities.
---@field window? LSP.ClientCapabilities.Window
--- General client capabilities.
---
---@since 3.16.0
---@field general? LSP.ClientCapabilities.General
--- Experimental client capabilities.
---@field experimental? LSP.Any


---@class LSP.ClientCapabilities.Workspace
--- The client supports applying batch edits
--- to the workspace by supporting the request
--- 'workspace/applyEdit'
---@field applyEdit? boolean
--- Capabilities specific to `WorkspaceEdit`s
---@field workspaceEdit? LSP.WorkspaceEditClientCapabilities
--- Capabilities specific to the `workspace/didChangeConfiguration`
--- notification.
---@field didChangeConfiguration? LSP.DidChangeConfigurationClientCapabilities
--- Capabilities specific to the `workspace/didChangeWatchedFiles`
--- notification.
---@field didChangeWatchedFiles? LSP.DidChangeWatchedFilesClientCapabilities
--- Capabilities specific to the `workspace/symbol` request.
---@field symbol? LSP.WorkspaceSymbolClientCapabilities
--- Capabilities specific to the `workspace/executeCommand` request.
---@field executeCommand? LSP.ExecuteCommandClientCapabilities
--- The client has support for workspace folders.
---
---@since 3.6.0
---@field workspaceFolders? boolean
--- The client supports `workspace/configuration` requests.
---
---@since 3.6.0
---@field configuration? boolean
--- Capabilities specific to the semantic token requests scoped to the
--- workspace.
---
---@since 3.16.0
---@field semanticTokens? LSP.SemanticTokensWorkspaceClientCapabilities
--- Capabilities specific to the code lens requests scoped to the
--- workspace.
---
---@since 3.16.0
---@field codeLens? LSP.CodeLensWorkspaceClientCapabilities
--- The client has support for file requests/notifications.
---
---@since 3.16.0
---@field fileOperations? LSP.ClientCapabilities.Workspace.FileOperations
--- Client workspace capabilities specific to inline values.
---
---@since 3.17.0
---@field inlineValue? LSP.InlineValueWorkspaceClientCapabilities
--- Client workspace capabilities specific to inlay hints.
---
---@since 3.17.0
---@field inlayHint? LSP.InlayHintWorkspaceClientCapabilities
--- Client workspace capabilities specific to diagnostics.
---
---@since 3.17.0.
---@field diagnostics? LSP.DiagnosticWorkspaceClientCapabilities


--- Capabilities specific to the notebook document support.
---
---@since 3.17.0
---@class LSP.NotebookDocumentClientCapabilities
--- Capabilities specific to notebook document synchronization
---
---@since 3.17.0
---@field synchronization LSP.NotebookDocumentSyncClientCapabilities


---@class LSP.ClientCapabilities.Workspace.FileOperations
--- Whether the client supports dynamic registration for file
--- requests/notifications.
---@field dynamicRegistration? boolean
--- The client has support for sending didCreateFiles notifications.
---@field didCreate? boolean
--- The client has support for sending willCreateFiles requests.
---@field willCreate? boolean
--- The client has support for sending didRenameFiles notifications.
---@field didRename? boolean
--- The client has support for sending willRenameFiles requests.
---@field willRename? boolean
--- The client has support for sending didDeleteFiles notifications.
---@field didDelete? boolean
--- The client has support for sending willDeleteFiles requests.
---@field willDelete? boolean


---@class LSP.ClientCapabilities.Window
--- It indicates whether the client supports server initiated
--- progress using the `window/workDoneProgress/create` request.
---
--- The capability also controls Whether client supports handling
--- of progress notifications. If set servers are allowed to report a
--- `workDoneProgress` property in the request specific server
--- capabilities.
---
---@since 3.15.0
---@field workDoneProgress? boolean
--- Capabilities specific to the showMessage request
---
---@since 3.16.0
---@field showMessage? LSP.ShowMessageRequestClientCapabilities
--- Client capabilities for the show document request.
---
---@since 3.16.0
---@field showDocument? LSP.ShowDocumentClientCapabilities


---@class LSP.ClientCapabilities.General
--- Client capability that signals how the client
--- handles stale requests (e.g. a request
--- for which the client will not process the response
--- anymore since the information is outdated).
---
---@since 3.17.0
---@field staleRequestSupport? { cancel: boolean, retryOnContentModified: string[] }
--- Client capabilities specific to regular expressions.
---
---@since 3.16.0
---@field regularExpressions? LSP.RegularExpressionsClientCapabilities
--- Client capabilities specific to the client's markdown parser.
---
---@since 3.16.0
---@field markdown? LSP.MarkdownClientCapabilities
--- The position encodings supported by the client. Client and server
--- have to agree on the same position encoding to ensure that offsets
--- (e.g. character position in a line) are interpreted the same on both
--- side.
---
--- To keep the protocol backwards compatible the following ---@field applies if
--- the value 'utf-16' is missing from the array of position encodings
--- servers can assume that the client supports UTF-16. UTF-16 is
--- therefore a mandatory encoding.
---
--- If omitted it defaults to ['utf-16'].
---
--- Implementation ---@field considerations since the conversion from one encoding
--- into another requires the content of the file / line the conversion
--- is best done where the file is read which is usually on the server
--- side.
---
---@since 3.17.0
---@field positionEncodings? LSP.PositionEncodingKind[]


---@class LSP.InitializeResult 
--- The capabilities the language server provides.
---@field capabilities LSP.ServerCapabilities
--- Information about the server.
---
---@since 3.15.0
---@field serverInfo? { name: string, version?: string }

---@enum LSP.InitializeErrorCodes
M.InitializeErrorCodes = {
    --- If the protocol version provided by the client can't be handled by
    --- the server.
    ---
    --- @deprecated This initialize error got replaced by client capabilities.
    --- There is no version handshake in version 3.0x
    unknownProtocolVersion = 1,
}


---@class LSP.InitializeError 
--- Indicates whether the client execute the following retry logic:
--- (1) show the message provided by the ResponseError to the user
--- (2) user selects retry or cancel
--- (3) if user selected retry the initialize method is sent again.
---@field retry boolean


---@class LSP.ServerCapabilities 
--- The position encoding the server picked from the encodings offered
--- by the client via the client capability `general.positionEncodings`.
---
--- If the client didn't provide any position encodings the only valid
--- value that a server can return is 'utf-16'.
---
--- If omitted it defaults to 'utf-16'.
---
---@since 3.17.0
---@field positionEncoding? LSP.PositionEncodingKind
--- Defines how text documents are synced. Is either a detailed structure
--- defining each notification or for backwards compatibility the
--- TextDocumentSyncKind number. If omitted it defaults to
--- `TextDocumentSyncKind.None`.
---@field textDocumentSync? LSP.TextDocumentSyncOptions | LSP.TextDocumentSyncKind
--- Defines how notebook documents are synced.
---
---@since 3.17.0
---@field notebookDocumentSync? LSP.NotebookDocumentSyncOptions | LSP.NotebookDocumentSyncRegistrationOptions
--- The server provides completion support.
---@field completionProvider? LSP.CompletionOptions
--- The server provides hover support.
---@field hoverProvider? boolean | LSP.HoverOptions
--- The server provides signature help support.
---@field signatureHelpProvider? LSP.SignatureHelpOptions
--- The server provides go to declaration support.
---
---@since 3.14.0
---@field declarationProvider? boolean | LSP.DeclarationOptions | LSP.DeclarationRegistrationOptions
--- The server provides goto definition support.
---@field definitionProvider? boolean | LSP.DefinitionOptions
--- The server provides goto type definition support.
---
---@since 3.6.0
---@field typeDefinitionProvider? boolean | LSP.TypeDefinitionOptions | LSP.TypeDefinitionRegistrationOptions
--- The server provides goto implementation support.
---
---@since 3.6.0
---@field implementationProvider? boolean | LSP.ImplementationOptions | LSP.ImplementationRegistrationOptions
--- The server provides find references support.
---@field referencesProvider? boolean | LSP.ReferenceOptions
--- The server provides document highlight support.
---@field documentHighlightProvider? boolean | LSP.DocumentHighlightOptions
--- The server provides document symbol support.
---@field documentSymbolProvider? boolean | LSP.DocumentSymbolOptions
--- The server provides code actions. The `CodeActionOptions` return type is
--- only valid if the client signals code action literal support via the
--- property `textDocument.codeAction.codeActionLiteralSupport`.
---@field codeActionProvider? boolean | LSP.CodeActionOptions
--- The server provides code lens.
---@field codeLensProvider? LSP.CodeLensOptions
--- The server provides document link support.
---@field documentLinkProvider? LSP.DocumentLinkOptions
--- The server provides color provider support.
---
---@since 3.6.0
---@field colorProvider? boolean | LSP.DocumentColorOptions | LSP.DocumentColorRegistrationOptions
--- The server provides document formatting.
---@field documentFormattingProvider? boolean | LSP.DocumentFormattingOptions
--- The server provides document range formatting.
---@field documentRangeFormattingProvider? boolean | LSP.DocumentRangeFormattingOptions
--- The server provides document formatting on typing.
---@field documentOnTypeFormattingProvider? LSP.DocumentOnTypeFormattingOptions
--- The server provides rename support. RenameOptions may only be
--- specified if the client states that it supports
--- `prepareSupport` in its initial `initialize` request.
---@field renameProvider? boolean | LSP.RenameOptions
--- The server provides folding provider support.
---
---@since 3.10.0
---@field foldingRangeProvider? boolean | LSP.FoldingRangeOptions | LSP.FoldingRangeRegistrationOptions
--- The server provides execute command support.
---@field executeCommandProvider? LSP.ExecuteCommandOptions
--- The server provides selection range support.
---
---@since 3.15.0
---@field selectionRangeProvider? boolean | LSP.SelectionRangeOptions | LSP.SelectionRangeRegistrationOptions
--- The server provides linked editing range support.
---
---@since 3.16.0
---@field linkedEditingRangeProvider? boolean | LSP.LinkedEditingRangeOptions | LSP.LinkedEditingRangeRegistrationOptions
--- The server provides call hierarchy support.
---
---@since 3.16.0
---@field callHierarchyProvider? boolean | LSP.CallHierarchyOptions | LSP.CallHierarchyRegistrationOptions
--- The server provides semantic tokens support.
---
---@since 3.16.0
---@field semanticTokensProvider? LSP.SemanticTokensOptions | LSP.SemanticTokensRegistrationOptions
--- Whether server provides moniker support.
---
---@since 3.16.0
---@field monikerProvider? boolean | LSP.MonikerOptions | LSP.MonikerRegistrationOptions
--- The server provides type hierarchy support.
---
---@since 3.17.0
---@field typeHierarchyProvider? boolean | LSP.TypeHierarchyOptions | LSP.TypeHierarchyRegistrationOptions
--- The server provides inline values.
---
---@since 3.17.0
---@field inlineValueProvider? boolean | LSP.InlineValueOptions | LSP.InlineValueRegistrationOptions
--- The server provides inlay hints.
---
---@since 3.17.0
---@field inlayHintProvider? boolean | LSP.InlayHintOptions | LSP.InlayHintRegistrationOptions
--- The server has support for pull model diagnostics.
---
---@since 3.17.0
---@field diagnosticProvider? LSP.DiagnosticOptions | LSP.DiagnosticRegistrationOptions
--- The server provides workspace symbol support.
---@field workspaceSymbolProvider? boolean | LSP.WorkspaceSymbolOptions
--- The server provides inline completions.
---
---@since 3.18.0
---@field inlineCompletionProvider? boolean | LSP.InlineCompletionOptions
--- Text document specific server capabilities.
---
---@since 3.18.0
---@field textDocument? { diagnostic?: { markupMessageSupport?: boolean } }
--- Workspace specific server capabilities
---@field workspace? { workspaceFolders?: LSP.WorkspaceFoldersServerCapabilities, fileOperations?: LSP.ServerCapabilities.Workspace.FileOperations }
--- Experimental server capabilities.
---@field experimental? LSP.Any


---@class LSP.ServerCapabilities.Workspace.FileOperations
--- The server is interested in receiving didCreateFiles
--- notifications.
---@field didCreate? LSP.FileOperationRegistrationOptions
--- The server is interested in receiving willCreateFiles requests.
---@field willCreate? LSP.FileOperationRegistrationOptions
--- The server is interested in receiving didRenameFiles
--- notifications.
---@field didRename? LSP.FileOperationRegistrationOptions
--- The server is interested in receiving willRenameFiles requests.
---@field willRename? LSP.FileOperationRegistrationOptions
--- The server is interested in receiving didDeleteFiles file
--- notifications.
---@field didDelete? LSP.FileOperationRegistrationOptions
--- The server is interested in receiving willDeleteFiles file
--- requests.
---@field willDelete? LSP.FileOperationRegistrationOptions


---@class LSP.InitializedParams


--- General parameters to register for a capability.
---@class LSP.Registration
--- The id used to register the request. The id can be used to deregister
--- the request again.
---@field id string
--- The method / capability to register for.
---@field method string
--- Options necessary for the registration.
---@field registerOptions? LSP.Any


---@class LSP.RegistrationParams 
---@field registrations LSP.Registration[]


--- Static registration options to be returned in the initialize request.
---@class LSP.StaticRegistrationOptions
--- The id used to register the request. The id can be used to deregister
--- the request again. See also Registration#id.
---@field id? string


--- General text document registration options.
---@class LSP.TextDocumentRegistrationOptions
--- A document selector to identify the scope of the registration. If set to
--- nil, the document selector provided on the client side will be used.
---@field documentSelector LSP.DocumentSelector | nil


--- General parameters to unregister a capability.
---@class LSP.Unregistration
--- The id used to unregister the request or notification. Usually an id
--- provided during the register request.
---@field id string
--- The method / capability to unregister for.
---@field method string


---@class LSP.UnregistrationParams 
-- This should correctly be named `unregistrations`. However, changing this
-- is a breaking change and needs to wait until we deliver a 4.x version
-- of the specification.
---@field unregisterations LSP.Unregistration[]


---@class LSP.SetTraceParams 
--- The new value that should be assigned to the trace setting.
---@field value LSP.TraceValue


---@class LSP.LogTraceParams 
--- The message to be logged.
---@field message string
--- Additional information that can be computed if the `trace` configuration
--- is set to `'verbose'`.
---@field verbose? string


---@enum LSP.TextDocumentSyncKind
M.TextDocumentSyncKind = {
    --- Documents should not be synced at all.
    None = 0,
    --- Documents are synced by always sending the full content of the document.
    Full = 1,
    --- Documents are synced by sending the full content on open. After that
    --- only incremental updates to the document are sent.
    Incremental = 2,
}


---@class LSP.DidOpenTextDocumentParams 
--- The document that was opened.
---@field textDocument LSP.TextDocumentItem


--- Describe options to be used when registering for text document change events.
---@class LSP.TextDocumentChangeRegistrationOptions : LSP.TextDocumentRegistrationOptions
--- How documents are synced to the server. See TextDocumentSyncKind.Full
--- and TextDocumentSyncKind.Incremental.
---@field syncKind LSP.TextDocumentSyncKind


---@class LSP.DidChangeTextDocumentParams 
--- The document that did change. The version number points
--- to the version after all provided content changes have
--- been applied.
---@field textDocument LSP.VersionedTextDocumentIdentifier
--- The actual content changes. The content changes describe single state
--- changes to the document. So if there are two content changes c1 (at
--- array index 0) and c2 (at array index 1) for a document in state S then
--- c1 moves the document from S to S' and c2 from S' to S''. So c1 is
--- computed on the state S and c2 is computed on the state S'.
---
--- To mirror the content of a document using change events use the following
--- approach:
--- - start with the same initial content
--- - apply the 'textDocument/didChange' notifications in the order you
---   receive them.
--- - apply the `TextDocumentContentChangeEvent`s in a single notification
---   in the order you receive them.
---@field contentChanges LSP.TextDocumentContentChangeEvent[]


---@alias LSP.TextDocumentContentChangeEvent LSP.TextDocumentContentChangeEvent.Full | LSP.TextDocumentContentChangeEvent.Simple


---@class LSP.TextDocumentContentChangeEvent.Full
--- The range of the document that changed.
---@field range LSP.Range
--- The optional length of the range that got replaced.
---
--- @deprecated use range instead.
---@field rangeLength? uinteger
--- The new text for the provided range.
---@field text string


---@class LSP.TextDocumentContentChangeEvent.Simple
--- The new text for the provided range.
---@field text string


--- The parameters send in a will save text document notification.
---@class LSP.WillSaveTextDocumentParams
--- The document that will be saved.
---@field textDocument LSP.TextDocumentIdentifier
--- The 'TextDocumentSaveReason'.
---@field reason LSP.TextDocumentSaveReason


---@enum LSP.TextDocumentSaveReason
M.TextDocumentSaveReason = {
    --- Manually triggered, e.g. by the user pressing save, by starting
    --- debugging, or by an API call.
    Manual = 1,
    --- Automatic after a delay.
    AfterDelay = 2,
    --- When the editor lost focus.
    FocusOut = 3,
}


---@class LSP.SaveOptions 
--- The client is supposed to include the content on save.
---@field includeText? boolean


---@class LSP.TextDocumentSaveRegistrationOptions : LSP.TextDocumentRegistrationOptions
--- The client is supposed to include the content on save.
---@field includeText? boolean


---@class LSP.DidSaveTextDocumentParams 
--- The document that was saved.
---@field textDocument LSP.TextDocumentIdentifier
--- Optional the content when saved. Depends on the includeText value
--- when the save notification was requested.
---@field text? string


---@class LSP.DidCloseTextDocumentParams 
--- The document that was closed.
---@field textDocument LSP.TextDocumentIdentifier


---@class LSP.TextDocumentSyncClientCapabilities 
--- Whether text document synchronization supports dynamic registration.
---@field dynamicRegistration? boolean
--- The client supports sending will save notifications.
---@field willSave? boolean
--- The client supports sending a will save request and
--- waits for a response providing text edits which will
--- be applied to the document before it is saved.
---@field willSaveWaitUntil? boolean
--- The client supports did save notifications.
---@field didSave? boolean


---@class LSP.TextDocumentSyncOptions 
--- Open and close notifications are sent to the server. If omitted open
--- close notification should not be sent.
---@field openClose? boolean
--- Change notifications are sent to the server. See
--- TextDocumentSyncKind.None, TextDocumentSyncKind.Full and
--- TextDocumentSyncKind.Incremental. If omitted it defaults to
--- TextDocumentSyncKind.None.
---@field change? LSP.TextDocumentSyncKind
--- If present will save notifications are sent to the server. If omitted
--- the notification should not be sent.
---@field willSave? boolean
--- If present will save wait until requests are sent to the server. If
--- omitted the request should not be sent.
---@field willSaveWaitUntil? boolean
--- If present save notifications are sent to the server. If omitted the
--- notification should not be sent.
---@field save? boolean | LSP.SaveOptions


--- A notebook document.
---
---@since 3.17.0
---@class LSP.NotebookDocument
--- The notebook document's URI.
---@field uri LSP.URI
--- The type of the notebook.
---@field notebookType string
--- The version number of this document (it will increase after each
--- change, including undo/redo).
---@field version integer
--- Additional metadata stored with the notebook
--- document.
---@field metadata? LSP.Object
--- The cells of a notebook.
---@field cells LSP.NotebookCell[]


--- A notebook cell.
---
--- A cell's document URI must be unique across ALL notebook
--- cells and can therefore be used to uniquely identify a  
--- notebook cell or the cell's text document.
---
---@since 3.17.0
---@class LSP.NotebookCell
--- The cell's kind.
---@field kind LSP.NotebookCellKind
--- The URI of the cell's text document
--- content.
---@field document LSP.DocumentUri
--- Additional metadata stored with the cell.
---@field metadata? LSP.Object
--- Additional execution summary information
--- if supported by the client.
---@field executionSummary? LSP.ExecutionSummary


---@enum LSP.NotebookCellKind
M.NotebookCellKind = {
    --- A markup-cell is a formatted source that is used for display.
    Markup = 1,
    --- A code-cell is source code.
    Code = 2,
}


---@class LSP.ExecutionSummary 
--- A strictly monotonically increasing value
--- indicating the execution order of a cell
--- inside a notebook.
---@field executionOrder uinteger
--- Whether the execution was successful or
--- not if known by the client.
---@field success? boolean


--- A notebook cell text document filter denotes a cell text
--- document by different properties.
---
---@since 3.17.0
---@class LSP.NotebookCellTextDocumentFilter
--- A filter that matches against the notebook
--- containing the notebook cell. If a string
--- value is provided, it matches against the
--- notebook type. '---' matches every notebook.
---@field notebook string | LSP.NotebookDocumentFilter
--- A language ID like `python`.
---
--- Will be matched against the language ID of the
--- notebook cell document. '---' matches every language.
---@field language? string


---@alias LSP.NotebookDocumentFilter
---| { notebookType: string, scheme?: string, pattern?: LSP.GlobPattern }
---| { notebookType?: string, scheme: string, pattern?: LSP.GlobPattern }
---| { notebookType?: string, scheme?: string, pattern: LSP.GlobPattern }


--- Notebook specific client capabilities.
---
---@since 3.17.0
---@class LSP.NotebookDocumentSyncClientCapabilities
--- Whether implementation supports dynamic registration. If this is
--- set to `true`, the client supports the new
--- `(NotebookDocumentSyncRegistrationOptions & NotebookDocumentSyncOptions)`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- The client supports sending execution summary data per cell.
---@field executionSummarySupport? boolean


---@class LSP.NotebookDocumentSyncOptions.NotebookSelector1
--- The notebook to be synced. If a string
--- value is provided, it matches against the
--- notebook type. '---' matches every notebook.
---@field notebook string | LSP.NotebookDocumentFilter
--- The cells of the matching notebook to be synced.
---@field cells? { language: string }[]


---@class LSP.NotebookDocumentSyncOptions.NotebookSelector2
--- The notebook to be synced. If a string
--- value is provided, it matches against the
--- notebook type. '---' matches every notebook.
---@field notebook? string | LSP.NotebookDocumentFilter
--- The cells of the matching notebook to be synced.
---@field cells { language: string }[]


--- Options specific to a notebook plus its cells
--- to be synced to the server.
---
--- If a selector provides a notebook document
--- filter but no cell selector, all cells of a
--- matching notebook document will be synced.
---
--- If a selector provides no notebook document
--- filter but only a cell selector, all notebook
--- documents that contain at least one matching
--- cell will be synced.
---
---@since 3.17.0
---@class LSP.NotebookDocumentSyncOptions
--- The notebooks to be synced
---@field notebookSelector (LSP.NotebookDocumentSyncOptions.NotebookSelector1 | LSP.NotebookDocumentSyncOptions.NotebookSelector2)[]
--- Whether save notifications should be forwarded to
--- the server. Will only be honored if mode === `notebook`.
---@field save? boolean


--- Registration options specific to a notebook.
---
---@since 3.17.0
---@class LSP.NotebookDocumentSyncRegistrationOptions : LSP.NotebookDocumentSyncOptions, LSP.StaticRegistrationOptions


--- The params sent in an open notebook document notification.
---
---@since 3.17.0
---@class LSP.DidOpenNotebookDocumentParams
--- The notebook document that got opened.
---@field notebookDocument LSP.NotebookDocument
--- The text documents that represent the content
--- of a notebook cell.
---@field cellTextDocuments LSP.TextDocumentItem[]


--- The params sent in a change notebook document notification.
---
---@since 3.17.0
---@class LSP.DidChangeNotebookDocumentParams
--- The notebook document that did change. The version number points
--- to the version after all provided changes have been applied.
---@field notebookDocument LSP.VersionedNotebookDocumentIdentifier
--- The actual changes to the notebook document.
---
--- The change describes a single state change to the notebook document,
--- so it moves a notebook document, its cells and its cell text document
--- contents from state S to S'.
---
--- To mirror the content of a notebook using change events use the
--- following approach:
--- - start with the same initial content
--- - apply the 'notebookDocument/didChange' notifications in the order
---   you receive them.
---@field change LSP.NotebookDocumentChangeEvent


--- A versioned notebook document identifier.
---
---@since 3.17.0
---@class LSP.VersionedNotebookDocumentIdentifier
--- The version number of this notebook document.
---@field version integer
--- The notebook document's URI.
---@field uri LSP.URI


--- A change event for a notebook document.
---
---@since 3.17.0
---@class LSP.NotebookDocumentChangeEvent
--- The changed meta data if any.
---@field metadata? LSP.Object
--- Changes to cells.
---@field cells? LSP.NotebookDocumentChangeEvent.Cells


---@class LSP.NotebookDocumentChangeEvent.Cells
--- Changes to the cell structure to add or
--- remove cells.
---@field structure? LSP.NotebookDocumentChangeEvent.Cells.Structure
--- Changes to notebook cells properties like its
--- kind, execution summary or metadata.
---@field data? LSP.NotebookCell[]
--- Changes to the text content of notebook cells.
---@field textContent? {
--- document: LSP.VersionedTextDocumentIdentifier,
--- changes: LSP.TextDocumentContentChangeEvent[],
---}[]


---@class LSP.NotebookDocumentChangeEvent.Cells.Structure
--- The change to the cell array.
---@field array LSP.NotebookCellArrayChange
--- Additional opened cell text documents.
---@field didOpen? LSP.TextDocumentItem[]
--- Additional closed cell text documents.
---@field didClose? LSP.TextDocumentIdentifier[]


--- A change describing how to move a `NotebookCell`
--- array from state S to S'.
---
---@since 3.17.0
---@class LSP.NotebookCellArrayChange
--- The start offset of the cell that changed.
---@field start uinteger
--- The number of deleted cells.
---@field deleteCount uinteger
--- The new cells, if any.
---@field cells? LSP.NotebookCell[]


--- The params sent in a save notebook document notification.
---
---@since 3.17.0
---@class LSP.DidSaveNotebookDocumentParams
--- The notebook document that got saved.
---@field notebookDocument LSP.NotebookDocumentIdentifier


--- The params sent in a close notebook document notification.
---
---@since 3.17.0
---@class LSP.DidCloseNotebookDocumentParams
--- The notebook document that got closed.
---@field notebookDocument LSP.NotebookDocumentIdentifier
--- The text documents that represent the content
--- of a notebook cell that got closed.
---@field cellTextDocuments LSP.TextDocumentIdentifier[]


--- A literal to identify a notebook document in the client.
---
---@since 3.17.0
---@class LSP.NotebookDocumentIdentifier
--- The notebook document's URI.
---@field uri LSP.URI


---@class LSP.DeclarationClientCapabilities 
--- Whether declaration supports dynamic registration. If this is set to
--- `true`, the client supports the new `DeclarationRegistrationOptions`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- The client supports additional metadata in the form of declaration links.
---@field linkSupport? boolean


---@class LSP.DeclarationOptions : LSP.WorkDoneProgressOptions


---@class LSP.DeclarationRegistrationOptions : LSP.DeclarationOptions, LSP.TextDocumentRegistrationOptions, LSP.StaticRegistrationOptions


---@class LSP.DeclarationParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams, LSP.PartialResultParams


---@class LSP.DefinitionClientCapabilities
--- Whether definition supports dynamic registration.
---@field dynamicRegistration? boolean
--- The client supports additional metadata in the form of definition links.
---
---@since 3.14.0
---@field linkSupport? boolean


---@class LSP.DefinitionOptions : LSP.WorkDoneProgressOptions


---@class LSP.DefinitionRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.DefinitionOptions 


---@class LSP.DefinitionParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams, LSP.PartialResultParams


---@class LSP.TypeDefinitionClientCapabilities
--- Whether implementation supports dynamic registration. If this is set to
--- `true`, the client supports the new `TypeDefinitionRegistrationOptions`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- The client supports additional metadata in the form of definition links.
---
---@since 3.14.0
---@field linkSupport? boolean


---@class LSP.TypeDefinitionOptions : LSP.WorkDoneProgressOptions


---@class LSP.TypeDefinitionRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.TypeDefinitionOptions, LSP.StaticRegistrationOptions


---@class LSP.TypeDefinitionParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams, LSP.PartialResultParams


---@class LSP.ImplementationClientCapabilities 
--- Whether the implementation supports dynamic registration. If this is set to
--- `true`, the client supports the new `ImplementationRegistrationOptions`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- The client supports additional metadata in the form of definition links.
---
---@since 3.14.0
---@field linkSupport? boolean


---@class LSP.ImplementationOptions : LSP.WorkDoneProgressOptions


---@class LSP.ImplementationRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.ImplementationOptions, LSP.StaticRegistrationOptions


---@class LSP.ImplementationParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams, LSP.PartialResultParams


---@class LSP.ReferenceClientCapabilities 
--- Whether references supports dynamic registration.
---@field dynamicRegistration? boolean


---@class LSP.ReferenceOptions : LSP.WorkDoneProgressOptions 


---@class LSP.ReferenceRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.ReferenceOptions


---@class LSP.ReferenceParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams, LSP.PartialResultParams
---@field context LSP.ReferenceContext


---@class LSP.ReferenceContext 
--- Include the declaration of the current symbol.
---@field includeDeclaration boolean


---@class LSP.CallHierarchyClientCapabilities 
--- Whether implementation supports dynamic registration. If this is set to
--- `true` the client supports the new `(TextDocumentRegistrationOptions &
--- StaticRegistrationOptions)` return value for the corresponding server
--- capability as well.
---@field dynamicRegistration? boolean


---@class LSP.CallHierarchyOptions : LSP.WorkDoneProgressOptions


---@class LSP.CallHierarchyRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.CallHierarchyOptions, LSP.StaticRegistrationOptions


---@class LSP.CallHierarchyPrepareParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams


---@class LSP.CallHierarchyItem 
--- The name of this item.
---@field name string
--- The kind of this item.
---@field kind LSP.SymbolKind
--- Tags for this item.
---@field tags? LSP.SymbolTag[]
--- More detail for this item, e.g. the signature of a function.
---@field detail? string
--- The resource identifier of this item.
---@field uri LSP.DocumentUri
--- The range enclosing this symbol not including leading/trailing whitespace
--- but everything else, e.g. comments and code.
---@field range LSP.Range
--- The range that should be selected and revealed when this symbol is being
--- picked, e.g. the name of a function. Must be contained by the
--- [`range`](#CallHierarchyItem.range).
---@field selectionRange LSP.Range
--- A data entry field that is preserved between a call hierarchy prepare and
--- incoming calls or outgoing calls requests.
---@field data? LSP.Any


---@class LSP.CallHierarchyIncomingCallsParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams 
---@field item LSP.CallHierarchyItem


---@class LSP.CallHierarchyIncomingCall 
--- The item that makes the call.
---@field from LSP.CallHierarchyItem
--- The ranges at which the calls appear. This is relative to the caller
--- denoted by [`this.from`](#CallHierarchyIncomingCall.from).
---@field fromRanges LSP.Range[]


---@class LSP.CallHierarchyOutgoingCallsParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams 
---@field item LSP.CallHierarchyItem


---@class LSP.CallHierarchyOutgoingCall 
--- The item that is called.
---@field to LSP.CallHierarchyItem
--- The range at which this item is called. This is the range relative to
--- the caller, e.g., the item passed to `callHierarchy/outgoingCalls` request.
---@field fromRanges LSP.Range[]


---@class LSP.TypeHierarchyClientCapabilities
--- Whether implementation supports dynamic registration. If this is set to
--- `true` the client supports the new `(TextDocumentRegistrationOptions &
--- StaticRegistrationOptions)` return value for the corresponding server
--- capability as well.
---@field dynamicRegistration? boolean


---@class LSP.TypeHierarchyOptions : LSP.WorkDoneProgressOptions 


---@class LSP.TypeHierarchyRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.TypeHierarchyOptions, LSP.StaticRegistrationOptions


---@class LSP.TypeHierarchyPrepareParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams


---@class LSP.TypeHierarchyItem 
--- The name of this item.
---@field name string
--- The kind of this item.
---@field kind LSP.SymbolKind
--- Tags for this item.
---@field tags? LSP.SymbolTag[]
--- More detail for this item, e.g. the signature of a function.
---@field detail? string
--- The resource identifier of this item.
---@field uri LSP.DocumentUri
--- The range enclosing this symbol not including leading/trailing whitespace
--- but everything else, e.g. comments and code.
---@field range LSP.Range
--- The range that should be selected and revealed when this symbol is being
--- picked, e.g. the name of a function. Must be contained by the
--- [`range`](#TypeHierarchyItem.range).
---@field selectionRange LSP.Range
--- A data entry field that is preserved between a type hierarchy prepare and
--- supertypes or subtypes requests. It could also be used to identify the
--- type hierarchy in the server, helping improve the performance on
--- resolving supertypes and subtypes.
---@field data? LSP.Any


---@class LSP.TypeHierarchySupertypesParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams 
---@field item LSP.TypeHierarchyItem


---@class LSP.TypeHierarchySubtypesParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams 
---@field item LSP.TypeHierarchyItem


---@class LSP.DocumentHighlightClientCapabilities 
--- Whether document highlight supports dynamic registration.
---@field dynamicRegistration? boolean


---@class LSP.DocumentHighlightOptions : LSP.WorkDoneProgressOptions 


---@class LSP.DocumentHighlightRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.DocumentHighlightOptions 


---@class LSP.DocumentHighlightParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams, LSP.PartialResultParams


--- A document highlight is a range inside a text document which deserves
--- special attention. Usually a document highlight is visualized by changing
--- the background color of its range.
---
---@class LSP.DocumentHighlight
--- The range this highlight applies to.
---@field range LSP.Range
--- The highlight kind, default is DocumentHighlightKind.Text.
---@field kind? LSP.DocumentHighlightKind


--- A document highlight kind.
---@enum LSP.DocumentHighlightKind
M.DocumentHighlightKind = {
    --- A textual occurrence.
    Text = 1,
    --- Read-access of a symbol, like reading a variable.
    Read = 2,
    --- Write-access of a symbol, like writing to a variable.
    Write = 3,
}


---@class LSP.DocumentLinkClientCapabilities 
--- Whether document link supports dynamic registration.
---@field dynamicRegistration? boolean
--- Whether the client supports the `tooltip` property on `DocumentLink`.
---
---@since 3.15.0
---@field tooltipSupport? boolean


---@class LSP.DocumentLinkOptions : LSP.WorkDoneProgressOptions 
--- Document links have a resolve provider as well.
---@field resolveProvider? boolean


---@class LSP.DocumentLinkRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.DocumentLinkOptions 


---@class LSP.DocumentLinkParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The document to provide document links for.
---@field textDocument LSP.TextDocumentIdentifier


--- A document link is a range in a text document that links to an internal or
--- external resource, like another text document or a web site.
---@class LSP.DocumentLink
--- The range this link applies to.
---@field range LSP.Range
--- The URI this link points to. If missing, a resolve request is sent later.
---@field target? LSP.URI
--- The tooltip text when you hover over this link.
---
--- If a tooltip is provided, it will be displayed in a string that includes
--- instructions on how to trigger the link, such as `0 (ctrl + click)`.
--- The specific instructions vary depending on OS, user settings, and
--- localization.
---
---@since 3.15.0
---@field tooltip? string
--- A data entry field that is preserved on a document link between a
--- DocumentLinkRequest and a DocumentLinkResolveRequest.
---@field data? LSP.Any


---@class LSP.HoverClientCapabilities 
--- Whether hover supports dynamic registration.
---@field dynamicRegistration? boolean
--- Client supports the following content formats if the content
--- property refers to a `literal of type MarkupContent`.
--- The order describes the preferred format of the client.
---@field contentFormat? LSP.MarkupKind[]


---@class LSP.HoverOptions : LSP.WorkDoneProgressOptions 


---@class LSP.HoverRegistrationOptions: LSP.TextDocumentRegistrationOptions, LSP.HoverOptions


---@class LSP.HoverParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams


--- The result of a hover request.
---@class LSP.Hover
--- The hover's content.
---@field contents LSP.MarkedString | LSP.MarkedString[] | LSP.MarkupContent
--- An optional range is a range inside a text document
--- that is used to visualize a hover, e.g. by changing the background color.
---@field range? LSP.Range


--- MarkedString can be used to render human readable text. It is either a
--- markdown string or a code-block that provides a language and a code snippet.
--- The language identifier is semantically equal to the optional language
--- identifier in fenced code blocks in GitHub issues.
---
--- The pair of a language and a value is an equivalent to markdown:
--- ```$language
--- $value
--- ```
---
--- Note that markdown strings will be sanitized - that means html will be
--- escaped.
---
---@deprecated use MarkupContent instead.
---@alias LSP.MarkedString string |  { language: string, value: string }


---@class LSP.CodeLensClientCapabilities 
--- Whether code lens supports dynamic registration.
---@field dynamicRegistration? boolean
--- Whether the client supports resolving additional code lens
--- properties via a separate `codeLens/resolve` request.
---
---@since 3.18.0
---@field resolveSupport? LSP.ClientCodeLensResolveOptions

---@since 3.18.0
---@class LSP.ClientCodeLensResolveOptions
--- The properties that a client can resolve lazily.
---@field properties string[]


---@class LSP.CodeLensOptions : LSP.WorkDoneProgressOptions 
--- Code lens has a resolve provider as well.
---@field resolveProvider? boolean


---@class LSP.CodeLensRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.CodeLensOptions 


---@class LSP.CodeLensParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams 
--- The document to request code lens for.
---@field textDocument LSP.TextDocumentIdentifier


--- A code lens represents a command that should be shown along with
--- source text, like the number of references, a way to run tests, etc.
---
--- A code lens is _unresolved_ when no command is associated to it. For
--- performance reasons the creation of a code lens and resolving should be done
--- in two stages.
---@class LSP.CodeLens
--- The range in which this code lens is valid. Should only span a single
--- line.
---@field range LSP.Range
--- The command this code lens represents.
---@field command? LSP.Command
--- A data entry field that is preserved on a code lens item between
--- a code lens and a code lens resolve request.
---@field data? LSP.Any


---@class LSP.CodeLensWorkspaceClientCapabilities 
--- Whether the client implementation supports a refresh request sent from the
--- server to the client.
---
--- Note that this event is global and will force the client to refresh all
--- code lenses currently shown. It should be used with absolute care and is
--- useful for situation where a server, for example, detects a project wide
--- change that requires such a calculation.
---@field refreshSupport? boolean


---@class LSP.FoldingRangeClientCapabilities 
--- Whether implementation supports dynamic registration for folding range  
--- providers. If this is set to `true` the client supports the new
--- `FoldingRangeRegistrationOptions` return value for the corresponding    
--- server capability as well.
---@field dynamicRegistration? boolean
--- The maximum number of folding ranges that the client prefers to receive 
--- per document. The value serves as a hint, servers are free to follow the
--- limit.
---@field rangeLimit? uinteger
--- If set, the client signals that it only supports folding complete lines.
--- If set, client will ignore specified `startCharacter` and `endCharacter`
--- properties in a FoldingRange.
---@field lineFoldingOnly? boolean
--- Specific options for the folding range kind.
---
---@since 3.17.0
---@field foldingRangeKind? { valueSet?: LSP.FoldingRangeKind[] }
--- Specific options for the folding range.
---@since 3.17.0
---@field foldingRange? { collapsedText?: boolean }


---@class LSP.FoldingRangeOptions : LSP.WorkDoneProgressOptions 


---@class LSP.FoldingRangeRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.FoldingRangeOptions, LSP.StaticRegistrationOptions


---@class LSP.FoldingRangeParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier


---@enum LSP.FoldingRangeKind
M.FoldingRangeKind = {
    --- Folding range for a comment
    Comment = 'comment',
    --- Folding range for a imports or includes
    Imports = 'imports',
    --- Folding range for a region (e.g. `#region`)
    Region = 'region',
}


--- Represents a folding range. To be valid, start and end line must be bigger
--- than zero and smaller than the number of lines in the document. Clients
--- are free to ignore invalid ranges.
---@class LSP.FoldingRange
--- The zero-based start line of the range to fold. The folded area starts
--- after the line's last character. To be valid, the end must be zero or
--- larger and smaller than the number of lines in the document.
---@field startLine uinteger
--- The zero-based character offset from where the folded range starts. If
--- not defined, defaults to the length of the start line.
---@field startCharacter? uinteger
--- The zero-based end line of the range to fold. The folded area ends with
--- the line's last character. To be valid, the end must be zero or larger
--- and smaller than the number of lines in the document.
---@field endLine uinteger
--- The zero-based character offset before the folded range ends. If not
--- defined, defaults to the length of the end line.
---@field endCharacter? uinteger
--- Describes the kind of the folding range such as `comment` or `region`.
--- The kind is used to categorize folding ranges and used by commands like
--- 'Fold all comments'. See [FoldingRangeKind](#FoldingRangeKind) for an
--- enumeration of standardized kinds.
---@field kind? LSP.FoldingRangeKind
--- The text that the client should show when the specified range is
--- collapsed. If not defined or not supported by the client, a default
--- will be chosen by the client.
---
---@since 3.17.0 - proposed
---@field collapsedText? string


---@class LSP.FoldingRangeWorkspaceClientCapabilities 
--- Whether the client implementation supports a refresh request sent from the
--- server to the client.
---
--- Note that this event is global and will force the client to refresh all
--- folding ranges currently shown. It should be used with absolute care and is
--- useful for situation where a server, for example, detects a project wide
--- change that requires such a calculation.
---
---@since 3.18.0
---@proposed
---@field refreshSupport? boolean


---@class LSP.SelectionRangeClientCapabilities 
--- Whether the implementation supports dynamic registration for selection range
--- providers. If this is set to `true`, the client supports the new
--- `SelectionRangeRegistrationOptions` return value for the corresponding
--- server capability as well.
---@field dynamicRegistration? boolean


---@class LSP.SelectionRangeOptions : LSP.WorkDoneProgressOptions


---@class LSP.SelectionRangeRegistrationOptions : LSP.SelectionRangeOptions, LSP.TextDocumentRegistrationOptions, LSP.StaticRegistrationOptions


---@class LSP.SelectionRangeParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier
--- The positions inside the text document.
---@field positions LSP.Position[]


---@class LSP.SelectionRange 
--- The [range](#Range) of this selection range.
---@field range LSP.Range
--- The parent selection range containing this range.
--- Therefore, `parent.range` must contain `this.range`.
---@field parent? LSP.SelectionRange


---@class LSP.DocumentSymbolClientCapabilities 
--- Whether document symbol supports dynamic registration.
---@field dynamicRegistration? boolean
--- Specific capabilities for the `SymbolKind` in the
--- `textDocument/documentSymbol` request.
---@field symbolKind? LSP.DocumentSymbolClientCapabilities.ValueSet
--- The client supports hierarchical document symbols.
---@field hierarchicalDocumentSymbolSupport? boolean
--- The client supports tags on `SymbolInformation`. Tags are supported on
--- `DocumentSymbol` if `hierarchicalDocumentSymbolSupport` is set to true.
--- Clients supporting tags have to handle unknown tags gracefully.
---
---@since 3.16.0
---@field tagSupport? { valueSet: LSP.SymbolTag[] }
--- The client supports an additional label presented in the UI when
--- registering a document symbol provider.
---
---@since 3.16.0
---@field labelSupport? boolean


---@class LSP.DocumentSymbolClientCapabilities.ValueSet
--- The symbol kind values the client supports. When this
--- property exists the client also guarantees that it will
--- handle values outside its set gracefully and falls back
--- to a default value when unknown.
---
--- If this property is not present the client only supports
--- the symbol kinds from `File` to `Array` as defined in
--- the initial version of the protocol.
---@field valueSet? LSP.SymbolKind[]


---@class LSP.DocumentSymbolOptions : LSP.WorkDoneProgressOptions 
--- A human-readable string that is shown when multiple outlines trees
--- are shown for the same document.
---
---@since 3.16.0
---@field label? string


---@class LSP.DocumentSymbolRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.DocumentSymbolOptions 


---@class LSP.DocumentSymbolParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier


---@enum LSP.SymbolKind
M.SymbolKind = {
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


---@enum LSP.SymbolTag
M.SymbolKind = {
    --- Render a symbol as obsolete, usually using a strike-out.
    Deprecated = 1,
}


--- Represents programming constructs like variables, classes, interfaces etc.
--- that appear in a document. Document symbols can be hierarchical and they
--- have two ---@field ranges one that encloses their definition and one that points to
--- their most interesting range, e.g. the range of an identifier.
---@class LSP.DocumentSymbol
--- The name of this symbol. Will be displayed in the user interface and
--- therefore must not be an empty string or a string only consisting of
--- white spaces.
---@field name string
--- More detail for this symbol, e.g. the signature of a function.
---@field detail? string
--- The kind of this symbol.
---@field kind LSP.SymbolKind
--- Tags for this document symbol.
---
---@since 3.16.0
---@field tags? LSP.SymbolTag[]
--- Indicates if this symbol is deprecated.
---
--- @deprecated Use tags instead
---@field deprecated? boolean
--- The range enclosing this symbol not including leading/trailing whitespace
--- but everything else, like comments. This information is typically used to
--- determine if the client's cursor is inside the symbol to reveal the
--- symbol in the UI.
---@field range LSP.Range
--- The range that should be selected and revealed when this symbol is being
--- picked, e.g. the name of a function. Must be contained by the `range`.
---@field selectionRange LSP.Range
--- Children of this symbol, e.g. properties of a class.
---@field children? LSP.DocumentSymbol[]


--- Represents information about programming constructs like variables, classes,
--- interfaces etc.
---
--- @deprecated use DocumentSymbol or WorkspaceSymbol instead.
---@class LSP.SymbolInformation
--- The name of this symbol.
---@field name string
--- The kind of this symbol.
---@field kind LSP.SymbolKind
--- Tags for this symbol.
---
---@since 3.16.0
---@field tags? LSP.SymbolTag[]
--- Indicates if this symbol is deprecated.
---
--- @deprecated Use tags instead
---@field deprecated? boolean
--- The location of this symbol. The location's range is used by a tool
--- to reveal the location in the editor. If the symbol is selected in the
--- tool the range's start information is used to position the cursor. So
--- the range usually spans more then the actual symbol's name and does
--- normally include things like visibility modifiers.
---
--- The range doesn't have to denote a node range in the sense of an abstract
--- syntax tree. It can therefore not be used to re-construct a hierarchy of
--- the symbols.
---@field location LSP.Location
--- The name of the symbol containing this symbol. This information is for
--- user interface purposes (e.g. to render a qualifier in the user interface
--- if necessary). It can't be used to re-infer a hierarchy for the document
--- symbols.
---@field containerName? string


---@enum LSP.SemanticTokenTypes
M.SemanticTokenTypes = {
    namespace = 'namespace',
	--- Represents a generic type. Acts as a fallback for types which
	--- can't be mapped to a specific type like class or enum.
	type = 'type',
	class = 'class',
	enum = 'enum',
	interface = 'interface',
	struct = 'struct',
	typeParameter = 'typeParameter',
	parameter = 'parameter',
	variable = 'variable',
	property = 'property',
	enumMember = 'enumMember',
	event = 'event',
	['function'] = 'function',
	method = 'method',
	macro = 'macro',
	keyword = 'keyword',
	modifier = 'modifier',
	comment = 'comment',
	string = 'string',
	number = 'number',
	regexp = 'regexp',
	operator = 'operator',
	---@since 3.17.0
	decorator = 'decorator'
}


---@enum LSP.SemanticTokenModifiers
M.SemanticTokenModifiers = {
	declaration = 'declaration',
	definition = 'definition',
	readonly = 'readonly',
	static = 'static',
	deprecated = 'deprecated',
	abstract = 'abstract',
	async = 'async',
	modification = 'modification',
	documentation = 'documentation',
	defaultLibrary = 'defaultLibrary'
}


---@enum LSP.TokenFormat
M.TokenFormat = {
    Relative = 'relative',
}


---@class LSP.SemanticTokensLegend
--- The token types a server uses.
---@field tokenTypes string[]
--- The token modifiers a server uses.
---@field tokenModifiers string[]


---@class LSP.SemanticTokensClientCapabilities
--- Whether the implementation supports dynamic registration. If this is set to
--- `true`, the client supports the new `(TextDocumentRegistrationOptions &
--- StaticRegistrationOptions)` return value for the corresponding server
--- capability as well.
---@field dynamicRegistration? boolean
--- Which requests the client supports and might send to the server
--- depending on the server's capability. Please note that clients might not
--- show semantic tokens or degrade some of the user experience if a range
--- or full request is advertised by the client but not provided by the
--- server. If, for example, the client capability `requests.full` and
--- `request.range` are both set to true but the server only provides a
--- range provider, the client might not render a minimap correctly or might
--- even decide to not show any semantic tokens at all.
---@field requests LSP.SemanticTokensClientCapabilities.Requests
--- The token types that the client supports.
---@field tokenTypes string[]
--- The token modifiers that the client supports.
---@field tokenModifiers string[]
--- The formats the client supports.
---@field formats LSP.TokenFormat[]
--- Whether the client supports tokens that can overlap each other.
---@field overlappingTokenSupport? boolean
--- Whether the client supports tokens that can span multiple lines.
---@field multilineTokenSupport? boolean
--- Whether the client allows the server to actively cancel a
--- semantic token request, e.g. supports returning
--- ErrorCodes.ServerCancelled. If a server does so, the client
--- needs to retrigger the request.
---
---@since 3.17.0
---@field serverCancelSupport? boolean
--- Whether the client uses semantic tokens to augment existing
--- syntax tokens. If set to `true`, client side created syntax
--- tokens and semantic tokens are both used for colorization. If
--- set to `false`, the client only uses the returned semantic tokens
--- for colorization.
---
--- If the value is `undefined` then the client behavior is not
--- specified.
---
---@since 3.17.0
---@field augmentsSyntaxTokens? boolean


---@class LSP.SemanticTokensClientCapabilities.Requests
--- The client will send the `textDocument/semanticTokens/range` request
--- if the server provides a corresponding handler.
---@field range? boolean | { }
--- The client will send the `textDocument/semanticTokens/full` request
--- if the server provides a corresponding handler.
---@field full? boolean | { delta?: boolean }


---@class LSP.SemanticTokensOptions : LSP.WorkDoneProgressOptions 
--- The legend used by the server.
---@field legend LSP.SemanticTokensLegend
--- Server supports providing semantic tokens for a specific range
--- of a document.
---@field range? boolean | { }
--- Server supports providing semantic tokens for a full document.
---@field full? boolean | { delta?: boolean}


---@class LSP.SemanticTokensRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.SemanticTokensOptions, LSP.StaticRegistrationOptions


---@class LSP.SemanticTokensParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier


---@class LSP.SemanticTokens
--- An optional result ID. If provided and clients support delta updating,
--- the client will include the result ID in the next semantic token request.
--- A server can then, instead of computing all semantic tokens again, simply
--- send a delta.
---@field resultId? string
--- The actual tokens.
---@field data uinteger[]


---@class LSP.SemanticTokensPartialResult
---@field data uinteger[]


---@class LSP.SemanticTokensDeltaParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier
--- The result ID of a previous response. The result ID can either point to
--- a full response or a delta response, depending on what was received last.
---@field previousResultId string


---@class LSP.SemanticTokensDelta
---@field resultId? string
--- The semantic token edits to transform a previous result into a new
--- result.
---@field edits LSP.SemanticTokensEdit[]


---@class LSP.SemanticTokensEdit
--- The start offset of the edit.
---@field start uinteger
--- The count of elements to remove.
---@field deleteCount uinteger
--- The elements to insert.
---@field data? uinteger[]


---@class LSP.SemanticTokensDeltaPartialResult
---@field edits LSP.SemanticTokensEdit[]


---@class LSP.SemanticTokensRangeParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier
--- The range the semantic tokens are requested for.
---@field range LSP.Range


---@class LSP.SemanticTokensWorkspaceClientCapabilities
--- Whether the client implementation supports a refresh request sent from
--- the server to the client.
---
--- Note that this event is global and will force the client to refresh all
--- semantic tokens currently shown. It should be used with absolute care
--- and is useful for situation where a server, for example, detects a project
--- wide change that requires such a calculation.
---@field refreshSupport? boolean


--- Inlay hint client capabilities.
---
---@since 3.17.0
---@class LSP.InlayHintClientCapabilities
--- Whether inlay hints support dynamic registration.
---@field dynamicRegistration? boolean
--- Indicates which properties a client can resolve lazily on an inlay
--- hint.
---@field resolveSupport? { properties: string[] }


--- Inlay hint options used during static registration.
---
---@since 3.17.0
---@class LSP.InlayHintOptions : LSP.WorkDoneProgressOptions
--- The server provides support to resolve additional
--- information for an inlay hint item.
---@field resolveProvider? boolean


--- Inlay hint options used during static or dynamic registration.
---
---@since 3.17.0
---@class LSP.InlayHintRegistrationOptions : LSP.InlayHintOptions, LSP.TextDocumentRegistrationOptions, LSP.StaticRegistrationOptions


--- A parameter literal used in inlay hint requests.
---
---@since 3.17.0
---@class LSP.InlayHintParams : LSP.WorkDoneProgressParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier
--- The visible document range for which inlay hints should be computed.
---@field range LSP.Range


--- Inlay hint information.
---
---@since 3.17.0
---@class LSP.InlayHint
--- The position of this hint.
---
--- If multiple hints have the same position, they will be shown in the order
--- they appear in the response.
---@field position LSP.Position
--- The label of this hint. A human readable string or an array of
--- InlayHintLabelPart label parts.
---
------Note--- that neither the string nor the label part can be empty.
---@field label string | LSP.InlayHintLabelPart[]
--- The kind of this hint. Can be omitted in which case the client
--- should fall back to a reasonable default.
---@field kind? LSP.InlayHintKind
--- Optional text edits that are performed when accepting this inlay hint.
---
------Note--- that edits are expected to change the document so that the inlay
--- hint (or its nearest variant) is now part of the document and the inlay
--- hint itself is now obsolete.
---
--- Depending on the client capability `inlayHint.resolveSupport`,
--- clients might resolve this property late using the resolve request.
---@field textEdits? LSP.TextEdit[]
--- The tooltip text when you hover over this item.
---
--- Depending on the client capability `inlayHint.resolveSupport` clients
--- might resolve this property late using the resolve request.
---@field tooltip? string | LSP.MarkupContent
--- Render padding before the hint.
---
--- ---@field Note Padding should use the editor's background color, not the
--- background color of the hint itself. That means padding can be used
--- to visually align/separate an inlay hint.
---@field paddingLeft? boolean
--- Render padding after the hint.
---
--- ---@field Note Padding should use the editor's background color, not the
--- background color of the hint itself. That means padding can be used
--- to visually align/separate an inlay hint.
---@field paddingRight? boolean
--- A data entry field that is preserved on an inlay hint between
--- a `textDocument/inlayHint` and an `inlayHint/resolve` request.
---@field data? LSP.Any


--- An inlay hint label part allows for interactive and composite labels
--- of inlay hints.
---
---@since 3.17.0
---@class LSP.InlayHintLabelPart
--- The value of this label part.
---@field value string
--- The tooltip text when you hover over this label part. Depending on
--- the client capability `inlayHint.resolveSupport`, clients might resolve
--- this property late using the resolve request.
---@field tooltip? string | LSP.MarkupContent
--- An optional source code location that represents this
--- label part.
---
--- The editor will use this location for the hover and for code navigation
--- ---@field features This part will become a clickable link that resolves to the
--- definition of the symbol at the given location (not necessarily the
--- location itself), it shows the hover that shows at the given location,
--- and it shows a context menu with further code navigation commands.
---
--- Depending on the client capability `inlayHint.resolveSupport` clients
--- might resolve this property late using the resolve request.
---@field location? LSP.Location
--- An optional command for this label part.
---
--- Depending on the client capability `inlayHint.resolveSupport`, clients
--- might resolve this property late using the resolve request.
---@field command? LSP.Command


---@enum LSP.InlayHintKind
M.InlayHintKind = {
    Type = 1,
    Parameter = 2,
}


--- Client workspace capabilities specific to inlay hints.
---
---@since 3.17.0
---@class LSP.InlayHintWorkspaceClientCapabilities
--- Whether the client implementation supports a refresh request sent from
--- the server to the client.
---
--- Note that this event is global and will force the client to refresh all
--- inlay hints currently shown. It should be used with absolute care and
--- is useful for situations where a server, for example, detects a project wide
--- change that requires such a calculation.
---@field refreshSupport? boolean


--- Client capabilities specific to inline values.
---
---@since 3.17.0
---@class LSP.InlineValueClientCapabilities
--- Whether the implementation supports dynamic registration for inline
--- value providers.
---@field dynamicRegistration? boolean


--- Inline value options used during static registration.
---
---@since 3.17.0
---@class LSP.InlineValueOptions : LSP.WorkDoneProgressOptions


--- Inline value options used during static or dynamic registration.
---
---@since 3.17.0
---@class LSP.InlineValueRegistrationOptions : LSP.InlineValueOptions, LSP.TextDocumentRegistrationOptions, LSP.StaticRegistrationOptions


--- A parameter literal used in inline value requests.
---
---@since 3.17.0
---@class LSP.InlineValueParams : LSP.WorkDoneProgressParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier
--- The document range for which inline values should be computed.
---@field range LSP.Range
--- Additional information about the context in which inline values were
--- requested.
---@field context LSP.InlineValueContext


---@since 3.17.0
---@class LSP.InlineValueContext
--- The stack frame (as a DAP ID) where the execution has stopped.
---@field frameId integer
--- The document range where execution has stopped.
--- Typically, the end position of the range denotes the line where the
--- inline values are shown.
---@field stoppedLocation LSP.Range


--- Provide inline value as text.
---
---@since 3.17.0
---@class LSP.InlineValueText
--- The document range for which the inline value applies.
---@field range LSP.Range
--- The text of the inline value.
---@field text string


--- Provide inline value through a variable lookup.
---
--- If only a range is specified, the variable name will be extracted from
--- the underlying document.
---
--- An optional variable name can be used to override the extracted name.
---
---@since 3.17.0
---@class LSP.InlineValueVariableLookup
--- The document range for which the inline value applies.
--- The range is used to extract the variable name from the underlying
--- document.
---@field range LSP.Range
--- If specified, the name of the variable to look up.
---@field variableName? string
--- How to perform the lookup.
---@field caseSensitiveLookup boolean


--- Provide an inline value through an expression evaluation.
---
--- If only a range is specified, the expression will be extracted from the
--- underlying document.
---
--- An optional expression can be used to override the extracted expression.
---
---@since 3.17.0
---@class LSP.InlineValueEvaluatableExpression
--- The document range for which the inline value applies.
--- The range is used to extract the evaluatable expression from the
--- underlying document.
---@field range LSP.Range
--- If specified the expression overrides the extracted expression.
---@field expression? string


--- Inline value information can be provided by different means:
--- - directly as a text value (class InlineValueText).
--- - as a name to use for a variable lookup (class InlineValueVariableLookup)
--- - as an evaluatable expression (class InlineValueEvaluatableExpression)
--- The InlineValue types combines all inline value types into one type.
---
---@since 3.17.0
---@alias LSP.InlineValue LSP.InlineValueText | LSP.InlineValueVariableLookup | LSP.InlineValueEvaluatableExpression


--- Client workspace capabilities specific to inline values.
---
---@since 3.17.0
---@class LSP.InlineValueWorkspaceClientCapabilities
--- Whether the client implementation supports a refresh request sent from
--- the server to the client.
---
--- Note that this event is global and will force the client to refresh all
--- inline values currently shown. It should be used with absolute care and
--- is useful for situations where a server, for example, detects a project
--- wide change that requires such a calculation.
---@field refreshSupport? boolean


---@class LSP.MonikerClientCapabilities
--- Whether implementation supports dynamic registration. If this is set to
--- `true`, the client supports the new `(TextDocumentRegistrationOptions &
--- StaticRegistrationOptions)` return value for the corresponding server
--- capability as well.
---@field dynamicRegistration? boolean


---@class LSP.MonikerOptions : LSP.WorkDoneProgressOptions 


---@class LSP.MonikerRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.MonikerOptions


---@class LSP.MonikerParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams, LSP.PartialResultParams


--- Moniker uniqueness level to define scope of the moniker.
---@enum LSP.UniquenessLevel
M.UniquenessLevel = {
    --- The moniker is only unique inside a document
    document = 'document',
    --- The moniker is unique inside a project for which a dump got created.
    project = 'project',
    --- The moniker is unique inside the group to which a project belongs.
    group = 'group',
    --- The moniker is unique inside the moniker scheme.
    scheme = 'scheme',
    --- The moniker is globally unique.
    ['global'] = 'global',
}


---@enum LSP.MonikerKind
M.MonikerKind = {
	--- The moniker represent a symbol that is imported into a project.
	import = 'import',

	--- The moniker represents a symbol that is exported from a project.
	export = 'export',

	--- The moniker represents a symbol that is local to a project (e.g. a local
	--- variable of a function, a class not visible outside the project, ...)
	['local'] = 'local'
}


--- Moniker definition to match LSIF 0.5 moniker definition.
---@class LSP.Moniker
--- The scheme of the moniker. For example, `tsc` or `.NET`.
---@field scheme string
--- The identifier of the moniker. The value is opaque in LSIF, however
--- schema owners are allowed to define the structure if they want.
---@field identifier string
--- The scope in which the moniker is unique.
---@field unique LSP.UniquenessLevel
--- The moniker kind if known.
---@field kind? LSP.MonikerKind


---@class LSP.CompletionClientCapabilities
--- Whether completion supports dynamic registration.
---@field dynamicRegistration? boolean
--- The client supports the following `CompletionItem` specific
--- capabilities.
---@field completionItem? LSP.CompletionClientCapabilities.CompletionItem
---@field completionItemKind? LSP.CompletionClientCapabilities.CompletionItemKind
--- The client supports sending additional context information for a
--- `textDocument/completion` request.
---@field contextSupport? boolean
--- The client's default when the completion item doesn't provide an
--- `insertTextMode` property.
---
---@since 3.17.0
---@field insertTextMode? LSP.InsertTextMode
--- The client supports the following `CompletionList` specific
--- capabilities.
---
---@since 3.17.0
---@field completionList? LSP.CompletionClientCapabilities.CompletionList


---@class LSP.CompletionClientCapabilities.CompletionItem
--- Client supports snippets as insert text.
---
--- A snippet can define tab stops and placeholders with `$1`, `$2`
--- and `$3:foo`. `$0` defines the final tab stop, it defaults to
--- the end of the snippet. Placeholders with equal identifiers are
--- linked, that is, typing in one will update others too.
---@field snippetSupport? boolean
--- Client supports commit characters on a completion item.
---@field commitCharactersSupport? boolean
--- Client supports these content formats for the documentation
--- property. The order describes the preferred format of the client.
---@field documentationFormat? LSP.MarkupKind[]
--- Client supports the deprecated property on a completion item.
---@field deprecatedSupport? boolean
--- Client supports the preselect property on a completion item.
---@field preselectSupport? boolean
--- Client supports the tag property on a completion item. Clients
--- supporting tags have to handle unknown tags gracefully. Clients
--- especially need to preserve unknown tags when sending a completion
--- item back to the server in a resolve call.
---
---@since 3.15.0
---@field tagSupport? { valueSet: LSP.CompletionItemTag[] }
--- Client supports insert replace edit to control different behavior if
--- a completion item is inserted in the text or should replace text.
---
---@since 3.16.0
---@field insertReplaceSupport? boolean
--- Indicates which properties a client can resolve lazily on a
--- completion item. Before version 3.16.0, only the predefined properties
--- `documentation` and `detail` could be resolved lazily.
---
---@since 3.16.0
---@field resolveSupport? { properties: string[] }
--- The client supports the `insertTextMode` property on
--- a completion item to override the whitespace handling mode
--- as defined by the client (see `insertTextMode`).
---
---@since 3.16.0
---@field insertTextModeSupport? { valueSet: LSP.InsertTextMode[] }
--- The client has support for completion item label
--- details (see also `CompletionItemLabelDetails`).
---
---@since 3.17.0
---@field labelDetailsSupport? boolean


---@class LSP.CompletionClientCapabilities.CompletionItemKind
--- The completion item kind values the client supports. When this
--- property exists, the client also guarantees that it will
--- handle values outside its set gracefully and falls back
--- to a default value when unknown.
---
--- If this property is not present, the client only supports
--- the completion item kinds from `Text` to `Reference` as defined in
--- the initial version of the protocol.
---@field valueSet? LSP.CompletionItemKind[]


---@class LSP.CompletionClientCapabilities.CompletionList
--- The client supports the following itemDefaults on
--- a completion list.
---
--- The value lists the supported property names of the
--- `CompletionList.itemDefaults` object. If omitted,
--- no properties are supported.
---
---@since 3.17.0
---@field itemDefaults? string[]
--- Specifies whether the client supports `CompletionList.applyKind` to
--- indicate how supported values from `completionList.itemDefaults`
--- and `completion` will be combined.
---
--- If a client supports `applyKind` it must support it for all fields
--- that it supports that are listed in `CompletionList.applyKind`. This
--- means when clients add support for new/future fields in completion
--- items the MUST also support merge for them if those fields are
--- defined in `CompletionList.applyKind`.
---
---@since 3.18.0
---@field applyKindSupport? boolean


--- Completion options.
---@class LSP.CompletionOptions : LSP.WorkDoneProgressOptions
--- Most tools trigger completion request automatically without explicitly
--- requesting it using a keyboard shortcut (e.g., Ctrl+Space). Typically they
--- do so when the user starts to type an identifier. For example, if the user
--- types `c` in a JavaScript file, code complete will automatically pop up and
--- present `console` besides others as a completion item. Characters that
--- make up identifiers don't need to be listed here.
---
--- If code complete should automatically be triggered on characters not being
--- valid inside an identifier (for example, `.` in JavaScript), list them in
--- `triggerCharacters`.
---@field triggerCharacters? string[]
--- The list of all possible characters that commit a completion. This field
--- can be used if clients don't support individual commit characters per
--- completion item. See client capability
--- `completion.completionItem.commitCharactersSupport`.
---
--- If a server provides both `allCommitCharacters` and commit characters on
--- an individual completion item, the ones on the completion item win.
---
---@since 3.2.0
---@field allCommitCharacters? string[]
--- The server provides support to resolve additional
--- information for a completion item.
---@field resolveProvider? boolean
--- The server supports the following `CompletionItem` specific
--- capabilities.
---
---@since 3.17.0
---@field completionItem? LSP.CompletionOptions.CompletionItem


---@class LSP.CompletionOptions.CompletionItem
--- The server has support for completion item label
--- details (see also `CompletionItemLabelDetails`) when receiving
--- a completion item in a resolve call.
---
---@since 3.17.0
---@field labelDetailsSupport? boolean


---@class LSP.CompletionRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.CompletionOptions 


---@class LSP.CompletionParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The completion context. This is only available if the client specifies
--- to send this using the client capability
--- `completion.contextSupport === true`
---@field context? LSP.CompletionContext


---@enum LSP.CompletionTriggerKind
M.CompletionTriggerKind = {
	--- Completion was triggered by typing an identifier (automatic code
	--- complete), manual invocation (e.g. Ctrl+Space) or via API.
	Invoked = 1,

	--- Completion was triggered by a trigger character specified by
	--- the `triggerCharacters` properties of the
	--- `CompletionRegistrationOptions`.
	TriggerCharacter = 2,

	--- Completion was re-triggered as the current completion list is incomplete.
	TriggerForIncompleteCompletions = 3,
}


--- Contains additional information about the context in which a completion
--- request is triggered.
---@class LSP.CompletionContext
--- How the completion was triggered.
---@field triggerKind LSP.CompletionTriggerKind
--- The trigger character (a single character) that
--- has triggered code complete. Is undefined if
--- `triggerKind !== CompletionTriggerKind.TriggerCharacter`
---@field triggerCharacter? string


--- Represents a collection of [completion items](#CompletionItem) to be
--- presented in the editor.
---@class LSP.CompletionList
--- This list is not complete. Further typing should result in recomputing
--- this list.
---
--- Recomputed lists have all their items replaced (not appended) in the
--- incomplete completion sessions.
---@field isIncomplete boolean
--- In many cases, the items of an actual completion result share the same
--- value for properties like `commitCharacters` or the range of a text
--- edit. A completion list can therefore define item defaults which will
--- be used if a completion item itself doesn't specify the value.
---
--- If a completion list specifies a default value and a completion item
--- also specifies a corresponding value, the rules for combining these are
--- defined by `applyKinds` (if the client supports it), defaulting to
--- ApplyKind.Replace.
---
--- Servers are only allowed to return default values if the client
--- signals support for this via the `completionList.itemDefaults`
--- capability.
---
---@since 3.17.0
---@field itemDefaults? LSP.CompletionList.ItemDefaults
--- Specifies how fields from a completion item should be combined with those
--- from `completionList.itemDefaults`.
---
--- If unspecified, all fields will be treated as ApplyKind.Replace.
---
--- If a field's value is ApplyKind.Replace, the value from a completion item
--- (if provided and not `nil`) will always be used instead of the value
--- from `completionItem.itemDefaults`.
---
--- If a field's value is ApplyKind.Merge, the values will be merged using
--- the rules defined against each field below.
---
--- Servers are only allowed to return `applyKind` if the client
--- signals support for this via the `completionList.applyKindSupport`
--- capability.
---
---@since 3.18.0
---@field applyKind? LSP.CompletionList.ApplyKind
--- The completion items.
---@field items LSP.CompletionItem[]


---@class LSP.CompletionList.ItemDefaults
--- A default commit character set.
---
---@since 3.17.0
---@field commitCharacters? string[]
--- A default edit range.
---
---@since 3.17.0
---@field editRange? LSP.Range | { insert: LSP.Range, replace: LSP.Range }
--- A default insert text format.
---
---@since 3.17.0
---@field insertTextFormat? LSP.InsertTextFormat
--- A default insert text mode.
---
---@since 3.17.0
---@field insertTextMode? LSP.InsertTextMode
--- A default data value.
---
---@since 3.17.0
---@field data? LSP.Any


---@class LSP.CompletionList.ApplyKind
--- Specifies whether commitCharacters on a completion will replace or be
--- merged with those in `completionList.itemDefaults.commitCharacters`.
---
--- If ApplyKind.Replace, the commit characters from the completion item
--- will always be used unless not provided, in which case those from
--- `completionList.itemDefaults.commitCharacters` will be used. An
--- empty list can be used if a completion item does not have any commit
--- characters and also should not use those from
--- `completionList.itemDefaults.commitCharacters`.
---
--- If ApplyKind.Merge the commitCharacters for the completion will be
--- the union of all values in both
--- `completionList.itemDefaults.commitCharacters` and the completion's
--- own `commitCharacters`.
---
---@since 3.18.0
---@field commitCharacters? LSP.ApplyKind
--- Specifies whether the `data` field on a completion will replace or
--- be merged with data from `completionList.itemDefaults.data`.
---
--- If ApplyKind.Replace, the data from the completion item will be used
--- if provided (and not `nil`), otherwise
--- `completionList.itemDefaults.data` will be used. An empty object can
--- be used if a completion item does not have any data but also should
--- not use the value from `completionList.itemDefaults.data`.
---
--- If ApplyKind.Merge, a shallow merge will be performed between
--- `completionList.itemDefaults.data` and the completion's own data
--- using the following rules:
---
--- - If a completion's `data` field is not provided (or `nil`), the
---   entire `data` field from `completionList.itemDefaults.data` will be
---   used as-is.
--- - If a completion's `data` field is provided, each field will
---   overwrite the field of the same name in
---   `completionList.itemDefaults.data` but no merging of nested fields
---   within that value will occur.
---
---@since 3.18.0
---@field data? LSP.ApplyKind


--- Defines whether the insert text in a completion item should be interpreted as
--- plain text or a snippet.
---@enum LSP.InsertTextFormat
M.InsertTextFormat = {
    --- The primary text to be inserted is treated as a plain string.
    PlainText = 1,
    --- The primary text to be inserted is treated as a snippet.
    ---
    --- A snippet can define tab stops and placeholders with `$1`, `$2`
    --- and `$3:foo`. `$0` defines the final tab stop, it defaults to
    --- the end of the snippet. Placeholders with equal identifiers are linked,
    --- that is, typing in one will update others too.
    Snippet = 2,
}


--- Completion item tags are extra annotations that tweak the rendering of a
--- completion item.
---
---@since 3.15.0
---@enum LSP.CompletionItemTag
M.CompletionItemTag = {
    --- Render a completion as obsolete, usually using a strike-out.
    Deprecated = 1,
}


--- A special text edit to provide an insert and a replace operation.
---
---@since 3.16.0
---@class LSP.InsertReplaceEdit
--- The string to be inserted.
---@field newText string
--- The range if the insert is requested.
---@field insert LSP.Range
--- The range if the replace is requested.
---@field replace LSP.Range


--- How whitespace and indentation is handled during completion
--- item insertion.
---
---@since 3.16.0
---@enum LSP.InsertTextMode
M.InsertTextMode = {
    --- The insertion or replace strings are taken as-is. If the
    --- value is multiline, the lines below the cursor will be
    --- inserted using the indentation defined in the string value.
    --- The client will not apply any kind of adjustments to the
    --- string.
    asIs = 1,
    --- The editor adjusts leading whitespace of new lines so that
    --- they match the indentation up to the cursor of the line for
    --- which the item is accepted.
    ---
    --- Consider a line like ---@field this <2tabs><cursor><3tabs>foo. Accepting a
    --- multi line completion item is indented using 2 tabs and all
    --- following lines inserted will be indented using 2 tabs as well.
    adjustIndentation = 2,
}


--- Additional details for a completion item label.
---
---@since 3.17.0
---@class LSP.CompletionItemLabelDetails
--- An optional string which is rendered less prominently directly after
--- @link CompletionItem.label label, without any spacing. Should be
--- used for function signatures or type annotations.
---@field detail? string
--- An optional string which is rendered less prominently after
--- @link CompletionItemLabelDetails.detail. Should be used for fully qualified
--- names or file paths.
---@field description? string


--- Defines how values from a set of defaults and an individual item will be
--- merged.
---
---@since 3.18.0
---@enum LSP.ApplyKind
M.ApplyKind = {
    --- The value from the individual item (if provided and not `nil`) will be
    --- used instead of the default.
    Replace = 1,
    --- The value from the item will be merged with the default.
    ---
    --- The specific rules for mergeing values are defined against each field
    --- that supports merging.
    Merge = 2,
}


---@class LSP.CompletionItem
--- The label of this completion item.
---
--- The label property is also by default the text that
--- is inserted when selecting this completion.
---
--- If label details are provided, the label itself should
--- be an unqualified name of the completion item.
---@field label string
--- Additional details for the label.
---
---@since 3.17.0
---@field labelDetails? LSP.CompletionItemLabelDetails
--- The kind of this completion item. Based on the kind,
--- an icon is chosen by the editor. The standardized set
--- of available values is defined in `CompletionItemKind`.
---@field kind? LSP.CompletionItemKind
--- Tags for this completion item.
---
---@since 3.15.0
---@field tags? LSP.CompletionItemTag[]
--- A human-readable string with additional information
--- about this item, like type or symbol information.
---@field detail? string
--- A human-readable string that represents a doc-comment.
---@field documentation? string | LSP.MarkupContent
--- Indicates if this item is deprecated.
---
--- @deprecated Use `tags` instead if supported.
---@field deprecated? boolean
--- Select this item when showing.
---
--- *Note* that only one completion item can be selected and that the
--- tool / client decides which item that is. The rule is that the---first---
--- item of those that match best is selected.
---@field preselect? boolean
--- A string that should be used when comparing this item
--- with other items. When omitted, the label is used
--- as the sort text for this item.
---@field sortText? string
--- A string that should be used when filtering a set of
--- completion items. When omitted, the label is used as the
--- filter text for this item.
---@field filterText? string
--- A string that should be inserted into a document when selecting
--- this completion. When omitted, the label is used as the insert text
--- for this item.
---
--- The `insertText` is subject to interpretation by the client side.
--- Some tools might not take the string literally. For example,
--- when code complete is requested for `con<cursor position>`
--- and a completion item with an `insertText` of `console` is provided,
--- VSCode will only insert `sole`. Therefore, it is
--- recommended to use `textEdit` instead since it avoids additional client
--- side interpretation.
---@field insertText? string
--- The format of the insert text. The format applies to both the
--- `insertText` property and the `newText` property of a provided
--- `textEdit`. If omitted, defaults to `InsertTextFormat.PlainText`.
---
--- Please note that the insertTextFormat doesn't apply to
--- `additionalTextEdits`.
---@field insertTextFormat? LSP.InsertTextFormat
--- How whitespace and indentation is handled during completion
--- item insertion. If not provided, the client's default value depends on
--- the `textDocument.completion.insertTextMode` client capability.
---
---@since 3.16.0
---@since 3.17.0 - support for `textDocument.completion.insertTextMode`
---@field insertTextMode? LSP.InsertTextMode
--- An edit which is applied to a document when selecting this completion.
--- When an edit is provided, the value of `insertText` is ignored.
---
--- *Note:* The range of the edit must be a single line range and it must
--- contain the position at which completion has been requested. Despite this
--- limitation, your edit can write multiple lines.
---
--- Most editors support two different operations when accepting a completion
--- item. One is to insert a completion text and the other is to replace an
--- existing text with a completion text. Since this can usually not be
--- predetermined by a server it can report both ranges. Clients need to
--- signal support for `InsertReplaceEdit`s via the
--- `textDocument.completion.completionItem.insertReplaceSupport` client
--- capability property.
---
--- *Note 1:* The text edit's range as well as both ranges from an insert
--- replace edit must be a single line and they must contain the position
--- at which completion has been requested. In both cases, the new text can
--- consist of multiple lines.
--- *Note 2:* If an `InsertReplaceEdit` is returned, the edit's insert range
--- must be a prefix of the edit's replace range, meaning it must be
--- contained in and starting at the same position.
---
---@since 3.16.0 additional type `InsertReplaceEdit`
---@field textEdit? LSP.TextEdit | LSP.InsertReplaceEdit
--- The edit text used if the completion item is part of a CompletionList and
--- CompletionList defines an item default for the text edit range.
---
--- Clients will only honor this property if they opt into completion list
--- item defaults using the capability `completionList.itemDefaults`.
---
--- If not provided and a list's default range is provided, the label
--- property is used as a text.
---
---@since 3.17.0
---@field textEditText? string
--- An optional array of additional text edits that are applied when
--- selecting this completion. Edits must not overlap (including the same
--- insert position) with the main edit nor with themselves.
---
--- Additional text edits should be used to change text unrelated to the
--- current cursor position (for example adding an import statement at the
--- top of the file if the completion item will insert an unqualified type).
---@field additionalTextEdits? LSP.TextEdit[]
--- An optional set of characters that, when pressed while this completion is
--- active, will accept it first and then type that character.---Note--- that all
--- commit characters should have `length=1` and that superfluous characters
--- will be ignored.
---@field commitCharacters? string[]
--- An optional command that is executed---after--- inserting this completion.
------Note--- that additional modifications to the current document should be
--- described with the additionalTextEdits-property.
---@field command? LSP.Command
--- A data entry field that is preserved on a completion item between
--- a completion and a completion resolve request.
---@field data? LSP.Any


--- The kind of a completion entry.
---@enum LSP.CompletionItemKind
M.CompletionItemKind = {
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


---@class LSP.PublishDiagnosticsClientCapabilities
--- Whether the clients accepts diagnostics with related information.
---@field relatedInformation? boolean
--- Client supports the tag property to provide meta data about a diagnostic.
--- Clients supporting tags have to handle unknown tags gracefully.
---
---@since 3.15.0
---@field tagSupport? { valueSet: LSP.DiagnosticTag[] }
--- Whether the client interprets the version property of the
--- `textDocument/publishDiagnostics` notification's parameter.
---
---@since 3.15.0
---@field versionSupport? boolean
--- Client supports a codeDescription property.
---
---@since 3.16.0
---@field codeDescriptionSupport? boolean
--- Whether code action supports the `data` property which is
--- preserved between a `textDocument/publishDiagnostics` and
--- `textDocument/codeAction` request.
---
---@since 3.16.0
---@field dataSupport? boolean


---@class LSP.PublishDiagnosticsParams
--- The URI for which diagnostic information is reported.
---@field uri LSP.DocumentUri
--- Optionally, the version number of the document the diagnostics are
--- published for.
---
---@since 3.15.0
---@field version? integer
--- An array of diagnostic information items.
---@field diagnostics LSP.Diagnostic[]


--- Client capabilities specific to diagnostic pull requests.
---
---@since 3.17.0
---@class LSP.DiagnosticClientCapabilities
--- Whether implementation supports dynamic registration. If this is set to
--- `true`, the client supports the new
--- `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- Whether the clients supports related documents for document diagnostic
--- pulls.
---@field relatedDocumentSupport? boolean
--- Whether the client supports `MarkupContent` in diagnostic messages.
---
---@since 3.18.0
---@proposed
---@field markupMessageSupport? boolean


--- Diagnostic options.
---
---@since 3.17.0
---@class LSP.DiagnosticOptions : LSP.WorkDoneProgressOptions
--- An optional identifier under which the diagnostics are
--- managed by the client.
---@field identifier? string
--- Whether the language has inter file dependencies, meaning that
--- editing code in one file can result in a different diagnostic
--- set in another file. Inter file dependencies are common for
--- most programming languages and typically uncommon for linters.
---@field interFileDependencies boolean
--- The server provides support for workspace diagnostics as well.
---@field workspaceDiagnostics boolean


--- Diagnostic registration options.
---
---@since 3.17.0
---@class LSP.DiagnosticRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.DiagnosticOptions, LSP.StaticRegistrationOptions


--- Parameters of the document diagnostic request.
---
---@since 3.17.0
---@class LSP.DocumentDiagnosticParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier
--- The additional identifier  provided during registration.
---@field identifier? string
--- The result ID of a previous response, if provided.
---@field previousResultId? string


--- The result of a document diagnostic pull request. A report can
--- either be a full report, containing all diagnostics for the
--- requested document, or an unchanged report, indicating that nothing
--- has changed in terms of diagnostics in comparison to the last
--- pull request.
---
---@since 3.17.0
---@alias LSP.DocumentDiagnosticReport LSP.RelatedFullDocumentDiagnosticReport | LSP.RelatedUnchangedDocumentDiagnosticReport


--- The document diagnostic report kinds.
---
---@since 3.17.0
---@enum LSP.DocumentDiagnosticReportKind
M.DocumentDiagnosticReportKind = {
    --- A diagnostic report with a full
    --- set of problems.
    Full = 'full',
    --- A report indicating that the last
    --- returned report is still accurate.
    Unchanged = 'unchanged',
}


--- A diagnostic report with a full set of problems.
---
---@since 3.17.0
---@class LSP.FullDocumentDiagnosticReport
--- A full document diagnostic report.
---@field kind LSP.DocumentDiagnosticReportKind.Full
--- An optional result ID. If provided, it will
--- be sent on the next diagnostic request for the
--- same document.
---@field resultId? string
--- The actual items.
---@field items LSP.Diagnostic[]


--- A diagnostic report indicating that the last returned
--- report is still accurate.
---
---@since 3.17.0
---@class LSP.UnchangedDocumentDiagnosticReport
--- A document diagnostic report indicating
--- no changes to the last result. A server can
--- only return `unchanged` if result IDs are
--- provided.
---@field kind LSP.DocumentDiagnosticReportKind.Unchanged
--- A result ID which will be sent on the next
--- diagnostic request for the same document.
---@field resultId string


--- A full diagnostic report with a set of related documents.
---
---@since 3.17.0
---@class LSP.RelatedFullDocumentDiagnosticReport : LSP.FullDocumentDiagnosticReport
--- Diagnostics of related documents. This information is useful
--- in programming languages where code in a file A can generate
--- diagnostics in a file B which A depends on. An example of
--- such a language is C/C++, where macro definitions in a file
--- a.cpp can result in errors in a header file b.hpp.
---
---@since 3.17.0
---@field relatedDocuments? { [string]: LSP.FullDocumentDiagnosticReport | LSP.UnchangedDocumentDiagnosticReport }


--- An unchanged diagnostic report with a set of related documents.
---
---@since 3.17.0
---@class LSP.RelatedUnchangedDocumentDiagnosticReport : LSP.UnchangedDocumentDiagnosticReport
--- Diagnostics of related documents. This information is useful
--- in programming languages where code in a file A can generate
--- diagnostics in a file B which A depends on. An example of
--- such a language is C/C++, where macro definitions in a file
--- a.cpp can result in errors in a header file b.hpp.
---
---@since 3.17.0
---@field relatedDocuments? { [string]: LSP.FullDocumentDiagnosticReport | LSP.UnchangedDocumentDiagnosticReport }


--- A partial result for a document diagnostic report.
---
---@since 3.17.0
---@class LSP.DocumentDiagnosticReportPartialResult
---@field relatedDocuments { [string]: LSP.FullDocumentDiagnosticReport | LSP.UnchangedDocumentDiagnosticReport }


--- Cancellation data returned from a diagnostic request.
---
---@since 3.17.0
---@class LSP.DiagnosticServerCancellationData
---@field retriggerRequest boolean


--- Parameters of the workspace diagnostic request.
---
---@since 3.17.0
---@class LSP.WorkspaceDiagnosticParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The additional identifier provided during registration.
---@field identifier? string
--- The currently known diagnostic reports with their
--- previous result IDs.
---@field previousResultIds LSP.PreviousResultId[]


--- A previous result ID in a workspace pull request.
---
---@since 3.17.0
---@class LSP.PreviousResultId
--- The URI for which the client knows a
--- result ID.
---@field uri LSP.DocumentUri
--- The value of the previous result ID.
---@field value string


--- A workspace diagnostic report.
---
---@since 3.17.0
---@class LSP.WorkspaceDiagnosticReport
---@field items LSP.WorkspaceDocumentDiagnosticReport[]


--- A full document diagnostic report for a workspace diagnostic result.
---
---@since 3.17.0
---@class LSP.WorkspaceFullDocumentDiagnosticReport : LSP.FullDocumentDiagnosticReport
--- The URI for which diagnostic information is reported.
---@field uri LSP.DocumentUri
--- The version number for which the diagnostics are reported.
--- If the document is not marked as open, `nil` can be provided.
---@field version integer | nil


--- An unchanged document diagnostic report for a workspace diagnostic result.
---
---@since 3.17.0
---@class LSP.WorkspaceUnchangedDocumentDiagnosticReport : LSP.UnchangedDocumentDiagnosticReport
--- The URI for which diagnostic information is reported.
---@field uri LSP.DocumentUri
--- The version number for which the diagnostics are reported.
--- If the document is not marked as open, `nil` can be provided.
---@field version integer | nil


--- A workspace diagnostic document report.
---
---@since 3.17.0
---@alias LSP.WorkspaceDocumentDiagnosticReport LSP.WorkspaceFullDocumentDiagnosticReport | LSP.WorkspaceUnchangedDocumentDiagnosticReport


--- A partial result for a workspace diagnostic report.
---
---@since 3.17.0
---@class LSP.WorkspaceDiagnosticReportPartialResult
---@field items LSP.WorkspaceDocumentDiagnosticReport[]


--- Workspace client capabilities specific to diagnostic pull requests.
---
---@since 3.17.0
---@class LSP.DiagnosticWorkspaceClientCapabilities
--- Whether the client implementation supports a refresh request sent from
--- the server to the client.
---
--- Note that this event is global and will force the client to refresh all
--- pulled diagnostics currently shown. It should be used with absolute care
--- and is useful for situation where a server, for example, detects a project
--- wide change that requires such a calculation.
---@field refreshSupport? boolean


---@class LSP.SignatureHelpClientCapabilities
--- Whether signature help supports dynamic registration.
---@field dynamicRegistration? boolean
--- The client supports the following `SignatureInformation`
--- specific properties.
---@field signatureInformation? LSP.SignatureHelpClientCapabilities.SignatureInformation
--- The client supports sending additional context information for a
--- `textDocument/signatureHelp` request. A client that opts into
--- contextSupport will also support the `retriggerCharacters` on
--- `SignatureHelpOptions`.
---
---@since 3.15.0
---@field contextSupport? boolean


---@class LSP.SignatureHelpClientCapabilities.SignatureInformation
--- Client supports the following content formats for the documentation
--- property. The order describes the preferred format of the client.
---@field documentationFormat? LSP.MarkupKind[]
--- Client capabilities specific to parameter information.
---@field parameterInformation? { labelOffsetSupport?: boolean }
--- The client supports the `activeParameter` property on
--- `SignatureInformation` literal.
---
---@since 3.16.0
---@field activeParameterSupport? boolean
--- The client supports the `activeParameter` property on
--- `SignatureHelp`/`SignatureInformation` being set to `nil` to
--- indicate that no parameter should be active.
---
---@since 3.18.0
---@field noActiveParameterSupport? boolean


---@class LSP.SignatureHelpOptions : LSP.WorkDoneProgressOptions 
--- The characters that trigger signature help
--- automatically.
---@field triggerCharacters? string[]
--- List of characters that re-trigger signature help.
---
--- These trigger characters are only active when signature help is already
--- showing. All trigger characters are also counted as re-trigger
--- characters.
---
---@since 3.15.0
---@field retriggerCharacters? string[]


---@class LSP.SignatureHelpRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.SignatureHelpOptions 


---@class LSP.SignatureHelpParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams
--- The signature help context. This is only available if the client
--- specifies to send this using the client capability
--- `textDocument.signatureHelp.contextSupport === true`
---
---@since 3.15.0
---@field context? LSP.SignatureHelpContext


--- How a signature help was triggered.
---
---@since 3.15.0
---@enum LSP.SignatureHelpTriggerKind
M.SignatureHelpTriggerKind = {
    --- Signature help was invoked manually by the user or by a command.
    Invoked = 1,
    --- Signature help was triggered by a trigger character.
    TriggerCharacter = 2,
    --- Signature help was triggered by the cursor moving or by the document
    --- content changing.
    ContentChange = 3,
}


--- Additional information about the context in which a signature help request
--- was triggered.
---
---@since 3.15.0
---@class LSP.SignatureHelpContext
--- Action that caused signature help to be triggered.
---@field triggerKind LSP.SignatureHelpTriggerKind
--- Character that caused signature help to be triggered.
---
--- This is undefined when triggerKind !==
--- SignatureHelpTriggerKind.TriggerCharacter
---@field triggerCharacter? string
--- `true` if signature help was already showing when it was triggered.
---
--- Retriggers occur when the signature help is already active and can be
--- caused by actions such as typing a trigger character, a cursor move, or
--- document content changes.
---@field isRetrigger boolean
--- The currently active `SignatureHelp`.
---
--- The `activeSignatureHelp` has its `SignatureHelp.activeSignature` field
--- updated based on the user navigating through available signatures.
---@field activeSignatureHelp? LSP.SignatureHelp


--- Signature help represents the signature of something
--- callable. There can be multiple signatures,
--- but only one active one and only one active parameter.
---@class LSP.SignatureHelp
--- One or more signatures. If no signatures are available,
--- the signature help request should return `nil`.
---@field signatures LSP.SignatureInformation[]
--- The active signature. If omitted or the value lies outside the
--- range of `signatures`, the value defaults to zero or is ignored if
--- the `SignatureHelp` has no signatures.
---
--- Whenever possible, implementers should make an active decision about
--- the active signature and shouldn't rely on a default value.
---
--- In future versions of the protocol, this property might become
--- mandatory to better express this.
---@field activeSignature? uinteger
--- The active parameter of the active signature.
---
--- If `nil`, no parameter of the signature is active (for example, a named
--- argument that does not match any declared parameters). This is only valid
--- since 3.18.0 and if the client specifies the client capability
--- `textDocument.signatureHelp.noActiveParameterSupport === true`.
---
--- If omitted or the value lies outside the range of
--- `signatures[activeSignature].parameters`, it defaults to 0 if the active
--- signature has parameters.
---
--- If the active signature has no parameters, it is ignored.
---
--- In future versions of the protocol this property might become
--- mandatory (but still nilable) to better express the active parameter if
--- the active signature does have any.
---@field activeParameter? uinteger | nil


--- Represents the signature of something callable. A signature
--- can have a label, like a function-name, a doc-comment, and
--- a set of parameters.
---@class LSP.SignatureInformation
--- The label of this signature. Will be shown in the UI.
---@field label string
--- The human-readable doc-comment of this signature.
--- Will be shown in the UI but can be omitted.
---@field documentation? string | LSP.MarkupContent
--- The parameters of this signature.
---@field parameters? LSP.ParameterInformation[]
--- The index of the active parameter.
---
--- If `nil`, no parameter of the signature is active (for example, a named
--- argument that does not match any declared parameters). This is only valid
--- since 3.18.0 and if the client specifies the client capability
--- `textDocument.signatureHelp.noActiveParameterSupport === true`.
---
--- If provided (or `nil`), this is used in place of
--- `SignatureHelp.activeParameter`.
---
---@since 3.16.0
---@field activeParameter? uinteger | nil


--- Represents a parameter of a callable-signature. A parameter can
--- have a label and a doc-comment.
---@class LSP.ParameterInformation
--- The label of this parameter information.
---
--- Either a string or an inclusive start and exclusive end offset within
--- its containing signature label (see SignatureInformation.label). The
--- offsets are based on a UTF-16 string representation, as `Position` and
--- `Range` do.
---
--- To avoid ambiguities, a server should use the [start, end] offset value
--- instead of using a substring. Whether a client support this is
--- controlled via `labelOffsetSupport` client capability.
---
---*Note*: a label of type string should be a substring of its containing
--- signature label. Its intended use case is to highlight the parameter
--- label part in the `SignatureInformation.label`.
---@field label string | [uinteger, uinteger]
--- The human-readable doc-comment of this parameter. Will be shown
--- in the UI but can be omitted.
---@field documentation? string | LSP.MarkupContent


---@class LSP.CodeActionClientCapabilities
--- Whether code action supports dynamic registration.
---@field dynamicRegistration? boolean
--- The client supports code action literals as a valid
--- response of the `textDocument/codeAction` request.
---
---@since 3.8.0
---@field codeActionLiteralSupport? { codeActionKind: { valueSet: LSP.CodeActionKind[] } }
--- Whether code action supports the `isPreferred` property.
---
---@since 3.15.0
---@field isPreferredSupport? boolean
--- Whether code action supports the `disabled` property.
---
---@since 3.16.0
---@field disabledSupport? boolean
--- Whether code action supports the `data` property which is
--- preserved between a `textDocument/codeAction` and a
--- `codeAction/resolve` request.
---
---@since 3.16.0
---@field dataSupport? boolean
--- Whether the client supports resolving additional code action
--- properties via a separate `codeAction/resolve` request.
---
---@since 3.16.0
---@field resolveSupport? { properties: string[] }
--- Whether the client honors the change annotations in
--- text edits and resource operations returned via the
--- `CodeAction#edit` property by, for example, presenting
--- the workspace edit in the user interface and asking
--- for confirmation.
---
---@since 3.16.0
---@field honorsChangeAnnotations? boolean
--- Whether the client supports documentation for a class of code actions.
---
---@since 3.18.0
---@proposed
---@field documentationSupport? boolean
--- Client supports the tag property on a code action. Clients
--- supporting tags have to handle unknown tags gracefully.
---
---@since 3.18.0 - proposed
---@field tagSupport? { valueSet: LSP.CodeActionTag[] }


--- Documentation for a class of code actions.
---
---@since 3.18.0
---@proposed
---@class LSP.CodeActionKindDocumentation
--- The kind of the code action being documented.
---
--- If the kind is generic, such as `CodeActionKind.Refactor`, the
--- documentation will be shown whenever any refactorings are returned. If
--- the kind is more specific, such as `CodeActionKind.RefactorExtract`, the
--- documentation will only be shown when extract refactoring code actions
--- are returned.
---@field kind LSP.CodeActionKind
--- Command that is used to display the documentation to the user.
---
--- The title of this documentation code action is taken
--- from {@linkcode Command.title}
---@field command LSP.Command


---@class LSP.CodeActionOptions : LSP.WorkDoneProgressOptions {
--- CodeActionKinds that this server may return.
---
--- The list of kinds may be generic, such as `CodeActionKind.Refactor`,
--- or the server may list out every specific kind they provide.
---@field codeActionKinds? LSP.CodeActionKind[]
--- Static documentation for a class of code actions.
---
--- Documentation from the provider should be shown in the code actions
--- menu if either:
---
--- - Code actions of `kind` are requested by the editor. In this case,
---   the editor will show the documentation that most closely matches the
---   requested code action kind. For example, if a provider has
---   documentation for both `Refactor` and `RefactorExtract`, when the
---   user requests code actions for `RefactorExtract`, the editor will use
---   the documentation for `RefactorExtract` instead of the documentation
---   for `Refactor`.
---
--- - Any code actions of `kind` are returned by the provider.
---
--- At most one documentation entry should be shown per provider.
---
---@since 3.18.0
---@proposed
---@field documentation? LSP.CodeActionKindDocumentation[]
--- The server provides support to resolve additional
--- information for a code action.
---
---@since 3.16.0
---@field resolveProvider? boolean


---@class LSP.CodeActionRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.CodeActionOptions


--- Params for the CodeActionRequest.
---@class LSP.CodeActionParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The document in which the command was invoked.
---@field textDocument LSP.TextDocumentIdentifier
--- The range for which the command was invoked.
---@field range LSP.Range
--- Context carrying additional information.
---@field context LSP.CodeActionContext


--- The kind of a code action.
---
--- Kinds are a hierarchical list of identifiers separated by `.`,
--- e.g. `"refactor.extract.function"`.
---
--- The set of kinds is open and the client needs to announce
--- the kinds it supports to the server during initialization.
--- A set of predefined code action kinds.
---@enum LSP.CodeActionKind
M.CodeActionKind = {
    --- Empty kind.
    Empty = '',
    --- Base kind for quickfix ---@field actions 'quickfix'.
    QuickFix = 'quickfix',
    --- Base kind for refactoring ---@field actions 'refactor'.
    Refactor = 'refactor',
    --- Base kind for refactoring extraction ---@field actions 'refactor.extract'.
    ---
    --- Example extract actions:
    ---
    --- - Extract method
    --- - Extract function
    --- - Extract variable
    --- - Extract interface from class
    --- - ...
    RefactorExtract = 'refactor.extract',
    --- Base kind for refactoring inline ---@field actions 'refactor.inline'.
    ---
    --- Example inline actions:
    ---
    --- - Inline function
    --- - Inline variable
    --- - Inline constant
    --- - ...
    RefactorInline = 'refactor.inline',
    --- Base kind for refactoring move ---@field actions 'refactor.move'
    ---
    --- Example move actions:
    ---
    --- - Move a function to a new file
    --- - Move a property between classes
    --- - Move method to base class
    --- - ...
    ---
    ---@since 3.18.0 - proposed
    RefactorMove = 'refactor.move',
    --- Base kind for refactoring rewrite ---@field actions 'refactor.rewrite'.
    ---
    --- Example rewrite actions:
    ---
    --- - Convert JavaScript function to class
    --- - Add or remove parameter
    --- - Encapsulate field
    --- - Make method static
    --- - ...
    RefactorRewrite = 'refactor.rewrite',
    --- Base kind for source ---@field actions `source`.
    ---
    --- Source code actions apply to the entire file.
    Source = 'source',
    --- Base kind for an organize imports source action:
    --- `source.organizeImports`.
    SourceOrganizeImports = 'source.organizeImports',
    --- Base kind for a 'fix all' source ---@field action `source.fixAll`.
    ---
    --- 'Fix all' actions automatically fix errors that have a clear fix that
    --- do not require user input. They should not suppress errors or perform
    --- unsafe fixes such as generating new types or classes.
    ---
    ---@since 3.17.0
    SourceFixAll = 'source.fixAll',
    --- Base kind for all code actions applying to the entire notebook's scope. CodeActionKinds using
    --- this should always begin with `notebook.`
    ---
    ---@since 3.18.0
    Notebook = 'notebook',
}


--- Contains additional diagnostic information about the context in which
--- a code action is run.
---@class LSP.CodeActionContext
--- An array of diagnostics known on the client side overlapping the range
--- provided to the `textDocument/codeAction` request. They are provided so
--- that the server knows which errors are currently presented to the user
--- for the given range. There is no guarantee that these accurately reflect
--- the error state of the resource. The primary parameter
--- to compute code actions is the provided range.
---
--- Note that the client should check the `textDocument.diagnostic.markupMessageSupport`
--- server capability before sending diagnostics with markup messages to a server.
--- Diagnostics with markup messages should be excluded for servers that don't support
--- them.
---@field diagnostics LSP.Diagnostic[]
--- Requested kind of actions to return.
---
--- Actions not of this kind are filtered out by the client before being
--- shown, so servers can omit computing them.
---@field only? LSP.CodeActionKind[]
--- The reason why code actions were requested.
---
---@since 3.17.0
---@field triggerKind? LSP.CodeActionTriggerKind


--- The reason why code actions were requested.
---
---@since 3.17.0
---@enum LSP.CodeActionTriggerKind
M.CodeActionTriggerKind = {
    --- Code actions were explicitly requested by the user or by an extension.
    Invoked = 1,
    --- Code actions were requested automatically.
    ---
    --- This typically happens when the current selection in a file changes,
    --- but can also be triggered when file content changes.
    Automatic = 2,
}


--- Code action tags are extra annotations that tweak the behavior of a code action.
---
---@since 3.18.0 - proposed
---@enum LSP.CodeActionTag
M.CodeActionTag = {
    --- Marks the code action as LLM-generated.
    LLMGenerated = 1,
}


--- A code action represents a change that can be performed in code, e.g. to fix
--- a problem or to refactor code.
---
--- A CodeAction must set either `edit` and/or a `command`. If both are supplied,
--- the `edit` is applied first, then the `command` is executed.
---@class LSP.CodeAction
--- A short, human-readable title for this code action.
---@field title string
--- The kind of the code action.
---
--- Used to filter code actions.
---@field kind? LSP.CodeActionKind
--- The diagnostics that this code action resolves.
---@field diagnostics? LSP.Diagnostic[]
--- Marks this as a preferred action. Preferred actions are used by the
--- `auto fix` command and can be targeted by keybindings.
---
--- A quick fix should be marked preferred if it properly addresses the
--- underlying error. A refactoring should be marked preferred if it is the
--- most reasonable choice of actions to take.
---
---@since 3.15.0
---@field isPreferred? boolean
--- Marks that the code action cannot currently be applied.
---
--- Clients should follow the following guidelines regarding disabled code
--- actions:
---
--- - Disabled code actions are not shown in automatic lightbulbs code
---   action menus.
---
--- - Disabled actions are shown as faded out in the code action menu when
---   the user request a more specific type of code action, such as
---   refactorings.
---
--- - If the user has a keybinding that auto applies a code action and only
---   a disabled code actions are returned, the client should show the user
---   an error message with `reason` in the editor.
---
---@since 3.16.0
---@field disabled? { reason: string }
--- The workspace edit this code action performs.
---@field edit? LSP.WorkspaceEdit
--- A command this code action executes. If a code action
--- provides an edit and a command, first the edit is
--- executed and then the command.
---@field command? LSP.Command
--- A data entry field that is preserved on a code action between
--- a `textDocument/codeAction` and a `codeAction/resolve` request.
---
---@since 3.16.0
---@field data? LSP.Any
--- Tags for this code action.
---
---@since 3.18.0 - proposed
---@field tags? LSP.CodeActionTag[]


---@class LSP.DocumentColorClientCapabilities
--- Whether document color supports dynamic registration.
---@field dynamicRegistration? boolean


---@class LSP.DocumentColorOptions : LSP.WorkDoneProgressOptions 


---@class LSP.DocumentColorRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.StaticRegistrationOptions, LSP.DocumentColorOptions


---@class LSP.DocumentColorParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier


---@class LSP.ColorInformation
--- The range in the document where this color appears.
---@field range LSP.Range
--- The actual color value for this color range.
---@field color LSP.Color


--- Represents a color in RGBA space.
---@class LSP.Color
--- The red component of this color in the range [0-1].
---@field red decimal
--- The green component of this color in the range [0-1].
---@field green decimal
--- The blue component of this color in the range [0-1].
---@field blue decimal
--- The alpha component of this color in the range [0-1].
---@field alpha decimal


---@class LSP.ColorPresentationParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- The text document.
---@field textDocument LSP.TextDocumentIdentifier
--- The color information to request presentations for.
---@field color LSP.Color
--- The range where the color would be inserted. Serves as a context.
---@field range LSP.Range


---@class LSP.ColorPresentation
--- The label of this color presentation. It will be shown on the color
--- picker header. By default, this is also the text that is inserted when
--- selecting this color presentation.
---@field label string
--- An [edit](#TextEdit) which is applied to a document when selecting
--- this presentation for the color. When omitted, the
--- [label](#ColorPresentation.label) is used.
---@field textEdit? LSP.TextEdit
--- An optional array of additional [text edits](#TextEdit) that are applied
--- when selecting this color presentation. Edits must not overlap with the
--- main [edit](#ColorPresentation.textEdit) nor with themselves.
---@field additionalTextEdits? LSP.TextEdit[]


---@class LSP.DocumentFormattingClientCapabilities
--- Whether formatting supports dynamic registration.
---@field dynamicRegistration? boolean


---@class LSP.DocumentFormattingOptions : LSP.WorkDoneProgressOptions 


---@class LSP.DocumentFormattingRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.DocumentFormattingOptions


---@class LSP.DocumentFormattingParams : LSP.WorkDoneProgressParams 
--- The document to format.
---@field textDocument LSP.TextDocumentIdentifier
--- The formatting options.
---@field options LSP.FormattingOptions


--- Value-object describing what options formatting should use.
---@class LSP.FormattingOptions
--- Size of a tab in spaces.
---@field tabSize uinteger
--- Prefer spaces over tabs.
---@field insertSpaces boolean
--- Trim trailing whitespace on a line.
---
---@since 3.15.0
---@field trimTrailingWhitespace? boolean
--- Insert a newline character at the end of the file if one does not exist.
---
---@since 3.15.0
---@field insertFinalNewline? boolean
--- Trim all newlines after the final newline at the end of the file.
---
---@since 3.15.0
---@field trimFinalNewlines? boolean
--- Signature for further properties.
---@field [string] boolean | integer | string


---@class LSP.DocumentRangeFormattingClientCapabilities
--- Whether formatting supports dynamic registration.
---@field dynamicRegistration? boolean
--- Whether the client supports formatting multiple ranges at once.
---
---@since 3.18.0
---@proposed
---@field rangesSupport? boolean


---@class LSP.DocumentRangeFormattingOptions : LSP.WorkDoneProgressOptions
--- Whether the server supports formatting multiple ranges at once.
---
---@since 3.18.0
---@proposed
---@field rangesSupport? boolean


---@class LSP.DocumentRangeFormattingRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.DocumentRangeFormattingOptions


---@class LSP.DocumentRangeFormattingParams : LSP.WorkDoneProgressParams 
--- The document to format.
---@field textDocument LSP.TextDocumentIdentifier
--- The range to format.
---@field range LSP.Range
--- The formatting options.
---@field options LSP.FormattingOptions


---@class LSP.DocumentRangesFormattingParams : LSP.WorkDoneProgressParams 
--- The document to format.
---@field textDocument LSP.TextDocumentIdentifier
--- The ranges to format.
---@field ranges LSP.Range[]
--- The format options.
---@field options LSP.FormattingOptions


---@class LSP.DocumentOnTypeFormattingClientCapabilities
--- Whether on type formatting supports dynamic registration.
---@field dynamicRegistration? boolean


---@class LSP.DocumentOnTypeFormattingOptions
--- A character on which formatting should be triggered, like ``.
---@field firstTriggerCharacter string
--- More trigger characters.
---@field moreTriggerCharacter? string[]


---@class LSP.DocumentOnTypeFormattingRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.DocumentOnTypeFormattingOptions


---@class LSP.DocumentOnTypeFormattingParams
--- The document to format.
---@field textDocument LSP.TextDocumentIdentifier
--- The position around which the on type formatting should happen.
--- This is not necessarily the exact position where the character denoted
--- by the property `ch` got typed.
---@field position LSP.Position
--- The character that has been typed that triggered the formatting
--- on type request. That is not necessarily the last character that
--- got inserted into the document since the client could auto insert
--- characters as well (e.g. automatic brace completion).
---@field ch string
--- The formatting options.
---@field options LSP.FormattingOptions


---@enum LSP.PrepareSupportDefaultBehavior
M.PrepareSupportDefaultBehavior = {
    --- The client's default behavior is to select the identifier
    --- according to the language's syntax rule.
    Identifier = 1,
}


---@class LSP.RenameClientCapabilities
--- Whether rename supports dynamic registration.
---@field dynamicRegistration? boolean
--- Client supports testing for validity of rename operations
--- before execution.
---
---@since version 3.12.0
---@field prepareSupport? boolean
--- Client supports the default behavior result
--- (` ---@field defaultBehavior boolean `).
---
--- The value indicates the default behavior used by the
--- client.
---
---@since version 3.16.0
---@field prepareSupportDefaultBehavior? LSP.PrepareSupportDefaultBehavior
--- Whether the client honors the change annotations in
--- text edits and resource operations returned via the
--- rename request's workspace edit by, for example, presenting
--- the workspace edit in the user interface and asking
--- for confirmation.
---
---@since 3.16.0
---@field honorsChangeAnnotations? boolean


---@class LSP.RenameOptions : LSP.WorkDoneProgressOptions 
--- Renames should be checked and tested before being executed.
---@field prepareProvider? boolean


---@class LSP.RenameRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.RenameOptions


---@class LSP.RenameParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams
--- The new name of the symbol. If the given name is not valid, the
--- request must return a [ResponseError](#ResponseError) with an
--- appropriate message set.
---@field newName string


---@class LSP.PrepareRenameParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams 


---@class LSP.LinkedEditingRangeClientCapabilities
--- Whether the implementation supports dynamic registration.
--- If this is set to `true` the client supports the new
--- `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean


---@class LSP.LinkedEditingRangeOptions : LSP.WorkDoneProgressOptions 


---@class LSP.LinkedEditingRangeRegistrationOptions : LSP.TextDocumentRegistrationOptions, LSP.LinkedEditingRangeOptions, LSP.StaticRegistrationOptions


---@class LSP.LinkedEditingRangeParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams


---@class LSP.LinkedEditingRanges
--- A list of ranges that can be renamed together. The ranges must have
--- identical length and contain identical text content. The ranges cannot
--- overlap.
---@field ranges LSP.Range[]
--- An optional word pattern (regular expression) that describes valid
--- contents for the given ranges. If no pattern is provided, the client
--- configuration's word pattern will be used.
---@field wordPattern? string


--- Client capabilities specific to inline completions.
---
---@since 3.18.0
---@class LSP.InlineCompletionClientCapabilities
--- Whether implementation supports dynamic registration for inline
--- completion providers.
---@field dynamicRegistration? boolean


--- Inline completion options used during static registration.
---
---@since 3.18.0
---@class LSP.InlineCompletionOptions : LSP.WorkDoneProgressOptions


--- Inline completion options used during static or dynamic registration.
---
---@since 3.18.0
---@class LSP.InlineCompletionRegistrationOptions : LSP.InlineCompletionOptions, LSP.TextDocumentRegistrationOptions, LSP.StaticRegistrationOptions


--- A parameter literal used in inline completion requests.
---
---@since 3.18.0
---@class LSP.InlineCompletionParams : LSP.TextDocumentPositionParams, LSP.WorkDoneProgressParams
--- Additional information about the context in which inline completions
--- were requested.
---@field context LSP.InlineCompletionContext


--- Provides information about the context in which an inline completion was
--- requested.
---
---@since 3.18.0
---@class LSP.InlineCompletionContext
--- Describes how the inline completion was triggered.
---@field triggerKind LSP.InlineCompletionTriggerKind
--- Provides information about the currently selected item in the
--- autocomplete widget if it is visible.
---
--- If set, provided inline completions must extend the text of the
--- selected item and use the same range, otherwise they are not shown as
--- preview.
--- As an example, if the document text is `console.` and the selected item
--- is `.log` replacing the `.` in the document, the inline completion must
--- also replace `.` and start with `.log`, for example `.log()`.
---
--- Inline completion providers are requested again whenever the selected
--- item changes.
---@field selectedCompletionInfo? LSP.SelectedCompletionInfo


--- Describes how an @link InlineCompletionItemProvider inline completion
--- provider was triggered.
---
---@since 3.18.0
---@enum LSP.InlineCompletionTriggerKind
M.InlineCompletionTriggerKind = {
    --- Completion was triggered explicitly by a user gesture.
    --- Return multiple completion items to enable cycling through them.
    Invoked = 1,
    --- Completion was triggered automatically while editing.
    --- It is sufficient to return a single completion item in this case.
    Automatic = 2,
}


--- Describes the currently selected completion item.
---
---@since 3.18.0
---@class LSP.SelectedCompletionInfo
--- The range that will be replaced if this completion item is accepted.
---@field range LSP.Range
--- The text the range will be replaced with if this completion is
--- accepted.
---@field text string


--- Represents a collection of @link InlineCompletionItem inline completion
--- items to be presented in the editor.
---
---@since 3.18.0
---@class LSP.InlineCompletionList
--- The inline completion items.
---@field items LSP.InlineCompletionItem[]


--- An inline completion item represents a text snippet that is proposed inline
--- to complete text that is being typed.
---
---@since 3.18.0
---@class LSP.InlineCompletionItem
--- The text to replace the range with. Must be set.
--- Is used both for the preview and the accept operation.
---@field insertText string | LSP.StringValue
--- A text that is used to decide if this inline completion should be
--- shown. When `falsy`, the @link InlineCompletionItem.insertText is
--- used.
---
--- An inline completion is shown if the text to replace is a prefix of the
--- filter text.
---@field filterText? string
--- The range to replace.
--- Must begin and end on the same line.
---
--- Prefer replacements over insertions to provide a better experience when
--- the user deletes typed text.
---@field range? LSP.Range
--- An optional @link Command that is executed*after* inserting this
--- completion.
---@field command? LSP.Command


---@class LSP.WorkspaceSymbolClientCapabilities
--- Symbol request supports dynamic registration.
---@field dynamicRegistration? boolean
--- Specific capabilities for the `SymbolKind` in the `workspace/symbol`
--- request.
---@field symbolKind? { valueSet?: LSP.SymbolKind[] }
--- The client supports tags on `SymbolInformation` and `WorkspaceSymbol`.
--- Clients supporting tags have to handle unknown tags gracefully.
---
---@since 3.16.0
---@field tagSupport? { valueSet: LSP.SymbolTag[] }
--- The client supports partial workspace symbols. The client will send the
--- request `workspaceSymbol/resolve` to the server to resolve additional
--- properties.
---
---@since 3.17.0 - proposedState
---@field resolveSupport? { properties: string[] }


---@class LSP.WorkspaceSymbolOptions : LSP.WorkDoneProgressOptions 
--- The server provides support to resolve additional
--- information for a workspace symbol.
---
---@since 3.17.0
---@field resolveProvider? boolean


---@class LSP.WorkspaceSymbolRegistrationOptions : LSP.WorkspaceSymbolOptions 


--- The parameters of a Workspace Symbol Request.
---@class LSP.WorkspaceSymbolParams : LSP.WorkDoneProgressParams, LSP.PartialResultParams
--- A query string to filter symbols by. Clients may send an empty
--- string here to request all symbols.
---
--- The `query`-parameter should be interpreted in a*relaxed way* as editors
--- will apply their own highlighting and scoring on the results. A good rule
--- of thumb is to match case-insensitive and to simply check that the
--- characters of*query* appear in their order in a candidate symbol.
--- Servers shouldn't use prefix, substring, or similar strict matching.
---@field query string


--- A special workspace symbol that supports locations without a range.
---
---@since 3.17.0
---@class LSP.WorkspaceSymbol
--- The name of this symbol.
---@field name string
--- The kind of this symbol.
---@field kind LSP.SymbolKind
--- Tags for this completion item.
---@field tags? LSP.SymbolTag[]
--- The name of the symbol containing this symbol. This information is for
--- user interface purposes (e.g. to render a qualifier in the user interface
--- if necessary). It can't be used to re-infer a hierarchy for the document
--- symbols.
---@field containerName? string
--- The location of this symbol. Whether a server is allowed to
--- return a location without a range depends on the client
--- capability `workspace.symbol.resolveSupport`.
---
--- See also `SymbolInformation.location`.
---@field location LSP.Location | { uri: LSP.DocumentUri }
--- A data entry field that is preserved on a workspace symbol between a
--- workspace symbol request and a workspace symbol resolve request.
---@field data? LSP.Any


---@class LSP.ConfigurationParams
---@field items LSP.ConfigurationItem[]


---@class LSP.ConfigurationItem
--- The scope to get the configuration section for.
---@field scopeUri? LSP.URI
--- The configuration section asked for.
---@field section? string


---@class LSP.DidChangeConfigurationClientCapabilities
--- Did change configuration notification supports dynamic registration.
---
---@since 3.6.0 to support the new pull model.
---@field dynamicRegistration? boolean


---@class LSP.DidChangeConfigurationParams
--- The actual changed settings.
---@field settings LSP.Any


---@class LSP.WorkspaceFoldersServerCapabilities
--- The server has support for workspace folders.
---@field supported? boolean
--- Whether the server wants to receive workspace folder
--- change notifications.
---
--- If a string is provided, the string is treated as an ID
--- under which the notification is registered on the client
--- side. The ID can be used to unregister for these events
--- using the `client/unregisterCapability` request.
---@field changeNotifications? string | boolean


---@class LSP.WorkspaceFolder
--- The associated URI for this workspace folder.
---@field uri LSP.URI
--- The name of the workspace folder. Used to refer to this
--- workspace folder in the user interface.
---@field name string


---@class LSP.DidChangeWorkspaceFoldersParams
--- The actual workspace folder change event.
---@field event LSP.WorkspaceFoldersChangeEvent


--- The workspace folder change event.
---@class LSP.WorkspaceFoldersChangeEvent
--- The array of added workspace folders.
---@field added LSP.WorkspaceFolder[]
--- The array of removed workspace folders.
---@field removed LSP.WorkspaceFolder[]


--- The options to register for file operations.
---
---@since 3.16.0
---@class LSP.FileOperationRegistrationOptions
--- The actual filters.
---@field filters LSP.FileOperationFilter[]


--- A pattern kind describing if a glob pattern matches a file,
--- a folder, or both.
---
---@since 3.16.0
---@enum LSP.FileOperationPatternKind
M.FileOperationPatternKind = {
    --- The pattern matches a file only.
    file = 'file',
    --- The pattern matches a folder only.
    folder = 'folder',
}


--- Matching options for the file operation pattern.
---
---@since 3.16.0
---@class LSP.FileOperationPatternOptions
--- The pattern should be matched ignoring casing.
---@field ignoreCase? boolean


--- A pattern to describe in which file operation requests or notifications
--- the server is interested in.
---
---@since 3.16.0
---@class LSP.FileOperationPattern
--- The glob pattern to match. Glob patterns can have the following syntax:
--- - `*` to match one or more characters in a path segment
--- - `?` to match on one character in a path segment
--- - `**` to match any number of path segments, including none
--- - `` to group sub patterns into an OR expression. (e.g. `**鈥?*.ts,js`
---   matches all TypeScript and JavaScript files)
--- - `[]` to declare a range of characters to match in a path segment
---   (e.g., `example.[0-9]` to match on `example.0`, `example.1`, 鈥?
--- - `[!...]` to negate a range of characters to match in a path segment
---   (e.g., `example.[!0-9]` to match on `example.a`, `example.b`, but
---   not `example.0`)
---@field glob string
--- Whether to match files or folders with this pattern.
---
--- Matches both if undefined.
---@field matches? LSP.FileOperationPatternKind
--- Additional options used during matching.
---@field options? LSP.FileOperationPatternOptions


--- A filter to describe in which file operation requests or notifications
--- the server is interested in.
---
---@since 3.16.0
---@class LSP.FileOperationFilter
--- A URI scheme, like `file` or `untitled`.
---@field scheme? string
--- The actual file operation pattern.
---@field pattern LSP.FileOperationPattern


--- The parameters sent in notifications/requests for user-initiated creation
--- of files.
---
---@since 3.16.0
---@class LSP.CreateFilesParams
--- An array of all files/folders created in this operation.
---@field files LSP.FileCreate[]


--- Represents information on a file/folder create.
---
---@since 3.16.0
---@class LSP.FileCreate
--- A file:// URI for the location of the file/folder being created.
---@field uri string


--- The parameters sent in notifications/requests for user-initiated renames
--- of files.
---
---@since 3.16.0
---@class LSP.RenameFilesParams
--- An array of all files/folders renamed in this operation. When a folder
--- is renamed, only the folder will be included, and not its children.
---@field files LSP.FileRename[]


--- Represents information on a file/folder rename.
---
---@since 3.16.0
---@class LSP.FileRename
--- A file:// URI for the original location of the file/folder being renamed.
---@field oldUri string
--- A file:// URI for the new location of the file/folder being renamed.
---@field newUri string


--- The parameters sent in notifications/requests for user-initiated deletes
--- of files.
---
---@since 3.16.0
---@class LSP.DeleteFilesParams
--- An array of all files/folders deleted in this operation.
---@field files LSP.FileDelete[]


--- Represents information on a file/folder delete.
---
---@since 3.16.0
---@class LSP.FileDelete
--- A file:// URI for the location of the file/folder being deleted.
---@field uri string


---@class LSP.DidChangeWatchedFilesClientCapabilities
--- Did change watched files notification supports dynamic registration.
--- Please note that the current protocol doesn't support static
--- configuration for file changes from the server side.
---@field dynamicRegistration? boolean
--- Whether the client has support for relative patterns
--- or not.
---
---@since 3.17.0
---@field relativePatternSupport? boolean


--- Describe options to be used when registering for file system change events.
---@class LSP.DidChangeWatchedFilesRegistrationOptions
--- The watchers to register.
---@field watchers LSP.FileSystemWatcher[]


---@class LSP.FileSystemWatcher
--- The glob pattern to watch. See @link GlobPattern glob pattern
--- for more detail.
---
---@since 3.17.0 support for relative patterns.
---@field globPattern LSP.GlobPattern
--- The kind of events of interest. If omitted, it defaults
--- to WatchKind.Create | WatchKind.Change | WatchKind.Delete
--- which is 7.
---@field kind? LSP.WatchKind


---@enum LSP.WatchKind
M.WatchKind = {
    --- Interested in create events.
    Create = 1,
    --- Interested in change events.
    Change = 2,
    --- Interested in delete events.
    Delete = 4,
}


---@class LSP.DidChangeWatchedFilesParams
--- The actual file events.
---@field changes LSP.FileEvent[]


--- An event describing a file change.
---@class LSP.FileEvent
--- The file's URI.
---@field uri LSP.DocumentUri
--- The change type.
---@field type LSP.FileChangeType


--- The file event type.
---@enum LSP.FileChangeType
M.FileChangeType = {
    --- The file got created.
    Created = 1,
    --- The file got changed.
    Changed = 2,
    --- The file got deleted.
    Deleted = 3,
}


---@class LSP.ExecuteCommandClientCapabilities
--- Execute command supports dynamic registration.
---@field dynamicRegistration? boolean


---@class LSP.ExecuteCommandOptions : LSP.WorkDoneProgressOptions 
--- The commands to be executed on the server.
---@field commands string[]


--- Execute command registration options.
---@class LSP.ExecuteCommandRegistrationOptions : LSP.ExecuteCommandOptions


---@class LSP.ExecuteCommandParams : LSP.WorkDoneProgressParams 
--- The identifier of the actual command handler.
---@field command string
--- Arguments that the command should be invoked with.
---@field arguments? LSP.Any[]


---@class LSP.ApplyWorkspaceEditParams
--- An optional label of the workspace edit. This label is
--- presented in the user interface, for example, on an undo
--- stack to undo the workspace edit.
---@field label? string
--- The edits to apply.
---@field edit LSP.WorkspaceEdit
--- Additional data about the edit.
---
---@since 3.18.0
---@proposed
---@field metadata? LSP.WorkspaceEditMetadata


--- Additional data about a workspace edit.
---
---@since 3.18.0
---@proposed
---@class LSP.WorkspaceEditMetadata
--- Signal to the editor that this edit is a refactoring.
---@field isRefactoring? boolean


---@class LSP.ApplyWorkspaceEditResult
--- Indicates whether the edit was applied or not.
---@field applied boolean
--- An optional textual description for why the edit was not applied.
--- This may be used by the server for diagnostic logging or to provide
--- a suitable error for a request that triggered the edit.
---@field failureReason? string
--- Depending on the client's failure handling strategy, `failedChange`
--- might contain the index of the change that failed. This property is
--- only available if the client signals a `failureHandling` strategy
--- in its client capabilities.
---@field failedChange? uinteger


--- Client capabilities for a text document content provider.
---
---@since 3.18.0
---@class LSP.TextDocumentContentClientCapabilities
--- Text document content provider supports dynamic registration.
---@field dynamicRegistration? boolean


--- Text document content provider options.
---
---@since 3.18.0
---@class LSP.TextDocumentContentOptions
--- The schemes for which the server provides content.
---@field schemes string[]


--- Text document content provider registration options.
---
---@since 3.18.0
---@class LSP.TextDocumentContentRegistrationOptions : LSP.TextDocumentContentOptions, LSP.StaticRegistrationOptions


--- Parameters for the `workspace/textDocumentContent` request.
---
---@since 3.18.0
---@class LSP.TextDocumentContentParams
--- The uri of the text document.
---@field uri LSP.DocumentUri


--- Result of the `workspace/textDocumentContent` request.
---
---@since 3.18.0
---@proposed
---@class LSP.TextDocumentContentResult
--- The text content of the text document. Please note, that the content of
--- any subsequent open notifications for the text document might differ
--- from the returned content due to whitespace and line ending
--- normalizations done on the client
---@field text string


--- Parameters for the `workspace/textDocumentContent/refresh` request.
---
---@since 3.18.0
---@class LSP.TextDocumentContentRefreshParams
--- The uri of the text document to refresh.
---@field uri LSP.DocumentUri


---@class LSP.ShowMessageParams
--- The message type. See @link MessageType.
---@field type LSP.MessageType
--- The actual message.
---@field message string


---@enum(key) LSP.MessageType
M.MessageType = {
    --- An error message.
    Error = 1,
    --- A warning message.
    Warning = 2,
    --- An information message.
    Info = 3,
    --- A log message.
    Log = 4,
    --- A debug message.
    ---
    ---@since 3.18.0
    Debug = 5,
}


--- Show message request client capabilities
---@class LSP.ShowMessageRequestClientCapabilities
--- Capabilities specific to the `MessageActionItem` type.
---@field messageActionItem? { additionalPropertiesSupport?: boolean }


---@class LSP.ShowMessageRequestParams
--- The message type. See @link MessageType.
---@field type LSP.MessageType
--- The actual message.
---@field message string
--- The message action items to present.
---@field actions? LSP.MessageActionItem[]


---@class LSP.MessageActionItem
--- A short title like 'Retry', 'Open Log' etc.
---@field title string


--- Client capabilities for the show document request.
---
---@since 3.16.0
---@class LSP.ShowDocumentClientCapabilities
--- The client has support for the show document
--- request.
---@field support boolean


--- Params to show a resource.
---
---@since 3.16.0
---@class LSP.ShowDocumentParams
--- The URI to show.
---@field uri LSP.URI
--- Indicates to show the resource in an external program.
--- To show, for example, `https:--code.visualstudio.com/`
--- in the default web browser, set `external` to `true`.
---@field external? boolean
--- An optional property to indicate whether the editor
--- showing the document should take focus or not.
--- Clients might ignore this property if an external
--- program is started.
---@field takeFocus? boolean
--- An optional selection range if the document is a text
--- document. Clients might ignore this property if an
--- external program is started or the file is not a text
--- file.
---@field selection? LSP.Range


--- The result of a show document request.
---
---@since 3.16.0
---@class LSP.ShowDocumentResult
--- A boolean indicating if the show was successful.
---@field success boolean


---@class LSP.LogMessageParams
--- The message type. See @link MessageType.
---@field type LSP.MessageType
--- The actual message.
---@field message string


---@class LSP.WorkDoneProgressCreateParams
--- The token to be used to report progress.
---@field token ProgressToken


---@class LSP.WorkDoneProgressCancelParams
--- The token to be used to report progress.
---@field token ProgressToken

return M
