---@class LSP
local M = {}


---@alias uinteger integer

---@alias LSPAny LSPObject | LSPArray | string | number | boolean | nil
---@alias LSPObject table<string, LSPAny>
---@alias LSPArray LSPAny[]


---@class Message
---@field jsonrpc "2.0"


---@class RequestMessage : Message
--- The request id.
---@field id integer | string
--- The method to be invoked.
---@field method string
--- The method's params.
---@field params? LSPArray | LSPObject


---@class ResponseMessage : Message
--- The request id.
---@field id integer | string | nil;
--- The result of a request. This member is REQUIRED on success.
--- This member MUST NOT exist if there was an error invoking the method.
---@field result? LSPAny
--- The error object in case a request fails.
---@field error? ResponseError


---@class ResponseError
--- A number indicating the error type that occurred.
---@field code number
--- A string providing a short description of the error.
---@field message string
--- A Primitive or Structured value that contains additional information about the error.
---@field data? LSPAny


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


---@class NotificationMessage : Message
--- The method to be invoked.
---@field method string
--- The notification's params.
---@field params? LSPArray | LSPObject


---@class CancelParams
--- The request id to cancel.
---@field id integer | string


---@alias ProgressToken integer | string


---@class ProgressParams
--- The progress token provided by the client or server.
---@field token ProgressToken
--- The progress data.
---@field value LSPAny


---@alias DocumentUri string
---@alias URI string


---@class RegularExpressionsClientCapabilities
--- The engine's name.
---@field engine string
--- The engine's version.
---@field version? string


M.EOL = { '\n', '\r\n', '\r' }


---@class Position
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
---@alias PositionEncodingKind string

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


---@class Range
--- The range's start position.
---@field start Position
--- The range's end position.
---@field end Position


---@class TextDocumentItem
--- The text document's URI.
---@field uri DocumentUri
--- The text document's language identifier.
---@field languageId string
--- The version number of this document (it will strictly increase after each
--- change, including undo/redo).
---@field version integer
--- The content of the opened text document.
---@field text string


---@class TextDocumentIdentifier
--- The text document's URI.
---@field uri DocumentUri


---@class VersionedTextDocumentIdentifier : TextDocumentIdentifier
--- The version number of this document.
---
--- The version number of a document will increase after each change,
--- including undo/redo. The number doesn't need to be consecutive.
---@field version integer


---@class OptionalVersionedTextDocumentIdentifier : TextDocumentIdentifier
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


---@class TextDocumentPositionParams
--- The text document.
---@field textDocument TextDocumentIdentifier
--- The position inside the text document.
---@field position Position


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
---@alias Pattern string


---@class RelativePattern
--- A workpsace folder or a base URI to which this pattern will be matched
--- against relatively.
---@field baseUri WorkspaceFolder | URI
--- The actual pattern
---@field pattern Pattern


---@alias GlobalPattern Pattern | RelativePattern


---@class DocumentFilter
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
---@field pattern? GlobalPattern


---@alias DocumentSelector DocumentFilter[]


--- A string value used as a snippet is a template which allows to insert text
--- and to control the editor cursor when insertion happens.
---
--- A snippet can define tab stops and placeholders with `$1`, `$2`
--- and `${3:foo}`. `$0` defines the final tab stop, it defaults to
--- the end of the snippet. Variables are defined with `$name` and
--- `${name:default value}`.
---
---@since 3.18.0
---@class StringValue
--- The kind of string value.
---@field kind "snippet"
--- The snippet string.
---@field value string


---@class TextEdit
--- The range of the text document to be manipulated. To insert
--- text into a document, create a range where start === end.
---@field range Range
--- The string to be inserted. For delete operations, use an
--- empty string.
---@field newText string


---@class ChangeAnnotation
--- A human-readable string describing the actual change. The string
--- is rendered prominently in the user interface.
---@field label string
--- A flag which indicates that user confirmation is needed
--- before applying the change.
---@field needsConfirmation? boolean
--- A human-readable string which is rendered less prominently in
--- the user interface.
---@field description? string


---@alias ChangeAnnotationIdentifier string


---@class AnnotatedTextEdit : TextEdit
--- The actual annotation identifier.
---@field annotationId ChangeAnnotationIdentifier


---@class SnippetTextEdit
--- The range of the text document to be manipulated.
---@field range Range
--- The snippet to be inserted.
---@field snippet StringValue
--- The actual identifier of the snippet edit.
---@field annotationId? ChangeAnnotationIdentifier


---@class TextDocumentEdit
--- The text document to change.
---@field textDocument OptionalVersionedTextDocumentIdentifier
--- The edits to be applied.
--- 
---@since 3.16.0 - support for AnnotatedTextEdit. This is guarded by the
--- client capability `workspace.workspaceEdit.changeAnnotationSupport`
--- 
---@since 3.18.0 - support for SnippetTextEdit. This is guarded by the
--- client capability `workspace.workspaceEdit.snippetEditSupport`
---@field edits (TextEdit | AnnotatedTextEdit | SnippetTextEdit)[]


---@class Location
---@field uri DocumentUri
---@field range Range


---@class LocationLink
--- Span of the origin of this link.
---
--- Used as the underlined span for mouse interaction. Defaults to the word
--- range at the mouse position.
---@field originSelectionRange? Range
--- The target resource identifier of this link.
---@field targetUri DocumentUri
--- The full target range of this link. If the target is, for example, a
--- symbol, then the target range is the range enclosing this symbol not
--- including leading/trailing whitespace but everything else like comments.
--- This information is typically used to highlight the range in the editor.
---@field targetRange Range
--- The range that should be selected and revealed when this link is being
--- followed, e.g., the name of a function. Must be contained by the
--- `targetRange`. See also `DocumentSymbol#range`
---@field targetSelectionRange Range


---@class Diagnostic
--- The range at which the message applies.
---@field range Range
--- The diagnostic's severity. To avoid interpretation mismatches when a
--- server is used with different clients it is highly recommended that
--- servers always provide a severity value. If omitted, it’s recommended
--- for the client to interpret it as an Error severity.
---@field severity? DiagnosticSeverity
--- The diagnostic's code, which might appear in the user interface.
---@field code? integer | string
--- An optional property to describe the error code.
---@since 3.16.0
---@field codeDescription? CodeDescription
--- A human-readable string describing the source of this
--- diagnostic, e.g. 'typescript' or 'super lint'.
---@field source? string
--- The diagnostic's message.
---@since 3.18.0 - support for MarkupContent. This is guarded by the client
--- capability `textDocument.diagnostic.markupMessageSupport`.
---@field message string | MarkupContent
--- Additional metadata about the diagnostic.
---@since 3.15.0
---@field tags? DiagnosticTag[]
--- An array of related diagnostic information, e.g. when symbol-names within
--- a scope collide all definitions can be marked via this property.
---@field relatedInformation? DiagnosticRelatedInformation[]
--- A data entry field that is preserved between a
--- `textDocument/publishDiagnostics` notification and
--- `textDocument/codeAction` request.
---@since 3.16.0
---@field data? LSPAny


---@enum DiagnosticSeverity
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


---@enum DiagnosticTag
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


---@class DiagnosticRelatedInformation
--- The location of this related diagnostic information.
---@field location Location
--- The message of this related diagnostic information.
---@field message string


---@class CodeDescription
--- A URI to open with more information about the diagnostic error.
---@field href URI


---@class Command
--- Title of the command, like `save`.
---@field title string
--- An optional tooltip.
---@field tooltip? string
--- The identifier of the actual command handler.
---@field command string
--- Arguments that the command handler should be invoked with.
---@field arguments? LSPAny[]


---@enum MarkupKind
M.MarkupKind = {
    --- Plain text is supported as a content format.
    PlainText = 'plaintext',

    --- Markdown is supported as a content format.
    Markdown = 'markdown',
}


---@class MarkupContent
--- The type of the Markup.
---@field kind MarkupKind
--- The content itself.
---@field value string


--- Client capabilities specific to the used markdown parser.
---
---@since 3.16.0
---@class MarkdownClientCapabilities
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
---@class CreateFileOptions  
--- Overwrite existing file. Overwrite wins over `ignoreIfExists`.
---@field overwrite? boolean
--- Ignore if exists.
---@field ignoreIfExists? boolean


--- Create file operation
---@class CreateFile
--- This is a create operation.
---@field kind 'create'
--- The resource to create.
---@field uri DocumentUri
--- Additional options.
---@field options? CreateFileOptions
--- An optional annotation identifier describing the operation.
---
---@since 3.16.0
---@field annotationId? ChangeAnnotationIdentifier


---@class RenameFileOptions
--- Overwrite target if existing. Overwrite wins over `ignoreIfExists`.
---@field overwrite? boolean
--- Ignores if target exists.
---@field ignoreIfExists? boolean


---@class RenameFile
--- This is a rename operation.
---@field kind 'rename'
--- The old (existing) location.
---@field oldUri DocumentUri
--- The new location.
---@field newUri DocumentUri
--- Rename options.
---@field options? RenameFileOptions
--- An optional annotation identifier describing the operation.
---
---@since 3.16.0
---@field annotationId? ChangeAnnotationIdentifier


--- Delete file options
---@class DeleteFileOptions
--- Delete the content recursively if a folder is denoted.
---@field recursive? boolean
--- Ignore the operation if the file doesn't exist.
---@field ignoreIfNotExists? boolean


--- Delete file operation
---@class DeleteFile
--- This is a delete operation.
---@field kind 'delete'
--- The file to delete.
---@field uri DocumentUri
--- Delete options.
---@field options? DeleteFileOptions
--- An optional annotation identifier describing the operation.
---
---@since 3.16.0
---@field annotationId? ChangeAnnotationIdentifier


---@class WorkspaceEdit 
--- Holds changes to existing resources.
---@field changes? { [DocumentUri]: TextEdit[] }
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
---@field documentChanges? (TextDocumentEdit[] | (TextDocumentEdit | CreateFile | RenameFile | DeleteFile)[] )
--- A map of change annotations that can be referenced in
--- `AnnotatedTextEdit`s or create, rename and delete file / folder
--- operations.
---
--- Whether clients honor this property depends on the client capability
--- `workspace.changeAnnotationSupport`.
---
---@since 3.16.0
---@field changeAnnotations? { [string]: ChangeAnnotation }


---@class WorkspaceEditClientCapabilities 
--- The client supports versioned document changes in `WorkspaceEdit`s.
---@field documentChanges? boolean
--- The resource operations the client supports. Clients should at least
--- support 'create', 'rename', and 'delete' for files and folders.
---
---@since 3.13.0
---@field resourceOperations? ResourceOperationKind[]
--- The failure handling strategy of a client if applying the workspace edit
--- fails.
---
---@since 3.13.0
---@field failureHandling? FailureHandlingKind
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
---@enum ResourceOperationKind
M.ResourceOperationKind = {
    --- Supports creating new files and folders.
    Create = 'create',
    --- Supports renaming existing files and folders.
    Rename = 'rename',
    --- Supports deleting existing files and folders.
    Delete = 'delete',
}


---@enum FailureHandlingKind
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


---@class WorkDoneProgressBegin 
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


---@class WorkDoneProgressReport 
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


---@class WorkDoneProgressEnd 
---@field kind 'end'
--- Optional, a final message indicating, for example,
--- the outcome of the operation.
---@field message? string


---@class WorkDoneProgressParams 
--- An optional token that a server can use to report work done progress.
---@field workDoneToken? ProgressToken


---@class WorkDoneProgressOptions 
---@field workDoneProgress? boolean


---@class PartialResultParams 
--- An optional token that a server can use to report partial results (e.g.
--- streaming) to the client.
---@field partialResultToken? ProgressToken


---@alias TraceValue 'off' | 'messages' | 'verbose'


---@class InitializeParams : WorkDoneProgressParams 
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
---@field rootUri DocumentUri | nil
--- User provided initialization options.
---@field initializationOptions? LSPAny
--- The capabilities provided by the client (editor or tool)
---@field capabilities ClientCapabilities
--- The initial trace setting. If omitted trace is disabled ('off').
---@field trace? TraceValue
--- The workspace folders configured in the client when the server starts.
--- This property is only available if the client supports workspace folders.
--- It can be `null` if the client supports workspace folders but none are
--- configured.
---
---@since 3.6.0
---@field workspaceFolders? WorkspaceFolder[] | nil


--- Text document specific client capabilities.
---@class TextDocumentClientCapabilities
--- Defines which synchronization capabilities the client supports.
---@field synchronization? TextDocumentSyncClientCapabilities
--- Defines which filters the client supports.
---
---@since 3.18.0
---@field filters? TextDocumentFilterClientCapabilities
--- Capabilities specific to the `textDocument/completion` request.
---@field completion? CompletionClientCapabilities
--- Capabilities specific to the `textDocument/hover` request.
---@field hover? HoverClientCapabilities
--- Capabilities specific to the `textDocument/signatureHelp` request.
---@field signatureHelp? SignatureHelpClientCapabilities
--- Capabilities specific to the `textDocument/declaration` request.
---
---@since 3.14.0
---@field declaration? DeclarationClientCapabilities
--- Capabilities specific to the `textDocument/definition` request.
---@field definition? DefinitionClientCapabilities
--- Capabilities specific to the `textDocument/typeDefinition` request.
---
---@since 3.6.0
---@field typeDefinition? TypeDefinitionClientCapabilities
--- Capabilities specific to the `textDocument/implementation` request.
---
---@since 3.6.0
---@field implementation? ImplementationClientCapabilities
--- Capabilities specific to the `textDocument/references` request.
---@field references? ReferenceClientCapabilities
--- Capabilities specific to the `textDocument/documentHighlight` request.
---@field documentHighlight? DocumentHighlightClientCapabilities
--- Capabilities specific to the `textDocument/documentSymbol` request.
---@field documentSymbol? DocumentSymbolClientCapabilities
--- Capabilities specific to the `textDocument/codeAction` request.
---@field codeAction? CodeActionClientCapabilities
--- Capabilities specific to the `textDocument/codeLens` request.
---@field codeLens? CodeLensClientCapabilities
--- Capabilities specific to the `textDocument/documentLink` request.
---@field documentLink? DocumentLinkClientCapabilities
--- Capabilities specific to the `textDocument/documentColor` and the
--- `textDocument/colorPresentation` request.
---
---@since 3.6.0
---@field colorProvider? DocumentColorClientCapabilities
--- Capabilities specific to the `textDocument/formatting` request.
---@field formatting? DocumentFormattingClientCapabilities
--- Capabilities specific to the `textDocument/rangeFormatting` and
--- `textDocument/rangesFormatting requests.
---@field rangeFormatting? DocumentRangeFormattingClientCapabilities
--- Capabilities specific to the `textDocument/onTypeFormatting` request.
---@field onTypeFormatting? DocumentOnTypeFormattingClientCapabilities
--- Capabilities specific to the `textDocument/rename` request.
---@field rename? RenameClientCapabilities
--- Capabilities specific to the `textDocument/publishDiagnostics`
--- notification.
---@field publishDiagnostics? PublishDiagnosticsClientCapabilities
--- Capabilities specific to the `textDocument/foldingRange` request.
---
---@since 3.10.0
---@field foldingRange? FoldingRangeClientCapabilities
--- Capabilities specific to the `textDocument/selectionRange` request.
---
---@since 3.15.0
---@field selectionRange? SelectionRangeClientCapabilities
--- Capabilities specific to the `textDocument/linkedEditingRange` request.
---
---@since 3.16.0
---@field linkedEditingRange? LinkedEditingRangeClientCapabilities
--- Capabilities specific to the various call hierarchy requests.
---
---@since 3.16.0
---@field callHierarchy? CallHierarchyClientCapabilities
--- Capabilities specific to the various semantic token requests.
---
---@since 3.16.0
---@field semanticTokens? SemanticTokensClientCapabilities
--- Capabilities specific to the `textDocument/moniker` request.
---
---@since 3.16.0
---@field moniker? MonikerClientCapabilities
--- Capabilities specific to the various type hierarchy requests.
---
---@since 3.17.0
---@field typeHierarchy? TypeHierarchyClientCapabilities
--- Capabilities specific to the `textDocument/inlineValue` request.
---
---@since 3.17.0
---@field inlineValue? InlineValueClientCapabilities
--- Capabilities specific to the `textDocument/inlayHint` request.
---
---@since 3.17.0
---@field inlayHint? InlayHintClientCapabilities
--- Capabilities specific to the diagnostic pull model.
---
---@since 3.17.0
---@field diagnostic? DiagnosticClientCapabilities
--- Capabilities specific to the `textDocument/inlineCompletion` request.
---
---@since 3.18.0
---@field inlineCompletion? InlineCompletionClientCapabilities


---@class TextDocumentFilterClientCapabilities 
--- The client supports Relative Patterns.
---
---@since 3.18.0
---@field relativePatternSupport? boolean


---@class ClientCapabilities 
--- Workspace specific client capabilities.
---@field workspace? ClientCapabilities.Workspace
--- Text document specific client capabilities.
---@field textDocument? TextDocumentClientCapabilities
--- Capabilities specific to the notebook document support.
---
---@since 3.17.0
---@field notebookDocument? NotebookDocumentClientCapabilities
--- Window specific client capabilities.
---@field window? ClientCapabilities.Window
--- General client capabilities.
---
---@since 3.16.0
---@field general? ClientCapabilities.General
--- Experimental client capabilities.
---@field experimental? LSPAny


---@class ClientCapabilities.Workspace
--- The client supports applying batch edits
--- to the workspace by supporting the request
--- 'workspace/applyEdit'
---@field applyEdit? boolean
--- Capabilities specific to `WorkspaceEdit`s
---@field workspaceEdit? WorkspaceEditClientCapabilities
--- Capabilities specific to the `workspace/didChangeConfiguration`
--- notification.
---@field didChangeConfiguration? DidChangeConfigurationClientCapabilities
--- Capabilities specific to the `workspace/didChangeWatchedFiles`
--- notification.
---@field didChangeWatchedFiles? DidChangeWatchedFilesClientCapabilities
--- Capabilities specific to the `workspace/symbol` request.
---@field symbol? WorkspaceSymbolClientCapabilities
--- Capabilities specific to the `workspace/executeCommand` request.
---@field executeCommand? ExecuteCommandClientCapabilities
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
---@field semanticTokens? SemanticTokensWorkspaceClientCapabilities
--- Capabilities specific to the code lens requests scoped to the
--- workspace.
---
---@since 3.16.0
---@field codeLens? CodeLensWorkspaceClientCapabilities
--- The client has support for file requests/notifications.
---
---@since 3.16.0
---@field fileOperations? ClientCapabilities.Workspace.FileOperations
--- Client workspace capabilities specific to inline values.
---
---@since 3.17.0
---@field inlineValue? InlineValueWorkspaceClientCapabilities
--- Client workspace capabilities specific to inlay hints.
---
---@since 3.17.0
---@field inlayHint? InlayHintWorkspaceClientCapabilities
--- Client workspace capabilities specific to diagnostics.
---
---@since 3.17.0.
---@field diagnostics? DiagnosticWorkspaceClientCapabilities


--- Capabilities specific to the notebook document support.
---
---@since 3.17.0
---@class NotebookDocumentClientCapabilities
--- Capabilities specific to notebook document synchronization
---
---@since 3.17.0
---@field synchronization NotebookDocumentSyncClientCapabilities


---@class ClientCapabilities.Workspace.FileOperations
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


---@class ClientCapabilities.Window
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
---@field showMessage? ShowMessageRequestClientCapabilities
--- Client capabilities for the show document request.
---
---@since 3.16.0
---@field showDocument? ShowDocumentClientCapabilities


---@class ClientCapabilities.General
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
---@field regularExpressions? RegularExpressionsClientCapabilities
--- Client capabilities specific to the client's markdown parser.
---
---@since 3.16.0
---@field markdown? MarkdownClientCapabilities
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
---@field positionEncodings? PositionEncodingKind[]


---@class InitializeResult 
--- The capabilities the language server provides.
---@field capabilities ServerCapabilities
--- Information about the server.
---
---@since 3.15.0
---@field serverInfo? { name: string, version?: string }

---@enum InitializeErrorCodes
M.InitializeErrorCodes = {
    --- If the protocol version provided by the client can't be handled by
    --- the server.
    ---
    --- @deprecated This initialize error got replaced by client capabilities.
    --- There is no version handshake in version 3.0x
    unknownProtocolVersion = 1,
}


---@class InitializeError 
--- Indicates whether the client execute the following retry logic:
--- (1) show the message provided by the ResponseError to the user
--- (2) user selects retry or cancel
--- (3) if user selected retry the initialize method is sent again.
---@field retry boolean


---@class ServerCapabilities 
--- The position encoding the server picked from the encodings offered
--- by the client via the client capability `general.positionEncodings`.
---
--- If the client didn't provide any position encodings the only valid
--- value that a server can return is 'utf-16'.
---
--- If omitted it defaults to 'utf-16'.
---
---@since 3.17.0
---@field positionEncoding? PositionEncodingKind
--- Defines how text documents are synced. Is either a detailed structure
--- defining each notification or for backwards compatibility the
--- TextDocumentSyncKind number. If omitted it defaults to
--- `TextDocumentSyncKind.None`.
---@field textDocumentSync? TextDocumentSyncOptions | TextDocumentSyncKind
--- Defines how notebook documents are synced.
---
---@since 3.17.0
---@field notebookDocumentSync? NotebookDocumentSyncOptions | NotebookDocumentSyncRegistrationOptions
--- The server provides completion support.
---@field completionProvider? CompletionOptions
--- The server provides hover support.
---@field hoverProvider? boolean | HoverOptions
--- The server provides signature help support.
---@field signatureHelpProvider? SignatureHelpOptions
--- The server provides go to declaration support.
---
---@since 3.14.0
---@field declarationProvider? boolean | DeclarationOptions | DeclarationRegistrationOptions
--- The server provides goto definition support.
---@field definitionProvider? boolean | DefinitionOptions
--- The server provides goto type definition support.
---
---@since 3.6.0
---@field typeDefinitionProvider? boolean | TypeDefinitionOptions | TypeDefinitionRegistrationOptions
--- The server provides goto implementation support.
---
---@since 3.6.0
---@field implementationProvider? boolean | ImplementationOptions | ImplementationRegistrationOptions
--- The server provides find references support.
---@field referencesProvider? boolean | ReferenceOptions
--- The server provides document highlight support.
---@field documentHighlightProvider? boolean | DocumentHighlightOptions
--- The server provides document symbol support.
---@field documentSymbolProvider? boolean | DocumentSymbolOptions
--- The server provides code actions. The `CodeActionOptions` return type is
--- only valid if the client signals code action literal support via the
--- property `textDocument.codeAction.codeActionLiteralSupport`.
---@field codeActionProvider? boolean | CodeActionOptions
--- The server provides code lens.
---@field codeLensProvider? CodeLensOptions
--- The server provides document link support.
---@field documentLinkProvider? DocumentLinkOptions
--- The server provides color provider support.
---
---@since 3.6.0
---@field colorProvider? boolean | DocumentColorOptions | DocumentColorRegistrationOptions
--- The server provides document formatting.
---@field documentFormattingProvider? boolean | DocumentFormattingOptions
--- The server provides document range formatting.
---@field documentRangeFormattingProvider? boolean | DocumentRangeFormattingOptions
--- The server provides document formatting on typing.
---@field documentOnTypeFormattingProvider? DocumentOnTypeFormattingOptions
--- The server provides rename support. RenameOptions may only be
--- specified if the client states that it supports
--- `prepareSupport` in its initial `initialize` request.
---@field renameProvider? boolean | RenameOptions
--- The server provides folding provider support.
---
---@since 3.10.0
---@field foldingRangeProvider? boolean | FoldingRangeOptions | FoldingRangeRegistrationOptions
--- The server provides execute command support.
---@field executeCommandProvider? ExecuteCommandOptions
--- The server provides selection range support.
---
---@since 3.15.0
---@field selectionRangeProvider? boolean | SelectionRangeOptions | SelectionRangeRegistrationOptions
--- The server provides linked editing range support.
---
---@since 3.16.0
---@field linkedEditingRangeProvider? boolean | LinkedEditingRangeOptions | LinkedEditingRangeRegistrationOptions
--- The server provides call hierarchy support.
---
---@since 3.16.0
---@field callHierarchyProvider? boolean | CallHierarchyOptions | CallHierarchyRegistrationOptions
--- The server provides semantic tokens support.
---
---@since 3.16.0
---@field semanticTokensProvider? SemanticTokensOptions | SemanticTokensRegistrationOptions
--- Whether server provides moniker support.
---
---@since 3.16.0
---@field monikerProvider? boolean | MonikerOptions | MonikerRegistrationOptions
--- The server provides type hierarchy support.
---
---@since 3.17.0
---@field typeHierarchyProvider? boolean | TypeHierarchyOptions | TypeHierarchyRegistrationOptions
--- The server provides inline values.
---
---@since 3.17.0
---@field inlineValueProvider? boolean | InlineValueOptions | InlineValueRegistrationOptions
--- The server provides inlay hints.
---
---@since 3.17.0
---@field inlayHintProvider? boolean | InlayHintOptions | InlayHintRegistrationOptions
--- The server has support for pull model diagnostics.
---
---@since 3.17.0
---@field diagnosticProvider? DiagnosticOptions | DiagnosticRegistrationOptions
--- The server provides workspace symbol support.
---@field workspaceSymbolProvider? boolean | WorkspaceSymbolOptions
--- The server provides inline completions.
---
---@since 3.18.0
---@field inlineCompletionProvider? boolean | InlineCompletionOptions
--- Text document specific server capabilities.
---
---@since 3.18.0
---@field textDocument? { diagnostic?: { markupMessageSupport?: boolean } }
--- Workspace specific server capabilities
---@field workspace? { workspaceFolders?: WorkspaceFoldersServerCapabilities, fileOperations?: ServerCapabilities.Workspace.FileOperations }
--- Experimental server capabilities.
---@field experimental? LSPAny


---@class ServerCapabilities.Workspace.FileOperations
--- The server is interested in receiving didCreateFiles
--- notifications.
---@field didCreate? FileOperationRegistrationOptions
--- The server is interested in receiving willCreateFiles requests.
---@field willCreate? FileOperationRegistrationOptions
--- The server is interested in receiving didRenameFiles
--- notifications.
---@field didRename? FileOperationRegistrationOptions
--- The server is interested in receiving willRenameFiles requests.
---@field willRename? FileOperationRegistrationOptions
--- The server is interested in receiving didDeleteFiles file
--- notifications.
---@field didDelete? FileOperationRegistrationOptions
--- The server is interested in receiving willDeleteFiles file
--- requests.
---@field willDelete? FileOperationRegistrationOptions


---@class InitializedParams


--- General parameters to register for a capability.
---@class Registration
--- The id used to register the request. The id can be used to deregister
--- the request again.
---@field id string
--- The method / capability to register for.
---@field method string
--- Options necessary for the registration.
---@field registerOptions? LSPAny


---@class RegistrationParams 
---@field registrations Registration[]


--- Static registration options to be returned in the initialize request.
---@class StaticRegistrationOptions
--- The id used to register the request. The id can be used to deregister
--- the request again. See also Registration#id.
---@field id? string


--- General text document registration options.
---@class TextDocumentRegistrationOptions
--- A document selector to identify the scope of the registration. If set to
--- nil, the document selector provided on the client side will be used.
---@field documentSelector DocumentSelector | nil


--- General parameters to unregister a capability.
---@class Unregistration
--- The id used to unregister the request or notification. Usually an id
--- provided during the register request.
---@field id string
--- The method / capability to unregister for.
---@field method string


---@class UnregistrationParams 
-- This should correctly be named `unregistrations`. However, changing this
-- is a breaking change and needs to wait until we deliver a 4.x version
-- of the specification.
---@field unregisterations Unregistration[]


---@class SetTraceParams 
--- The new value that should be assigned to the trace setting.
---@field value TraceValue


---@class LogTraceParams 
--- The message to be logged.
---@field message string
--- Additional information that can be computed if the `trace` configuration
--- is set to `'verbose'`.
---@field verbose? string


---@enum TextDocumentSyncKind
M.TextDocumentSyncKind = {
    --- Documents should not be synced at all.
    None = 0,
    --- Documents are synced by always sending the full content of the document.
    Full = 1,
    --- Documents are synced by sending the full content on open. After that
    --- only incremental updates to the document are sent.
    Incremental = 2,
}


---@class DidOpenTextDocumentParams 
--- The document that was opened.
---@field textDocument TextDocumentItem


--- Describe options to be used when registering for text document change events.
---@class TextDocumentChangeRegistrationOptions : TextDocumentRegistrationOptions
--- How documents are synced to the server. See TextDocumentSyncKind.Full
--- and TextDocumentSyncKind.Incremental.
---@field syncKind TextDocumentSyncKind


---@class DidChangeTextDocumentParams 
--- The document that did change. The version number points
--- to the version after all provided content changes have
--- been applied.
---@field textDocument VersionedTextDocumentIdentifier
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
---@field contentChanges TextDocumentContentChangeEvent[]


---@alias TextDocumentContentChangeEvent TextDocumentContentChangeEvent.Full | TextDocumentContentChangeEvent.Simple


---@class TextDocumentContentChangeEvent.Full
--- The range of the document that changed.
---@field range Range
--- The optional length of the range that got replaced.
---
--- @deprecated use range instead.
---@field rangeLength? uinteger
--- The new text for the provided range.
---@field text string


---@class TextDocumentContentChangeEvent.Simple
--- The new text for the provided range.
---@field text string


--- The parameters send in a will save text document notification.
---@class WillSaveTextDocumentParams
--- The document that will be saved.
---@field textDocument TextDocumentIdentifier
--- The 'TextDocumentSaveReason'.
---@field reason TextDocumentSaveReason


---@enum TextDocumentSaveReason
M.TextDocumentSaveReason = {
    --- Manually triggered, e.g. by the user pressing save, by starting
    --- debugging, or by an API call.
    Manual = 1,
    --- Automatic after a delay.
    AfterDelay = 2,
    --- When the editor lost focus.
    FocusOut = 3,
}


---@class SaveOptions 
--- The client is supposed to include the content on save.
---@field includeText? boolean


---@class TextDocumentSaveRegistrationOptions : TextDocumentRegistrationOptions
--- The client is supposed to include the content on save.
---@field includeText? boolean


---@class DidSaveTextDocumentParams 
--- The document that was saved.
---@field textDocument TextDocumentIdentifier
--- Optional the content when saved. Depends on the includeText value
--- when the save notification was requested.
---@field text? string


---@class DidCloseTextDocumentParams 
--- The document that was closed.
---@field textDocument TextDocumentIdentifier


---@class TextDocumentSyncClientCapabilities 
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


---@class TextDocumentSyncOptions 
--- Open and close notifications are sent to the server. If omitted open
--- close notification should not be sent.
---@field openClose? boolean
--- Change notifications are sent to the server. See
--- TextDocumentSyncKind.None, TextDocumentSyncKind.Full and
--- TextDocumentSyncKind.Incremental. If omitted it defaults to
--- TextDocumentSyncKind.None.
---@field change? TextDocumentSyncKind
--- If present will save notifications are sent to the server. If omitted
--- the notification should not be sent.
---@field willSave? boolean
--- If present will save wait until requests are sent to the server. If
--- omitted the request should not be sent.
---@field willSaveWaitUntil? boolean
--- If present save notifications are sent to the server. If omitted the
--- notification should not be sent.
---@field save? boolean | SaveOptions


--- A notebook document.
---
---@since 3.17.0
---@class NotebookDocument
--- The notebook document's URI.
---@field uri URI
--- The type of the notebook.
---@field notebookType string
--- The version number of this document (it will increase after each
--- change, including undo/redo).
---@field version integer
--- Additional metadata stored with the notebook
--- document.
---@field metadata? LSPObject
--- The cells of a notebook.
---@field cells NotebookCell[]


--- A notebook cell.
---
--- A cell's document URI must be unique across ALL notebook
--- cells and can therefore be used to uniquely identify a  
--- notebook cell or the cell's text document.
---
---@since 3.17.0
---@class NotebookCell
--- The cell's kind.
---@field kind NotebookCellKind
--- The URI of the cell's text document
--- content.
---@field document DocumentUri
--- Additional metadata stored with the cell.
---@field metadata? LSPObject
--- Additional execution summary information
--- if supported by the client.
---@field executionSummary? ExecutionSummary


---@enum NotebookCellKind
M.NotebookCellKind = {
    --- A markup-cell is a formatted source that is used for display.
    Markup = 1,
    --- A code-cell is source code.
    Code = 2,
}


---@class ExecutionSummary 
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
---@class NotebookCellTextDocumentFilter
--- A filter that matches against the notebook
--- containing the notebook cell. If a string
--- value is provided, it matches against the
--- notebook type. '---' matches every notebook.
---@field notebook string | NotebookDocumentFilter
--- A language ID like `python`.
---
--- Will be matched against the language ID of the
--- notebook cell document. '---' matches every language.
---@field language? string


---@alias NotebookDocumentFilter
---| { notebookType: string, scheme?: string, pattern?: GlobPattern }
---| { notebookType?: string, scheme: string, pattern?: GlobPattern }
---| { notebookType?: string, scheme?: string, pattern: GlobPattern }


--- Notebook specific client capabilities.
---
---@since 3.17.0
---@class NotebookDocumentSyncClientCapabilities
--- Whether implementation supports dynamic registration. If this is
--- set to `true`, the client supports the new
--- `(NotebookDocumentSyncRegistrationOptions & NotebookDocumentSyncOptions)`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- The client supports sending execution summary data per cell.
---@field executionSummarySupport? boolean


---@class NotebookDocumentSyncOptions.NotebookSelector1
--- The notebook to be synced. If a string
--- value is provided, it matches against the
--- notebook type. '---' matches every notebook.
---@field notebook string | NotebookDocumentFilter
--- The cells of the matching notebook to be synced.
---@field cells? { language: string }[]


---@class NotebookDocumentSyncOptions.NotebookSelector2
--- The notebook to be synced. If a string
--- value is provided, it matches against the
--- notebook type. '---' matches every notebook.
---@field notebook? string | NotebookDocumentFilter
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
---@class NotebookDocumentSyncOptions
--- The notebooks to be synced
---@field notebookSelector (NotebookDocumentSyncOptions.NotebookSelector1 | NotebookDocumentSyncOptions.NotebookSelector2)[]
--- Whether save notifications should be forwarded to
--- the server. Will only be honored if mode === `notebook`.
---@field save? boolean


--- Registration options specific to a notebook.
---
---@since 3.17.0
---@class NotebookDocumentSyncRegistrationOptions : NotebookDocumentSyncOptions, StaticRegistrationOptions


--- The params sent in an open notebook document notification.
---
---@since 3.17.0
---@class DidOpenNotebookDocumentParams
--- The notebook document that got opened.
---@field notebookDocument NotebookDocument
--- The text documents that represent the content
--- of a notebook cell.
---@field cellTextDocuments TextDocumentItem[]


--- The params sent in a change notebook document notification.
---
---@since 3.17.0
---@class DidChangeNotebookDocumentParams
--- The notebook document that did change. The version number points
--- to the version after all provided changes have been applied.
---@field notebookDocument VersionedNotebookDocumentIdentifier
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
---@field change NotebookDocumentChangeEvent


--- A versioned notebook document identifier.
---
---@since 3.17.0
---@class VersionedNotebookDocumentIdentifier
--- The version number of this notebook document.
---@field version integer
--- The notebook document's URI.
---@field uri URI


--- A change event for a notebook document.
---
---@since 3.17.0
---@class NotebookDocumentChangeEvent
--- The changed meta data if any.
---@field metadata? LSPObject
--- Changes to cells.
---@field cells? NotebookDocumentChangeEvent.Cells


---@class NotebookDocumentChangeEvent.Cells
--- Changes to the cell structure to add or
--- remove cells.
---@field structure? NotebookDocumentChangeEvent.Cells.Structure
--- Changes to notebook cells properties like its
--- kind, execution summary or metadata.
---@field data? NotebookCell[]
--- Changes to the text content of notebook cells.
---@field textContent? {
--- document: VersionedTextDocumentIdentifier,
--- changes: TextDocumentContentChangeEvent[],
---}[]


---@class NotebookDocumentChangeEvent.Cells.Structure
--- The change to the cell array.
---@field array NotebookCellArrayChange
--- Additional opened cell text documents.
---@field didOpen? TextDocumentItem[]
--- Additional closed cell text documents.
---@field didClose? TextDocumentIdentifier[]


--- A change describing how to move a `NotebookCell`
--- array from state S to S'.
---
---@since 3.17.0
---@class NotebookCellArrayChange
--- The start offset of the cell that changed.
---@field start uinteger
--- The number of deleted cells.
---@field deleteCount uinteger
--- The new cells, if any.
---@field cells? NotebookCell[]


--- The params sent in a save notebook document notification.
---
---@since 3.17.0
---@class DidSaveNotebookDocumentParams
--- The notebook document that got saved.
---@field notebookDocument NotebookDocumentIdentifier


--- The params sent in a close notebook document notification.
---
---@since 3.17.0
---@class DidCloseNotebookDocumentParams
--- The notebook document that got closed.
---@field notebookDocument NotebookDocumentIdentifier
--- The text documents that represent the content
--- of a notebook cell that got closed.
---@field cellTextDocuments TextDocumentIdentifier[]


--- A literal to identify a notebook document in the client.
---
---@since 3.17.0
---@class NotebookDocumentIdentifier
--- The notebook document's URI.
---@field uri URI


---@class DeclarationClientCapabilities 
--- Whether declaration supports dynamic registration. If this is set to
--- `true`, the client supports the new `DeclarationRegistrationOptions`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- The client supports additional metadata in the form of declaration links.
---@field linkSupport? boolean


---@class DeclarationOptions : WorkDoneProgressOptions


---@class DeclarationRegistrationOptions : DeclarationOptions, TextDocumentRegistrationOptions, StaticRegistrationOptions


---@class DeclarationParams : TextDocumentPositionParams, WorkDoneProgressParams, PartialResultParams


---@class DefinitionClientCapabilities
--- Whether definition supports dynamic registration.
---@field dynamicRegistration? boolean
--- The client supports additional metadata in the form of definition links.
---
---@since 3.14.0
---@field linkSupport? boolean


---@class DefinitionOptions : WorkDoneProgressOptions


---@class DefinitionRegistrationOptions : TextDocumentRegistrationOptions, DefinitionOptions 


---@class DefinitionParams : TextDocumentPositionParams, WorkDoneProgressParams, PartialResultParams


---@class TypeDefinitionClientCapabilities
--- Whether implementation supports dynamic registration. If this is set to
--- `true`, the client supports the new `TypeDefinitionRegistrationOptions`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- The client supports additional metadata in the form of definition links.
---
---@since 3.14.0
---@field linkSupport? boolean


---@class TypeDefinitionOptions : WorkDoneProgressOptions


---@class TypeDefinitionRegistrationOptions : TextDocumentRegistrationOptions, TypeDefinitionOptions, StaticRegistrationOptions


---@class TypeDefinitionParams : TextDocumentPositionParams, WorkDoneProgressParams, PartialResultParams


---@class ImplementationClientCapabilities 
--- Whether the implementation supports dynamic registration. If this is set to
--- `true`, the client supports the new `ImplementationRegistrationOptions`
--- return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
--- The client supports additional metadata in the form of definition links.
---
---@since 3.14.0
---@field linkSupport? boolean


---@class ImplementationOptions : WorkDoneProgressOptions


---@class ImplementationRegistrationOptions : TextDocumentRegistrationOptions, ImplementationOptions, StaticRegistrationOptions


---@class ImplementationParams : TextDocumentPositionParams, WorkDoneProgressParams, PartialResultParams


---@class ReferenceClientCapabilities 
--- Whether references supports dynamic registration.
---@field dynamicRegistration? boolean


---@class ReferenceOptions : WorkDoneProgressOptions 


---@class ReferenceRegistrationOptions : TextDocumentRegistrationOptions, ReferenceOptions


---@class ReferenceParams : TextDocumentPositionParams, WorkDoneProgressParams, PartialResultParams
---@field context ReferenceContext


---@class ReferenceContext 
--- Include the declaration of the current symbol.
---@field includeDeclaration boolean


---@class CallHierarchyClientCapabilities 
--- Whether implementation supports dynamic registration. If this is set to
--- `true` the client supports the new `(TextDocumentRegistrationOptions &
--- StaticRegistrationOptions)` return value for the corresponding server
--- capability as well.
---@field dynamicRegistration? boolean


---@class CallHierarchyOptions : WorkDoneProgressOptions


---@class CallHierarchyRegistrationOptions : TextDocumentRegistrationOptions, CallHierarchyOptions, StaticRegistrationOptions


---@class CallHierarchyPrepareParams : TextDocumentPositionParams, WorkDoneProgressParams


---@class CallHierarchyItem 
--- The name of this item.
---@field name string
--- The kind of this item.
---@field kind SymbolKind
--- Tags for this item.
---@field tags? SymbolTag[]
--- More detail for this item, e.g. the signature of a function.
---@field detail? string
--- The resource identifier of this item.
---@field uri DocumentUri
--- The range enclosing this symbol not including leading/trailing whitespace
--- but everything else, e.g. comments and code.
---@field range Range
--- The range that should be selected and revealed when this symbol is being
--- picked, e.g. the name of a function. Must be contained by the
--- [`range`](#CallHierarchyItem.range).
---@field selectionRange Range
--- A data entry field that is preserved between a call hierarchy prepare and
--- incoming calls or outgoing calls requests.
---@field data? LSPAny


---@class CallHierarchyIncomingCallsParams : WorkDoneProgressParams, PartialResultParams 
---@field item CallHierarchyItem


---@class CallHierarchyIncomingCall 
--- The item that makes the call.
---@field from CallHierarchyItem
--- The ranges at which the calls appear. This is relative to the caller
--- denoted by [`this.from`](#CallHierarchyIncomingCall.from).
---@field fromRanges Range[]


---@class CallHierarchyOutgoingCallsParams : WorkDoneProgressParams, PartialResultParams 
---@field item CallHierarchyItem


---@class CallHierarchyOutgoingCall 
--- The item that is called.
---@field to CallHierarchyItem
--- The range at which this item is called. This is the range relative to
--- the caller, e.g., the item passed to `callHierarchy/outgoingCalls` request.
---@field fromRanges Range[]


---@class TypeHierarchyClientCapabilities
--- Whether implementation supports dynamic registration. If this is set to
--- `true` the client supports the new `(TextDocumentRegistrationOptions &
--- StaticRegistrationOptions)` return value for the corresponding server
--- capability as well.
---@field dynamicRegistration? boolean


---@class TypeHierarchyOptions : WorkDoneProgressOptions 


---@class TypeHierarchyRegistrationOptions : TextDocumentRegistrationOptions, TypeHierarchyOptions, StaticRegistrationOptions


---@class TypeHierarchyPrepareParams : TextDocumentPositionParams, WorkDoneProgressParams


---@class TypeHierarchyItem 
--- The name of this item.
---@field name string
--- The kind of this item.
---@field kind SymbolKind
--- Tags for this item.
---@field tags? SymbolTag[]
--- More detail for this item, e.g. the signature of a function.
---@field detail? string
--- The resource identifier of this item.
---@field uri DocumentUri
--- The range enclosing this symbol not including leading/trailing whitespace
--- but everything else, e.g. comments and code.
---@field range Range
--- The range that should be selected and revealed when this symbol is being
--- picked, e.g. the name of a function. Must be contained by the
--- [`range`](#TypeHierarchyItem.range).
---@field selectionRange Range
--- A data entry field that is preserved between a type hierarchy prepare and
--- supertypes or subtypes requests. It could also be used to identify the
--- type hierarchy in the server, helping improve the performance on
--- resolving supertypes and subtypes.
---@field data? LSPAny


---@class TypeHierarchySupertypesParams : WorkDoneProgressParams, PartialResultParams 
---@field item TypeHierarchyItem


---@class TypeHierarchySubtypesParams : WorkDoneProgressParams, PartialResultParams 
---@field item TypeHierarchyItem


---@class DocumentHighlightClientCapabilities 
--- Whether document highlight supports dynamic registration.
---@field dynamicRegistration? boolean


---@class DocumentHighlightOptions : WorkDoneProgressOptions 


---@class DocumentHighlightRegistrationOptions : TextDocumentRegistrationOptions, DocumentHighlightOptions 


---@class DocumentHighlightParams : TextDocumentPositionParams, WorkDoneProgressParams, PartialResultParams


--- A document highlight is a range inside a text document which deserves
--- special attention. Usually a document highlight is visualized by changing
--- the background color of its range.
---
---@class DocumentHighlight
--- The range this highlight applies to.
---@field range Range
--- The highlight kind, default is DocumentHighlightKind.Text.
---@field kind? DocumentHighlightKind


--- A document highlight kind.
---@enum DocumentHighlightKind
M.DocumentHighlightKind = {
    --- A textual occurrence.
    Text = 1,
    --- Read-access of a symbol, like reading a variable.
    Read = 2,
    --- Write-access of a symbol, like writing to a variable.
    Write = 3,
}


---@class DocumentLinkClientCapabilities 
--- Whether document link supports dynamic registration.
---@field dynamicRegistration? boolean
--- Whether the client supports the `tooltip` property on `DocumentLink`.
---
---@since 3.15.0
---@field tooltipSupport? boolean


---@class DocumentLinkOptions : WorkDoneProgressOptions 
--- Document links have a resolve provider as well.
---@field resolveProvider? boolean


---@class DocumentLinkRegistrationOptions : TextDocumentRegistrationOptions, DocumentLinkOptions 


---@class DocumentLinkParams : WorkDoneProgressParams, PartialResultParams
--- The document to provide document links for.
---@field textDocument TextDocumentIdentifier


--- A document link is a range in a text document that links to an internal or
--- external resource, like another text document or a web site.
---@class DocumentLink
--- The range this link applies to.
---@field range Range
--- The URI this link points to. If missing, a resolve request is sent later.
---@field target? URI
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
---@field data? LSPAny


---@class HoverClientCapabilities 
--- Whether hover supports dynamic registration.
---@field dynamicRegistration? boolean
--- Client supports the following content formats if the content
--- property refers to a `literal of type MarkupContent`.
--- The order describes the preferred format of the client.
---@field contentFormat? MarkupKind[]


---@class HoverOptions : WorkDoneProgressOptions 


---@class HoverRegistrationOptions: TextDocumentRegistrationOptions, HoverOptions


---@class HoverParams : TextDocumentPositionParams, WorkDoneProgressParams


--- The result of a hover request.
---@class Hover
--- The hover's content.
---@field contents MarkedString | MarkedString[] | MarkupContent
--- An optional range is a range inside a text document
--- that is used to visualize a hover, e.g. by changing the background color.
---@field range? Range


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
---@alias MarkedString string |  { language: string, value: string }


---@class CodeLensClientCapabilities 
--- Whether code lens supports dynamic registration.
---@field dynamicRegistration? boolean
--- Whether the client supports resolving additional code lens
--- properties via a separate `codeLens/resolve` request.
---
---@since 3.18.0
---@field resolveSupport? ClientCodeLensResolveOptions

---@since 3.18.0
---@class ClientCodeLensResolveOptions
--- The properties that a client can resolve lazily.
---@field properties string[]


---@class CodeLensOptions : WorkDoneProgressOptions 
--- Code lens has a resolve provider as well.
---@field resolveProvider? boolean


---@class CodeLensRegistrationOptions : TextDocumentRegistrationOptions, CodeLensOptions 


---@class CodeLensParams : WorkDoneProgressParams, PartialResultParams 
--- The document to request code lens for.
---@field textDocument TextDocumentIdentifier


--- A code lens represents a command that should be shown along with
--- source text, like the number of references, a way to run tests, etc.
---
--- A code lens is _unresolved_ when no command is associated to it. For
--- performance reasons the creation of a code lens and resolving should be done
--- in two stages.
---@class CodeLens
--- The range in which this code lens is valid. Should only span a single
--- line.
---@field range Range
--- The command this code lens represents.
---@field command? Command
--- A data entry field that is preserved on a code lens item between
--- a code lens and a code lens resolve request.
---@field data? LSPAny


---@class CodeLensWorkspaceClientCapabilities 
--- Whether the client implementation supports a refresh request sent from the
--- server to the client.
---
--- Note that this event is global and will force the client to refresh all
--- code lenses currently shown. It should be used with absolute care and is
--- useful for situation where a server, for example, detects a project wide
--- change that requires such a calculation.
---@field refreshSupport? boolean


---@class FoldingRangeClientCapabilities 
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
---@field foldingRangeKind? { valueSet?: FoldingRangeKind[] }
--- Specific options for the folding range.
---@since 3.17.0
---@field foldingRange? { collapsedText?: boolean }


---@class FoldingRangeOptions : WorkDoneProgressOptions 


---@class FoldingRangeRegistrationOptions : TextDocumentRegistrationOptions, FoldingRangeOptions, StaticRegistrationOptions


---@class FoldingRangeParams : WorkDoneProgressParams, PartialResultParams
--- The text document.
---@field textDocument TextDocumentIdentifier


---@enum FoldingRangeKind
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
---@class FoldingRange
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
---@field kind? FoldingRangeKind
--- The text that the client should show when the specified range is
--- collapsed. If not defined or not supported by the client, a default
--- will be chosen by the client.
---
---@since 3.17.0 - proposed
---@field collapsedText? string


---@class FoldingRangeWorkspaceClientCapabilities 
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


---@class SelectionRangeClientCapabilities 
--- Whether the implementation supports dynamic registration for selection range
--- providers. If this is set to `true`, the client supports the new
--- `SelectionRangeRegistrationOptions` return value for the corresponding
--- server capability as well.
---@field dynamicRegistration? boolean


---@class SelectionRangeOptions : WorkDoneProgressOptions


---@class SelectionRangeRegistrationOptions : SelectionRangeOptions, TextDocumentRegistrationOptions, StaticRegistrationOptions


---@class SelectionRangeParams : WorkDoneProgressParams, PartialResultParams
--- The text document.
---@field textDocument TextDocumentIdentifier
--- The positions inside the text document.
---@field positions Position[]


---@class SelectionRange 
--- The [range](#Range) of this selection range.
---@field range Range
--- The parent selection range containing this range.
--- Therefore, `parent.range` must contain `this.range`.
---@field parent? SelectionRange


---@class DocumentSymbolClientCapabilities 
--- Whether document symbol supports dynamic registration.
---@field dynamicRegistration? boolean
--- Specific capabilities for the `SymbolKind` in the
--- `textDocument/documentSymbol` request.
---@field symbolKind? DocumentSymbolClientCapabilities.ValueSet
--- The client supports hierarchical document symbols.
---@field hierarchicalDocumentSymbolSupport? boolean
--- The client supports tags on `SymbolInformation`. Tags are supported on
--- `DocumentSymbol` if `hierarchicalDocumentSymbolSupport` is set to true.
--- Clients supporting tags have to handle unknown tags gracefully.
---
---@since 3.16.0
---@field tagSupport? { valueSet: SymbolTag[] }
--- The client supports an additional label presented in the UI when
--- registering a document symbol provider.
---
---@since 3.16.0
---@field labelSupport? boolean


---@class DocumentSymbolClientCapabilities.ValueSet
--- The symbol kind values the client supports. When this
--- property exists the client also guarantees that it will
--- handle values outside its set gracefully and falls back
--- to a default value when unknown.
---
--- If this property is not present the client only supports
--- the symbol kinds from `File` to `Array` as defined in
--- the initial version of the protocol.
---@field valueSet? SymbolKind[]


---@class DocumentSymbolOptions : WorkDoneProgressOptions 
--- A human-readable string that is shown when multiple outlines trees
--- are shown for the same document.
---
---@since 3.16.0
---@field label? string


---@class DocumentSymbolRegistrationOptions : TextDocumentRegistrationOptions, DocumentSymbolOptions 


---@class DocumentSymbolParams : WorkDoneProgressParams, PartialResultParams
--- The text document.
---@field textDocument TextDocumentIdentifier


---@enum SymbolKind
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


---@enum SymbolTag
M.SymbolKind = {
    --- Render a symbol as obsolete, usually using a strike-out.
    Deprecated = 1,
}


--- Represents programming constructs like variables, classes, interfaces etc.
--- that appear in a document. Document symbols can be hierarchical and they
--- have two ---@field ranges one that encloses their definition and one that points to
--- their most interesting range, e.g. the range of an identifier.
---@class DocumentSymbol
--- The name of this symbol. Will be displayed in the user interface and
--- therefore must not be an empty string or a string only consisting of
--- white spaces.
---@field name string
--- More detail for this symbol, e.g. the signature of a function.
---@field detail? string
--- The kind of this symbol.
---@field kind SymbolKind
--- Tags for this document symbol.
---
---@since 3.16.0
---@field tags? SymbolTag[]
--- Indicates if this symbol is deprecated.
---
--- @deprecated Use tags instead
---@field deprecated? boolean
--- The range enclosing this symbol not including leading/trailing whitespace
--- but everything else, like comments. This information is typically used to
--- determine if the client's cursor is inside the symbol to reveal the
--- symbol in the UI.
---@field range Range
--- The range that should be selected and revealed when this symbol is being
--- picked, e.g. the name of a function. Must be contained by the `range`.
---@field selectionRange Range
--- Children of this symbol, e.g. properties of a class.
---@field children? DocumentSymbol[]


--- Represents information about programming constructs like variables, classes,
--- interfaces etc.
---
--- @deprecated use DocumentSymbol or WorkspaceSymbol instead.
---@class SymbolInformation
--- The name of this symbol.
---@field name string
--- The kind of this symbol.
---@field kind SymbolKind
--- Tags for this symbol.
---
---@since 3.16.0
---@field tags? SymbolTag[]
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
---@field location Location
--- The name of the symbol containing this symbol. This information is for
--- user interface purposes (e.g. to render a qualifier in the user interface
--- if necessary). It can't be used to re-infer a hierarchy for the document
--- symbols.
---@field containerName? string


---@enum SemanticTokenTypes
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


---@enum SemanticTokenModifiers
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


---@enum TokenFormat
M.TokenFormat = {
    Relative = 'relative',
}


---@class SemanticTokensLegend
--- The token types a server uses.
---@field tokenTypes string[]
--- The token modifiers a server uses.
---@field tokenModifiers string[]


---@class SemanticTokensClientCapabilities
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
---@field requests SemanticTokensClientCapabilities.Requests
--- The token types that the client supports.
---@field tokenTypes string[]
--- The token modifiers that the client supports.
---@field tokenModifiers string[]
--- The formats the client supports.
---@field formats TokenFormat[]
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


---@class SemanticTokensClientCapabilities.Requests
--- The client will send the `textDocument/semanticTokens/range` request
--- if the server provides a corresponding handler.
---@field range? boolean | { }
--- The client will send the `textDocument/semanticTokens/full` request
--- if the server provides a corresponding handler.
---@field full? boolean | { delta?: boolean }


---@class SemanticTokensOptions : WorkDoneProgressOptions 
--- The legend used by the server.
---@field legend SemanticTokensLegend
--- Server supports providing semantic tokens for a specific range
--- of a document.
---@field range? boolean | { }
--- Server supports providing semantic tokens for a full document.
---@field full? boolean | { delta?: boolean}


---@class SemanticTokensRegistrationOptions : TextDocumentRegistrationOptions, SemanticTokensOptions, StaticRegistrationOptions


---@class SemanticTokensParams : WorkDoneProgressParams, PartialResultParams
--- The text document.
---@field textDocument TextDocumentIdentifier


---@class SemanticTokens
--- An optional result ID. If provided and clients support delta updating,
--- the client will include the result ID in the next semantic token request.
--- A server can then, instead of computing all semantic tokens again, simply
--- send a delta.
---@field resultId? string
--- The actual tokens.
---@field data uinteger[]


---@class SemanticTokensPartialResult
---@field data uinteger[]


---@class SemanticTokensDeltaParams : WorkDoneProgressParams, PartialResultParams
--- The text document.
---@field textDocument TextDocumentIdentifier
--- The result ID of a previous response. The result ID can either point to
--- a full response or a delta response, depending on what was received last.
---@field previousResultId string


---@class SemanticTokensDelta
---@field resultId? string
--- The semantic token edits to transform a previous result into a new
--- result.
---@field edits SemanticTokensEdit[]


---@class SemanticTokensEdit
--- The start offset of the edit.
---@field start uinteger
--- The count of elements to remove.
---@field deleteCount uinteger
--- The elements to insert.
---@field data? uinteger[]


---@class SemanticTokensDeltaPartialResult
---@field edits SemanticTokensEdit[]


---@class SemanticTokensRangeParams : WorkDoneProgressParams, PartialResultParams
--- The text document.
---@field textDocument TextDocumentIdentifier
--- The range the semantic tokens are requested for.
---@field range Range


---@class SemanticTokensWorkspaceClientCapabilities
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
---@class InlayHintClientCapabilities
--- Whether inlay hints support dynamic registration.
---@field dynamicRegistration? boolean
--- Indicates which properties a client can resolve lazily on an inlay
--- hint.
---@field resolveSupport? { properties: string[] }


--- Inlay hint options used during static registration.
---
---@since 3.17.0
---@class InlayHintOptions : WorkDoneProgressOptions
--- The server provides support to resolve additional
--- information for an inlay hint item.
---@field resolveProvider? boolean


--- Inlay hint options used during static or dynamic registration.
---
---@since 3.17.0
---@class InlayHintRegistrationOptions : InlayHintOptions, TextDocumentRegistrationOptions, StaticRegistrationOptions


--- A parameter literal used in inlay hint requests.
---
---@since 3.17.0
---@class InlayHintParams : WorkDoneProgressParams
--- The text document.
---@field textDocument TextDocumentIdentifier
--- The visible document range for which inlay hints should be computed.
---@field range Range


--- Inlay hint information.
---
---@since 3.17.0
---@class InlayHint
--- The position of this hint.
---
--- If multiple hints have the same position, they will be shown in the order
--- they appear in the response.
---@field position Position
--- The label of this hint. A human readable string or an array of
--- InlayHintLabelPart label parts.
---
------Note--- that neither the string nor the label part can be empty.
---@field label string | InlayHintLabelPart[]
--- The kind of this hint. Can be omitted in which case the client
--- should fall back to a reasonable default.
---@field kind? InlayHintKind
--- Optional text edits that are performed when accepting this inlay hint.
---
------Note--- that edits are expected to change the document so that the inlay
--- hint (or its nearest variant) is now part of the document and the inlay
--- hint itself is now obsolete.
---
--- Depending on the client capability `inlayHint.resolveSupport`,
--- clients might resolve this property late using the resolve request.
---@field textEdits? TextEdit[]
--- The tooltip text when you hover over this item.
---
--- Depending on the client capability `inlayHint.resolveSupport` clients
--- might resolve this property late using the resolve request.
---@field tooltip? string | MarkupContent
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
---@field data? LSPAny


--- An inlay hint label part allows for interactive and composite labels
--- of inlay hints.
---
---@since 3.17.0
---@class InlayHintLabelPart
--- The value of this label part.
---@field value string
--- The tooltip text when you hover over this label part. Depending on
--- the client capability `inlayHint.resolveSupport`, clients might resolve
--- this property late using the resolve request.
---@field tooltip? string | MarkupContent
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
---@field location? Location
--- An optional command for this label part.
---
--- Depending on the client capability `inlayHint.resolveSupport`, clients
--- might resolve this property late using the resolve request.
---@field command? Command


---@enum InlayHintKind
M.InlayHintKind = {
    Type = 1,
    Parameter = 2,
}


--- Client workspace capabilities specific to inlay hints.
---
---@since 3.17.0
---@class InlayHintWorkspaceClientCapabilities
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
---@class InlineValueClientCapabilities
--- Whether the implementation supports dynamic registration for inline
--- value providers.
---@field dynamicRegistration? boolean


--- Inline value options used during static registration.
---
---@since 3.17.0
---@class InlineValueOptions : WorkDoneProgressOptions


--- Inline value options used during static or dynamic registration.
---
---@since 3.17.0
---@class InlineValueRegistrationOptions : InlineValueOptions, TextDocumentRegistrationOptions, StaticRegistrationOptions


--- A parameter literal used in inline value requests.
---
---@since 3.17.0
---@class InlineValueParams : WorkDoneProgressParams
--- The text document.
---@field textDocument TextDocumentIdentifier
--- The document range for which inline values should be computed.
---@field range Range
--- Additional information about the context in which inline values were
--- requested.
---@field context InlineValueContext


---@since 3.17.0
---@class InlineValueContext
--- The stack frame (as a DAP ID) where the execution has stopped.
---@field frameId integer
--- The document range where execution has stopped.
--- Typically, the end position of the range denotes the line where the
--- inline values are shown.
---@field stoppedLocation Range


--- Provide inline value as text.
---
---@since 3.17.0
---@class InlineValueText
--- The document range for which the inline value applies.
---@field range Range
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
---@class InlineValueVariableLookup
--- The document range for which the inline value applies.
--- The range is used to extract the variable name from the underlying
--- document.
---@field range Range
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
---@class InlineValueEvaluatableExpression
--- The document range for which the inline value applies.
--- The range is used to extract the evaluatable expression from the
--- underlying document.
---@field range Range
--- If specified the expression overrides the extracted expression.
---@field expression? string


--- Inline value information can be provided by different means:
--- - directly as a text value (class InlineValueText).
--- - as a name to use for a variable lookup (class InlineValueVariableLookup)
--- - as an evaluatable expression (class InlineValueEvaluatableExpression)
--- The InlineValue types combines all inline value types into one type.
---
---@since 3.17.0
---@alias InlineValue InlineValueText | InlineValueVariableLookup | InlineValueEvaluatableExpression


--- Client workspace capabilities specific to inline values.
---
---@since 3.17.0
---@class InlineValueWorkspaceClientCapabilities
--- Whether the client implementation supports a refresh request sent from
--- the server to the client.
---
--- Note that this event is global and will force the client to refresh all
--- inline values currently shown. It should be used with absolute care and
--- is useful for situations where a server, for example, detects a project
--- wide change that requires such a calculation.
---@field refreshSupport? boolean


---@class MonikerClientCapabilities
--- Whether implementation supports dynamic registration. If this is set to
--- `true`, the client supports the new `(TextDocumentRegistrationOptions &
--- StaticRegistrationOptions)` return value for the corresponding server
--- capability as well.
---@field dynamicRegistration? boolean


---@class MonikerOptions : WorkDoneProgressOptions 


---@class MonikerRegistrationOptions : TextDocumentRegistrationOptions, MonikerOptions


---@class MonikerParams : TextDocumentPositionParams, WorkDoneProgressParams, PartialResultParams


--- Moniker uniqueness level to define scope of the moniker.
---@enum UniquenessLevel
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
    global = 'global',
}


---@enum MonikerKind
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
---@class Moniker
--- The scheme of the moniker. For example, `tsc` or `.NET`.
---@field scheme string
--- The identifier of the moniker. The value is opaque in LSIF, however
--- schema owners are allowed to define the structure if they want.
---@field identifier string
--- The scope in which the moniker is unique.
---@field unique UniquenessLevel
--- The moniker kind if known.
---@field kind? MonikerKind


---@class CompletionClientCapabilities
--- Whether completion supports dynamic registration.
---@field dynamicRegistration? boolean
--- The client supports the following `CompletionItem` specific
--- capabilities.
---@field completionItem? CompletionClientCapabilities.CompletionItem
---@field completionItemKind? CompletionClientCapabilities.CompletionItemKind
--- The client supports sending additional context information for a
--- `textDocument/completion` request.
---@field contextSupport? boolean
--- The client's default when the completion item doesn't provide an
--- `insertTextMode` property.
---
---@since 3.17.0
---@field insertTextMode? InsertTextMode
--- The client supports the following `CompletionList` specific
--- capabilities.
---
---@since 3.17.0
---@field completionList? CompletionClientCapabilities.CompletionList


---@class CompletionClientCapabilities.CompletionItem
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
---@field documentationFormat? MarkupKind[]
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
---@field tagSupport? { valueSet: CompletionItemTag[] }
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
---@field insertTextModeSupport? { valueSet: InsertTextMode[] }
--- The client has support for completion item label
--- details (see also `CompletionItemLabelDetails`).
---
---@since 3.17.0
---@field labelDetailsSupport? boolean


---@class CompletionClientCapabilities.CompletionItemKind
--- The completion item kind values the client supports. When this
--- property exists, the client also guarantees that it will
--- handle values outside its set gracefully and falls back
--- to a default value when unknown.
---
--- If this property is not present, the client only supports
--- the completion item kinds from `Text` to `Reference` as defined in
--- the initial version of the protocol.
---@field valueSet? CompletionItemKind[]


---@class CompletionClientCapabilities.CompletionList
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
---@class CompletionOptions : WorkDoneProgressOptions
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
---@field completionItem? CompletionOptions.CompletionItem


---@class CompletionOptions.CompletionItem
--- The server has support for completion item label
--- details (see also `CompletionItemLabelDetails`) when receiving
--- a completion item in a resolve call.
---
---@since 3.17.0
---@field labelDetailsSupport? boolean


---@class CompletionRegistrationOptions : TextDocumentRegistrationOptions, CompletionOptions 


---@class CompletionParams : TextDocumentPositionParams, WorkDoneProgressParams, PartialResultParams
--- The completion context. This is only available if the client specifies
--- to send this using the client capability
--- `completion.contextSupport === true`
---@field context? CompletionContext


---@enum CompletionTriggerKind
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
---@class CompletionContext
--- How the completion was triggered.
---@field triggerKind CompletionTriggerKind
--- The trigger character (a single character) that
--- has triggered code complete. Is undefined if
--- `triggerKind !== CompletionTriggerKind.TriggerCharacter`
---@field triggerCharacter? string


--- Represents a collection of [completion items](#CompletionItem) to be
--- presented in the editor.
---@class CompletionList
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
---@field itemDefaults? CompletionList.ItemDefaults
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
---@field applyKind? CompletionList.ApplyKind
--- The completion items.
---@field items CompletionItem[]


---@class CompletionList.ItemDefaults
--- A default commit character set.
---
---@since 3.17.0
---@field commitCharacters? string[]
--- A default edit range.
---
---@since 3.17.0
---@field editRange? Range | { insert: Range, replace: Range }
--- A default insert text format.
---
---@since 3.17.0
---@field insertTextFormat? InsertTextFormat
--- A default insert text mode.
---
---@since 3.17.0
---@field insertTextMode? InsertTextMode
--- A default data value.
---
---@since 3.17.0
---@field data? LSPAny


---@class CompletionList.ApplyKind
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
---@field commitCharacters? ApplyKind
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
---@field data? ApplyKind


--- Defines whether the insert text in a completion item should be interpreted as
--- plain text or a snippet.
---@enum InsertTextFormat
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
---@enum CompletionItemTag
M.CompletionItemTag = {
    --- Render a completion as obsolete, usually using a strike-out.
    Deprecated = 1,
}


--- A special text edit to provide an insert and a replace operation.
---
---@since 3.16.0
---@class InsertReplaceEdit
--- The string to be inserted.
---@field newText string
--- The range if the insert is requested.
---@field insert Range
--- The range if the replace is requested.
---@field replace Range


--- How whitespace and indentation is handled during completion
--- item insertion.
---
---@since 3.16.0
---@enum InsertTextMode
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
---@class CompletionItemLabelDetails
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
---@enum ApplyKind
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


---@class CompletionItem
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
---@field labelDetails? CompletionItemLabelDetails
--- The kind of this completion item. Based on the kind,
--- an icon is chosen by the editor. The standardized set
--- of available values is defined in `CompletionItemKind`.
---@field kind? CompletionItemKind
--- Tags for this completion item.
---
---@since 3.15.0
---@field tags? CompletionItemTag[]
--- A human-readable string with additional information
--- about this item, like type or symbol information.
---@field detail? string
--- A human-readable string that represents a doc-comment.
---@field documentation? string | MarkupContent
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
---@field insertTextFormat? InsertTextFormat
--- How whitespace and indentation is handled during completion
--- item insertion. If not provided, the client's default value depends on
--- the `textDocument.completion.insertTextMode` client capability.
---
---@since 3.16.0
---@since 3.17.0 - support for `textDocument.completion.insertTextMode`
---@field insertTextMode? InsertTextMode
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
---@field textEdit? TextEdit | InsertReplaceEdit
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
---@field additionalTextEdits? TextEdit[]
--- An optional set of characters that, when pressed while this completion is
--- active, will accept it first and then type that character.---Note--- that all
--- commit characters should have `length=1` and that superfluous characters
--- will be ignored.
---@field commitCharacters? string[]
--- An optional command that is executed---after--- inserting this completion.
------Note--- that additional modifications to the current document should be
--- described with the additionalTextEdits-property.
---@field command? Command
--- A data entry field that is preserved on a completion item between
--- a completion and a completion resolve request.
---@field data? LSPAny


--- The kind of a completion entry.
---@enum CompletionItemKind
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


---@class PublishDiagnosticsClientCapabilities
--- Whether the clients accepts diagnostics with related information.
---@field relatedInformation? boolean
--- Client supports the tag property to provide meta data about a diagnostic.
--- Clients supporting tags have to handle unknown tags gracefully.
---
---@since 3.15.0
---@field tagSupport? { valueSet: DiagnosticTag[] }
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


---@class PublishDiagnosticsParams
--- The URI for which diagnostic information is reported.
---@field uri DocumentUri
--- Optionally, the version number of the document the diagnostics are
--- published for.
---
---@since 3.15.0
---@field version? integer
--- An array of diagnostic information items.
---@field diagnostics Diagnostic[]


--- Client capabilities specific to diagnostic pull requests.
---
---@since 3.17.0
---@class DiagnosticClientCapabilities
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
---@class DiagnosticOptions : WorkDoneProgressOptions
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
---@class DiagnosticRegistrationOptions : TextDocumentRegistrationOptions, DiagnosticOptions, StaticRegistrationOptions


--- Parameters of the document diagnostic request.
---
---@since 3.17.0
---@class DocumentDiagnosticParams : WorkDoneProgressParams, PartialResultParams
--- The text document.
---@field textDocument TextDocumentIdentifier
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
---@alias DocumentDiagnosticReport RelatedFullDocumentDiagnosticReport | RelatedUnchangedDocumentDiagnosticReport


--- The document diagnostic report kinds.
---
---@since 3.17.0
---@enum DocumentDiagnosticReportKind
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
---@class FullDocumentDiagnosticReport
--- A full document diagnostic report.
---@field kind DocumentDiagnosticReportKind.Full
--- An optional result ID. If provided, it will
--- be sent on the next diagnostic request for the
--- same document.
---@field resultId? string
--- The actual items.
---@field items Diagnostic[]


--- A diagnostic report indicating that the last returned
--- report is still accurate.
---
---@since 3.17.0
---@class UnchangedDocumentDiagnosticReport
--- A document diagnostic report indicating
--- no changes to the last result. A server can
--- only return `unchanged` if result IDs are
--- provided.
---@field kind DocumentDiagnosticReportKind.Unchanged
--- A result ID which will be sent on the next
--- diagnostic request for the same document.
---@field resultId string


--- A full diagnostic report with a set of related documents.
---
---@since 3.17.0
---@class RelatedFullDocumentDiagnosticReport : FullDocumentDiagnosticReport
--- Diagnostics of related documents. This information is useful
--- in programming languages where code in a file A can generate
--- diagnostics in a file B which A depends on. An example of
--- such a language is C/C++, where macro definitions in a file
--- a.cpp can result in errors in a header file b.hpp.
---
---@since 3.17.0
---@field relatedDocuments? { [string]: FullDocumentDiagnosticReport | UnchangedDocumentDiagnosticReport }


--- An unchanged diagnostic report with a set of related documents.
---
---@since 3.17.0
---@class RelatedUnchangedDocumentDiagnosticReport : UnchangedDocumentDiagnosticReport
--- Diagnostics of related documents. This information is useful
--- in programming languages where code in a file A can generate
--- diagnostics in a file B which A depends on. An example of
--- such a language is C/C++, where macro definitions in a file
--- a.cpp can result in errors in a header file b.hpp.
---
---@since 3.17.0
---@field relatedDocuments? { [string]: FullDocumentDiagnosticReport | UnchangedDocumentDiagnosticReport }


--- A partial result for a document diagnostic report.
---
---@since 3.17.0
---@class DocumentDiagnosticReportPartialResult
---@field relatedDocuments { [string]: FullDocumentDiagnosticReport | UnchangedDocumentDiagnosticReport }


--- Cancellation data returned from a diagnostic request.
---
---@since 3.17.0
---@class DiagnosticServerCancellationData
---@field retriggerRequest boolean

return M
