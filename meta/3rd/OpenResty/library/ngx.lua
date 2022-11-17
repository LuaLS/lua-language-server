---@meta

---@class ngx : table
---
--- The `ngx.null` constant is a `NULL` light userdata usually used to represent nil values in Lua tables etc and is similar to the `lua-cjson` library's `cjson.null` constant.
---@field null userdata
---
--- Read and write the current request's response status. This should be called
--- before sending out the response headers.
---
--- ```lua
---  -- set
---  ngx.status = ngx.HTTP_CREATED
---  -- get
---  status = ngx.status
--- ```
---
--- Setting `ngx.status` after the response header is sent out has no effect but leaving an error message in your NGINX's error log file:
---   attempt to set ngx.status after sending out response headers
---@field status ngx.http.status_code
---
--- Returns `true` if the response headers have been sent (by ngx_lua), and `false` otherwise.
---
---@field headers_sent boolean
---
--- Returns `true` if the current request is an NGINX subrequest, or `false` otherwise.
---@field is_subrequest boolean
---
ngx = {}

---@class ngx.OK
ngx.OK       = 0
---@class ngx.ERROR
ngx.ERROR    = -1
ngx.AGAIN    = -2
ngx.DONE     = -4
ngx.DECLINED = -5

ngx.HTTP_GET       = 2
ngx.HTTP_HEAD      = 4
ngx.HTTP_POST      = 8
ngx.HTTP_PUT       = 16
ngx.HTTP_DELETE    = 32
ngx.HTTP_MKCOL     = 64
ngx.HTTP_COPY      = 128
ngx.HTTP_MOVE      = 256
ngx.HTTP_OPTIONS   = 512
ngx.HTTP_PROPFIND  = 1024
ngx.HTTP_PROPPATCH = 2048
ngx.HTTP_LOCK      = 4096
ngx.HTTP_UNLOCK    = 8192
ngx.HTTP_PATCH     = 16384
ngx.HTTP_TRACE     = 32768

---@alias ngx.http.method
---| `ngx.HTTP_GET`
---| `ngx.HTTP_HEAD`
---| `ngx.HTTP_POST`
---| `ngx.HTTP_PUT`
---| `ngx.HTTP_DELETE`
---| `ngx.HTTP_MKCOL`
---| `ngx.HTTP_COPY`
---| `ngx.HTTP_MOVE`
---| `ngx.HTTP_OPTIONS`
---| `ngx.HTTP_PROPFIND`
---| `ngx.HTTP_PROPPATCH`
---| `ngx.HTTP_LOCK`
---| `ngx.HTTP_UNLOCK`
---| `ngx.HTTP_PATCH`
---| `ngx.HTTP_TRACE`

ngx.HTTP_CONTINUE               = 100
ngx.HTTP_SWITCHING_PROTOCOLS    = 101
ngx.HTTP_OK                     = 200
ngx.HTTP_CREATED                = 201
ngx.HTTP_ACCEPTED               = 202
ngx.HTTP_NO_CONTENT             = 204
ngx.HTTP_PARTIAL_CONTENT        = 206
ngx.HTTP_SPECIAL_RESPONSE       = 300
ngx.HTTP_MOVED_PERMANENTLY      = 301
ngx.HTTP_MOVED_TEMPORARILY      = 302
ngx.HTTP_SEE_OTHER              = 303
ngx.HTTP_NOT_MODIFIED           = 304
ngx.HTTP_TEMPORARY_REDIRECT     = 307
ngx.HTTP_PERMANENT_REDIRECT     = 308
ngx.HTTP_BAD_REQUEST            = 400
ngx.HTTP_UNAUTHORIZED           = 401
ngx.HTTP_PAYMENT_REQUIRED       = 402
ngx.HTTP_FORBIDDEN              = 403
ngx.HTTP_NOT_FOUND              = 404
ngx.HTTP_NOT_ALLOWED            = 405
ngx.HTTP_NOT_ACCEPTABLE         = 406
ngx.HTTP_REQUEST_TIMEOUT        = 408
ngx.HTTP_CONFLICT               = 409
ngx.HTTP_GONE                   = 410
ngx.HTTP_UPGRADE_REQUIRED       = 426
ngx.HTTP_TOO_MANY_REQUESTS      = 429
ngx.HTTP_CLOSE                  = 444
ngx.HTTP_ILLEGAL                = 451
ngx.HTTP_INTERNAL_SERVER_ERROR  = 500
ngx.HTTP_METHOD_NOT_IMPLEMENTED = 501
ngx.HTTP_BAD_GATEWAY            = 502
ngx.HTTP_SERVICE_UNAVAILABLE    = 503
ngx.HTTP_GATEWAY_TIMEOUT        = 504
ngx.HTTP_VERSION_NOT_SUPPORTED  = 505
ngx.HTTP_INSUFFICIENT_STORAGE   = 507

---@alias ngx.http.status_code
---| integer
---| `ngx.HTTP_CONTINUE`
---| `ngx.HTTP_SWITCHING_PROTOCOLS`
---| `ngx.HTTP_OK`
---| `ngx.HTTP_CREATED`
---| `ngx.HTTP_ACCEPTED`
---| `ngx.HTTP_NO_CONTENT`
---| `ngx.HTTP_PARTIAL_CONTENT`
---| `ngx.HTTP_SPECIAL_RESPONSE`
---| `ngx.HTTP_MOVED_PERMANENTLY`
---| `ngx.HTTP_MOVED_TEMPORARILY`
---| `ngx.HTTP_SEE_OTHER`
---| `ngx.HTTP_NOT_MODIFIED`
---| `ngx.HTTP_TEMPORARY_REDIRECT`
---| `ngx.HTTP_PERMANENT_REDIRECT`
---| `ngx.HTTP_BAD_REQUEST`
---| `ngx.HTTP_UNAUTHORIZED`
---| `ngx.HTTP_PAYMENT_REQUIRED`
---| `ngx.HTTP_FORBIDDEN`
---| `ngx.HTTP_NOT_FOUND`
---| `ngx.HTTP_NOT_ALLOWED`
---| `ngx.HTTP_NOT_ACCEPTABLE`
---| `ngx.HTTP_REQUEST_TIMEOUT`
---| `ngx.HTTP_CONFLICT`
---| `ngx.HTTP_GONE`
---| `ngx.HTTP_UPGRADE_REQUIRED`
---| `ngx.HTTP_TOO_MANY_REQUESTS`
---| `ngx.HTTP_CLOSE`
---| `ngx.HTTP_ILLEGAL`
---| `ngx.HTTP_INTERNAL_SERVER_ERROR`
---| `ngx.HTTP_METHOD_NOT_IMPLEMENTED`
---| `ngx.HTTP_BAD_GATEWAY`
---| `ngx.HTTP_SERVICE_UNAVAILABLE`
---| `ngx.HTTP_GATEWAY_TIMEOUT`
---| `ngx.HTTP_VERSION_NOT_SUPPORTED`
---| `ngx.HTTP_INSUFFICIENT_STORAGE`


ngx.DEBUG  = 8
ngx.INFO   = 7
ngx.NOTICE = 6
ngx.WARN   = 5
ngx.ERR    = 4
ngx.CRIT   = 3
ngx.ALERT  = 2
ngx.EMERG  = 1
ngx.STDERR = 0

--- NGINX log level constants
--- https://github.com/openresty/lua-nginx-module/#nginx-log-level-constants
---@alias ngx.log.level
---| `ngx.DEBUG`  # debug
---| `ngx.INFO`   # info
---| `ngx.NOTICE` # notice
---| `ngx.WARN`   # warning
---| `ngx.ERR`    # error
---| `ngx.ALERT`  # alert
---| `ngx.CRIT`   # critical
---| `ngx.EMERG`  # emergency
---| `ngx.STDERR` # standard error


--- ngx.ctx table
---
--- This table can be used to store per-request Lua context data and has a life time identical to the current request (as with the NGINX variables).
---
--- Consider the following example,
---
--- ```nginx
---  location /test {
---      rewrite_by_lua_block {
---          ngx.ctx.foo = 76
---      }
---      access_by_lua_block {
---          ngx.ctx.foo = ngx.ctx.foo + 3
---      }
---      content_by_lua_block {
---          ngx.say(ngx.ctx.foo)
---      }
---  }
--- ```
---
--- Then `GET /test` will yield the output
---
--- ```bash
---  79
--- ```
---
--- That is, the `ngx.ctx.foo` entry persists across the rewrite, access, and content phases of a request.
---
--- Every request, including subrequests, has its own copy of the table. For example:
---
--- ```nginx
---  location /sub {
---      content_by_lua_block {
---          ngx.say("sub pre: ", ngx.ctx.blah)
---          ngx.ctx.blah = 32
---          ngx.say("sub post: ", ngx.ctx.blah)
---      }
---  }
---
---  location /main {
---      content_by_lua_block {
---          ngx.ctx.blah = 73
---          ngx.say("main pre: ", ngx.ctx.blah)
---          local res = ngx.location.capture("/sub")
---          ngx.print(res.body)
---          ngx.say("main post: ", ngx.ctx.blah)
---      }
---  }
--- ```
---
--- Then `GET /main` will give the output
---
--- ```bash
---  main pre: 73
---  sub pre: nil
---  sub post: 32
---  main post: 73
--- ```
---
--- Here, modification of the `ngx.ctx.blah` entry in the subrequest does not affect the one in the parent request. This is because they have two separate versions of `ngx.ctx.blah`.
---
--- Internal redirection will destroy the original request `ngx.ctx` data (if any) and the new request will have an empty `ngx.ctx` table. For instance,
---
--- ```nginx
---  location /new {
---      content_by_lua_block {
---          ngx.say(ngx.ctx.foo)
---      }
---  }
---
---  location /orig {
---      content_by_lua_block {
---          ngx.ctx.foo = "hello"
---          ngx.exec("/new")
---      }
---  }
--- ```
---
--- Then `GET /orig` will give
---
--- ```bash
---  nil
--- ```
---
--- rather than the original `"hello"` value.
---
--- Arbitrary data values, including Lua closures and nested tables, can be inserted into this "magic" table. It also allows the registration of custom meta methods.
---
--- Overriding `ngx.ctx` with a new Lua table is also supported, for example,
---
--- ```lua
---  ngx.ctx = { foo = 32, bar = 54 }
--- ```
---
--- When being used in the context of `init_worker_by_lua*`, this table just has the same lifetime of the current Lua handler.
---
--- The `ngx.ctx` lookup requires relatively expensive metamethod calls and it is much slower than explicitly passing per-request data along by your own function arguments. So do not abuse this API for saving your own function arguments because it usually has quite some performance impact.
---
--- Because of the metamethod magic, never "local" the `ngx.ctx` table outside your Lua function scope on the Lua module level due to `worker-level data sharing`. For example, the following is bad:
---
--- ```lua
---  -- mymodule.lua
---  local _M = {}
---
---  -- the following line is bad since ngx.ctx is a per-request
---  -- data while this <code>ctx</code> variable is on the Lua module level
---  -- and thus is per-nginx-worker.
---  local ctx = ngx.ctx
---
---  function _M.main()
---      ctx.foo = "bar"
---  end
---
---  return _M
--- ```
---
--- Use the following instead:
---
--- ```lua
---  -- mymodule.lua
---  local _M = {}
---
---  function _M.main(ctx)
---      ctx.foo = "bar"
---  end
---
---  return _M
--- ```
---
--- That is, let the caller pass the `ctx` table explicitly via a function argument.
ngx.ctx = {}

--- NGINX thread methods
ngx.thread = {}

---@class ngx.thread : thread

--- Kills a running "light thread" created by `ngx.thread.spawn`. Returns a true value when successful or `nil` and a string describing the error otherwise.
---
--- According to the current implementation, only the parent coroutine (or "light thread") can kill a thread. Also, a running "light thread" with pending NGINX subrequests (initiated by `ngx.location.capture` for example) cannot be killed due to a limitation in the NGINX core.
---
---@param thread ngx.thread
---@return boolean ok
---@return string? error
function ngx.thread.kill(thread) end

--- Waits on one or more child "light threads" and returns the results of the first "light thread" that terminates (either successfully or with an error).
---
--- The arguments `thread1`, `thread2`, and etc are the Lua thread objects returned by earlier calls of `ngx.thread.spawn`.
---
--- The return values have exactly the same meaning as `coroutine.resume`, that is, the first value returned is a boolean value indicating whether the "light thread" terminates successfully or not, and subsequent values returned are the return values of the user Lua function that was used to spawn the "light thread" (in case of success) or the error object (in case of failure).
---
--- Only the direct "parent coroutine" can wait on its child "light thread", otherwise a Lua exception will be raised.
---
--- The following example demonstrates the use of `ngx.thread.wait` and `ngx.location.capture` to emulate `ngx.location.capture_multi`:
---
--- ```lua
---  local capture = ngx.location.capture
---  local spawn = ngx.thread.spawn
---  local wait = ngx.thread.wait
---  local say = ngx.say
---
---  local function fetch(uri)
---      return capture(uri)
---  end
---
---  local threads = {
---      spawn(fetch, "/foo"),
---      spawn(fetch, "/bar"),
---      spawn(fetch, "/baz")
---  }
---
---  for i = 1, #threads do
---      local ok, res = wait(threads[i])
---      if not ok then
---          say(i, ": failed to run: ", res)
---      else
---          say(i, ": status: ", res.status)
---          say(i, ": body: ", res.body)
---      end
---  end
--- ```
---
--- Here it essentially implements the "wait all" model.
---
--- And below is an example demonstrating the "wait any" model:
---
--- ```lua
---  function f()
---      ngx.sleep(0.2)
---      ngx.say("f: hello")
---      return "f done"
---  end
---
---  function g()
---      ngx.sleep(0.1)
---      ngx.say("g: hello")
---      return "g done"
---  end
---
---  local tf, err = ngx.thread.spawn(f)
---  if not tf then
---      ngx.say("failed to spawn thread f: ", err)
---      return
---  end
---
---  ngx.say("f thread created: ", coroutine.status(tf))
---
---  local tg, err = ngx.thread.spawn(g)
---  if not tg then
---      ngx.say("failed to spawn thread g: ", err)
---      return
---  end
---
---  ngx.say("g thread created: ", coroutine.status(tg))
---
---  ok, res = ngx.thread.wait(tf, tg)
---  if not ok then
---      ngx.say("failed to wait: ", res)
---      return
---  end
---
---  ngx.say("res: ", res)
---
---  -- stop the "world", aborting other running threads
---  ngx.exit(ngx.OK)
--- ```
---
--- And it will generate the following output:
---
---     f thread created: running
---     g thread created: running
---     g: hello
---     res: g done
---
---@param ... ngx.thread
---@return boolean ok
---@return any     ret_or_error
function ngx.thread.wait(...) end

--- Spawns a new user "light thread" with the Lua function `func` as well as those optional arguments `arg1`, `arg2`, and etc. Returns a Lua thread (or Lua coroutine) object represents this "light thread".
---
--- "Light threads" are just a special kind of Lua coroutines that are scheduled by the ngx_lua module.
---
--- Before `ngx.thread.spawn` returns, the `func` will be called with those optional arguments until it returns, aborts with an error, or gets yielded due to I/O operations via the NGINX APIs for lua (like `tcpsock:receive`).
---
--- After `ngx.thread.spawn` returns, the newly-created "light thread" will keep running asynchronously usually at various I/O events.
---
--- All the Lua code chunks running by `rewrite_by_lua`, `access_by_lua`, and `content_by_lua` are in a boilerplate "light thread" created automatically by ngx_lua. Such boilerplate "light thread" are also called "entry threads".
---
--- By default, the corresponding NGINX handler (e.g., `rewrite_by_lua` handler) will not terminate until
---
--- 1. both the "entry thread" and all the user "light threads" terminates,
--- 1. a "light thread" (either the "entry thread" or a user "light thread" aborts by calling `ngx.exit`, `ngx.exec`, `ngx.redirect`, or `ngx.req.set_uri(uri, true)`, or
--- 1. the "entry thread" terminates with a Lua error.
---
--- When the user "light thread" terminates with a Lua error, however, it will not abort other running "light threads" like the "entry thread" does.
---
--- Due to the limitation in the NGINX subrequest model, it is not allowed to abort a running NGINX subrequest in general. So it is also prohibited to abort a running "light thread" that is pending on one ore more NGINX subrequests. You must call `ngx.thread.wait` to wait for those "light thread" to terminate before quitting the "world". A notable exception here is that you can abort pending subrequests by calling `ngx.exit` with and only with the status code `ngx.ERROR` (-1), `408`, `444`, or `499`.
---
--- The "light threads" are not scheduled in a pre-emptive way. In other words, no time-slicing is performed automatically. A "light thread" will keep running exclusively on the CPU until
---
--- 1. a (nonblocking) I/O operation cannot be completed in a single run,
--- 1. it calls `coroutine.yield` to actively give up execution, or
--- 1. it is aborted by a Lua error or an invocation of `ngx.exit`, `ngx.exec`, `ngx.redirect`, or `ngx.req.set_uri(uri, true)`.
---
--- For the first two cases, the "light thread" will usually be resumed later by the ngx_lua scheduler unless a "stop-the-world" event happens.
---
--- User "light threads" can create "light threads" themselves. And normal user coroutines created by `coroutine.create` can also create "light threads". The coroutine (be it a normal Lua coroutine or a "light thread") that directly spawns the "light thread" is called the "parent coroutine" for the "light thread" newly spawned.
---
--- The "parent coroutine" can call `ngx.thread.wait` to wait on the termination of its child "light thread".
---
--- You can call coroutine.status() and coroutine.yield() on the "light thread" coroutines.
---
--- The status of the "light thread" coroutine can be "zombie" if
---
--- 1. the current "light thread" already terminates (either successfully or with an error),
--- 1. its parent coroutine is still alive, and
--- 1. its parent coroutine is not waiting on it with `ngx.thread.wait`.
---
--- The following example demonstrates the use of coroutine.yield() in the "light thread" coroutines
--- to do manual time-slicing:
---
--- ```lua
---  local yield = coroutine.yield
---
---  function f()
---      local self = coroutine.running()
---      ngx.say("f 1")
---      yield(self)
---      ngx.say("f 2")
---      yield(self)
---      ngx.say("f 3")
---  end
---
---  local self = coroutine.running()
---  ngx.say("0")
---  yield(self)
---
---  ngx.say("1")
---  ngx.thread.spawn(f)
---
---  ngx.say("2")
---  yield(self)
---
---  ngx.say("3")
---  yield(self)
---
---  ngx.say("4")
--- ```
---
--- Then it will generate the output
---
---     0
---     1
---     f 1
---     2
---     f 2
---     3
---     f 3
---     4
---
--- "Light threads" are mostly useful for making concurrent upstream requests in a single NGINX request handler, much like a generalized version of `ngx.location.capture_multi` that can work with all the NGINX APIs for lua. The following example demonstrates parallel requests to MySQL, Memcached, and upstream HTTP services in a single Lua handler, and outputting the results in the order that they actually return (similar to Facebook's BigPipe model):
---
--- ```lua
---  -- query mysql, memcached, and a remote http service at the same time,
---  -- output the results in the order that they
---  -- actually return the results.
---
---  local mysql = require "resty.mysql"
---  local memcached = require "resty.memcached"
---
---  local function query_mysql()
---      local db = mysql:new()
---      db:connect{
---                  host = "127.0.0.1",
---                  port = 3306,
---                  database = "test",
---                  user = "monty",
---                  password = "mypass"
---                }
---      local res, err, errno, sqlstate =
---              db:query("select * from cats order by id asc")
---      db:set_keepalive(0, 100)
---      ngx.say("mysql done: ", cjson.encode(res))
---  end
---
---  local function query_memcached()
---      local memc = memcached:new()
---      memc:connect("127.0.0.1", 11211)
---      local res, err = memc:get("some_key")
---      ngx.say("memcached done: ", res)
---  end
---
---  local function query_http()
---      local res = ngx.location.capture("/my-http-proxy")
---      ngx.say("http done: ", res.body)
---  end
---
---  ngx.thread.spawn(query_mysql)      -- create thread 1
---  ngx.thread.spawn(query_memcached)  -- create thread 2
---  ngx.thread.spawn(query_http)       -- create thread 3
--- ```
---
---@param func function
---@param ... any
---@return ngx.thread
function ngx.thread.spawn(func, ...) end

--- NGINX worker methods
ngx.worker = {}

--- This function returns a boolean value indicating whether the current NGINX worker process already starts exiting. NGINX worker process exiting happens on NGINX server quit or configuration reload (aka HUP reload).
---
---@return boolean
function ngx.worker.exiting() end

--- Returns the ordinal number of the current NGINX worker processes (starting from number 0).
---
--- So if the total number of workers is `N`, then this method may return a number between 0
--- and `N - 1` (inclusive).
---
---@return number
function ngx.worker.id() end

--- Returns the total number of the NGINX worker processes (i.e., the value configured
--- by the `worker_processes`
--- directive in `nginx.conf`).
---
---@return number
function ngx.worker.count() end

--- This function returns a Lua number for the process ID (PID) of the current NGINX worker process. This API is more efficient than `ngx.var.pid` and can be used in contexts where the `ngx.var.VARIABLE` API cannot be used (like `init_worker_by_lua`).
---
---@return number
function ngx.worker.pid() end

---@class ngx.config : table
---
--- This string field indicates the current NGINX subsystem the current Lua environment is based on. For this module, this field always takes the string value `"http"`.
--- For `ngx_stream_lua_module`, however, this field takes the value `"stream"`.
---@field subsystem '"http"'|'"stream"'
---
--- This field takes an integral value indicating the version number of the current NGINX core being used. For example, the version number `1.4.3` results in the Lua number 1004003.
---@field nginx_version number
---
--- This field takes an integral value indicating the version number of the current `ngx_lua` module being used.
--- For example, the version number `0.9.3` results in the Lua number 9003.
---@field ngx_lua_version number
---
--- This boolean field indicates whether the current NGINX is a debug build, i.e., being built by the `./configure` option `--with-debug`.
---@field debug boolean
---
--- This boolean field indicates whether the current NGINX run by resty.
---@field is_console boolean
---
ngx.config = {}


--- Returns the NGINX server "prefix" path, as determined by the `-p` command-line option when running the NGINX executable, or the path specified by the `--prefix` command-line option when building NGINX with the `./configure` script.
---
---@return string
function ngx.config.prefix() end

--- This function returns a string for the NGINX `./configure` command's arguments string.
---
---@return string
function ngx.config.nginx_configure() end

ngx.timer = {}

---@alias ngx.timer.callback fun(premature:boolean, ...:any)

--- Returns the number of pending timers.
---
---@return number
function ngx.timer.pending_count() end

--- Returns the number of timers currently running.
---
---@return integer
function ngx.timer.running_count() end

--- Similar to the `ngx.timer.at` API function, but
---
--- 1. `delay` *cannot* be zero,
--- 2. timer will be created every `delay` seconds until the current NGINX worker process starts exiting.
---
--- When success, returns a "conditional true" value (but not a `true`). Otherwise, returns a "conditional false" value and a string describing the error.
---
--- This API also respect the `lua_max_pending_timers` and `lua_max_running_timers`.
---
---@param  delay    number              the interval to execute the timer on
---@param  callback ngx.timer.callback  the function to call
---@param  ...      any                 extra arguments to pass to `callback`
---@return boolean  ok
---@return string?  error
function ngx.timer.every(delay, callback, ...) end

--- Creates an NGINX timer with a user callback function as well as optional user arguments.
---
--- The first argument, `delay`, specifies the delay for the timer,
--- in seconds. One can specify fractional seconds like `0.001` to mean 1
--- millisecond here. `0` delay can also be specified, in which case the
--- timer will immediately expire when the current handler yields
--- execution.
---
--- The second argument, `callback`, can
--- be any Lua function, which will be invoked later in a background
--- "light thread" after the delay specified. The user callback will be
--- called automatically by the NGINX core with the arguments `premature`,
--- `user_arg1`, `user_arg2`, and etc, where the `premature`
--- argument takes a boolean value indicating whether it is a premature timer
--- expiration or not, and `user_arg1`, `user_arg2`, and etc, are
--- those (extra) user arguments specified when calling `ngx.timer.at`
--- as the remaining arguments.
---
--- Premature timer expiration happens when the NGINX worker process is
--- trying to shut down, as in an NGINX configuration reload triggered by
--- the `HUP` signal or in an NGINX server shutdown. When the NGINX worker
--- is trying to shut down, one can no longer call `ngx.timer.at` to
--- create new timers with nonzero delays and in that case `ngx.timer.at` will return a "conditional false" value and
--- a string describing the error, that is, "process exiting".
---
--- It is allowed to create zero-delay timers even when the NGINX worker process starts shutting down.
---
--- When a timer expires, the user Lua code in the timer callback is
--- running in a "light thread" detached completely from the original
--- request creating the timer. So objects with the same lifetime as the
--- request creating them, like `cosockets`, cannot be shared between the
--- original request and the timer user callback function.
---
--- Here is a simple example:
---
--- ```nginx
---  location / {
---      ...
---      log_by_lua_block {
---          local function push_data(premature, uri, args, status)
---              -- push the data uri, args, and status to the remote
---              -- via ngx.socket.tcp or ngx.socket.udp
---              -- (one may want to buffer the data in Lua a bit to
---              -- save I/O operations)
---          end
---          local ok, err = ngx.timer.at(0, push_data,
---                                       ngx.var.uri, ngx.var.args, ngx.header.status)
---          if not ok then
---              ngx.log(ngx.ERR, "failed to create timer: ", err)
---              return
---          end
---      }
---  }
--- ```
---
--- One can also create infinite re-occurring timers, for instance, a timer getting triggered every `5` seconds, by calling `ngx.timer.at` recursively in the timer callback function. Here is such an example,
---
--- ```lua
---  local delay = 5
---  local handler
---  handler = function (premature)
---      -- do some routine job in Lua just like a cron job
---      if premature then
---          return
---      end
---      local ok, err = ngx.timer.at(delay, handler)
---      if not ok then
---          ngx.log(ngx.ERR, "failed to create the timer: ", err)
---          return
---      end
---  end
---
---  local ok, err = ngx.timer.at(delay, handler)
---  if not ok then
---      ngx.log(ngx.ERR, "failed to create the timer: ", err)
---      return
---  end
--- ```
---
--- It is recommended, however, to use the `ngx.timer.every` API function
--- instead for creating recurring timers since it is more robust.
---
--- Because timer callbacks run in the background and their running time
--- will not add to any client request's response time, they can easily
--- accumulate in the server and exhaust system resources due to either
--- Lua programming mistakes or just too much client traffic. To prevent
--- extreme consequences like crashing the NGINX server, there are
--- built-in limitations on both the number of "pending timers" and the
--- number of "running timers" in an NGINX worker process. The "pending
--- timers" here mean timers that have not yet been expired and "running
--- timers" are those whose user callbacks are currently running.
---
--- The maximal number of pending timers allowed in an NGINX
--- worker is controlled by the `lua_max_pending_timers`
--- directive. The maximal number of running timers is controlled by the
--- `lua_max_running_timers` directive.
---
--- According to the current implementation, each "running timer" will
--- take one (fake) connection record from the global connection record
--- list configured by the standard `worker_connections` directive in
--- `nginx.conf`. So ensure that the
--- `worker_connections` directive is set to
--- a large enough value that takes into account both the real connections
--- and fake connections required by timer callbacks (as limited by the
--- `lua_max_running_timers` directive).
---
--- A lot of the Lua APIs for NGINX are enabled in the context of the timer
--- callbacks, like stream/datagram cosockets (`ngx.socket.tcp` and `ngx.socket.udp`), shared
--- memory dictionaries (`ngx.shared.DICT`), user coroutines (`coroutine.*`),
--- user "light threads" (`ngx.thread.*`), `ngx.exit`, `ngx.now`/`ngx.time`,
--- `ngx.md5`/`ngx.sha1_bin`, are all allowed. But the subrequest API (like
--- `ngx.location.capture`), the `ngx.req.*` API, the downstream output API
--- (like `ngx.say`, `ngx.print`, and `ngx.flush`) are explicitly disabled in
--- this context.
---
--- You can pass most of the standard Lua values (nils, booleans, numbers, strings, tables, closures, file handles, and etc) into the timer callback, either explicitly as user arguments or implicitly as upvalues for the callback closure. There are several exceptions, however: you *cannot* pass any thread objects returned by `coroutine.create` and `ngx.thread.spawn` or any cosocket objects returned by `ngx.socket.tcp`, `ngx.socket.udp`, and `ngx.req.socket` because these objects' lifetime is bound to the request context creating them while the timer callback is detached from the creating request's context (by design) and runs in its own (fake) request context. If you try to share the thread or cosocket objects across the boundary of the creating request, then you will get the "no co ctx found" error (for threads) or "bad request" (for cosockets). It is fine, however, to create all these objects inside your timer callback.
---
---@param  delay    number
---@param  callback ngx.timer.callback
---@param  ...      any
---@return boolean  ok
---@return string?  error
function ngx.timer.at(delay, callback, ...) end


--- Unescape `str` as an escaped URI component.
---
--- For example,
---
--- ```lua
---  ngx.say(ngx.unescape_uri("b%20r56+7"))
--- ```
---
--- gives the output
---
---     b r56 7
---
---@param str string
---@return string
function ngx.unescape_uri(str) end

--- Escape `str` as a URI component.
---
---@param str string
---@return string
function ngx.escape_uri(str) end

--- Returns the binary form of the SHA-1 digest of the `str` argument.
---
--- This function requires SHA-1 support in the NGINX build. (This usually just means OpenSSL should be installed while building NGINX).
---
---@param str string
---@return any
function ngx.sha1_bin(str) end

--- Calculates the CRC-32 (Cyclic Redundancy Code) digest for the `str` argument.
---
--- This method performs better on relatively short `str` inputs (i.e., less than 30 ~ 60 bytes), as compared to `ngx.crc32_long`. The result is exactly the same as `ngx.crc32_long`.
---
--- Behind the scene, it is just a thin wrapper around the `ngx_crc32_short` function defined in the NGINX core.
---
---@param str string
---@return number
function ngx.crc32_short(str) end

--- Calculates the CRC-32 (Cyclic Redundancy Code) digest for the `str` argument.
---
--- This method performs better on relatively long `str` inputs (i.e., longer than 30 ~ 60 bytes), as compared to `ngx.crc32_short`.  The result is exactly the same as `ngx.crc32_short`.
---
--- Behind the scene, it is just a thin wrapper around the `ngx_crc32_long` function defined in the NGINX core.
---
---@param str string
---@return number
function ngx.crc32_long(str) end

--- Returns the binary form of the MD5 digest of the `str` argument.
---
--- See `ngx.md5` if the hexadecimal form of the MD5 digest is required.
---
---@param str string
---@return string
function ngx.md5_bin(str) end

--- Returns the hexadecimal representation of the MD5 digest of the `str` argument.
---
--- For example,
---
--- ```nginx
---  location = /md5 {
---      content_by_lua_block { ngx.say(ngx.md5("hello")) }
---  }
--- ```
---
--- yields the output
---
---     5d41402abc4b2a76b9719d911017c592
---
--- See `ngx.md5_bin` if the raw binary MD5 digest is required.
---
---@param str string
---@return string
function ngx.md5(str) end

--- Computes the `HMAC-SHA1` digest of the argument `str` and turns the result using the secret key `<secret_key>`.
---
--- The raw binary form of the `HMAC-SHA1` digest will be generated, use `ngx.encode_base64`, for example, to encode the result to a textual representation if desired.
---
--- For example,
---
--- ```lua
---  local key = "thisisverysecretstuff"
---  local src = "some string we want to sign"
---  local digest = ngx.hmac_sha1(key, src)
---  ngx.say(ngx.encode_base64(digest))
--- ```
---
--- yields the output
---
---     R/pvxzHC4NLtj7S+kXFg/NePTmk=
---
---@param secret_key string
---@param str string
---@return string
function ngx.hmac_sha1(secret_key, str) end

--- Returns a quoted SQL string literal according to the MySQL quoting rules.
---
---@param raw_value string
---@return string
function ngx.quote_sql_str(raw_value) end

ngx.re = {}


--- PCRE regex options string
---
--- This is a string made up of single-letter PCRE option names, usable in all `ngx.re.*` functions.
---
--- Options:
---
--- a - anchored mode (only match from the beginning)
--- d - enable the DFA mode (or the longest token match semantics).
--- D - enable duplicate named pattern support. This allows named subpattern names to be repeated, returning the captures in an array-like Lua table.
--- i - case insensitive mode
--- j - enable PCRE JIT compilation. For optimum performance, this option should always be used together with the 'o' option.
--- J - enable the PCRE Javascript compatible mode
--- m - multi-line mode
--- o - compile-once mode, to enable the worker-process-level compiled-regex cache
--- s - single-line mode
--- u - UTF-8 mode.
--- U - similar to "u" but disables PCRE's UTF-8 validity check on the subject string
--- x - extended mode
---
--- These options can be combined:
---
--- ```lua
---  local m, err = ngx.re.match("hello, world", "HEL LO", "ix")
---  -- m[0] == "hello"
--- ```
---
--- ```lua
---  local m, err = ngx.re.match("hello, 美好生活", "HELLO, (.{2})", "iu")
---  -- m[0] == "hello, 美好"
---  -- m[1] == "美好"
--- ```
---
--- The `o` option is useful for performance tuning, because the regex pattern in question will only be compiled once, cached in the worker-process level, and shared among all requests in the current NGINX worker process. The upper limit of the regex cache can be tuned via the `lua_regex_cache_max_entries` directive.
---
---@alias ngx.re.options string


--- ngx.re.match capture table
---
--- This table may have both integer and string keys.
---
--- `captures[0]` is special and contains the whole substring match
---
--- `captures[1]` through `captures[n]` contain the values of unnamed, parenthesized sub-pattern captures
---
--- ```lua
---  local m, err = ngx.re.match("hello, 1234", "[0-9]+")
---  if m then
---      -- m[0] == "1234"
---
---  else
---      if err then
---          ngx.log(ngx.ERR, "error: ", err)
---          return
---      end
---
---      ngx.say("match not found")
---  end
--- ```
---
--- ```lua
---  local m, err = ngx.re.match("hello, 1234", "([0-9])[0-9]+")
---  -- m[0] == "1234"
---  -- m[1] == "1"
--- ```
---
--- Named captures are stored with string keys corresponding to the capture name (e.g. `captures["my_capture_name"]`) _in addition to_ their sequential integer key (`captures[n]`):
---
--- ```lua
---  local m, err = ngx.re.match("hello, 1234", "([0-9])(?<remaining>[0-9]+)")
---  -- m[0] == "1234"
---  -- m[1] == "1"
---  -- m[2] == "234"
---  -- m["remaining"] == "234"
--- ```
---
--- Unmatched captures (named or unnamed) take the value `false`.
---
--- ```lua
---  local m, err = ngx.re.match("hello, world", "(world)|(hello)|(?<named>howdy)")
---  -- m[0] == "hello"
---  -- m[1] == false
---  -- m[2] == "hello"
---  -- m[3] == false
---  -- m["named"] == false
--- ```
---
---@alias ngx.re.captures table<integer|string, string|string[]|'false'>

--- ngx.re.match context table
---
--- A Lua table holding an optional `pos` field. When the `pos` field in the `ctx` table argument is specified, `ngx.re.match` will start matching from that offset (starting from 1). Regardless of the presence of the `pos` field in the `ctx` table, `ngx.re.match` will always set this `pos` field to the position *after* the substring matched by the whole pattern in case of a successful match. When match fails, the `ctx` table will be left intact.
---
--- ```lua
---  local ctx = {}
---  local m, err = ngx.re.match("1234, hello", "[0-9]+", "", ctx)
---       -- m[0] = "1234"
---       -- ctx.pos == 5
--- ```
---
--- ```lua
---  local ctx = { pos = 2 }
---  local m, err = ngx.re.match("1234, hello", "[0-9]+", "", ctx)
---       -- m[0] = "234"
---       -- ctx.pos == 5
--- ```
---
---@class ngx.re.ctx : table
---@field pos? integer


--- Similar to `ngx.re.match` but only returns the beginning index (`from`) and end index (`to`) of the matched substring. The returned indexes are 1-based and can be fed directly into the `string.sub` API function to obtain the matched substring.
---
--- In case of errors (like bad regexes or any PCRE runtime errors), this API function returns two `nil` values followed by a string describing the error.
---
--- If no match is found, this function just returns a `nil` value.
---
--- Below is an example:
---
--- ```lua
---  local s = "hello, 1234"
---  local from, to, err = ngx.re.find(s, "([0-9]+)", "jo")
---  if from then
---      ngx.say("from: ", from)
---      ngx.say("to: ", to)
---      ngx.say("matched: ", string.sub(s, from, to))
---  else
---      if err then
---          ngx.say("error: ", err)
---          return
---      end
---      ngx.say("not matched!")
---  end
--- ```
---
--- This example produces the output
---
---     from: 8
---     to: 11
---     matched: 1234
---
--- Because this API function does not create new Lua strings nor new Lua tables, it is much faster than `ngx.re.match`. It should be used wherever possible.
---
--- The optional 5th argument, `nth`, allows the caller to specify which (submatch) capture's indexes to return. When `nth` is 0 (which is the default), the indexes for the whole matched substring is returned; when `nth` is 1, then the 1st submatch capture's indexes are returned; when `nth` is 2, then the 2nd submatch capture is returned, and so on. When the specified submatch does not have a match, then two `nil` values will be returned. Below is an example for this:
---
--- ```lua
---  local str = "hello, 1234"
---  local from, to = ngx.re.find(str, "([0-9])([0-9]+)", "jo", nil, 2)
---  if from then
---      ngx.say("matched 2nd submatch: ", string.sub(str, from, to))  -- yields "234"
---  end
--- ```
---
---@param  subject  string
---@param  regex    string
---@param  options? ngx.re.options
---@param  ctx?     ngx.re.ctx
---@param  nth?     integer
---@return integer? from
---@return integer? to
---@return string?  error
function ngx.re.find(subject, regex, options, ctx, nth) end


--- Similar to `ngx.re.match`, but returns a Lua iterator instead, so as to let the user programmer iterate all the matches over the `<subject>` string argument with the PCRE `regex`.
---
--- In case of errors, like seeing an ill-formed regular expression, `nil` and a string describing the error will be returned.
---
--- Here is a small example to demonstrate its basic usage:
---
--- ```lua
---  local iterator, err = ngx.re.gmatch("hello, world!", "([a-z]+)", "i")
---  if not iterator then
---      ngx.log(ngx.ERR, "error: ", err)
---      return
---  end
---
---  local m
---  m, err = iterator()    -- m[0] == m[1] == "hello"
---  if err then
---      ngx.log(ngx.ERR, "error: ", err)
---      return
---  end
---
---  m, err = iterator()    -- m[0] == m[1] == "world"
---  if err then
---      ngx.log(ngx.ERR, "error: ", err)
---      return
---  end
---
---  m, err = iterator()    -- m == nil
---  if err then
---      ngx.log(ngx.ERR, "error: ", err)
---      return
---  end
--- ```
---
--- More often we just put it into a Lua loop:
---
--- ```lua
---  local it, err = ngx.re.gmatch("hello, world!", "([a-z]+)", "i")
---  if not it then
---      ngx.log(ngx.ERR, "error: ", err)
---      return
---  end
---
---  while true do
---      local m, err = it()
---      if err then
---          ngx.log(ngx.ERR, "error: ", err)
---          return
---      end
---
---      if not m then
---          -- no match found (any more)
---          break
---      end
---
---      -- found a match
---      ngx.say(m[0])
---      ngx.say(m[1])
---  end
--- ```
---
--- The current implementation requires that the iterator returned should only be used in a single request. That is, one should *not* assign it to a variable belonging to persistent namespace like a Lua package.
---
---@alias ngx.re.gmatch.iterator fun():string,string
---
---@param  subject                 string
---@param  regex                   string
---@param  options?                ngx.re.options
---@return ngx.re.gmatch.iterator? iterator
---@return string?                 error
function ngx.re.gmatch(subject, regex, options) end


--- Matches the `subject` string using the Perl compatible regular expression `regex` with the optional `options`.
---
--- Only the first occurrence of the match is returned, or `nil` if no match is found. In case of errors, like seeing a bad regular expression or exceeding the PCRE stack limit, `nil` and a string describing the error will be returned.
---
--- The optional fourth argument, `ctx`, can be a Lua table holding an optional `pos` field. When the `pos` field in the `ctx` table argument is specified, `ngx.re.match` will start matching from that offset (starting from 1). Regardless of the presence of the `pos` field in the `ctx` table, `ngx.re.match` will always set this `pos` field to the position *after* the substring matched by the whole pattern in case of a successful match. When match fails, the `ctx` table will be left intact.
---
--- ```lua
---  local ctx = {}
---  local m, err = ngx.re.match("1234, hello", "[0-9]+", "", ctx)
---       -- m[0] = "1234"
---       -- ctx.pos == 5
--- ```
---
--- ```lua
---  local ctx = { pos = 2 }
---  local m, err = ngx.re.match("1234, hello", "[0-9]+", "", ctx)
---       -- m[0] = "234"
---       -- ctx.pos == 5
--- ```
---
--- The `ctx` table argument combined with the `a` regex modifier can be used to construct a lexer atop `ngx.re.match`.
---
--- Note that, the `options` argument is not optional when the `ctx` argument is specified and that the empty Lua string (`""`) must be used as placeholder for `options` if no meaningful regex options are required.
---
--- The optional 5th argument, `res_table`, allows the caller to supply the Lua table used to hold all the capturing results. Starting from `0.9.6`, it is the caller's responsibility to ensure this table is empty. This is very useful for recycling Lua tables and saving GC and table allocation overhead.
---
---@param  subject          string
---@param  regex            string
---@param  options?         ngx.re.options
---@param  ctx?             ngx.re.ctx
---@param  res?             ngx.re.captures
---@return ngx.re.captures? captures
---@return string?          error
function ngx.re.match(subject, regex, options, ctx, res) end

--- Just like `ngx.re.sub`, but does global substitution.
---
--- Here is some examples:
---
--- ```lua
---  local newstr, n, err = ngx.re.gsub("hello, world", "([a-z])[a-z]+", "[$0,$1]", "i")
---  if newstr then
---      -- newstr == "[hello,h], [world,w]"
---      -- n == 2
---  else
---      ngx.log(ngx.ERR, "error: ", err)
---      return
---  end
--- ```
---
--- ```lua
---  local func = function (m)
---      return "[" .. m[0] .. "," .. m[1] .. "]"
---  end
---  local newstr, n, err = ngx.re.gsub("hello, world", "([a-z])[a-z]+", func, "i")
---      -- newstr == "[hello,h], [world,w]"
---      -- n == 2
--- ```
---
---@param  subject  string
---@param  regex    string
---@param  replace  ngx.re.replace
---@param  options? ngx.re.options
---@return string?  new
---@return integer? n
---@return string?  error
function ngx.re.gsub(subject, regex, replace, options) end

--- When `replace` is string, then it is treated as a special template for string replacement:
---
--- ```lua
---  local newstr, n, err = ngx.re.sub("hello, 1234", "([0-9])[0-9]", "[$0][$1]")
---  if newstr then
---      -- newstr == "hello, [12][1]34"
---      -- n == 1
---  else
---      ngx.log(ngx.ERR, "error: ", err)
---      return
---  end
--- ```
---
--- ...where `$0` refers to the whole substring matched by the pattern, and `$1` referring to the first parenthesized capturing substring.
---
--- Curly braces can also be used to disambiguate variable names from the background string literals:
---
--- ```lua
---  local newstr, n, err = ngx.re.sub("hello, 1234", "[0-9]", "${0}00")
---      -- newstr == "hello, 100234"
---      -- n == 1
--- ```
---
--- Literal dollar sign characters (`$`) in the `replace` string argument can be escaped by another dollar sign:
---
--- ```lua
---  local newstr, n, err = ngx.re.sub("hello, 1234", "[0-9]", "$$")
---      -- newstr == "hello, $234"
---      -- n == 1
--- ```
---
--- Do not use backlashes to escape dollar signs; it will not work as expected.
---@alias ngx.re.replace.string string

--- When `replace` is a function, it will be invoked with the capture table as the argument to generate the replace string literal for substitution. The capture table fed into the `replace` function is exactly the same as the return value of `ngx.re.match`. Here is an example:
---
--- ```lua
---  local func = function (m)
---      return "[" .. m[0] .. "][" .. m[1] .. "]"
---  end
---  local newstr, n, err = ngx.re.sub("hello, 1234", "( [0-9] ) [0-9]", func, "x")
---      -- newstr == "hello, [12][1]34"
---      -- n == 1
--- ```
---
--- The dollar sign characters in the return value of the `replace` function argument are not special at all.
---
---@alias ngx.re.replace.fn fun(m:ngx.re.captures):string

---@alias ngx.re.replace ngx.re.replace.string|ngx.re.replace.fn

--- Substitutes the first match of the Perl compatible regular expression `regex` on the `subject` argument string with the string or function argument `replace`.
---
--- This method returns the resulting new string as well as the number of successful substitutions. In case of failures, like syntax errors in the regular expressions or the `<replace>` string argument, it will return `nil` and a string describing the error.
---
---@param  subject  string
---@param  regex    string
---@param  replace  ngx.re.replace
---@param  options? ngx.re.options
---@return string?  new
---@return integer? n
---@return string?  error
function ngx.re.sub(subject, regex, replace, options) end


--- Decodes the `str` argument as a base64 digest to the raw form. Returns `nil` if `str` is not well formed.
---
---@param str string
---@return string
function ngx.decode_base64(str) end

--- Encodes `str` to a base64 digest.
---
--- An optional boolean-typed `no_padding` argument can be specified to control whether the base64 padding should be appended to the resulting digest (default to `false`, i.e., with padding enabled).
---
---@param str string
---@param no_padding? boolean
---@return string
function ngx.encode_base64(str, no_padding) end

--- Fetching the shm-based Lua dictionary object for the shared memory zone named `DICT` defined by the `lua_shared_dict` directive.
---
--- All these methods are *atomic* operations, that is, safe from concurrent accesses from multiple NGINX worker processes for the same `lua_shared_dict` zone.
---
--- The shared dictionary will retain its contents through a server config reload (either by sending the `HUP` signal to the NGINX process or by using the `-s reload` command-line option).
---
--- The contents in the dictionary storage will be lost, however, when the NGINX server quits.
---
---@type table<string,ngx.shared.DICT>
ngx.shared = {}

---@class ngx.shared.DICT
local DICT = {}

--- Valid values for ngx.shared.DICT
---@alias ngx.shared.DICT.value
---| string
---| number
---| boolean
---| nil

--- Retrieve a value. If the key does not exist or has expired, then `nil` will be returned.
---
--- In case of errors, `nil` and a string describing the error will be returned.
---
--- The value returned will have the original data type when they were inserted into the dictionary, for example, Lua booleans, numbers, or strings.
---
--- ```lua
---  local cats = ngx.shared.cats
---  local value, flags = cats:get("Marry")
--- ```
---
--- If the user flags is `0` (the default), then no flags value will be returned.
---
---@param key string
---@return ngx.shared.DICT.value? value
---@return ngx.shared.DICT.flags|string|nil flags_or_error
function DICT:get(key) end


--- Similar to the `get` method but returns the value even if the key has already expired.
---
--- Returns a 3rd value, `stale`, indicating whether the key has expired or not.
---
--- Note that the value of an expired key is not guaranteed to be available so one should never rely on the availability of expired items.
---
---@param  key              string
---@return ngx.shared.DICT.value? value
---@return ngx.shared.DICT.flags|string flags_or_error
---@return boolean          stale
function DICT:get_stale(key) end

---@alias ngx.shared.DICT.error string
---| '"no memory"'        # not enough available memory to store a value
---| '"exists"'           # called add() on an existing value
---| '"not found"'        # called a method (replace/ttl/expire) on an absent value
---| '"not a number"'     # called incr() on a non-number value
---| '"value not a list"' # called list methods (lpush/lpop/rpush/rpop/llen) on a non-list value

--- Optional user flags associated with a shm value.
---
--- The user flags is stored as an unsigned 32-bit integer internally. Defaults to `0`.
---
---@alias ngx.shared.DICT.flags integer

--- Expiration time of an shm value (in seconds)
---
--- The time resolution is `0.001` seconds.
--- If this value is set to `0` (the default), the shm value will never expire.
---
---@alias ngx.shared.DICT.exptime number

--- Unconditionally sets a key-value pair into the shm-based dictionary.
---
--- When it fails to allocate memory for the current key-value item, then `set` will try removing existing items in the storage according to the Least-Recently Used (LRU) algorithm. Note that, LRU takes priority over expiration time here. If up to tens of existing items have been removed and the storage left is still insufficient (either due to the total capacity limit specified by `lua_shared_dict` or memory segmentation), then the `err` return value will be `no memory` and `success` will be `false`.
---
--- If this method succeeds in storing the current item by forcibly removing other not-yet-expired items in the dictionary via LRU, the `forcible` return value will be `true`. If it stores the item without forcibly removing other valid items, then the return value `forcible` will be `false`.
---
--- ```lua
---  local cats = ngx.shared.cats
---  local succ, err, forcible = cats:set("Marry", "it is a nice cat!")
--- ```
---
--- Please note that while internally the key-value pair is set atomically, the atomicity does not go across the method call boundary.
---
---@param  key      string
---@param  value    ngx.shared.DICT.value
---@param  exptime? ngx.shared.DICT.exptime
---@param  flags?   ngx.shared.DICT.flags
---@return boolean  ok       # whether the key-value pair is stored or not
---@return ngx.shared.DICT.error? error
---@return boolean  forcible # indicates whether other valid items have been removed forcibly when out of storage in the shared memory zone.
function DICT:set(key, value, exptime, flags) end

--- Similar to the `set` method, but never overrides the (least recently used) unexpired items in the store when running out of storage in the shared memory zone. In this case, it will immediately return `nil` and the string "no memory".
---
---@param  key      string
---@param  value    ngx.shared.DICT.value
---@param  exptime? ngx.shared.DICT.exptime
---@param  flags?   ngx.shared.DICT.flags
---@return boolean  ok       # whether the key-value pair is stored or not
---@return ngx.shared.DICT.error? error
---@return boolean  forcible # indicates whether other valid items have been removed forcibly when out of storage in the shared memory zone.
function DICT:safe_set(key, value, exptime, flags) end

--- Just like the `set` method, but only stores the key-value pair if the key does *not* exist.
---
--- If the `key` argument already exists in the dictionary (and not expired for sure), the `success` return value will be `false` and the `err` return value will be `"exists"`.
---
---@param  key      string
---@param  value    ngx.shared.DICT.value
---@param  exptime? ngx.shared.DICT.exptime
---@param  flags?   ngx.shared.DICT.flags
---@return boolean  ok       # whether the key-value pair is stored or not
---@return ngx.shared.DICT.error? error
---@return boolean  forcible # indicates whether other valid items have been removed forcibly when out of storage in the shared memory zone.
function DICT:add(key, value, exptime, flags) end

--- Similar to the `add` method, but never overrides the (least recently used) unexpired items in the store when running out of storage in the shared memory zone. In this case, it will immediately return `nil` and the string "no memory".
---
---@param  key      string
---@param  value    ngx.shared.DICT.value
---@param  exptime? ngx.shared.DICT.exptime
---@param  flags?   ngx.shared.DICT.flags
---@return boolean  ok       # whether the key-value pair is stored or not
---@return ngx.shared.DICT.error? error
---@return boolean  forcible # indicates whether other valid items have been removed forcibly when out of storage in the shared memory zone.
function DICT:safe_add(key, value, exptime, flags) end


--- Just like the `set` method, but only stores the key-value pair if the key *does* exist.
---
--- If the `key` argument does *not* exist in the dictionary (or expired already), the `success` return value will be `false` and the `err` return value will be `"not found"`.
---
---@param  key      string
---@param  value    ngx.shared.DICT.value
---@param  exptime? ngx.shared.DICT.exptime
---@param  flags?   ngx.shared.DICT.flags
---@return boolean  ok       # whether the key-value pair is stored or not
---@return ngx.shared.DICT.error? error
---@return boolean  forcible # indicates whether other valid items have been removed forcibly when out of storage in the shared memory zone.
function DICT:replace(key, value, exptime, flags) end

--- Unconditionally removes the key-value pair.
---
--- It is equivalent to `ngx.shared.DICT:set(key, nil)`.
---
---@param key string
function DICT:delete(key) end


--- Increments the (numerical) value for `key` by the step value `value`. Returns the new resulting number if the operation is successfully completed or `nil` and an error message otherwise.
---
--- When the key does not exist or has already expired in the shared dictionary,
---
--- 1. if the `init` argument is not specified or takes the value `nil`, this method will return `nil` and the error string `"not found"`, or
--- 1. if the `init` argument takes a number value, this method will create a new `key` with the value `init + value`.
---
--- Like the `add` method, it also overrides the (least recently used) unexpired items in the store when running out of storage in the shared memory zone.
---
--- The optional `init_ttl` argument specifies expiration time (in seconds) of the value when it is initialized via the `init` argument. This argument cannot be provided without providing the `init` argument as well, and has no effect if the value already exists (e.g., if it was previously inserted via `set` or the likes).
---
--- ```lua
---  local cats = ngx.shared.cats
---  local newval, err = cats:incr("black_cats", 1, 0, 0.1)
---
---  print(newval) -- 1
---
---  ngx.sleep(0.2)
---
---  local val, err = cats:get("black_cats")
---  print(val) -- nil
--- ```
---
--- The `forcible` return value will always be `nil` when the `init` argument is not specified.
---
--- If this method succeeds in storing the current item by forcibly removing other not-yet-expired items in the dictionary via LRU, the `forcible` return value will be `true`. If it stores the item without forcibly removing other valid items, then the return value `forcible` will be `false`.
---
--- If the original value is not a valid Lua number in the dictionary, it will return `nil` and `"not a number"`.
---
--- The `value` argument and `init` argument can be any valid Lua numbers, like negative numbers or floating-point numbers.
---
---
---@param  key       string
---@param  value     number
---@param  init?     number
---@param  init_ttl? ngx.shared.DICT.exptime
---@return integer? new
---@return ngx.shared.DICT.error? error
---@return boolean  forcible
function DICT:incr(key, value, init, init_ttl) end

--- Valid ngx.shared.DICT value for lists
---@alias ngx.shared.DICT.list_value
---| string
---| number

--- Inserts the specified (numerical or string) `value` at the head of the list named `key`.
---
--- If `key` does not exist, it is created as an empty list before performing the push operation. When the `key` already takes a value that is not a list, it will return `nil` and `"value not a list"`.
---
--- It never overrides the (least recently used) unexpired items in the store when running out of storage in the shared memory zone. In this case, it will immediately return `nil` and the string "no memory".
---
---@param  key     string
---@param  value   ngx.shared.DICT.list_value
---@return number? len    # number of elements in the list after the push operation
---@return ngx.shared.DICT.error? error
function DICT:lpush(key, value) end


--- Similar to the `lpush` method, but inserts the specified (numerical or string) `value` at the tail of the list named `key`.
---
---@param  key     string
---@param  value   ngx.shared.DICT.list_value
---@return number? len    # number of elements in the list after the push operation
---@return ngx.shared.DICT.error? error
function DICT:rpush(key, value) end


--- Removes and returns the first element of the list named `key`.
---
--- If `key` does not exist, it will return `nil`. When the `key` already takes a value that is not a list, it will return `nil` and `"value not a list"`.
---
---@param  key     string
---@return ngx.shared.DICT.list_value? item
---@return ngx.shared.DICT.error? error
function DICT:lpop(key) end


--- Removes and returns the last element of the list named `key`.
---
--- If `key` does not exist, it will return `nil`. When the `key` already takes a value that is not a list, it will return `nil` and `"value not a list"`.
---
---@param  key     string
---@return ngx.shared.DICT.list_value? item
---@return ngx.shared.DICT.error? error
function DICT:rpop(key) end

--- Returns the number of elements in the list named `key`.
---
--- If key does not exist, it is interpreted as an empty list and 0 is returned. When the `key` already takes a value that is not a list, it will return `nil` and `"value not a list"`.
---
---@param key string
---@return number? len
---@return ngx.shared.DICT.error? error
function DICT:llen(key) end


--- Retrieves the remaining TTL (time-to-live in seconds) of a key-value pair.
---
--- Returns the TTL as a number if the operation is successfully completed or `nil` and an error message otherwise.
---
--- If the key does not exist (or has already expired), this method will return `nil` and the error string `"not found"`.
---
--- The TTL is originally determined by the `exptime` argument of the `set`, `add`, `replace` (and the likes) methods. It has a time resolution of `0.001` seconds. A value of `0` means that the item will never expire.
---
--- Example:
---
--- ```lua
---  local cats = ngx.shared.cats
---  local succ, err = cats:set("Marry", "a nice cat", 0.5)
---
---  ngx.sleep(0.2)
---
---  local ttl, err = cats:ttl("Marry")
---  ngx.say(ttl) -- 0.3
--- ```
---@param  key     string
---@return number? ttl
---@return ngx.shared.DICT.error? error
function DICT:ttl(key) end


--- Updates the `exptime` (in second) of a key-value pair.
---
--- Returns a boolean indicating success if the operation completes or `nil` and an error message otherwise.
---
--- If the key does not exist, this method will return `nil` and the error string `"not found"`.
---
--- ```lua
---  local cats = ngx.shared.cats
---  local succ, err = cats:set("Marry", "a nice cat", 0.1)
---
---  succ, err = cats:expire("Marry", 0.5)
---
---  ngx.sleep(0.2)
---
---  local val, err = cats:get("Marry")
---  ngx.say(val) -- "a nice cat"
--- ```
---
---@param  key     string
---@param  exptime ngx.shared.DICT.exptime
---@return boolean ok
---@return ngx.shared.DICT.error? error
function DICT:expire(key, exptime) end


--- Flushes out all the items in the dictionary. This method does not actuall free up all the memory blocks in the dictionary but just marks all the existing items as expired.
---
function DICT:flush_all() end


--- Flushes out the expired items in the dictionary, up to the maximal number specified by the optional `max_count` argument. When the `max_count` argument is given `0` or not given at all, then it means unlimited. Returns the number of items that have actually been flushed.
---
--- Unlike the `flush_all` method, this method actually frees up the memory used by the expired items.
---
---@param max_count? number
---@return number flushed
function DICT:flush_expired(max_count) end


--- Fetch a list of the keys from the dictionary, up to `<max_count>`.
---
--- By default, only the first 1024 keys (if any) are returned. When the `<max_count>` argument is given the value `0`, then all the keys will be returned even there is more than 1024 keys in the dictionary.
---
--- **CAUTION** Avoid calling this method on dictionaries with a very large number of keys as it may lock the dictionary for significant amount of time and block NGINX worker processes trying to access the dictionary.
---
---@param  max_count? number
---@return string[]  keys
function DICT:get_keys(max_count) end


--- Retrieves the capacity in bytes for the shm-based dictionary.
---
--- ```lua
---  local cats = ngx.shared.cats
---  local capacity_bytes = cats:capacity()
--- ```
---
---@return number
function DICT:capacity() end


--- Retrieves the free page size in bytes for the shm-based dictionary.
---
--- **Note:** The memory for ngx.shared.DICT is allocated via the NGINX slab allocator which has each slot for
--- data size ranges like \~8, 9\~16, 17\~32, ..., 1025\~2048, 2048\~ bytes. And pages are assigned to a slot if there is no room in already assigned pages for the slot.
---
--- So even if the return value of the `free_space` method is zero, there may be room in already assigned pages, so
--- you may successfully set a new key value pair to the shared dict without getting `true` for `forcible` or
--- non nil `err` from the `ngx.shared.DICT.set`.
---
--- On the other hand, if already assigned pages for a slot are full and a new key value pair is added to the
--- slot and there is no free page, you may get `true` for `forcible` or non nil `err` from the
--- `ngx.shared.DICT.set` method.
---
--- ```lua
---  local cats = ngx.shared.cats
---  local free_page_bytes = cats:free_space()
--- ```
---
---@return number
function DICT:free_space() end

--- Read and write NGINX variable values.
---
--- Usage:
---
---```lua
---  value = ngx.var.some_nginx_variable_name
---  ngx.var.some_nginx_variable_name = value
---```
---
--- Note that only already defined NGINX variables can be written to.
--- For example:
---
--- ```nginx
---  location /foo {
---      set $my_var ''; # this line is required to create $my_var at config time
---      content_by_lua_block {
---          ngx.var.my_var = 123
---          ...
---      }
---  }
--- ```
---
--- That is, NGINX variables cannot be created on-the-fly.
---
--- Some special NGINX variables like `$args` and `$limit_rate` can be assigned a value,
--- many others are not, like `$query_string`, `$arg_PARAMETER`, and `$http_NAME`.
---
--- NGINX regex group capturing variables `$1`, `$2`, `$3`, and etc, can be read by this
--- interface as well, by writing `ngx.var[1]`, `ngx.var[2]`, `ngx.var[3]`, and etc.
---
--- Setting `ngx.var.Foo` to a `nil` value will unset the `$Foo` NGINX variable.
---
--- ```lua
---  ngx.var.args = nil
--- ```
---
--- **CAUTION** When reading from an NGINX variable, NGINX will allocate memory in the per-request memory pool which is freed only at request termination. So when you need to read from an NGINX variable repeatedly in your Lua code, cache the NGINX variable value to your own Lua variable, for example,
---
--- ```lua
---  local val = ngx.var.some_var
---  --- use the val repeatedly later
--- ```
---
--- to prevent (temporary) memory leaking within the current request's lifetime. Another way of caching the result is to use the `ngx.ctx` table.
---
--- Undefined NGINX variables are evaluated to `nil` while uninitialized (but defined) NGINX variables are evaluated to an empty Lua string.
---
--- This API requires a relatively expensive metamethod call and it is recommended to avoid using it on hot code paths.
---
---@type table
ngx.var = {}

--- Embedded Variables
--- see https://nginx.org/en/docs/http/ngx_http_core_module.html#variables

--- client address in a binary form, value’s length is always 4 bytes for IPv4 addresses or 16 bytes for IPv6 addresses
---@type string
ngx.var.binary_remote_addr = nil

--- number of bytes sent to a client, not counting the response header; this variable is compatible with the “%B” parameter of the mod_log_config Apache module
---@type number
ngx.var.body_bytes_sent = nil

--- number of bytes sent to a client (1.3.8, 1.2.5)
---@type number
ngx.var.bytes_sent = nil

--- connection serial number (1.3.8, 1.2.5)
---@type string
ngx.var.connection = nil

--- current number of requests made through a connection (1.3.8, 1.2.5)
---@type string
ngx.var.connection_requests = nil

--- connection time in seconds with a milliseconds resolution (1.19.10)
---@type string
ngx.var.connection_time = nil

--- “Content-Length” request header field
---@type string
ngx.var.content_length = nil

--- “Content-Type” request header field
---@type string
ngx.var.content_type = nil

--- root or alias directive’s value for the current request
---@type string
ngx.var.document_root = nil

--- same as ngx.var.uri
---@type string
ngx.var.document_uri = nil

--- in this order of precedence: host name from the request line, or host name from the “Host” request header field, or the server name matching a request
---@type string
ngx.var.host = nil

--- host name
---@type string
ngx.var.hostname = nil

--- “on” if connection operates in SSL mode, or an empty string otherwise
---@type string '"on"'|'""'
ngx.var.https = nil

--- “?” if a request line has arguments, or an empty string otherwise
---@type string
ngx.var.is_args = nil

--- setting this variable enables response rate limiting; see limit_rate
---@type string
ngx.var.limit_rate = nil

--- current time in seconds with the milliseconds resolution (1.3.9, 1.2.6)
---@type string
ngx.var.msec = nil

--- nginx version
---@type string
ngx.var.nginx_version = nil

--- PID of the worker process
---@type string
ngx.var.pid = nil

--- “p” if request was pipelined, “.” otherwise (1.3.12, 1.2.7)
---@type string
ngx.var.pipe = nil

--- client address from the PROXY protocol header (1.5.12)
--- The PROXY protocol must be previously enabled by setting the proxy_protocol parameter in the listen directive.
---@type string
ngx.var.proxy_protocol_addr = nil

--- client port from the PROXY protocol header (1.11.0)
---
--- The PROXY protocol must be previously enabled by setting the proxy_protocol parameter in the listen directive.
---@type string
ngx.var.proxy_protocol_port = nil

--- server address from the PROXY protocol header (1.17.6)
---
--- The PROXY protocol must be previously enabled by setting the proxy_protocol parameter in the listen directive.
---@type string
ngx.var.proxy_protocol_server_addr = nil

--- server port from the PROXY protocol header (1.17.6)
---
--- The PROXY protocol must be previously enabled by setting the proxy_protocol parameter in the listen directive.
---@type string
ngx.var.proxy_protocol_server_port = nil

--- same as ngx.var.args
---@type string
ngx.var.query_string = nil

--- an absolute pathname corresponding to the root or alias directive’s value for the current request, with all symbolic links resolved to real paths
---@type string
ngx.var.realpath_root = nil

--- client address
---@type string
ngx.var.remote_addr = nil

--- client port
---@type string
ngx.var.remote_port = nil

--- user name supplied with the Basic authentication
---@type string
ngx.var.remote_user = nil

--- full original request line
---@type string
ngx.var.request = nil

--- request body
---
--- The variable’s value is made available in locations processed by the proxy_pass, fastcgi_pass, uwsgi_pass, and scgi_pass directives when the request body was read to a memory buffer.
---@type string
ngx.var.request_body = nil

--- name of a temporary file with the request body
---
--- At the end of processing, the file needs to be removed.
--- To always write the request body to a file, client_body_in_file_only needs to be enabled.
--- When the name of a temporary file is passed in a proxied request or in a request to a FastCGI/uwsgi/SCGI server, passing the request body should be disabled by the proxy_pass_request_body off, fastcgi_pass_request_body off, uwsgi_pass_request_body off, or scgi_pass_request_body off directives, respectively.
---@type string
ngx.var.request_body_file = nil

--- “OK” if a request has completed, or an empty string otherwise
---@type string
ngx.var.request_completion = nil

--- file path for the current request, based on the root or alias directives, and the request URI
---@type string
ngx.var.request_filename = nil

--- unique request identifier generated from 16 random bytes, in hexadecimal (1.11.0)
---@type string
ngx.var.request_id = nil

--- request length (including request line, header, and request body) (1.3.12, 1.2.7)
---@type string
ngx.var.request_length = nil

--- request method, usually “GET” or “POST”
---@type string
ngx.var.request_method = nil

--- request processing time in seconds with a milliseconds resolution (1.3.9, 1.2.6); time elapsed since the first bytes were read from the client
---@type string
ngx.var.request_time = nil

--- full original request URI (with arguments)
---@type string
ngx.var.request_uri = nil

--- request scheme, “http” or “https”
---@type string
ngx.var.scheme = nil

--- an address of the server which accepted a request
---
--- Computing a value of this variable usually requires one system call. To avoid a system call, the listen directives must specify addresses and use the bind parameter.
---@type string
ngx.var.server_addr = nil

--- name of the server which accepted a request
---@type string
ngx.var.server_name = nil

--- port of the server which accepted a request
---@type string
ngx.var.server_port = nil

--- request protocol, usually “HTTP/1.0”, “HTTP/1.1”, or “HTTP/2.0”
---@type string
ngx.var.server_protocol = nil

--- response status (1.3.2, 1.2.2)
---@type string
ngx.var.status = nil

--- local time in the ISO 8601 standard format (1.3.12, 1.2.7)
---@type string
ngx.var.time_iso8601 = nil

--- local time in the Common Log Format (1.3.12, 1.2.7)
---@type string
ngx.var.time_local = nil

--- current URI in request, normalized
--- The value of $uri may change during request processing, e.g. when doing internal redirects, or when using index files.
---@type string
ngx.var.uri = nil

--- Updating query arguments via the NGINX variable `$args` (or `ngx.var.args` in Lua) at runtime is also supported:
---
--- ```lua
---  ngx.var.args = "a=3&b=42"
---  local args, err = ngx.req.get_uri_args()
--- ```
---
--- Here the `args` table will always look like
---
--- ```lua
---  {a = 3, b = 42}
--- ```
---
--- regardless of the actual request query string.
---@type string
ngx.var.args = nil

--- embedded upstream variables
--- https://nginx.org/en/docs/http/ngx_http_upstream_module.html#variables

--- IP address and port, or the path to the UNIX-domain socket of the upstream server.
--- If several servers were contacted during request processing, their addresses are separated by commas, e.g. “192.168.1.1:80, 192.168.1.2:80, unix:/tmp/sock”.
--- If an internal redirect from one server group to another happens, initiated by “X-Accel-Redirect” or error_page, then the server addresses from different groups are separated by colons, e.g. “192.168.1.1:80, 192.168.1.2:80, unix:/tmp/sock : 192.168.10.1:80, 192.168.10.2:80”.
--- If a server cannot be selected, the variable keeps the name of the server group.
---@type string
ngx.var.upstream_addr = nil

--- number of bytes received from an upstream server (1.11.4). Values from several connections are separated by commas and colons like addresses in the $upstream_addr variable.
---@type string
ngx.var.upstream_bytes_received = nil

--- number of bytes sent to an upstream server (1.15.8). Values from several connections are separated by commas and colons like addresses in the $upstream_addr variable.
---@type string
ngx.var.upstream_bytes_sent = nil

--- status of accessing a response cache (0.8.3). The status can be either “MISS”, “BYPASS”, “EXPIRED”, “STALE”, “UPDATING”, “REVALIDATED”, or “HIT”.
---@type string
ngx.var.upstream_cache_status = nil

--- time spent on establishing a connection with the upstream server (1.9.1)
--
--- the time is kept in seconds with millisecond resolution.
--- In case of SSL, includes time spent on handshake.
--- Times of several connections are separated by commas and colons like addresses in the $upstream_addr variable.
---@type string
ngx.var.upstream_connect_time = nil

--- time spent on receiving the response header from the upstream server (1.7.10)
--- the time is kept in seconds with millisecond resolution.
--- Times of several responses are separated by commas and colons like addresses in the $upstream_addr variable.
---@type string
ngx.var.upstream_header_time = nil

--- the time the request spent in the upstream queue (1.13.9).
--- the time is kept in seconds with millisecond resolution.
--- Times of several responses are separated by commas and colons like addresses in the $upstream_addr variable.
---@type string
ngx.var.upstream_queue_time = nil

--- the length of the response obtained from the upstream server (0.7.27).
--- the length is kept in bytes.
--- Lengths of several responses are separated by commas and colons like addresses in the $upstream_addr variable.
---@type string
ngx.var.upstream_response_length = nil

--- time spent on receiving the response from the upstream server
---
--- the time is kept in seconds with millisecond resolution.
--- Times of several responses are separated by commas and colons like addresses in the $upstream_addr variable.
---@type string
ngx.var.upstream_response_time = nil

--- status code of the response obtained from the upstream server.
--- Status codes of several responses are separated by commas and colons like addresses in the $upstream_addr variable.
--- If a server cannot be selected, the variable keeps the 502 (Bad Gateway) status code.
---@type string
ngx.var.upstream_status = nil


ngx.req = {}

--- Returns a boolean indicating whether the current request is an "internal request", i.e.,
--- a request initiated from inside the current NGINX server instead of from the client side.
---
--- Subrequests are all internal requests and so are requests after internal redirects.
---
---@return boolean
function ngx.req.is_internal() end

--- Returns the HTTP version number for the current request as a Lua number.
---
--- Current possible values are 2.0, 1.0, 1.1, and 0.9. Returns `nil` for unrecognized values.
---
---@return '2.0'|'1.0'|'1.1'|'0.9'|'nil'
function ngx.req.http_version() end

--- Set the current request's request body using the in-memory data specified by the `data` argument.
---
--- If the request body has not been read yet, call `ngx.req.read_body` first (or turn on `lua_need_request_body` to force this module to read the request body. This is not recommended however). Additionally, the request body must not have been previously discarded by `ngx.req.discard_body`.
---
--- Whether the previous request body has been read into memory or buffered into a disk file, it will be freed or the disk file will be cleaned up immediately, respectively.
---
---@param data any
function ngx.req.set_body_data(data) end

--- Returns a Lua table holding all the current request POST query arguments (of the MIME type `application/x-www-form-urlencoded`). Call `ngx.req.read_body` to read the request body first or turn on the `lua_need_request_body` directive to avoid errors.
---
--- ```nginx
---  location = /test {
---      content_by_lua_block {
---          ngx.req.read_body()
---          local args, err = ngx.req.get_post_args()
---
---          if err == "truncated" then
---              -- one can choose to ignore or reject the current request here
---          end
---
---          if not args then
---              ngx.say("failed to get post args: ", err)
---              return
---          end
---          for key, val in pairs(args) do
---              if type(val) == "table" then
---                  ngx.say(key, ": ", table.concat(val, ", "))
---              else
---                  ngx.say(key, ": ", val)
---              end
---          end
---      }
---  }
--- ```
---
--- Then
---
--- ```bash
---  # Post request with the body 'foo=bar&bar=baz&bar=blah'
---  $ curl --data 'foo=bar&bar=baz&bar=blah' localhost/test
--- ```
---
--- will yield the response body like
---
--- ```bash
---  foo: bar
---  bar: baz, blah
--- ```
---
--- Multiple occurrences of an argument key will result in a table value holding all of the values for that key in order.
---
--- Keys and values will be unescaped according to URI escaping rules.
---
--- With the settings above,
---
--- ```bash
---  # POST request with body 'a%20b=1%61+2'
---  $ curl -d 'a%20b=1%61+2' localhost/test
--- ```
---
--- will yield:
---
--- ```bash
---  a b: 1a 2
--- ```
---
--- Arguments without the `=<value>` parts are treated as boolean arguments. `POST /test` with the request body `foo&bar` will yield:
---
--- ```bash
---  foo: true
---  bar: true
--- ```
---
--- That is, they will take Lua boolean values `true`. However, they are different from arguments taking empty string values. `POST /test` with request body `foo=&bar=` will return something like
---
--- ```bash
---  foo:
---  bar:
--- ```
---
--- Empty key arguments are discarded. `POST /test` with body `=hello&=world` will yield empty outputs for instance.
---
--- Note that a maximum of 100 request arguments are parsed by default (including those with the same name) and that additional request arguments are silently discarded to guard against potential denial of service attacks. When the limit is exceeded, it will return a second value which is the string `"truncated"`.
---
--- However, the optional `max_args` function argument can be used to override this limit:
---
--- ```lua
---  local args, err = ngx.req.get_post_args(10)
---  if err == "truncated" then
---      -- one can choose to ignore or reject the current request here
---  end
--- ```
---
--- This argument can be set to zero to remove the limit and to process all request arguments received:
---
--- ```lua
---  local args, err = ngx.req.get_post_args(0)
--- ```
---
--- Removing the `max_args` cap is strongly discouraged.
---
---@param max_args? number
---@return table args
---@return string|'"truncated"' error
function ngx.req.get_post_args(max_args) end

--- Returns a Lua table holding all the current request URL query arguments. An optional `tab` argument can be used to reuse the table returned by this method.
---
--- ```nginx
---  location = /test {
---      content_by_lua_block {
---          local args, err = ngx.req.get_uri_args()
---
---          if err == "truncated" then
---              -- one can choose to ignore or reject the current request here
---          end
---
---          for key, val in pairs(args) do
---              if type(val) == "table" then
---                  ngx.say(key, ": ", table.concat(val, ", "))
---              else
---                  ngx.say(key, ": ", val)
---              end
---          end
---      }
---  }
--- ```
---
--- Then `GET /test?foo=bar&bar=baz&bar=blah` will yield the response body
---
--- ```bash
---  foo: bar
---  bar: baz, blah
--- ```
---
--- Multiple occurrences of an argument key will result in a table value holding all the values for that key in order.
---
--- Keys and values are unescaped according to URI escaping rules. In the settings above, `GET /test?a%20b=1%61+2` will yield:
---
--- ```bash
---  a b: 1a 2
--- ```
---
--- Arguments without the `=<value>` parts are treated as boolean arguments. `GET /test?foo&bar` will yield:
---
--- ```bash
---  foo: true
---  bar: true
--- ```
---
--- That is, they will take Lua boolean values `true`. However, they are different from arguments taking empty string values. `GET /test?foo=&bar=` will give something like
---
--- ```bash
---  foo:
---  bar:
--- ```
---
--- Empty key arguments are discarded. `GET /test?=hello&=world` will yield an empty output for instance.
---
--- Updating query arguments via the NGINX variable `$args` (or `ngx.var.args` in Lua) at runtime is also supported:
---
--- ```lua
---  ngx.var.args = "a=3&b=42"
---  local args, err = ngx.req.get_uri_args()
--- ```
---
--- Here the `args` table will always look like
---
--- ```lua
---  {a = 3, b = 42}
--- ```
---
--- regardless of the actual request query string.
---
--- Note that a maximum of 100 request arguments are parsed by default (including those with the same name) and that additional request arguments are silently discarded to guard against potential denial of service attacks. When the limit is exceeded, it will return a second value which is the string `"truncated"`.
---
--- However, the optional `max_args` function argument can be used to override this limit:
---
--- ```lua
---  local args, err = ngx.req.get_uri_args(10)
---  if err == "truncated" then
---      -- one can choose to ignore or reject the current request here
---  end
--- ```
---
--- This argument can be set to zero to remove the limit and to process all request arguments received:
---
--- ```lua
---  local args, err = ngx.req.get_uri_args(0)
--- ```
---
--- Removing the `max_args` cap is strongly discouraged.
---
---@param max_args? number
---@param tab? table
---@return table args
---@return string|'"truncated"' error
function ngx.req.get_uri_args(max_args, tab) end

--- Rewrite the current request's (parsed) URI by the `uri` argument. The `uri` argument must be a Lua string and cannot be of zero length, or a Lua exception will be thrown.
---
--- The optional boolean `jump` argument can trigger location rematch (or location jump) as `ngx_http_rewrite_module`'s `rewrite` directive, that is, when `jump` is `true` (default to `false`), this function will never return and it will tell NGINX to try re-searching locations with the new URI value at the later `post-rewrite` phase and jumping to the new location.
---
--- Location jump will not be triggered otherwise, and only the current request's URI will be modified, which is also the default behavior. This function will return but with no returned values when the `jump` argument is `false` or absent altogether.
---
--- For example, the following NGINX config snippet
---
--- ```nginx
---  rewrite ^ /foo last;
--- ```
---
--- can be coded in Lua like this:
---
--- ```lua
---  ngx.req.set_uri("/foo", true)
--- ```
---
--- Similarly, NGINX config
---
--- ```nginx
---  rewrite ^ /foo break;
--- ```
---
--- can be coded in Lua as
---
--- ```lua
---  ngx.req.set_uri("/foo", false)
--- ```
---
--- or equivalently,
---
--- ```lua
---  ngx.req.set_uri("/foo")
--- ```
---
--- The `jump` argument can only be set to `true` in `rewrite_by_lua*`. Use of jump in other contexts is prohibited and will throw out a Lua exception.
---
--- A more sophisticated example involving regex substitutions is as follows
---
--- ```nginx
---  location /test {
---      rewrite_by_lua_block {
---          local uri = ngx.re.sub(ngx.var.uri, "^/test/(.*)", "/$1", "o")
---          ngx.req.set_uri(uri)
---      }
---      proxy_pass http://my_backend;
---  }
--- ```
---
--- which is functionally equivalent to
---
--- ```nginx
---  location /test {
---      rewrite ^/test/(.*) /$1 break;
---      proxy_pass http://my_backend;
---  }
--- ```
---
--- Note: this function throws a Lua error if the `uri` argument
--- contains unsafe characters (control characters).
---
--- Note that it is not possible to use this interface to rewrite URI arguments and that `ngx.req.set_uri_args` should be used for this instead. For instance, NGINX config
---
--- ```nginx
---  rewrite ^ /foo?a=3? last;
--- ```
---
--- can be coded as
---
--- ```nginx
---  ngx.req.set_uri_args("a=3")
---  ngx.req.set_uri("/foo", true)
--- ```
---
--- or
---
--- ```nginx
---  ngx.req.set_uri_args({a = 3})
---  ngx.req.set_uri("/foo", true)
--- ```
---
--- An optional boolean `binary` argument allows arbitrary binary URI data. By default, this `binary` argument is false and this function will throw out a Lua error such as the one below when the `uri` argument contains any control characters (ASCII Code 0 ~ 0x08, 0x0A ~ 0x1F and 0x7F).
---
---     [error] 23430#23430: *1 lua entry thread aborted: runtime error:
---     content_by_lua(nginx.conf:44):3: ngx.req.set_uri unsafe byte "0x00"
---     in "\x00foo" (maybe you want to set the 'binary' argument?)
---
---@param uri string
---@param jump? boolean
---@param binary? boolean
function ngx.req.set_uri(uri, jump, binary) end

--- Append new data chunk specified by the `data_chunk` argument onto the existing request body created by the `ngx.req.init_body` call.
---
--- When the data can no longer be hold in the memory buffer for the request body, then the data will be flushed onto a temporary file just like the standard request body reader in the NGINX core.
---
--- It is important to always call the `ngx.req.finish_body` after all the data has been appended onto the current request body.
---
--- This function can be used with `ngx.req.init_body`, `ngx.req.finish_body`, and `ngx.req.socket` to implement efficient input filters in pure Lua (in the context of `rewrite_by_lua*` or `access_by_lua*`), which can be used with other NGINX content handler or upstream modules like `ngx_http_proxy_module` and `ngx_http_fastcgi_module`.
---
---@param data_chunk any
function ngx.req.append_body(data_chunk) end

--- Overrides the current request's request method with the `method_id` argument. Currently only numerical `method constants` are supported, like `ngx.HTTP_POST` and `ngx.HTTP_GET`.
---
--- If the current request is an NGINX subrequest, then the subrequest's method will be overridden.
---
---@param method_id ngx.http.method
function ngx.req.set_method(method_id) end

--- Retrieves the current request's request method name. Strings like `"GET"` and `"POST"` are returned instead of numerical `method constants`.
---
--- If the current request is an NGINX subrequest, then the subrequest's method name will be returned.
---
---@return string
function ngx.req.get_method() end

--- Returns a read-only cosocket object that wraps the downstream connection. Only `receive` and `receiveuntil` methods are supported on this object.
---
--- In case of error, `nil` will be returned as well as a string describing the error.
---
--- The socket object returned by this method is usually used to read the current request's body in a streaming fashion. Do not turn on the `lua_need_request_body` directive, and do not mix this call with `ngx.req.read_body` and `ngx.req.discard_body`.
---
--- If any request body data has been pre-read into the NGINX core request header buffer, the resulting cosocket object will take care of this to avoid potential data loss resulting from such pre-reading.
--- Chunked request bodies are not yet supported in this API.
---
--- An optional boolean `raw` argument can be provided. When this argument is `true`, this function returns a full-duplex cosocket object wrapping around the raw downstream connection socket, upon which you can call the `receive`, `receiveuntil`, and `send` methods.
---
--- When the `raw` argument is `true`, it is required that no pending data from any previous `ngx.say`, `ngx.print`, or `ngx.send_headers` calls exists. So if you have these downstream output calls previously, you should call `ngx.flush(true)` before calling `ngx.req.socket(true)` to ensure that there is no pending output data. If the request body has not been read yet, then this "raw socket" can also be used to read the request body.
---
--- You can use the "raw request socket" returned by `ngx.req.socket(true)` to implement fancy protocols like `WebSocket`, or just emit your own raw HTTP response header or body data. You can refer to the `lua-resty-websocket library` for a real world example.
---
---@param raw? boolean
---@return tcpsock? socket
---@return string? error
function ngx.req.socket(raw) end

--- Completes the construction process of the new request body created by the `ngx.req.init_body` and `ngx.req.append_body` calls.
---
--- This function can be used with `ngx.req.init_body`, `ngx.req.append_body`, and `ngx.req.socket` to implement efficient input filters in pure Lua (in the context of `rewrite_by_lua*` or `access_by_lua*`), which can be used with other NGINX content handler or upstream modules like `ngx_http_proxy_module` and `ngx_http_fastcgi_module`.
---
function ngx.req.finish_body() end

--- Returns the original raw HTTP protocol header received by the NGINX server.
---
--- By default, the request line and trailing `CR LF` terminator will also be included. For example,
---
--- ```lua
---  ngx.print(ngx.req.raw_header())
--- ```
---
--- gives something like this:
---
---     GET /t HTTP/1.1
---     Host: localhost
---     Connection: close
---     Foo: bar
---
--- You can specify the optional
--- `no_request_line` argument as a `true` value to exclude the request line from the result. For example,
---
--- ```lua
---  ngx.print(ngx.req.raw_header(true))
--- ```
---
--- outputs something like this:
---
---     Host: localhost
---     Connection: close
---     Foo: bar
---
--- This method does not work in HTTP/2 requests yet.
---
---@param no_request_line? boolean
---@return string
function ngx.req.raw_header(no_request_line) end

--- Returns a floating-point number representing the timestamp (including milliseconds as the decimal part) when the current request was created.
---
--- The following example emulates the `$request_time` variable value (provided by `ngx_http_log_module`) in pure Lua:
---
--- ```lua
---  local request_time = ngx.now() - ngx.req.start_time()
--- ```
---
---@return number
function ngx.req.start_time() end

--- Creates a new blank request body for the current request and inializes the buffer for later request body data writing via the `ngx.req.append_body` and `ngx.req.finish_body` APIs.
---
--- If the `buffer_size` argument is specified, then its value will be used for the size of the memory buffer for body writing with `ngx.req.append_body`. If the argument is omitted, then the value specified by the standard `client_body_buffer_size` directive will be used instead.
---
--- When the data can no longer be hold in the memory buffer for the request body, then the data will be flushed onto a temporary file just like the standard request body reader in the NGINX core.
---
--- It is important to always call the `ngx.req.finish_body` after all the data has been appended onto the current request body. Also, when this function is used together with `ngx.req.socket`, it is required to call `ngx.req.socket` *before* this function, or you will get the "request body already exists" error message.
---
--- The usage of this function is often like this:
---
--- ```lua
---  ngx.req.init_body(128 * 1024)  -- buffer is 128KB
---  for chunk in next_data_chunk() do
---      ngx.req.append_body(chunk) -- each chunk can be 4KB
---  end
---  ngx.req.finish_body()
--- ```
---
--- This function can be used with `ngx.req.append_body`, `ngx.req.finish_body`, and `ngx.req.socket` to implement efficient input filters in pure Lua (in the context of `rewrite_by_lua*` or `access_by_lua*`), which can be used with other NGINX content handler or upstream modules like `ngx_http_proxy_module` and `ngx_http_fastcgi_module`.
---
---@param buffer_size?  number
function ngx.req.init_body(buffer_size) end

--- Set the current request's request body using the in-file data specified by the `file_name` argument.
---
--- If the request body has not been read yet, call `ngx.req.read_body` first (or turn on `lua_need_request_body` to force this module to read the request body. This is not recommended however). Additionally, the request body must not have been previously discarded by `ngx.req.discard_body`.
---
--- If the optional `auto_clean` argument is given a `true` value, then this file will be removed at request completion or the next time this function or `ngx.req.set_body_data` are called in the same request. The `auto_clean` is default to `false`.
---
--- Please ensure that the file specified by the `file_name` argument exists and is readable by an NGINX worker process by setting its permission properly to avoid Lua exception errors.
---
--- Whether the previous request body has been read into memory or buffered into a disk file, it will be freed or the disk file will be cleaned up immediately, respectively.
---
---@param file_name string
---@param auto_clean? boolean
function ngx.req.set_body_file(file_name, auto_clean) end

--- Clears the current request's request header named `header_name`. None of the current request's existing subrequests will be affected but subsequently initiated subrequests will inherit the change by default.
---
---@param header_name string
function ngx.req.clear_header(header_name) end

--- Returns a Lua table holding all the current request headers.
---
--- ```lua
---  local h, err = ngx.req.get_headers()
---
---  if err == "truncated" then
---      -- one can choose to ignore or reject the current request here
---  end
---
---  for k, v in pairs(h) do
---      ...
---  end
--- ```
---
--- To read an individual header:
---
--- ```lua
---  ngx.say("Host: ", ngx.req.get_headers()["Host"])
--- ```
---
--- Note that the `ngx.var.HEADER` API call, which uses core `$http_HEADER` variables, may be more preferable for reading individual request headers.
---
--- For multiple instances of request headers such as:
---
--- ```bash
---  Foo: foo
---  Foo: bar
---  Foo: baz
--- ```
---
--- the value of `ngx.req.get_headers()["Foo"]` will be a Lua (array) table such as:
---
--- ```lua
---  {"foo", "bar", "baz"}
--- ```
---
--- Note that a maximum of 100 request headers are parsed by default (including those with the same name) and that additional request headers are silently discarded to guard against potential denial of service attacks. When the limit is exceeded, it will return a second value which is the string `"truncated"`.
---
--- However, the optional `max_headers` function argument can be used to override this limit:
---
--- ```lua
---  local headers, err = ngx.req.get_headers(10)
---
---  if err == "truncated" then
---      -- one can choose to ignore or reject the current request here
---  end
--- ```
---
--- This argument can be set to zero to remove the limit and to process all request headers received:
---
--- ```lua
---  local headers, err = ngx.req.get_headers(0)
--- ```
---
--- Removing the `max_headers` cap is strongly discouraged.
---
--- All the header names in the Lua table returned are converted to the pure lower-case form by default, unless the `raw` argument is set to `true` (default to `false`).
---
--- Also, by default, an `__index` metamethod is added to the resulting Lua table and will normalize the keys to a pure lowercase form with all underscores converted to dashes in case of a lookup miss. For example, if a request header `My-Foo-Header` is present, then the following invocations will all pick up the value of this header correctly:
---
--- ```lua
---  ngx.say(headers.my_foo_header)
---  ngx.say(headers["My-Foo-Header"])
---  ngx.say(headers["my-foo-header"])
--- ```
---
--- The `__index` metamethod will not be added when the `raw` argument is set to `true`.
---
---@param max_headers? number
---@param raw? boolean
---@return table<string, string|string[]> headers
---@return string|'"truncated"' error
function ngx.req.get_headers(max_headers, raw) end

--- Explicitly discard the request body, i.e., read the data on the connection and throw it away immediately (without using the request body by any means).
---
--- This function is an asynchronous call and returns immediately.
---
--- If the request body has already been read, this function does nothing and returns immediately.
---
function ngx.req.discard_body() end

--- Set the current request's request header named `header_name` to value `header_value`, overriding any existing ones.
---
--- By default, all the subrequests subsequently initiated by `ngx.location.capture` and `ngx.location.capture_multi` will inherit the new header.
---
--- Here is an example of setting the `Content-Type` header:
---
--- ```lua
---  ngx.req.set_header("Content-Type", "text/css")
--- ```
---
--- The `header_value` can take an array list of values,
--- for example,
---
--- ```lua
---  ngx.req.set_header("Foo", {"a", "abc"})
--- ```
---
--- will produce two new request headers:
---
--- ```bash
---  Foo: a
---  Foo: abc
--- ```
---
--- and old `Foo` headers will be overridden if there is any.
---
--- When the `header_value` argument is `nil`, the request header will be removed. So
---
--- ```lua
---  ngx.req.set_header("X-Foo", nil)
--- ```
---
--- is equivalent to
---
--- ```lua
---  ngx.req.clear_header("X-Foo")
--- ```
---
---@param header_name string
---@param header_value string|string[]|nil
function ngx.req.set_header(header_name, header_value) end

--- Retrieves in-memory request body data. It returns a Lua string rather than a Lua table holding all the parsed query arguments. Use the `ngx.req.get_post_args` function instead if a Lua table is required.
---
--- This function returns `nil` if
---
--- 1. the request body has not been read,
--- 1. the request body has been read into disk temporary files,
--- 1. or the request body has zero size.
---
--- If the request body has not been read yet, call `ngx.req.read_body` first (or turn on `lua_need_request_body` to force this module to read the request body. This is not recommended however).
---
--- If the request body has been read into disk files, try calling the `ngx.req.get_body_file` function instead.
---
--- To force in-memory request bodies, try setting `client_body_buffer_size` to the same size value in `client_max_body_size`.
---
--- Note that calling this function instead of using `ngx.var.request_body` or `ngx.var.echo_request_body` is more efficient because it can save one dynamic memory allocation and one data copy.
---
---@return string?
function ngx.req.get_body_data() end

--- Reads the client request body synchronously without blocking the NGINX event loop.
---
--- ```lua
---  ngx.req.read_body()
---  local args = ngx.req.get_post_args()
--- ```
---
--- If the request body is already read previously by turning on `lua_need_request_body` or by using other modules, then this function does not run and returns immediately.
---
--- If the request body has already been explicitly discarded, either by the `ngx.req.discard_body` function or other modules, this function does not run and returns immediately.
---
--- In case of errors, such as connection errors while reading the data, this method will throw out a Lua exception *or* terminate the current request with a 500 status code immediately.
---
--- The request body data read using this function can be retrieved later via `ngx.req.get_body_data` or, alternatively, the temporary file name for the body data cached to disk using `ngx.req.get_body_file`. This depends on
---
--- 1. whether the current request body is already larger than the `client_body_buffer_size`,
--- 1. and whether `client_body_in_file_only` has been switched on.
---
--- In cases where current request may have a request body and the request body data is not required, The `ngx.req.discard_body` function must be used to explicitly discard the request body to avoid breaking things under HTTP 1.1 keepalive or HTTP 1.1 pipelining.
---
function ngx.req.read_body() end

--- Retrieves the file name for the in-file request body data. Returns `nil` if the request body has not been read or has been read into memory.
---
--- The returned file is read only and is usually cleaned up by NGINX's memory pool. It should not be manually modified, renamed, or removed in Lua code.
---
--- If the request body has not been read yet, call `ngx.req.read_body` first (or turn on `lua_need_request_body` to force this module to read the request body. This is not recommended however).
---
--- If the request body has been read into memory, try calling the `ngx.req.get_body_data` function instead.
---
--- To force in-file request bodies, try turning on `client_body_in_file_only`.
---
---@return string? filename
function ngx.req.get_body_file() end

--- Rewrite the current request's URI query arguments by the `args` argument. The `args` argument can be either a Lua string, as in
---
--- ```lua
---  ngx.req.set_uri_args("a=3&b=hello%20world")
--- ```
---
--- or a Lua table holding the query arguments' key-value pairs, as in
---
--- ```lua
---  ngx.req.set_uri_args({ a = 3, b = "hello world" })
--- ```
---
--- where in the latter case, this method will escape argument keys and values according to the URI escaping rule.
---
--- Multi-value arguments are also supported:
---
--- ```lua
---  ngx.req.set_uri_args({ a = 3, b = {5, 6} })
--- ```
---
--- which will result in a query string like `a=3&b=5&b=6`.
---
---@param args string|table
function ngx.req.set_uri_args(args) end

--- Encode the Lua table to a query args string according to the URI encoded rules.
---
--- For example,
---
--- ```lua
---  ngx.encode_args({foo = 3, ["b r"] = "hello world"})
--- ```
---
--- yields
---
---     foo=3&b%20r=hello%20world
---
--- The table keys must be Lua strings.
---
--- Multi-value query args are also supported. Just use a Lua table for the argument's value, for example:
---
--- ```lua
---  ngx.encode_args({baz = {32, "hello"}})
--- ```
---
--- gives
---
---     baz=32&baz=hello
---
--- If the value table is empty and the effect is equivalent to the `nil` value.
---
--- Boolean argument values are also supported, for instance,
---
--- ```lua
---  ngx.encode_args({a = true, b = 1})
--- ```
---
--- yields
---
---     a&b=1
---
--- If the argument value is `false`, then the effect is equivalent to the `nil` value.
---
---@param args table
---@return string encoded
function ngx.encode_args(args) end

--- Decodes a URI encoded query-string into a Lua table. This is the inverse function of `ngx.encode_args`.
---
--- The optional `max_args` argument can be used to specify the maximum number of arguments parsed from the `str` argument. By default, a maximum of 100 request arguments are parsed (including those with the same name) and that additional URI arguments are silently discarded to guard against potential denial of service attacks. When the limit is exceeded, it will return a second value which is the string `"truncated"`.
---
--- This argument can be set to zero to remove the limit and to process all request arguments received:
---
--- ```lua
---  local args = ngx.decode_args(str, 0)
--- ```
---
--- Removing the `max_args` cap is strongly discouraged.
---
---@param  str                  string
---@param  max_args?            number
---@return table                args
---@return string|'"truncated"' error
function ngx.decode_args(str, max_args) end

ngx.socket = {}

---@class udpsock
local udpsock = {}

--- Attempts to connect a UDP socket object to a remote server or to a datagram unix domain socket file. Because the datagram protocol is actually connection-less, this method does not really establish a "connection", but only just set the name of the remote peer for subsequent read/write operations.
---
--- Both IP addresses and domain names can be specified as the `host` argument. In case of domain names, this method will use NGINX core's dynamic resolver to parse the domain name without blocking and it is required to configure the `resolver` directive in the `nginx.conf` file like this:
---
--- ```nginx
---  resolver 8.8.8.8;  # use Google's public DNS nameserver
--- ```
---
--- If the nameserver returns multiple IP addresses for the host name, this method will pick up one randomly.
---
--- In case of error, the method returns `nil` followed by a string describing the error. In case of success, the method returns `1`.
---
--- Here is an example for connecting to a UDP (memcached) server:
---
--- ```nginx
---  location /test {
---      resolver 8.8.8.8;
---
---      content_by_lua_block {
---          local sock = ngx.socket.udp()
---          local ok, err = sock:setpeername("my.memcached.server.domain", 11211)
---          if not ok then
---              ngx.say("failed to connect to memcached: ", err)
---              return
---          end
---          ngx.say("successfully connected to memcached!")
---          sock:close()
---      }
---  }
--- ```
---
--- Connecting to a datagram unix domain socket file is also possible on Linux:
---
--- ```lua
---  local sock = ngx.socket.udp()
---  local ok, err = sock:setpeername("unix:/tmp/some-datagram-service.sock")
---  if not ok then
---      ngx.say("failed to connect to the datagram unix domain socket: ", err)
---      return
---  end
--- ```
---
--- assuming the datagram service is listening on the unix domain socket file `/tmp/some-datagram-service.sock` and the client socket will use the "autobind" feature on Linux.
---
--- Calling this method on an already connected socket object will cause the original connection to be closed first.
---
---@param host  string
---@param port number
---@return boolean ok
---@return string? error
---@overload fun(self:udpsock, unix_socket:string):boolean, string?
function udpsock:setpeername(host, port) end

--- Sends data on the current UDP or datagram unix domain socket object.
---
--- In case of success, it returns `1`. Otherwise, it returns `nil` and a string describing the error.
---
--- The input argument `data` can either be a Lua string or a (nested) Lua table holding string fragments. In case of table arguments, this method will copy all the string elements piece by piece to the underlying NGINX socket send buffers, which is usually optimal than doing string concatenation operations on the Lua land.
---
---@param data string | string[]
---@return boolean ok
---@return string? error
function udpsock:send(data) end

--- Receives data from the UDP or datagram unix domain socket object with an optional receive buffer size argument, `size`.
---
--- This method is a synchronous operation and is 100% nonblocking.
---
--- In case of success, it returns the data received; in case of error, it returns `nil` with a string describing the error.
---
--- If the `size` argument is specified, then this method will use this size as the receive buffer size. But when this size is greater than `8192`, then `8192` will be used instead.
---
--- If no argument is specified, then the maximal buffer size, `8192` is assumed.
---
--- Timeout for the reading operation is controlled by the `lua_socket_read_timeout` config directive and the `settimeout` method. And the latter takes priority. For example:
---
--- ```lua
---  sock:settimeout(1000)  -- one second timeout
---  local data, err = sock:receive()
---  if not data then
---      ngx.say("failed to read a packet: ", err)
---      return
---  end
---  ngx.say("successfully read a packet: ", data)
--- ```
---
--- It is important here to call the `settimeout` method *before* calling this method.
---
---@param size? number
---@return string? data
---@return string? error
function udpsock:receive(size) end


--- Closes the current UDP or datagram unix domain socket. It returns the `1` in case of success and returns `nil` with a string describing the error otherwise.
---
--- Socket objects that have not invoked this method (and associated connections) will be closed when the socket object is released by the Lua GC (Garbage Collector) or the current client HTTP request finishes processing.
---
---@return boolean ok
---@return string? error
function udpsock:close() end

--- Set the timeout value in milliseconds for subsequent socket operations (like `receive`).
---
--- Settings done by this method takes priority over those config directives, like `lua_socket_read_timeout`.
---
---@param time number
function udpsock:settimeout(time) end

--- Creates and returns a TCP or stream-oriented unix domain socket object (also known as one type of the "cosocket" objects). The following methods are supported on this object:
---
--- * `connect`
--- * `sslhandshake`
--- * `send`
--- * `receive`
--- * `close`
--- * `settimeout`
--- * `settimeouts`
--- * `setoption`
--- * `receiveany`
--- * `receiveuntil`
--- * `setkeepalive`
--- * `getreusedtimes`
---
--- It is intended to be compatible with the TCP API of the `LuaSocket` library but is 100% nonblocking out of the box.
---
--- The cosocket object created by this API function has exactly the same lifetime as the Lua handler creating it. So never pass the cosocket object to any other Lua handler (including ngx.timer callback functions) and never share the cosocket object between different NGINX requests.
---
--- For every cosocket object's underlying connection, if you do not
--- explicitly close it (via `close`) or put it back to the connection
--- pool (via `setkeepalive`), then it is automatically closed when one of
--- the following two events happens:
---
--- * the current request handler completes, or
--- * the Lua cosocket object value gets collected by the Lua GC.
---
--- Fatal errors in cosocket operations always automatically close the current
--- connection (note that, read timeout error is the only error that is
--- not fatal), and if you call `close` on a closed connection, you will get
--- the "closed" error.
---
--- The cosocket object here is full-duplex, that is, a reader "light thread" and a writer "light thread" can operate on a single cosocket object simultaneously (both "light threads" must belong to the same Lua handler though, see reasons above). But you cannot have two "light threads" both reading (or writing or connecting) the same cosocket, otherwise you might get an error like "socket busy reading" when calling the methods of the cosocket object.
---
---@return tcpsock
function ngx.socket.tcp() end

---@class tcpsock
local tcpsock = {}

--- Attempts to connect a TCP socket object to a remote server or to a stream unix domain socket file without blocking.
---
--- Before actually resolving the host name and connecting to the remote backend, this method will always look up the connection pool for matched idle connections created by previous calls of this method (or the `ngx.socket.connect` function).
---
--- Both IP addresses and domain names can be specified as the `host` argument. In case of domain names, this method will use NGINX core's dynamic resolver to parse the domain name without blocking and it is required to configure the `resolver` directive in the `nginx.conf` file like this:
---
--- ```nginx
---  resolver 8.8.8.8;  # use Google's public DNS nameserver
--- ```
---
--- If the nameserver returns multiple IP addresses for the host name, this method will pick up one randomly.
---
--- In case of error, the method returns `nil` followed by a string describing the error. In case of success, the method returns `1`.
---
--- Here is an example for connecting to a TCP server:
---
--- ```nginx
---  location /test {
---      resolver 8.8.8.8;
---
---      content_by_lua_block {
---          local sock = ngx.socket.tcp()
---          local ok, err = sock:connect("www.google.com", 80)
---          if not ok then
---              ngx.say("failed to connect to google: ", err)
---              return
---          end
---          ngx.say("successfully connected to google!")
---          sock:close()
---      }
---  }
--- ```
---
--- Connecting to a Unix Domain Socket file is also possible:
---
--- ```lua
---  local sock = ngx.socket.tcp()
---  local ok, err = sock:connect("unix:/tmp/memcached.sock")
---  if not ok then
---      ngx.say("failed to connect to the memcached unix domain socket: ", err)
---      return
---  end
--- ```
---
--- assuming memcached (or something else) is listening on the unix domain socket file `/tmp/memcached.sock`.
---
--- Timeout for the connecting operation is controlled by the `lua_socket_connect_timeout` config directive and the `settimeout` method. And the latter takes priority. For example:
---
--- ```lua
---  local sock = ngx.socket.tcp()
---  sock:settimeout(1000)  -- one second timeout
---  local ok, err = sock:connect(host, port)
--- ```
---
--- It is important here to call the `settimeout` method *before* calling this method.
---
--- Calling this method on an already connected socket object will cause the original connection to be closed first.
---
---@param host string
---@param port number
---@param opts? tcpsock.connect.opts
---@return boolean ok
---@return string? error
---@overload fun(self:tcpsock, unix_socket:string, opts?:tcpsock.connect.opts):boolean, string?
function tcpsock:connect(host, port, opts) end

--- An optional Lua table can be specified as the last argument to `tcpsock:connect()`
---
---@class tcpsock.connect.opts : table
---
--- A custom name for the connection pool being used. If omitted, then the connection pool name will be generated from the string template `"<host>:<port>"` or `"<unix-socket-path>"`.
---@field pool string
---
---	The size of the connection pool. If omitted and no `backlog` option was provided, no pool will be created. If omitted but `backlog` was provided, the pool will be created with a default size equal to the value of the `lua_socket_pool_size` directive. The connection pool holds up to `pool_size` alive connections ready to be reused by subsequent calls to `connect`, but note that there is no upper limit to the total number of opened connections outside of the pool. If you need to restrict the total number of opened connections, specify the `backlog` option. When the connection pool would exceed its size limit, the least recently used (kept-alive) connection already in the pool will be closed to make room for the current connection. Note that the cosocket connection pool is per NGINX worker process rather than per NGINX server instance, so the size limit specified here also applies to every single NGINX worker process. Also note that the size of the connection pool cannot be changed once it has been created.
---@field pool_size number
---
--- Limits the total number of opened connections for this pool. No more connections than `pool_size` can be opened for this pool at any time. If the connection pool is full, subsequent connect operations will be queued into a queue equal to this option's value (the "backlog" queue). If the number of queued connect operations is equal to `backlog`, subsequent connect operations will fail and return `nil` plus the error string `"too many waiting connect operations"`. The queued connect operations will be resumed once the number of connections in the pool is less than `pool_size`. The queued connect operation will abort once they have been queued for more than `connect_timeout`, controlled by `settimeouts`, and will return `nil` plus the error string `"timeout"`.
---@field backlog number


--- Does SSL/TLS handshake on the currently established connection.
---
--- The optional `reused_session` argument can take a former SSL
--- session userdata returned by a previous `sslhandshake`
--- call for exactly the same target. For short-lived connections, reusing SSL
--- sessions can usually speed up the handshake by one order by magnitude but it
--- is not so useful if the connection pool is enabled. This argument defaults to
--- `nil`. If this argument takes the boolean `false` value, no SSL session
--- userdata would return by this call and only a Lua boolean will be returned as
--- the first return value; otherwise the current SSL session will
--- always be returned as the first argument in case of successes.
---
--- The optional `server_name` argument is used to specify the server
--- name for the new TLS extension Server Name Indication (SNI). Use of SNI can
--- make different servers share the same IP address on the server side. Also,
--- when SSL verification is enabled, this `server_name` argument is
--- also used to validate the server name specified in the server certificate sent from
--- the remote.
---
--- The optional `ssl_verify` argument takes a Lua boolean value to
--- control whether to perform SSL verification. When set to `true`, the server
--- certificate will be verified according to the CA certificates specified by
--- the `lua_ssl_trusted_certificate` directive.
--- You may also need to adjust the `lua_ssl_verify_depth`
--- directive to control how deep we should follow along the certificate chain.
--- Also, when the `ssl_verify` argument is true and the
--- `server_name` argument is also specified, the latter will be used
--- to validate the server name in the server certificate.
---
--- The optional `send_status_req` argument takes a boolean that controls whether to send
--- the OCSP status request in the SSL handshake request (which is for requesting OCSP stapling).
---
--- For connections that have already done SSL/TLS handshake, this method returns
--- immediately.
---
---@param reused_session?  userdata|boolean
---@param server_name?     string
---@param ssl_verify?      boolean
---@param send_status_req? boolean
---@return userdata|boolean session_or_ok
---@return string? error
function tcpsock:sslhandshake(reused_session, server_name, ssl_verify, send_status_req) end

--- Set client certificate chain and corresponding private key to the TCP socket object.
---
--- The certificate chain and private key provided will be used later by the `tcpsock:sslhandshake` method.
---
--- If both of `cert` and `pkey` are `nil`, this method will clear any existing client certificate and private key that was previously set on the cosocket object
---
---@param cert ffi.cdata*|nil # a client certificate chain cdata object that will be used while handshaking with remote server. These objects can be created using ngx.ssl.parse_pem_cert function provided by lua-resty-core. Note that specifying the cert option requires corresponding pkey be provided too.
---@param key ffi.cdata*|nil  # a private key corresponds to the cert option above. These objects can be created using ngx.ssl.parse_pem_priv_key function provided by lua-resty-core.
---@return boolean ok
---@return string? error
function tcpsock:setclientcert(cert, key) end


--- Sends data without blocking on the current TCP or Unix Domain Socket connection.
---
--- This method is a synchronous operation that will not return until *all* the data has been flushed into the system socket send buffer or an error occurs.
---
--- In case of success, it returns the total number of bytes that have been sent. Otherwise, it returns `nil` and a string describing the error.
---
--- The input argument `data` can either be a Lua string or a (nested) Lua table holding string fragments. In case of table arguments, this method will copy all the string elements piece by piece to the underlying NGINX socket send buffers, which is usually optimal than doing string concatenation operations on the Lua land.
---
--- Timeout for the sending operation is controlled by the `lua_socket_send_timeout` config directive and the `settimeout` method. And the latter takes priority. For example:
---
--- ```lua
---  sock:settimeout(1000)  -- one second timeout
---  local bytes, err = sock:send(request)
--- ```
---
--- It is important here to call the `settimeout` method *before* calling this method.
---
--- In case of any connection errors, this method always automatically closes the current connection.
---
---@param data string|string[]
---@return number? bytes
---@return string? error
function tcpsock:send(data) end


--- Receives data from the connected socket according to the reading pattern or size.
---
--- This method is a synchronous operation just like the `send` method and is 100% nonblocking.
---
--- In case of success, it returns the data received; in case of error, it returns `nil` with a string describing the error and the partial data received so far.
---
--- If a non-number-like string argument is specified, then it is interpreted as a "pattern". The following patterns are supported:
---
--- * `'*a'`: reads from the socket until the connection is closed. No end-of-line translation is performed;
--- * `'*l'`: reads a line of text from the socket. The line is terminated by a `Line Feed` (LF) character (ASCII 10), optionally preceded by a `Carriage Return` (CR) character (ASCII 13). The CR and LF characters are not included in the returned line. In fact, all CR characters are ignored by the pattern.
---
--- If no argument is specified, then it is assumed to be the pattern `'*l'`, that is, the line reading pattern.
---
--- If a number-like argument is specified (including strings that look like numbers), then it is interpreted as a size. This method will not return until it reads exactly this size of data or an error occurs.
---
---
--- Timeout for the reading operation is controlled by the `lua_socket_read_timeout` config directive and the `settimeout` method. And the latter takes priority. For example:
---
--- ```lua
---  sock:settimeout(1000)  -- one second timeout
---  local line, err, partial = sock:receive()
---  if not line then
---      ngx.say("failed to read a line: ", err)
---      return
---  end
---  ngx.say("successfully read a line: ", line)
--- ```
---
--- It is important here to call the `settimeout` method *before* calling this method.
---
--- This method does not automatically closes the current connection when the read timeout error happens. For other connection errors, this method always automatically closes the connection.
---
---@overload fun(self:tcpsock, size:number):string,string,string
---
---@param  pattern? '"*a"'|'"*l"'
---@return string? data
---@return string? error
---@return string? partial
function tcpsock:receive(pattern) end

--- Returns any data received by the connected socket, at most `max` bytes.
---
--- This method is a synchronous operation just like the `send` method and is 100% nonblocking.
---
--- In case of success, it returns the data received; in case of error, it returns `nil` with a string describing the error.
---
--- If the received data is more than this size, this method will return with exactly this size of data.
--- The remaining data in the underlying receive buffer could be returned in the next reading operation.
---
--- Timeout for the reading operation is controlled by the `lua_socket_read_timeout` config directive and the `settimeouts` method. And the latter takes priority. For example:
---
--- ```lua
---  sock:settimeouts(1000, 1000, 1000)  -- one second timeout for connect/read/write
---  local data, err = sock:receiveany(10 * 1024) -- read any data, at most 10K
---  if not data then
---      ngx.say("failed to read any data: ", err)
---      return
---  end
---  ngx.say("successfully read: ", data)
--- ```
---
--- This method doesn't automatically close the current connection when the read timeout error occurs. For other connection errors, this method always automatically closes the connection.
---
---@param max integer
---@return string? data
---@return string? error
function tcpsock:receiveany(max) end


--- This method returns an iterator Lua function that can be called to read the data stream until it sees the specified pattern or an error occurs.
---
--- Here is an example for using this method to read a data stream with the boundary sequence `--abcedhb`:
---
--- ```lua
---  local reader = sock:receiveuntil("\r\n--abcedhb")
---  local data, err, partial = reader()
---  if not data then
---      ngx.say("failed to read the data stream: ", err)
---  end
---  ngx.say("read the data stream: ", data)
--- ```
---
--- When called without any argument, the iterator function returns the received data right *before* the specified pattern string in the incoming data stream. So for the example above, if the incoming data stream is `'hello, world! -agentzh\r\n--abcedhb blah blah'`, then the string `'hello, world! -agentzh'` will be returned.
---
--- In case of error, the iterator function will return `nil` along with a string describing the error and the partial data bytes that have been read so far.
---
--- The iterator function can be called multiple times and can be mixed safely with other cosocket method calls or other iterator function calls.
---
--- The iterator function behaves differently (i.e., like a real iterator) when it is called with a `size` argument. That is, it will read that `size` of data on each invocation and will return `nil` at the last invocation (either sees the boundary pattern or meets an error). For the last successful invocation of the iterator function, the `err` return value will be `nil` too. The iterator function will be reset after the last successful invocation that returns `nil` data and `nil` error. Consider the following example:
---
--- ```lua
---  local reader = sock:receiveuntil("\r\n--abcedhb")
---
---  while true do
---      local data, err, partial = reader(4)
---      if not data then
---          if err then
---              ngx.say("failed to read the data stream: ", err)
---              break
---          end
---
---          ngx.say("read done")
---          break
---      end
---      ngx.say("read chunk: [", data, "]")
---  end
--- ```
---
--- Then for the incoming data stream `'hello, world! -agentzh\r\n--abcedhb blah blah'`, we shall get the following output from the sample code above:
---
---     read chunk: [hell]
---     read chunk: [o, w]
---     read chunk: [orld]
---     read chunk: [! -a]
---     read chunk: [gent]
---     read chunk: [zh]
---     read done
---
--- Note that, the actual data returned *might* be a little longer than the size limit specified by the `size` argument when the boundary pattern has ambiguity for streaming parsing. Near the boundary of the data stream, the data string actually returned could also be shorter than the size limit.
---
--- Timeout for the iterator function's reading operation is controlled by the `lua_socket_read_timeout` config directive and the `settimeout` method. And the latter takes priority. For example:
---
--- ```lua
---  local readline = sock:receiveuntil("\r\n")
---
---  sock:settimeout(1000)  -- one second timeout
---  line, err, partial = readline()
---  if not line then
---      ngx.say("failed to read a line: ", err)
---      return
---  end
---  ngx.say("successfully read a line: ", line)
--- ```
---
--- It is important here to call the `settimeout` method *before* calling the iterator function (note that the `receiveuntil` call is irrelevant here).
---
--- This method also takes an optional `options` table argument to control the behavior. The following options are supported:
---
--- * `inclusive`
---
--- The `inclusive` takes a boolean value to control whether to include the pattern string in the returned data string. Default to `false`. For example,
---
--- ```lua
---  local reader = tcpsock:receiveuntil("_END_", { inclusive = true })
---  local data = reader()
---  ngx.say(data)
--- ```
---
--- Then for the input data stream `"hello world _END_ blah blah blah"`, then the example above will output `hello world _END_`, including the pattern string `_END_` itself.
---
--- This method does not automatically closes the current connection when the read timeout error happens. For other connection errors, this method always automatically closes the connection.
---
---@alias ngx.socket.tcpsock.iterator fun(size:number|nil):string,string,any
---
---@overload fun(self:tcpsock, size:number, options:table):ngx.socket.tcpsock.iterator
---
---@param pattern string
---@param options? table
---@return ngx.socket.tcpsock.iterator
function tcpsock:receiveuntil(pattern, options) end


--- Closes the current TCP or stream unix domain socket. It returns the `1` in case of success and returns `nil` with a string describing the error otherwise.
---
--- Note that there is no need to call this method on socket objects that have invoked the `setkeepalive` method because the socket object is already closed (and the current connection is saved into the built-in connection pool).
---
--- Socket objects that have not invoked this method (and associated connections) will be closed when the socket object is released by the Lua GC (Garbage Collector) or the current client HTTP request finishes processing.
---
---@return boolean ok
---@return string? error
function tcpsock:close() end


--- Set the timeout value in milliseconds for subsequent socket operations (`connect`, `receive`, and iterators returned from `receiveuntil`).
---
--- Settings done by this method take priority over those specified via config directives (i.e. `lua_socket_connect_timeout`, `lua_socket_send_timeout`, and `lua_socket_read_timeout`).
---
--- Note that this method does *not* affect the `lua_socket_keepalive_timeout` setting; the `timeout` argument to the `setkeepalive` method should be used for this purpose instead.
---
---@param time number
function tcpsock:settimeout(time) end


--- Respectively sets the connect, send, and read timeout thresholds (in milliseconds) for subsequent socket
--- operations (`connect`, `send`, `receive`, and iterators returned from `receiveuntil`).
---
--- Settings done by this method take priority over those specified via config directives (i.e. `lua_socket_connect_timeout`, `lua_socket_send_timeout`, and `lua_socket_read_timeout`).
---
--- It is recommended to use `settimeouts` instead of `settimeout`.
---
--- Note that this method does *not* affect the `lua_socket_keepalive_timeout` setting; the `timeout` argument to the `setkeepalive` method should be used for this purpose instead.
---
---@param connect_timeout number|nil
---@param send_timeout number|nil
---@param read_timeout number|nil
function tcpsock:settimeouts(connect_timeout, send_timeout, read_timeout) end


--- This function is added for `LuaSocket` API compatibility and does nothing for now.
---
--- In case of success, it returns `true`. Otherwise, it returns nil and a string describing the error.
---
--- The `option` is a string with the option name, and the value depends on the option being set:
---
--- * `keepalive`
---
--- 	Setting this option to true enables sending of keep-alive messages on
--- 	connection-oriented sockets. Make sure the `connect` function
--- 	had been called before, for example,
---
---     ```lua
---     local ok, err = tcpsock:setoption("keepalive", true)
---     if not ok then
---         ngx.say("setoption keepalive failed: ", err)
---     end
---     ```
--- * `reuseaddr`
---
--- 	Enabling this option indicates that the rules used in validating addresses
--- 	supplied in a call to bind should allow reuse of local addresses. Make sure
--- 	the `connect` function had been called before, for example,
---
---     ```lua
---     local ok, err = tcpsock:setoption("reuseaddr", 0)
---     if not ok then
---         ngx.say("setoption reuseaddr failed: ", err)
---     end
---     ```
--- * `tcp-nodelay`
---
--- 	Setting this option to true disables the Nagle's algorithm for the connection.
--- 	Make sure the `connect` function had been called before, for example,
---
---     ```lua
---     local ok, err = tcpsock:setoption("tcp-nodelay", true)
---     if not ok then
---         ngx.say("setoption tcp-nodelay failed: ", err)
---     end
---     ```
--- * `sndbuf`
---
--- 	Sets the maximum socket send buffer in bytes. The kernel doubles this value
--- 	(to allow space for bookkeeping overhead) when it is set using setsockopt().
--- 	Make sure the `connect` function had been called before, for example,
---
---     ```lua
---     local ok, err = tcpsock:setoption("sndbuf", 1024 * 10)
---     if not ok then
---         ngx.say("setoption sndbuf failed: ", err)
---     end
---     ```
--- * `rcvbuf`
---
--- 	Sets the maximum socket receive buffer in bytes. The kernel doubles this value
--- 	(to allow space for bookkeeping overhead) when it is set using setsockopt. Make
--- 	sure the `connect` function had been called before, for example,
---
---     ```lua
---     local ok, err = tcpsock:setoption("rcvbuf", 1024 * 10)
---     if not ok then
---         ngx.say("setoption rcvbuf failed: ", err)
---     end
---     ```
---
--- NOTE: Once the option is set, it will become effective until the connection is closed. If you know the connection is from the connection pool and all the in-pool connections already have called the setoption() method with the desired socket option state, then you can just skip calling setoption() again to avoid the overhead of repeated calls, for example,
---
--- ```lua
---  local count, err = tcpsock:getreusedtimes()
---  if not count then
---      ngx.say("getreusedtimes failed: ", err)
---      return
---  end
---
---  if count == 0 then
---      local ok, err = tcpsock:setoption("rcvbuf", 1024 * 10)
---      if not ok then
---          ngx.say("setoption rcvbuf failed: ", err)
---          return
---      end
---  end
--- ```
---
---@param  option  tcpsock.setoption.option
---@param  value   number|boolean
---@return boolean ok
---@return string? error
function tcpsock:setoption(option, value) end

---@alias tcpsock.setoption.option
---| '"keepalive"'   # enable or disable keepalive
---| '"reuseaddr"'   # reuse addr options
---| '"tcp-nodelay"' # disables the Nagle's algorithm for the connection.
---| '"sndbuf"'      # max send buffer size (in bytes)
---| '"rcvbuf"'      # max receive bufer size (in bytes)



--- Puts the current socket's connection immediately into the cosocket built-in connection pool and keep it alive until other `connect` method calls request it or the associated maximal idle timeout is expired.
---
--- The first optional argument, `timeout`, can be used to specify the maximal idle timeout (in milliseconds) for the current connection. If omitted, the default setting in the `lua_socket_keepalive_timeout` config directive will be used. If the `0` value is given, then the timeout interval is unlimited.
---
--- The second optional argument `size` is considered deprecated since the `v0.10.14` release of this module, in favor of the `pool_size` option of the `connect` method.
--- Since the `v0.10.14` release, this option will only take effect if the call to `connect` did not already create a connection pool.
--- When this option takes effect (no connection pool was previously created by `connect`), it will specify the size of the connection pool, and create it.
--- If omitted (and no pool was previously created), the default size is the value of the `lua_socket_pool_size` directive.
--- The connection pool holds up to `size` alive connections ready to be reused by subsequent calls to `connect`, but note that there is no upper limit to the total number of opened connections outside of the pool.
--- When the connection pool would exceed its size limit, the least recently used (kept-alive) connection already in the pool will be closed to make room for the current connection.
--- Note that the cosocket connection pool is per NGINX worker process rather than per NGINX server instance, so the size limit specified here also applies to every single NGINX worker process. Also note that the size of the connection pool cannot be changed once it has been created.
--- If you need to restrict the total number of opened connections, specify both the `pool_size` and `backlog` option in the call to `connect`.
---
--- In case of success, this method returns `1`; otherwise, it returns `nil` and a string describing the error.
---
--- When the system receive buffer for the current connection has unread data, then this method will return the "connection in dubious state" error message (as the second return value) because the previous session has unread data left behind for the next session and the connection is not safe to be reused.
---
--- This method also makes the current cosocket object enter the "closed" state, so there is no need to manually call the `close` method on it afterwards.
---
---@param timeout? number
---@param size? number
---@return boolean ok
---@return string? error
function tcpsock:setkeepalive(timeout, size) end


--- This method returns the (successfully) reused times for the current connection. In case of error, it returns `nil` and a string describing the error.
---
--- If the current connection does not come from the built-in connection pool, then this method always returns `0`, that is, the connection has never been reused (yet). If the connection comes from the connection pool, then the return value is always non-zero. So this method can also be used to determine if the current connection comes from the pool.
---
---@return number? count
---@return string? error
function tcpsock:getreusedtimes() end

--- This function is a shortcut for combining `ngx.socket.tcp()` and the `connect()` method call in a single operation. It is actually implemented like this:
---
--- ```lua
---  local sock = ngx.socket.tcp()
---  local ok, err = sock:connect(...)
---  if not ok then
---      return nil, err
---  end
---  return sock
--- ```
---
--- There is no way to use the `settimeout` method to specify connecting timeout for this method and the `lua_socket_connect_timeout` directive must be set at configure time instead.
---
---@param host string
---@param port? number
---@return tcpsock? socket
---@return string? error
function ngx.socket.connect(host, port) end

--- Creates and returns a UDP or datagram-oriented unix domain socket object (also known as one type of the "cosocket" objects). The following methods are supported on this object:
---
--- * `setpeername`
--- * `send`
--- * `receive`
--- * `close`
--- * `settimeout`
---
--- It is intended to be compatible with the UDP API of the `LuaSocket` library but is 100% nonblocking out of the box.
---
---@return udpsock
function ngx.socket.udp() end

--- Just an alias to `ngx.socket.tcp`. If the stream-typed cosocket may also connect to a unix domain
--- socket, then this API name is preferred.
---
function ngx.socket.stream() end

--- When this is used in the context of the `set_by_lua*` directives, this table is read-only and holds the input arguments to the config directives:
---
--- ```lua
---  value = ngx.arg[n]
--- ```
---
--- Here is an example
---
--- ```nginx
---  location /foo {
---      set $a 32;
---      set $b 56;
---
---      set_by_lua $sum
---          'return tonumber(ngx.arg[1]) + tonumber(ngx.arg[2])'
---          $a $b;
---
---      echo $sum;
---  }
--- ```
---
--- that writes out `88`, the sum of `32` and `56`.
---
--- When this table is used in the context of `body_filter_by_lua*`, the first element holds the input data chunk to the output filter code and the second element holds the boolean flag for the "eof" flag indicating the end of the whole output data stream.
---
--- The data chunk and "eof" flag passed to the downstream NGINX output filters can also be overridden by assigning values directly to the corresponding table elements. When setting `nil` or an empty Lua string value to `ngx.arg[1]`, no data chunk will be passed to the downstream NGINX output filters at all.
ngx.arg = {}

---@alias ngx.phase.name
---| '"init"'
---| '"init_worker"'
---| '"ssl_cert"'
---| '"ssl_session_fetch"'
---| '"ssl_session_store"'
---| '"set"'
---| '"rewrite"'
---| '"balancer"'
---| '"access"'
---| '"content"'
---| '"header_filter"'
---| '"body_filter"'
---| '"log"'
---| '"timer"'

--- Retrieves the current running phase name.
---
---@return ngx.phase.name
function ngx.get_phase() end


--- When `status >= 200` (i.e., `ngx.HTTP_OK` and above), it will interrupt the execution of the current request and return status code to NGINX.
---
--- When `status == 0` (i.e., `ngx.OK`), it will only quit the current phase handler (or the content handler if the `content_by_lua*` directive is used) and continue to run later phases (if any) for the current request.
---
--- The `status` argument can be `ngx.OK`, `ngx.ERROR`, `ngx.HTTP_NOT_FOUND`,
--- `ngx.HTTP_MOVED_TEMPORARILY`, or other `ngx.HTTP_*` status constants.
---
--- To return an error page with custom contents, use code snippets like this:
---
--- ```lua
---  ngx.status = ngx.HTTP_GONE
---  ngx.say("This is our own content")
---  -- to cause quit the whole request rather than the current phase handler
---  ngx.exit(ngx.HTTP_OK)
--- ```
---
--- The effect in action:
---
--- ```bash
---  $ curl -i http://localhost/test
---  HTTP/1.1 410 Gone
---  Server: nginx/1.0.6
---  Date: Thu, 15 Sep 2011 00:51:48 GMT
---  Content-Type: text/plain
---  Transfer-Encoding: chunked
---  Connection: keep-alive
---
---  This is our own content
--- ```
---
--- Number literals can be used directly as the argument, for instance,
---
--- ```lua
---  ngx.exit(501)
--- ```
---
--- Note that while this method accepts all `ngx.HTTP_*` status constants as input, it only accepts `ngx.OK` and `ngx.ERROR` of the `core constants`.
---
--- Also note that this method call terminates the processing of the current request and that it is recommended that a coding style that combines this method call with the `return` statement, i.e., `return ngx.exit(...)` be used to reinforce the fact that the request processing is being terminated.
---
--- When being used in the contexts of `header_filter_by_lua*`, `balancer_by_lua*`, and
--- `ssl_session_store_by_lua*`, `ngx.exit()` is
--- an asynchronous operation and will return immediately. This behavior may change in future and it is recommended that users always use `return` in combination as suggested above.
---
---@param status ngx.OK|ngx.ERROR|ngx.http.status_code
function ngx.exit(status) end

--- Issue an `HTTP 301` or `302` redirection to `uri`.
---
--- Notice: the `uri` should not contains `\r` or `\n`, otherwise, the characters after `\r` or `\n` will be truncated, including the `\r` or `\n` bytes themself.
---
--- The `uri` argument will be truncated if it contains the
--- `\r` or `\n` characters. The truncated value will contain
--- all characters up to (and excluding) the first occurrence of `\r` or
--- `\n`.
---
--- The optional `status` parameter specifies the HTTP status code to be used. The following status codes are supported right now:
---
--- * `301`
--- * `302` (default)
--- * `303`
--- * `307`
--- * `308`
---
--- It is `302` (`ngx.HTTP_MOVED_TEMPORARILY`) by default.
---
--- Here is an example assuming the current server name is `localhost` and that it is listening on port 1984:
---
--- ```lua
---  return ngx.redirect("/foo")
--- ```
---
--- which is equivalent to
---
--- ```lua
---  return ngx.redirect("/foo", ngx.HTTP_MOVED_TEMPORARILY)
--- ```
---
--- Redirecting arbitrary external URLs is also supported, for example:
---
--- ```lua
---  return ngx.redirect("http://www.google.com")
--- ```
---
--- We can also use the numerical code directly as the second `status` argument:
---
--- ```lua
---  return ngx.redirect("/foo", 301)
--- ```
---
--- This method is similar to the `rewrite` directive with the `redirect` modifier in the standard
--- `ngx_http_rewrite_module`, for example, this `nginx.conf` snippet
---
--- ```nginx
---  rewrite ^ /foo? redirect;  # nginx config
--- ```
---
--- is equivalent to the following Lua code
---
--- ```lua
---  return ngx.redirect('/foo');  -- Lua code
--- ```
---
--- while
---
--- ```nginx
---  rewrite ^ /foo? permanent;  # nginx config
--- ```
---
--- is equivalent to
---
--- ```lua
---  return ngx.redirect('/foo', ngx.HTTP_MOVED_PERMANENTLY)  -- Lua code
--- ```
---
--- URI arguments can be specified as well, for example:
---
--- ```lua
---  return ngx.redirect('/foo?a=3&b=4')
--- ```
---
--- Note that this method call terminates the processing of the current request and that it *must* be called before `ngx.send_headers` or explicit response body
--- outputs by either `ngx.print` or `ngx.say`.
---
--- It is recommended that a coding style that combines this method call with the `return` statement, i.e., `return ngx.redirect(...)` be adopted when this method call is used in contexts other than `header_filter_by_lua*` to reinforce the fact that the request processing is being terminated.
---
---@param uri string
---@param status? 301|302|303|307|308
function ngx.redirect(uri, status) end


--- Registers a user Lua function as the callback which gets called automatically when the client closes the (downstream) connection prematurely.
---
--- Returns `1` if the callback is registered successfully or returns `nil` and a string describing the error otherwise.
---
--- All the NGINX APIs for lua can be used in the callback function because the function is run in a special "light thread", just as those "light threads" created by `ngx.thread.spawn`.
---
--- The callback function can decide what to do with the client abortion event all by itself. For example, it can simply ignore the event by doing nothing and the current Lua request handler will continue executing without interruptions. And the callback function can also decide to terminate everything by calling `ngx.exit`, for example,
---
--- ```lua
---  local function my_cleanup()
---      -- custom cleanup work goes here, like cancelling a pending DB transaction
---
---      -- now abort all the "light threads" running in the current request handler
---      ngx.exit(499)
---  end
---
---  local ok, err = ngx.on_abort(my_cleanup)
---  if not ok then
---      ngx.log(ngx.ERR, "failed to register the on_abort callback: ", err)
---      ngx.exit(500)
---  end
--- ```
---
--- When `lua_check_client_abort` is set to `off` (which is the default), then this function call will always return the error message "lua_check_client_abort is off".
---
--- According to the current implementation, this function can only be called once in a single request handler; subsequent calls will return the error message "duplicate call".
---
---@param callback fun()
---@return boolean ok
---@return string|'"lua_check_client_abort is off"'|'"duplicate call"' error
function ngx.on_abort(callback) end


--- Does an internal redirect to `uri` with `args` and is similar to the `echo_exec` directive of the `echo-nginx-module`.
---
--- ```lua
---  ngx.exec('/some-location');
---  ngx.exec('/some-location', 'a=3&b=5&c=6');
---  ngx.exec('/some-location?a=3&b=5', 'c=6');
--- ```
---
--- The optional second `args` can be used to specify extra URI query arguments, for example:
---
--- ```lua
---  ngx.exec("/foo", "a=3&b=hello%20world")
--- ```
---
--- Alternatively, a Lua table can be passed for the `args` argument for ngx_lua to carry out URI escaping and string concatenation.
---
--- ```lua
---  ngx.exec("/foo", { a = 3, b = "hello world" })
--- ```
---
--- The result is exactly the same as the previous example.
---
--- The format for the Lua table passed as the `args` argument is identical to the format used in the `ngx.encode_args` method.
---
--- Named locations are also supported but the second `args` argument will be ignored if present and the querystring for the new target is inherited from the referring location (if any).
---
--- `GET /foo/file.php?a=hello` will return "hello" and not "goodbye" in the example below
---
--- ```nginx
---  location /foo {
---      content_by_lua_block {
---          ngx.exec("@bar", "a=goodbye");
---      }
---  }
---
---  location @bar {
---      content_by_lua_block {
---          local args = ngx.req.get_uri_args()
---          for key, val in pairs(args) do
---              if key == "a" then
---                  ngx.say(val)
---              end
---          end
---      }
---  }
--- ```
---
--- Note that the `ngx.exec` method is different from `ngx.redirect` in that
--- it is purely an internal redirect and that no new external HTTP traffic is involved.
---
--- Also note that this method call terminates the processing of the current request and that it *must* be called before `ngx.send_headers` or explicit response body
--- outputs by either `ngx.print` or `ngx.say`.
---
--- It is recommended that a coding style that combines this method call with the `return` statement, i.e., `return ngx.exec(...)` be adopted when this method call is used in contexts other than `header_filter_by_lua*` to reinforce the fact that the request processing is being terminated.
---
---@param uri string
---@param args? string|table<string,any>
function ngx.exec(uri, args) end

ngx.location = {}

---@class ngx.location.capture.response : table
---@field status    integer                        # response status code
---@field header    table<string, string|string[]> # response headers
---@field body      string                         # response body
---@field truncated boolean                        # truth-y if the response body is truncated. You always need to check the `res.truncated` boolean flag to see if `res.body` contains truncated data. The data truncation here can only be caused by those unrecoverable errors in your subrequests like the cases that the remote end aborts the connection prematurely in the middle of the response body data stream or a read timeout happens when your subrequest is receiving the response body data from the remote.

--- An optional option table can be fed as the second argument, which supports the options:
---
---@class ngx.location.capture.options
---
---@field method ngx.http.method # the subrequest's request method, which only accepts constants like `ngx.HTTP_POST`.
---
---@field body string # the subrequest's request body (string value only).
---
---@field args string|table # the subrequest's URI query arguments (both string value and Lua tables are accepted)
---@field ctx table # a Lua table to be the `ngx.ctx` table for the subrequest. It can be the current request's `ngx.ctx` table, which effectively makes the parent and its subrequest to share exactly the same context table.
---
---@field vars table # a Lua table which holds the values to set the specified NGINX variables in the subrequest as this option's value.
---
---@field copy_all_vars boolean # whether to copy over all the NGINX variable values of the current request to the subrequest in question. modifications of the NGINX variables in the subrequest will not affect the current (parent) request.
---
---@field share_all_vars boolean # whether to share all the NGINX variables of the subrequest with the current (parent) request. modifications of the NGINX variables in the subrequest will affect the current (parent) request. Enabling this option may lead to hard-to-debug issues due to bad side-effects and is considered bad and harmful. Only enable this option when you completely know what you are doing.
---
---@field always_forward_body boolean #  when set to true, the current (parent) request's request body will always be forwarded to the subrequest being created if the `body` option is not specified. The request body read by either `ngx.req.read_body()` or `lua_need_request_body on` will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest (no matter the request body data is buffered in memory buffers or temporary files). By default, this option is `false` and when the `body` option is not specified, the request body of the current (parent) request is only forwarded when the subrequest takes the `PUT` or `POST` request method.


---@alias ngx.location.capture.uri string

---@class ngx.location.capture.arg : table
---@field [1] ngx.location.capture.uri      request uri
---@field [2] ngx.location.capture.options? request options


--- Issues a synchronous but still non-blocking *NGINX Subrequest* using `uri`.
---
--- NGINX's subrequests provide a powerful way to make non-blocking internal requests to other locations configured with disk file directory or *any* other NGINX C modules like `ngx_proxy`, `ngx_fastcgi`, `ngx_memc`,
--- `ngx_postgres`, `ngx_drizzle`, and even ngx_lua itself and etc etc etc.
---
--- Also note that subrequests just mimic the HTTP interface but there is *no* extra HTTP/TCP traffic *nor* IPC involved. Everything works internally, efficiently, on the C level.
---
--- Subrequests are completely different from HTTP 301/302 redirection (via `ngx.redirect`) and internal redirection (via `ngx.exec`).
---
--- You should always read the request body (by either calling `ngx.req.read_body` or configuring `lua_need_request_body` on) before initiating a subrequest.
---
--- This API function (as well as `ngx.location.capture_multi`) always buffers the whole response body of the subrequest in memory. Thus, you should use `cosockets`
--- and streaming processing instead if you have to handle large subrequest responses.
---
--- Here is a basic example:
---
--- ```lua
---  res = ngx.location.capture(uri)
--- ```
---
--- Returns a Lua table with 4 slots: `res.status`, `res.header`, `res.body`, and `res.truncated`.
---
--- URI query strings can be concatenated to URI itself, for instance,
---
--- ```lua
---  res = ngx.location.capture('/foo/bar?a=3&b=4')
--- ```
---
--- Named locations like `@foo` are not allowed due to a limitation in
--- the NGINX core. Use normal locations combined with the `internal` directive to
--- prepare internal-only locations.
---
--- An optional option table can be fed as the second argument.
---
--- Issuing a POST subrequest, for example, can be done as follows
---
--- ```lua
---  res = ngx.location.capture(
---      '/foo/bar',
---      { method = ngx.HTTP_POST, body = 'hello, world' }
---  )
--- ```
---
--- See HTTP method constants methods other than POST.
--- The `method` option is `ngx.HTTP_GET` by default.
---
--- The `args` option can specify extra URI arguments, for instance,
---
--- ```lua
---  ngx.location.capture('/foo?a=1',
---      { args = { b = 3, c = ':' } }
---  )
--- ```
---
--- is equivalent to
---
--- ```lua
---  ngx.location.capture('/foo?a=1&b=3&c=%3a')
--- ```
---
--- that is, this method will escape argument keys and values according to URI rules and
--- concatenate them together into a complete query string. The format for the Lua table passed as the `args` argument is identical to the format used in the `ngx.encode_args` method.
---
--- The `args` option can also take plain query strings:
---
--- ```lua
---  ngx.location.capture('/foo?a=1',
---      { args = 'b=3&c=%3a' }
---  )
--- ```
---
--- This is functionally identical to the previous examples.
---
--- The `share_all_vars` option controls whether to share NGINX variables among the current request and its subrequests.
--- If this option is set to `true`, then the current request and associated subrequests will share the same NGINX variable scope. Hence, changes to NGINX variables made by a subrequest will affect the current request.
---
--- Care should be taken in using this option as variable scope sharing can have unexpected side effects. The `args`, `vars`, or `copy_all_vars` options are generally preferable instead.
---
--- This option is set to `false` by default
---
--- ```nginx
---  location /other {
---      set $dog "$dog world";
---      echo "$uri dog: $dog";
---  }
---
---  location /lua {
---      set $dog 'hello';
---      content_by_lua_block {
---          res = ngx.location.capture("/other",
---              { share_all_vars = true });
---
---          ngx.print(res.body)
---          ngx.say(ngx.var.uri, ": ", ngx.var.dog)
---      }
---  }
--- ```
---
--- Accessing location `/lua` gives
---
---     /other dog: hello world
---     /lua: hello world
---
--- The `copy_all_vars` option provides a copy of the parent request's NGINX variables to subrequests when such subrequests are issued. Changes made to these variables by such subrequests will not affect the parent request or any other subrequests sharing the parent request's variables.
---
--- ```nginx
---  location /other {
---      set $dog "$dog world";
---      echo "$uri dog: $dog";
---  }
---
---  location /lua {
---      set $dog 'hello';
---      content_by_lua_block {
---          res = ngx.location.capture("/other",
---              { copy_all_vars = true });
---
---          ngx.print(res.body)
---          ngx.say(ngx.var.uri, ": ", ngx.var.dog)
---      }
---  }
--- ```
---
--- Request `GET /lua` will give the output
---
---     /other dog: hello world
---     /lua: hello
---
--- Note that if both `share_all_vars` and `copy_all_vars` are set to true, then `share_all_vars` takes precedence.
---
--- In addition to the two settings above, it is possible to specify
--- values for variables in the subrequest using the `vars` option. These
--- variables are set after the sharing or copying of variables has been
--- evaluated, and provides a more efficient method of passing specific
--- values to a subrequest over encoding them as URL arguments and
--- unescaping them in the NGINX config file.
---
--- ```nginx
---  location /other {
---      content_by_lua_block {
---          ngx.say("dog = ", ngx.var.dog)
---          ngx.say("cat = ", ngx.var.cat)
---      }
---  }
---
---  location /lua {
---      set $dog '';
---      set $cat '';
---      content_by_lua_block {
---          res = ngx.location.capture("/other",
---              { vars = { dog = "hello", cat = 32 }});
---
---          ngx.print(res.body)
---      }
---  }
--- ```
---
--- Accessing `/lua` will yield the output
---
---     dog = hello
---     cat = 32
---
--- The `ctx` option can be used to specify a custom Lua table to serve as the `ngx.ctx` table for the subrequest.
---
--- ```nginx
---  location /sub {
---      content_by_lua_block {
---          ngx.ctx.foo = "bar";
---      }
---  }
---  location /lua {
---      content_by_lua_block {
---          local ctx = {}
---          res = ngx.location.capture("/sub", { ctx = ctx })
---
---          ngx.say(ctx.foo);
---          ngx.say(ngx.ctx.foo);
---      }
---  }
--- ```
---
--- Then request `GET /lua` gives
---
---     bar
---     nil
---
--- It is also possible to use this `ctx` option to share the same `ngx.ctx` table between the current (parent) request and the subrequest:
---
--- ```nginx
---  location /sub {
---      content_by_lua_block {
---          ngx.ctx.foo = "bar";
---      }
---  }
---  location /lua {
---      content_by_lua_block {
---          res = ngx.location.capture("/sub", { ctx = ngx.ctx })
---          ngx.say(ngx.ctx.foo);
---      }
---  }
--- ```
---
--- Request `GET /lua` yields the output
---
---     bar
---
--- Note that subrequests issued by `ngx.location.capture` inherit all the
--- request headers of the current request by default and that this may have unexpected side effects on the
--- subrequest responses. For example, when using the standard `ngx_proxy` module to serve
--- subrequests, an "Accept-Encoding: gzip" header in the main request may result
--- in gzipped responses that cannot be handled properly in Lua code. Original request headers should be ignored by setting
--- `proxy_pass_request_headers` to `off` in subrequest locations.
---
--- When the `body` option is not specified and the `always_forward_body` option is false (the default value), the `POST` and `PUT` subrequests will inherit the request bodies of the parent request (if any).
---
--- There is a hard-coded upper limit on the number of concurrent subrequests possible for every main request. In older versions of NGINX, the limit was `50` concurrent subrequests and in more recent versions, NGINX `1.1.x` onwards, this was increased to `200` concurrent subrequests. When this limit is exceeded, the following error message is added to the `error.log` file:
---
---     [error] 13983#0: *1 subrequests cycle while processing "/uri"
---
--- The limit can be manually modified if required by editing the definition of the `NGX_HTTP_MAX_SUBREQUESTS` macro in the `nginx/src/http/ngx_http_request.h` file in the NGINX source tree.
---
--- Please also refer to restrictions on capturing locations configured by subrequest directives of other modules.
---
---@param uri ngx.location.capture.uri
---@param options? ngx.location.capture.options
---@return ngx.location.capture.response
function ngx.location.capture(uri, options) end


--- Just like `ngx.location.capture`, but supports multiple subrequests running in parallel.
---
--- This function issues several parallel subrequests specified by the input table and returns their results in the same order. For example,
---
--- ```lua
---  local res1, res2, res3 = ngx.location.capture_multi{
---      { "/foo", { args = "a=3&b=4" } },
---      { "/bar" },
---      { "/baz", { method = ngx.HTTP_POST, body = "hello" } },
---  }
---
---  if res1.status == ngx.HTTP_OK then
---      ...
---  end
---
---  if res2.body == "BLAH" then
---      ...
---  end
--- ```
---
--- This function will not return until all the subrequests terminate.
--- The total latency is the longest latency of the individual subrequests rather than the sum.
---
--- Lua tables can be used for both requests and responses when the number of subrequests to be issued is not known in advance:
---
--- ```lua
---  -- construct the requests table
---  local reqs = {}
---  table.insert(reqs, { "/mysql" })
---  table.insert(reqs, { "/postgres" })
---  table.insert(reqs, { "/redis" })
---  table.insert(reqs, { "/memcached" })
---
---  -- issue all the requests at once and wait until they all return
---  local resps = { ngx.location.capture_multi(reqs) }
---
---  -- loop over the responses table
---  for i, resp in ipairs(resps) do
---      -- process the response table "resp"
---  end
--- ```
---
--- The `ngx.location.capture` function is just a special form
--- of this function. Logically speaking, the `ngx.location.capture` can be implemented like this
---
--- ```lua
---  ngx.location.capture = function (uri, args)
---    return ngx.location.capture_multi({ {uri, args} })
---  end
--- ```
---
--- Please also refer to restrictions on capturing locations configured by subrequest directives of other modules.
---
---@param args ngx.location.capture.arg[]
---@return ngx.location.capture.response ...
function ngx.location.capture_multi(args) end


--- Set, add to, or clear the current request's `HEADER` response header that is to be sent.
---
--- Underscores (`_`) in the header names will be replaced by hyphens (`-`) by default. This transformation can be turned off via the `lua_transform_underscores_in_response_headers` directive.
---
--- The header names are matched case-insensitively.
---
--- ```lua
---  -- equivalent to ngx.header["Content-Type"] = 'text/plain'
---  ngx.header.content_type = 'text/plain';
---
---  ngx.header["X-My-Header"] = 'blah blah';
--- ```
---
--- Multi-value headers can be set this way:
---
--- ```lua
---  ngx.header['Set-Cookie'] = {'a=32; path=/', 'b=4; path=/'}
--- ```
---
--- will yield
---
--- ```bash
---  Set-Cookie: a=32; path=/
---  Set-Cookie: b=4; path=/
--- ```
---
--- in the response headers.
---
--- Only Lua tables are accepted (Only the last element in the table will take effect for standard headers such as `Content-Type` that only accept a single value).
---
--- ```lua
---  ngx.header.content_type = {'a', 'b'}
--- ```
---
--- is equivalent to
---
--- ```lua
---  ngx.header.content_type = 'b'
--- ```
---
--- Setting a slot to `nil` effectively removes it from the response headers:
---
--- ```lua
---  ngx.header["X-My-Header"] = nil;
--- ```
---
--- The same applies to assigning an empty table:
---
--- ```lua
---  ngx.header["X-My-Header"] = {};
--- ```
---
--- Setting `ngx.header.HEADER` after sending out response headers (either explicitly with `ngx.send_headers` or implicitly with `ngx.print` and similar) will log an error message.
---
--- Reading `ngx.header.HEADER` will return the value of the response header named `HEADER`.
---
--- Underscores (`_`) in the header names will also be replaced by dashes (`-`) and the header names will be matched case-insensitively. If the response header is not present at all, `nil` will be returned.
---
--- This is particularly useful in the context of `header_filter_by_lua*`, for example:
---
--- ```nginx
---  location /test {
---      set $footer '';
---
---      proxy_pass http://some-backend;
---
---      header_filter_by_lua_block {
---          if ngx.header["X-My-Header"] == "blah" then
---              ngx.var.footer = "some value"
---          end
---      }
---
---      echo_after_body $footer;
---  }
--- ```
---
--- For multi-value headers, all of the values of header will be collected in order and returned as a Lua table. For example, response headers
---
---     Foo: bar
---     Foo: baz
---
--- will result in
---
--- ```lua
---  {"bar", "baz"}
--- ```
---
--- to be returned when reading `ngx.header.Foo`.
---
--- Note that `ngx.header` is not a normal Lua table and as such, it is not possible to iterate through it using the Lua `ipairs` function.
---
--- Note: `HEADER` and `VALUE` will be truncated if they
--- contain the `\r` or `\n` characters. The truncated values
--- will contain all characters up to (and excluding) the first occurrence of
--- `\r` or `\n`.
---
--- For reading *request* headers, use the `ngx.req.get_headers` function instead.
---
---@type table<string, string|string[]|nil>
ngx.header = {}


--- Parse the http time string (as returned by `ngx.http_time`) into seconds. Returns the seconds or `nil` if the input string is in bad forms.
---
--- ```lua
---  local time = ngx.parse_http_time("Thu, 18 Nov 2010 11:27:35 GMT")
---  if time == nil then
---      ...
---  end
--- ```
---
---@param str string
---@return number?
function ngx.parse_http_time(str) end


--- Returns a formated string can be used as the http header time (for example, being used in `Last-Modified` header). The parameter `sec` is the time stamp in seconds (like those returned from `ngx.time`).
---
--- ```lua
---  ngx.say(ngx.http_time(1290079655))
---      -- yields "Thu, 18 Nov 2010 11:27:35 GMT"
--- ```
---
---@param sec number
---@return string
function ngx.http_time(sec) end


--- Sleeps for the specified seconds without blocking. One can specify time resolution up to 0.001 seconds (i.e., one milliseconds).
---
--- Behind the scene, this method makes use of the NGINX timers.
---
--- The `0` time argument can also be specified.
---
---@param seconds number
function ngx.sleep(seconds) end

--- Forcibly updates the NGINX current time cache. This call involves a syscall and thus has some overhead, so do not abuse it.
---
function ngx.update_time() end

--- Returns a floating-point number for the elapsed time in seconds (including milliseconds as the decimal part) from the epoch for the current time stamp from the NGINX cached time (no syscall involved unlike Lua's date library).
---
--- You can forcibly update the NGINX time cache by calling `ngx.update_time` first.
---
---@return number
function ngx.now() end

--- Returns the current time stamp (in the format `yyyy-mm-dd hh:mm:ss`) of the NGINX cached time (no syscall involved unlike Lua's `os.date` function).
---
---@return string
function ngx.localtime() end

--- Returns the current time stamp (in the format `yyyy-mm-dd hh:mm:ss`) of the NGINX cached time (no syscall involved unlike Lua's `os.date` function).
---
---@return string
function ngx.utctime() end

--- Returns a formatted string can be used as the cookie expiration time. The parameter `sec` is the time stamp in seconds (like those returned from `ngx.time`).
---
--- ```lua
---  ngx.say(ngx.cookie_time(1290079655))
---      -- yields "Thu, 18-Nov-10 11:27:35 GMT"
--- ```
---
---@param sec number
---@return string
function ngx.cookie_time(sec) end

--- Returns current date (in the format `yyyy-mm-dd`) from the NGINX cached time (no syscall involved unlike Lua's date library).
---
--- This uses the local timezone.
---
---@return string
function ngx.today() end

--- Returns the elapsed seconds from the epoch for the current time stamp from the NGINX cached time (no syscall involved unlike Lua's date library).
---
--- Updates of the NGINX time cache can be forced by calling `ngx.update_time` first.
---
---@return integer
function ngx.time() end

--- Log arguments concatenated to error.log with the given logging level.
---
--- Lua `nil` arguments are accepted and result in literal `"nil"` string while Lua booleans result in literal `"true"` or `"false"` string outputs. And the `ngx.null` constant will yield the `"null"` string output.
---
--- The `level` argument can take constants like `ngx.ERR` and `ngx.WARN`.
---
--- There is a hard coded `2048` byte limitation on error message lengths in the NGINX core. This limit includes trailing newlines and leading time stamps. If the message size exceeds this limit, NGINX will truncate the message text accordingly. This limit can be manually modified by editing the `NGX_MAX_ERROR_STR` macro definition in the `src/core/ngx_log.h` file in the NGINX source tree.
---
---@param level ngx.log.level
---@param ... any
function ngx.log(level, ...) end


--- Explicitly specify the end of the response output stream. In the case of HTTP 1.1 chunked encoded output, it will just trigger the NGINX core to send out the "last chunk".
---
--- When you disable the HTTP 1.1 keep-alive feature for your downstream connections, you can rely on well written HTTP clients to close the connection actively for you when you call this method. This trick can be used do back-ground jobs without letting the HTTP clients to wait on the connection, as in the following example:
---
--- ```nginx
---  location = /async {
---      keepalive_timeout 0;
---      content_by_lua_block {
---          ngx.say("got the task!")
---          ngx.eof()  -- well written HTTP clients will close the connection at this point
---          -- access MySQL, PostgreSQL, Redis, Memcached, and etc here...
---      }
---  }
--- ```
---
--- But if you create subrequests to access other locations configured by NGINX upstream modules, then you should configure those upstream modules to ignore client connection abortions if they are not by default. For example, by default the standard `ngx_http_proxy_module` will terminate both the subrequest and the main request as soon as the client closes the connection, so it is important to turn on the `proxy_ignore_client_abort` directive in your location block configured by `ngx_http_proxy_module`://nginx.org/en/docs/http/ngx_http_proxy_module.html):
---
--- ```nginx
---  proxy_ignore_client_abort on;
--- ```
---
--- A better way to do background jobs is to use the `ngx.timer.at` API.
---
--- Returns `1` on success, or returns `nil` and a string describing the error otherwise.
---
---@return boolean ok
---@return string? error
function ngx.eof() end

--- Emits arguments concatenated to the HTTP client (as response body). If response headers have not been sent, this function will send headers out first and then output body data.
---
--- Returns `1` on success, or returns `nil` and a string describing the error otherwise.
---
--- Lua `nil` values will output `"nil"` strings and Lua boolean values will output `"true"` and `"false"` literal strings respectively.
---
--- Nested arrays of strings are permitted and the elements in the arrays will be sent one by one:
---
--- ```lua
---  local table = {
---      "hello, ",
---      {"world: ", true, " or ", false,
---          {": ", nil}}
---  }
---  ngx.print(table)
--- ```
---
--- will yield the output
---
--- ```bash
---  hello, world: true or false: nil
--- ```
---
--- Non-array table arguments will cause a Lua exception to be thrown.
---
--- The `ngx.null` constant will yield the `"null"` string output.
---
--- This is an asynchronous call and will return immediately without waiting for all the data to be written into the system send buffer. To run in synchronous mode, call `ngx.flush(true)` after calling `ngx.print`. This can be particularly useful for streaming output. See `ngx.flush` for more details.
---
--- Please note that both `ngx.print` and `ngx.say` will always invoke the whole NGINX output body filter chain, which is an expensive operation. So be careful when calling either of these two in a tight loop; buffer the data yourself in Lua and save the calls.
---
---@param ... string|string[]
---@return boolean ok
---@return string? error
function ngx.print(...) end

--- Just as `ngx.print` but also emit a trailing newline.
---
---@param ... string|string[]
---@return boolean ok
---@return string? error
function ngx.say(...) end

--- Explicitly send out the response headers.
---
--- Returns `1` on success, or returns `nil` and a string describing the error otherwise.
---
--- Note that there is normally no need to manually send out response headers as ngx_lua will automatically send headers out before content is output with `ngx.say` or `ngx.print` or when `content_by_lua*` exits normally.
---
---@return boolean ok
---@return string? error
function ngx.send_headers() end

--- Flushes response output to the client.
---
--- `ngx.flush` accepts an optional boolean `wait` argument (Default: `false`). When called with the default argument, it issues an asynchronous call (Returns immediately without waiting for output data to be written into the system send buffer). Calling the function with the `wait` argument set to `true` switches to synchronous mode.
---
--- In synchronous mode, the function will not return until all output data has been written into the system send buffer or until the `send_timeout` setting has expired. Note that using the Lua coroutine mechanism means that this function does not block the NGINX event loop even in the synchronous mode.
---
--- When `ngx.flush(true)` is called immediately after `ngx.print` or `ngx.say`, it causes the latter functions to run in synchronous mode. This can be particularly useful for streaming output.
---
--- Note that `ngx.flush` is not functional when in the HTTP 1.0 output buffering mode. See `HTTP 1.0 support`.
---
--- Returns `1` on success, or returns `nil` and a string describing the error otherwise.
---
---@param wait? boolean
---@return boolean ok
---@return string? error
function ngx.flush(wait) end

--- NGINX response methods
ngx.resp = {}

--- Returns a Lua table holding all the current response headers for the current request.
---
--- ```lua
---  local h, err = ngx.resp.get_headers()
---
---  if err == "truncated" then
---      -- one can choose to ignore or reject the current response here
---  end
---
---  for k, v in pairs(h) do
---      ...
---  end
--- ```
---
--- This function has the same signature as `ngx.req.get_headers` except getting response headers instead of request headers.
---
--- Note that a maximum of 100 response headers are parsed by default (including those with the same name) and that additional response headers are silently discarded to guard against potential denial of service attacks. When the limit is exceeded, it will return a second value which is the string `"truncated"`.
---
---@param max_headers? number
---@param raw? boolean
---@return table<string, string|string[]>
---@return string|'"truncated"' error
function ngx.resp.get_headers(max_headers, raw) end

---@alias ngx.thread.arg boolean|number|integer|string|lightuserdata|table

---**syntax:** *ok, res1, res2, ... = ngx.run_worker_thread(threadpool, module_name, func_name, arg1, arg2, ...)*
---
---**context:** *rewrite_by_lua&#42;, access_by_lua&#42;, content_by_lua&#42;*
---
---**This API is still experimental and may change in the future without notice.**
---
---**This API is available only for Linux.**
---
---Wrap the [nginx worker thread](http://nginx.org/en/docs/dev/development_guide.html#threads) to execute lua function. The caller coroutine would yield until the function returns.
---
---Only the following ngx_lua APIs could be used in `function_name` function of the `module` module:
---
---* `ngx.encode_base64`
---* `ngx.decode_base64`
---
---* `ngx.hmac_sha1`
---* `ngx.encode_args`
---* `ngx.decode_args`
---* `ngx.quote_sql_str`
---
---* `ngx.re.match`
---* `ngx.re.find`
---* `ngx.re.gmatch`
---* `ngx.re.sub`
---* `ngx.re.gsub`
---
---* `ngx.crc32_short`
---* `ngx.crc32_long`
---* `ngx.hmac_sha1`
---* `ngx.md5_bin`
---* `ngx.md5`
---
---* `ngx.config.subsystem`
---* `ngx.config.debug`
---* `ngx.config.prefix`
---* `ngx.config.nginx_version`
---* `ngx.config.nginx_configure`
---* `ngx.config.ngx_lua_version`
---
---
---The first argument `threadpool` specifies the Nginx thread pool name defined by [thread_pool](https://nginx.org/en/docs/ngx_core_module.html#thread_pool).
---
---The second argument `module_name` specifies the lua module name to execute in the worker thread, which would return a lua table. The module must be inside the package path, e.g.
---
---```nginx
---
---lua_package_path '/opt/openresty/?.lua;;';
---```
---
---The third argument `func_name` specifies the function field in the module table as the second argument.
---
---The type of `arg`s must be one of type below:
---
---* boolean
---* number
---* string
---* nil
---* table (the table may be recursive, and contains members of types above.)
---
---The `ok` is in boolean type, which indicate the C land error (failed to get thread from thread pool, pcall the module function failed, .etc). If `ok` is `false`, the `res1` is the error string.
---
---The return values (res1, ...) are returned by invocation of the module function. Normally, the `res1` should be in boolean type, so that the caller could inspect the error.
---
---This API is useful when you need to execute the below types of tasks:
---
---* CPU bound task, e.g. do md5 calculation
---* File I/O task
---* Call `os.execute()` or blocking C API via `ffi`
---* Call external Lua library not based on cosocket or nginx
---
---Example1: do md5 calculation.
---
---```nginx
---
---location /calc_md5 {
---     default_type 'text/plain';
---
---     content_by_lua_block {
---         local ok, md5_or_err = ngx.run_worker_thread("testpool", "md5", "md5")
---         ngx.say(ok, " : ", md5_or_err)
---     }
--- }
---```
---
---`md5.lua`
---
---```lua
---local function md5()
---    return ngx.md5("hello")
---end
---```
---
---Example2: write logs into the log file.
---
---```nginx
---
---location /write_log_file {
---     default_type 'text/plain';
---
---     content_by_lua_block {
---         local ok, err = ngx.run_worker_thread("testpool", "write_log_file", "log", ngx.var.arg_str)
---         if not ok then
---             ngx.say(ok, " : ", err)
---             return
---         end
---         ngx.say(ok)
---     }
--- }
---```
---
---`write_log_file.lua`
---
---```lua
---
--- local function log(str)
---     local file, err = io.open("/tmp/tmp.log", "a")
---     if not file then
---         return false, err
---     end
---     file:write(str)
---     file:flush()
---     file:close()
---     return true
--- end
--- return {log=log}
---```
---
---@param threadpool string
---@param module_name string
---@param func_name string
---@param arg1? ngx.thread.arg
---@param arg2? ngx.thread.arg
---@param ... ngx.thread.arg
---@return boolean ok
---@return ngx.thread.arg? result_or_error
---@return any ...
function ngx.run_worker_thread(threadpool, module_name, func_name, arg1, arg2, ...)
end

return ngx
