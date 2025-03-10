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

return M
