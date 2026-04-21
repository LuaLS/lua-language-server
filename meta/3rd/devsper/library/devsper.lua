---@meta devsper

--- Result returned by devsper.exec().
---@class devsper.ExecResult
---@field code    integer  Exit code of the process.
---@field stdout  string   Standard output captured from the process.
---@field stderr  string   Standard error captured from the process.

--- HTTP response returned by devsper.http methods.
---@class devsper.HttpResponse
---@field status  integer               HTTP status code (e.g. 200, 404).
---@field body    string                Response body as a string.
---@field headers table<string,string>  Response headers keyed by header name.

---@class devsper.HttpLib
---Fetch a URL and return the response.
---@field get  fun(url: string, opts?: { headers?: table<string,string>, timeout?: integer }): devsper.HttpResponse
---Perform an HTTP POST request.
---@field post fun(url: string, body: string|table, opts?: { headers?: table<string,string>, timeout?: integer }): devsper.HttpResponse

--- Context object passed to tool run functions.
---@class devsper.ToolCtx
---@field workflow_id string  ID of the parent workflow.
---@field run_id      string  ID of the current run.
local ToolCtx = {}

--- Emit a structured log message from within a tool.
---@param level "debug"|"info"|"warn"|"error"  Log level.
---@param msg   string  Log message text.
function ToolCtx:log(level, msg) end

--- Parameter specification for a tool parameter.
---@class devsper.ParamSpec
---@field type     "string"|"number"|"boolean"|"object"  JSON-schema-style type.
---@field required boolean?                              Whether the parameter is required. Defaults to false.
---@field default  any?                                  Default value when the parameter is omitted.

--- Configuration for the evolutionary/speculative execution engine.
---@class devsper.EvolutionConfig
---@field allow_mutations boolean?  Allow the swarm to mutate task prompts at runtime. Defaults to false.
---@field max_depth       integer?  Maximum recursion/mutation depth. Defaults to 3.
---@field speculative     boolean?  Enable speculative (parallel branch) execution. Defaults to false.

--- Top-level configuration passed to devsper.workflow().
---@class devsper.WorkflowConfig
---@field name      string                                    Human-readable workflow name (required).
---@field model     string?                                   Default LLM model ID for tasks in this workflow.
---@field workers   integer?                                  Number of parallel worker goroutines/processes.
---@field bus       "memory"|"redis"|"kafka"?                 Message bus backend. Defaults to "memory".
---@field evolution devsper.EvolutionConfig?                  Optional evolutionary execution configuration.

--- Specification for a single workflow task.
---@class devsper.TaskSpec
---@field prompt     string    Prompt sent to the LLM for this task (required).
---@field model      string?   Override the workflow-level model for this task.
---@field can_mutate boolean?  Allow this task's prompt to be mutated by the evolution engine.
---@field depends_on? (string|"*")[]  Task IDs that must complete first. Use "*" to depend on all other tasks.

--- Specification for a workflow plugin.
---@class devsper.PluginSpec
---@field source string  Path or import specifier for the plugin module (required).

--- Specification for a workflow input parameter.
---@class devsper.InputSpec
---@field type     "string"|"number"|"boolean"|"object"?  Type of the input value.
---@field required boolean?                               Whether this input must be supplied at run time.
---@field default  any?                                   Default value used when the input is not supplied.

--- Specification passed to devsper.tool().
---@class devsper.ToolSpec
---@field description string                                     Human-readable description of the tool (required).
---@field params      table<string, devsper.ParamSpec>?          Map of parameter name to its spec.
---@field run         fun(ctx: devsper.ToolCtx, args: table): any, string?  Tool implementation (required). Returns a result and an optional error string.

--- Fluent builder returned by devsper.workflow().
---@class devsper.WorkflowBuilder
local WorkflowBuilder = {}

--- Register a task in the workflow.
---@param id   string            Unique task identifier within the workflow.
---@param spec devsper.TaskSpec  Task configuration.
---@return devsper.WorkflowBuilder  Returns the builder for chaining.
function WorkflowBuilder:task(id, spec) end

--- Register a plugin in the workflow.
---@param name string              Plugin name used to reference it within tasks.
---@param spec devsper.PluginSpec  Plugin configuration.
---@return devsper.WorkflowBuilder  Returns the builder for chaining.
function WorkflowBuilder:plugin(name, spec) end

--- Declare an input parameter for the workflow.
---@param name string             Input parameter name.
---@param spec devsper.InputSpec  Input specification.
---@return devsper.WorkflowBuilder  Returns the builder for chaining.
function WorkflowBuilder:input(name, spec) end

--- The devsper global injected into every .devsper file.
---@class devsper
---@field http devsper.HttpLib  HTTP client for use inside tools or workflows.
devsper = {}

--- Define and register a workflow. Returns a builder for adding tasks, plugins, and inputs.
---@param config devsper.WorkflowConfig  Top-level workflow configuration.
---@return devsper.WorkflowBuilder
function devsper.workflow(config) end

--- Define and register a tool that the swarm can invoke.
---@param name string           Unique tool name.
---@param spec devsper.ToolSpec Tool specification including description, params, and run function.
---@return nil
function devsper.tool(name, spec) end

--- Execute a subprocess and return its result.
---@param cmd  string    Executable to run.
---@param args string[]? Arguments to pass to the executable.
---@return devsper.ExecResult
function devsper.exec(cmd, args) end

--- Emit a structured log message at the workflow/global level.
---@param level "debug"|"info"|"warn"|"error"  Log level.
---@param msg   string  Log message text.
function devsper.log(level, msg) end
