---@meta

--- lua cjson
---
--- https://kyne.com.au/~mark/software/lua-cjson.php
--- https://kyne.com.au/~mark/software/lua-cjson-manual.html
--- https://openresty.org/en/lua-cjson-library.html
---
--- **NOTE:** This includes the additions in the OpenResty-maintained cjson fork: https://github.com/openresty/lua-cjson
---
--- ---
---
--- The cjson module will throw an error during JSON conversion if any invalid
--- data is encountered. Refer to `cjson.encode` and cjson.decode for details.
---
--- The cjson.safe module behaves identically to the cjson module, except when
--- errors are encountered during JSON conversion. On error, the cjson_safe.encode
--- and cjson_safe.decode functions will return nil followed by the error message.
---
--- cjson.new can be used to instantiate an independent copy of the Lua CJSON
--- module. The new module has a separate persistent encoding buffer, and default settings.
---
--- Lua CJSON can support Lua implementations using multiple preemptive threads
--- within a single Lua state provided the persistent encoding buffer is not
--- shared. This can be achieved by one of the following methods:
---
---  * Disabling the persistent encoding buffer with cjson.encode_keep_buffer
---  * Ensuring each thread calls cjson.encode separately (ie, treat cjson.encode as non-reentrant).
---  * Using a separate cjson module table per preemptive thread (cjson.new)
---
--- ## Note
---
--- Lua CJSON uses `strtod` and `snprintf` to perform numeric conversion as they
--- are usually well supported, fast and bug free. However, these functions
--- require a workaround for JSON encoding/parsing under locales using a comma
--- decimal separator. Lua CJSON detects the current locale during instantiation
--- to determine and automatically implement the workaround if required. Lua
--- CJSON should be reinitialised via cjson.new if the locale of the current
--- process changes. Using a different locale per thread is not supported.
---
---@class cjson
---@field _NAME          string
---@field _VERSION       string
---@field null           cjson.null
---@field empty_array    cjson.empty_array
---@field array_mt       cjson.array_mt
---@field empty_array_mt cjson.empty_array_mt
---
local cjson = {}


--- A metatable which can "tag" a table as a JSON Array in case it is empty (that
--- is, if the table has no elements, `cjson.encode()` will encode it as an empty
--- JSON Array).
---
--- Instead of:
---
---```lua
--- local function serialize(arr)
---     if #arr < 1 then
---         arr = cjson.empty_array
---     end
---
---     return cjson.encode({some_array = arr})
--- end
---```
---
--- This is more concise:
---
---```lua
--- local function serialize(arr)
---     setmetatable(arr, cjson.empty_array_mt)
---
---     return cjson.encode({some_array = arr})
--- end
---```
---
--- Both will generate:
---
---```json
--- {
---     "some_array": []
--- }
---```
---
--- **NOTE:** This field is specific to the OpenResty cjson fork.
---
---@alias cjson.empty_array_mt table


--- When lua-cjson encodes a table with this metatable, it will systematically
--- encode it as a JSON Array. The resulting, encoded Array will contain the
--- array part of the table, and will be of the same length as the `#` operator
--- on that table. Holes in the table will be encoded with the null JSON value.
---
--- ## Example
---
---```lua
--- local t = { "hello", "world" }
--- setmetatable(t, cjson.array_mt)
--- cjson.encode(t) -- ["hello","world"]
---```
---
--- Or:
---
---```lua
--- local t = {}
--- t[1] = "one"
--- t[2] = "two"
--- t[4] = "three"
--- t.foo = "bar"
--- setmetatable(t, cjson.array_mt)
--- cjson.encode(t) -- ["one","two",null,"three"]
---```
---
--- **NOTE:** This field is specific to the OpenResty cjson fork.
---
--- This value was introduced in the 2.1.0.5 release of this module.
---
---@alias cjson.array_mt table


--- Sentinel type that denotes a JSON `null` value
---@alias cjson.null lightuserdata


--- A lightuserdata, similar to `cjson.null`, which will be encoded as an empty
--- JSON Array by `cjson.encode()`.
---
--- For example, since encode_empty_table_as_object is true by default:
---
---```lua
--- local cjson = require "cjson"
---
--- local json = cjson.encode({
---     foo = "bar",
---     some_object = {},
---     some_array = cjson.empty_array
--- })
---```
---
--- This will generate:
---
---```json
--- {
---     "foo": "bar",
---     "some_object": {},
---     "some_array": []
--- }
---```
---
--- **NOTE:** This field is specific to the OpenResty cjson fork.
---
---@alias cjson.empty_array lightuserdata


--- unserialize a json string to a lua value
---
--- `cjson.decode` will deserialise any UTF-9 JSON string into a Lua value or table.
---
--- UTF-16 and UTF-32 JSON strings are not supported.
---
--- cjson.decode requires that any NULL (ASCII 0) and double quote (ASCII 34) characters are escaped within strings. All escape codes will be decoded and other bytes will be passed transparently. UTF-8 characters are not validated during decoding and should be checked elsewhere if required.
---
--- JSON null will be converted to a NULL lightuserdata value. This can be compared with `cjson.null` for convenience.
---
--- By default, numbers incompatible with the JSON specification (infinity, NaN, hexadecimal) can be decoded. This default can be changed with `cjson.decode_invalid_numbers()`.
---
--- ```lua
--- local json_text '[ true, { "foo": "bar" } ]'
--- cjson.decode(json_text) --> { true, { foo = "bar" } }
--- ```
---
---@param json string
---@return any
function cjson.decode(json) end


--- decode_invalid_numbers
---
--- Lua CJSON may generate an error when trying to decode numbers not supported
--- by the JSON specification. Invalid numbers are defined as:
---
---  * infinity
---  * not-a-number (NaN)
---  * hexadecimal
---
--- Available settings:
---
---  * `true`: Accept and decode invalid numbers. This is the default setting.
---  * `false`:  Throw an error when invalid numbers are encountered.
---
--- The current setting is always returned, and is only updated when an argument is provided.
---
---@param setting? boolean # (default: `true`)
---@return boolean setting # the value of the current setting
function cjson.decode_invalid_numbers(setting) end


--- decode_max_depth
---
--- Lua CJSON will generate an error when parsing deeply nested JSON once the
--- maximum array/object depth has been exceeded.  This check prevents
--- unnecessarily complicated JSON from slowing down the application, or crashing
--- the application due to lack of process stack space.
---
--- An error may be generated before the depth limit is hit if Lua is unable to
--- allocate more objects on the Lua stack.
---
--- By default, Lua CJSON will reject JSON with arrays and/or objects nested
--- more than 1000 levels deep.
---
--- The current setting is always returned, and is only updated when an argument is provided.
---
---@param depth? integer # must be positive (default `1000`)
---@return integer depth
function cjson.decode_max_depth(depth) end


--- decode_array_with_array_mt
---
--- If enabled, JSON Arrays decoded by cjson.decode will result in Lua tables
--- with the array_mt metatable. This can ensure a 1-to-1 relationship between
--- arrays upon multiple encoding/decoding of your JSON data with this module.
---
--- If disabled, JSON Arrays will be decoded to plain Lua tables, without the
--- `cjson.array_mt` metatable.
---
--- ## Example
---
---```lua
--- local cjson = require "cjson"
---
--- -- default behavior
--- local my_json = [[{"my_array":[]}]]
--- local t = cjson.decode(my_json)
--- cjson.encode(t) -- {"my_array":{}} back to an object
---
--- -- now, if this behavior is enabled
--- cjson.decode_array_with_array_mt(true)
---
--- local my_json = [[{"my_array":[]}]]
--- local t = cjson.decode(my_json)
--- cjson.encode(t) -- {"my_array":[]} properly re-encoded as an array
---```
---
--- **NOTE:** This function is specific to the OpenResty cjson fork.
---
---@param enabled boolean # (default: false)
function cjson.decode_array_with_array_mt(enabled) end


--- serialize a lua value to a json string
---
--- cjson.encode will serialise a Lua value into a string containing the JSON representation.
---
--- cjson.encode supports the following types:
---
---  * boolean
---  * lightuserdata (NULL value only)
---  * nil
---  * number
---  * string
---  * table
---
--- The remaining Lua types will generate an error:
---
---  * function
---  * lightuserdata (non-NULL values)
---  * thread
---  * userdata
---
--- By default, numbers are encoded with 14 significant digits. Refer to cjson.encode_number_precision for details.
---
--- Lua CJSON will escape the following characters within each UTF-8 string:
---
---  * Control characters (ASCII 0 - 31)
---  * Double quote (ASCII 34)
---  * Forward slash (ASCII 47)
---  * Blackslash (ASCII 92)
---  * Delete (ASCII 127)
---
--- All other bytes are passed transparently.
---
---
--- ## Caution
---
--- Lua CJSON will successfully encode/decode binary strings, but this is technically not supported by JSON and may not be compatible with other JSON libraries. To ensure the output is valid JSON, applications should ensure all Lua strings passed to cjson.encode are UTF-8.
---
--- ---
--- Base64 is commonly used to encode binary data as the most efficient encoding under UTF-8 can only reduce the encoded size by a further ~8%. Lua Base64 routines can be found in the LuaSocket and lbase64 packages.
---
--- Lua CJSON uses a heuristic to determine whether to encode a Lua table as a JSON array or an object. A Lua table with only positive integer keys of type number will be encoded as a JSON array. All other tables will be encoded as a JSON object.
---
--- Lua CJSON does not use metamethods when serialising tables.
---
---  * `rawget()` is used to iterate over Lua arrays
---  * `next()` is used to iterate over Lua objects
---
--- Lua arrays with missing entries (sparse arrays) may optionally be encoded in
--- several different ways. Refer to cjson.encode_sparse_array for details.
---
--- JSON object keys are always strings. Hence cjson.encode only supports table
--- keys which are type number or string. All other types will generate an error.
---
--- ## Note
--- 	Standards compliant JSON must be encapsulated in either an object ({}) or an array ([]). If strictly standards compliant JSON is desired, a table must be passed to cjson.encode.
---
--- ---
---
--- By default, encoding the following Lua values will generate errors:
---
---  * Numbers incompatible with the JSON specification (infinity, NaN)
---  * Tables nested more than 1000 levels deep
---  * Excessively sparse Lua arrays
---
--- These defaults can be changed with:
---
---  * cjson.encode_invalid_numbers
---  * cjson.encode_max_depth
---  * cjson.encode_sparse_array
---
---```lua
--- local value = { true, { foo = "bar" } }
--- cjson.encode(value) --> '[true,{"foo":"bar"}]'
---```
---
---@param value any
---@return string json
function cjson.encode(value) end


--- encode_invalid_numbers
---
--- Lua CJSON may generate an error when encoding floating point numbers not
--- supported by the JSON specification (invalid numbers):
---
---  * infinity
---  * not-a-number (NaN)
---
--- Available settings:
---
--- * `true`: Allow invalid numbers to be encoded. This will generate non-standard JSON, but this output is supported by some libraries.
--- * `false`: Throw an error when attempting to encode invalid numbers. This is the default setting.
--- * `"null"`: Encode invalid numbers as a JSON null value. This allows infinity and NaN to be encoded into valid JSON.
---
--- The current setting is always returned, and is only updated when an argument is provided.
---
---@param setting? boolean|'"null"'
---@return boolean|'"null"' setting
function cjson.encode_invalid_numbers(setting) end


--- encode_keep_buffer
---
--- Lua CJSON can reuse the JSON encoding buffer to improve performance.
---
--- Available settings:
---
--- * `true` - The buffer will grow to the largest size required and is not freed until the Lua CJSON module is garbage collected. This is the default setting.
--- * `false` - Free the encode buffer after each call to cjson.encode.
---
--- The current setting is always returned, and is only updated when an argument is provided.
---
---@param setting? boolean
---@return boolean setting
function cjson.encode_keep_buffer(setting) end


--- encode_max_depth
---
--- Once the maximum table depth has been exceeded Lua CJSON will generate an
--- error. This prevents a deeply nested or recursive data structure from
--- crashing the application.
---
--- By default, Lua CJSON will generate an error when trying to encode data
--- structures with more than 1000 nested tables.
---
--- The current setting is always returned, and is only updated when an argument is provided.
---
---@param depth? integer # must be positive (default `1000`)
---@return integer depth
function cjson.encode_max_depth(depth) end


--- encode_number_precision
---
--- The amount of significant digits returned by Lua CJSON when encoding numbers
--- can be changed to balance accuracy versus performance. For data structures
--- containing many numbers, setting cjson.encode_number_precision to a smaller
--- integer, for example 3, can improve encoding performance by up to 50%.
---
--- By default, Lua CJSON will output 14 significant digits when converting a number to text.
---
--- The current setting is always returned, and is only updated when an argument is provided.
---
--- **NOTE:** The maximum value of 16 is only supported by the OpenResty cjson
--- fork. The maximum in the upstream mpx/lua-cjson module is 14.
---
---@param precision? integer # must be between 1 and 16
---@return integer precision
function cjson.encode_number_precision(precision) end


--- encode_sparse_array
---
--- Lua CJSON classifies a Lua table into one of three kinds when encoding a JSON array. This is determined by the number of values missing from the Lua array as follows:
---
---  * Normal - All values are available.
---  * Sparse - At least 1 value is missing.
---  * Excessively sparse - The number of values missing exceeds the configured ratio.
---
--- Lua CJSON encodes sparse Lua arrays as JSON arrays using JSON null for the missing entries.
---
--- An array is excessively sparse when all the following conditions are met:
---
---  * ratio > 0
---  * maximum_index > safe
---  * maximum_index > item_count * ratio
---
--- Lua CJSON will never consider an array to be excessively sparse when ratio = 0.
--- The safe limit ensures that small Lua arrays are always encoded as sparse arrays.
---
--- By default, attempting to encode an excessively sparse array will generate
--- an error. If convert is set to true, excessively sparse arrays will be
--- converted to a JSON object.
---
--- The current settings are always returned. A particular setting is only
--- changed when the argument is provided (non-nil).
---
--- ## Example: Encoding a sparse array
---
---```lua
--- cjson.encode({ [3] = "data" })
--- -- Returns: '[null,null,"data"]'
---```
---
--- ## Example: Enabling conversion to a JSON object
---
---```lua
--- cjson.encode_sparse_array(true)
--- cjson.encode({ [1000] = "excessively sparse" })
--- -- Returns: '{"1000":"excessively sparse"}'
---```
---
---@param convert? boolean # (default: false)
---@param ratio? integer   # must be positive (default: 2)
---@param safe?  integer   # must be positive (default: 10)
---@return boolean convert
---@return integer ratio
---@return integer safe
function cjson.encode_sparse_array(convert, ratio, safe) end


--- encode_empty_table_as_object
---
--- Change the default behavior when encoding an empty Lua table.
---
--- By default, empty Lua tables are encoded as empty JSON Objects (`{}`). If
--- this is set to false, empty Lua tables will be encoded as empty JSON Arrays
--- instead (`[]`).
---
--- **NOTE:** This function is specific to the OpenResty cjson fork.
---
---@param setting boolean|'"on"'|'"off"'
function cjson.encode_empty_table_as_object(setting) end


--- encode_escape_forward_slash
---
--- If enabled, forward slash '/' will be encoded as '\/'.
---
--- If disabled, forward slash '/' will be encoded as '/' (no escape is applied).
---
--- **NOTE:** This function is specific to the OpenResty cjson fork.
---
---@param enabled boolean # (default: true)
function cjson.encode_escape_forward_slash(enabled) end


--- instantiate an independent copy of the Lua CJSON module
---
--- The new module has a separate persistent encoding buffer, and default settings
---@return cjson
function cjson.new() end


return cjson
