---#if not JIT then DISABLE() end
---@meta


--[[
### Buffer Objects

A buffer object is a garbage-collected Lua object. After creation with buffer.new(), it can (and should) be reused for many operations. When the last reference to a buffer object is gone, it will eventually be freed by the garbage collector, along with the allocated buffer space.

Buffers operate like a FIFO (first-in first-out) data structure. Data can be appended (written) to the end of the buffer and consumed (read) from the front of the buffer. These operations may be freely mixed.

The buffer space that holds the characters is managed automatically — it grows as needed and already consumed space is recycled. Use buffer.new(size) and buf:free(), if you need more control.

The maximum size of a single buffer is the same as the maximum size of a Lua string, which is slightly below two gigabytes. For huge data sizes, neither strings nor buffers are the right data structure — use the FFI library to directly map memory or files up to the virtual memory limit of your OS.

### Buffer Method Overview

+   The buf:put*()-like methods append (write) characters to the end of the buffer.
+   The buf:get*()-like methods consume (read) characters from the front of the buffer.
+   Other methods, like buf:tostring() only read the buffer contents, but don't change the buffer.
+   The buf:set() method allows zero-copy consumption of a string or an FFI cdata object as a buffer.
+   The FFI-specific methods allow zero-copy read/write-style operations or modifying the buffer contents in-place. Please check the [FFI caveats](#ffi_caveats) below, too.
+   Methods that don't need to return anything specific, return the buffer object itself as a convenience. This allows method chaining, e.g.: buf:reset():encode(obj) or buf:skip(len):get()

## Serialization of Lua Objects

The following functions and methods allow **high-speed serialization** (encoding) of a Lua object into a string and decoding it back to a Lua object. This allows convenient storage and transport of **structured data**.

The encoded data is in an [internal binary format](#serialize_format). The data can be stored in files, binary-transparent databases or transmitted to other LuaJIT instances across threads, processes or networks.

Encoding speed can reach up to 1 Gigabyte/second on a modern desktop- or server-class system, even when serializing many small objects. Decoding speed is mostly constrained by object creation cost.

The serializer handles most Lua types, common FFI number types and nested structures. Functions, thread objects, other FFI cdata and full userdata cannot be serialized (yet).

The encoder serializes nested structures as trees. Multiple references to a single object will be stored separately and create distinct objects after decoding. Circular references cause an error.

## Error handling

Many of the buffer methods can throw an error. Out-of-memory or usage errors are best caught with an outer wrapper for larger parts of code. There's not much one can do after that, anyway.

OTOH you may want to catch some errors individually. Buffer methods need to receive the buffer object as the first argument. The Lua colon-syntax obj:method() does that implicitly. But to wrap a method with pcall(), the arguments need to be passed like this:

local ok, err = pcall(buf.encode, buf, obj)
if not ok then
  -- Handle error in err.
end

## FFI caveats

The string buffer library has been designed to work well together with the FFI library. But due to the low-level nature of the FFI library, some care needs to be taken:

First, please remember that FFI pointers are zero-indexed. The space returned by buf:reserve() and buf:ref() starts at the returned pointer and ends before len bytes after that.

I.e. the first valid index is ptr[0] and the last valid index is ptr[len-1]. If the returned length is zero, there's no valid index at all. The returned pointer may even be NULL.

The space pointed to by the returned pointer is only valid as long as the buffer is not modified in any way (neither append, nor consume, nor reset, etc.). The pointer is also not a GC anchor for the buffer object itself.

Buffer data is only guaranteed to be byte-aligned. Casting the returned pointer to a data type with higher alignment may cause unaligned accesses. It depends on the CPU architecture whether this is allowed or not (it's always OK on x86/x64 and mostly OK on other modern architectures).

FFI pointers or references do not count as GC anchors for an underlying object. E.g. an array allocated with ffi.new() is anchored by buf:set(array, len), but not by buf:set(array+offset, len). The addition of the offset creates a new pointer, even when the offset is zero. In this case, you need to make sure there's still a reference to the original array as long as its contents are in use by the buffer.

Even though each LuaJIT VM instance is single-threaded (but you can create multiple VMs), FFI data structures can be accessed concurrently. Be careful when reading/writing FFI cdata from/to buffers to avoid concurrent accesses or modifications. In particular, the memory referenced by buf:set(cdata, len) must not be modified while buffer readers are working on it. Shared, but read-only memory mappings of files are OK, but only if the file does not change.

### len = #buf
Returns the current length of the buffer data in bytes.
```lua
len = #buf
```
### res = str|num|buf .. str|num|buf […]

The Lua concatenation operator .. also accepts buffers, just like strings or numbers. It always returns a string and not a buffer.

Note that although this is supported for convenience, this thwarts one of the main reasons to use buffers, which is to avoid string allocations. Rewrite it with buf:put() and buf:get().

Mixing this with unrelated objects that have a __concat metamethod may not work, since these probably only expect strings.

```lua
res = str|num|buf .. str|num|buf […]
```
]]
---@class Luajit.Buffer
local buf = {}

--[[
The buffer space of the buffer object is freed. The object itself remains intact, empty and may be reused.

Note: you normally don't need to use this method. The garbage collector automatically frees the buffer space, when the buffer object is collected. Use this method, if you need to free the associated memory immediately.
]]
---@return Luajit.Buffer
function buf:free()
end

-- Reset (empty) the buffer. The allocated buffer space is not freed and may be reused.
---@return Luajit.Buffer
function buf:reset()
end

-- Skips (consumes) len bytes from the buffer up to the current length of the buffer data.
---@param len integer
---@return Luajit.Buffer
function buf:skip(len)
end

--[[
Appends a string str, a number num or any object obj with a __tostring metamethod to the buffer. Multiple arguments are appended in the given order.

Appending a buffer to a buffer is possible and short-circuited internally. But it still involves a copy. Better combine the buffer writes to use a single buffer.    
]]
---@param ... any
---@return Luajit.Buffer
function buf:put(...)
end

-- Appends the formatted arguments to the buffer. The format string supports the same options as `string.format()`.
---@param format any
---@param ... any
---@return Luajit.Buffer
function buf:putf(format, ...)
end

--[[
Appends the given len number of bytes from the memory pointed to by the FFI cdata object to the buffer. The object needs to be convertible to a (constant) pointer.
]]
---@param cdata ffi.cdata*
---@param len integer
---@return Luajit.Buffer
function buf:putcdata(cdata, len)
end

--[[

```lua
buf = buf:set(cdata, len)
```

This method allows zero-copy consumption of a string or an FFI cdata object as a buffer. It stores a reference to the passed string str or the FFI cdata object in the buffer. Any buffer space originally allocated is freed. This is *not* an append operation, unlike the buf:put*() methods.

After calling this method, the buffer behaves as if buf:free():put(str) or buf:free():put(cdata, len) had been called. However, the data is only referenced and not copied, as long as the buffer is only consumed.

In case the buffer is written to later on, the referenced data is copied and the object reference is removed (copy-on-write semantics).

The stored reference is an anchor for the garbage collector and keeps the originally passed string or FFI cdata object alive.
]]
---@overload fun(str:string):Luajit.Buffer
---@param cdata ffi.cdata*
---@param len integer
---@return Luajit.Buffer
function buf:set(cdata, len)
end

--[[
Consumes the buffer data and returns one or more strings. If called without arguments, the whole buffer data is consumed. If called with a number, up to len bytes are consumed. A nil argument consumes the remaining buffer space (this only makes sense as the last argument). Multiple arguments consume the buffer data in the given order.

Note: a zero length or no remaining buffer data returns an empty string and not nil.
]]
---@overload fun():string
---@param len integer
---@param ... integer
---@return string str
---@return string ...
function buf:get(len, ...)
end

--[[
The reserve method reserves at least size bytes of write space in the buffer. It returns an uint8_t * FFI cdata pointer ptr that points to this space.

The available length in bytes is returned in len. This is at least size bytes, but may be more to facilitate efficient buffer growth. You can either make use of the additional space or ignore len and only use size bytes.
]]
---@param size integer
---@return ffi.cdata* ptr
---@return integer len
function buf:reserve(size)
end

--[[

The `commit` method appends the used bytes of the previously returned write space to the buffer data.

This pair of methods allows zero-copy use of C read-style APIs:

```lua
local MIN_SIZE = 65536
repeat
  local ptr, len = buf:reserve(MIN_SIZE)
  local n = C.read(fd, ptr, len)
  if n == 0 then break end -- EOF.
  if n < 0 then error("read error") end
  buf:commit(n)
until false
```

The reserved write space is *not* initialized. At least the used bytes **must** be written to before calling the commit method. There's no need to call the commit method, if nothing is added to the buffer (e.g. on error).    
]]
---@param used integer
function buf:commit(used)
end

--[[

Returns an uint8_t * FFI cdata pointer ptr that points to the buffer data. The length of the buffer data in bytes is returned in len.

The returned pointer can be directly passed to C functions that expect a buffer and a length. You can also do bytewise reads (local x = ptr[i]) or writes (ptr[i] = 0x40) of the buffer data.

In conjunction with the skip method, this allows zero-copy use of C write-style APIs:

repeat
  local ptr, len = buf:ref()
  if len == 0 then break end
  local n = C.write(fd, ptr, len)
  if n < 0 then error("write error") end
  buf:skip(n)
until n >= len

Unlike Lua strings, buffer data is *not* implicitly zero-terminated. It's not safe to pass ptr to C functions that expect zero-terminated strings. If you're not using len, then you're doing something wrong.
]]
---@return ffi.cdata* ptr
---@return integer len
function buf:ref()
end

--[[
The stand-alone function de-serializes (decodes) the string str, the buffer method de-serializes one object from the buffer. Both return a Lua object obj.

The returned object may be any of the supported Lua types — even nil.

This function may throw an error when fed with malformed or incomplete encoded data. The stand-alone function throws when there's left-over data after decoding a single top-level object. The buffer method leaves any left-over data in the buffer.
]]
---@param str string
---@return any obj
function buf:decode(str)
end

--[[
Serializes (encodes) the Lua object obj. The stand-alone function returns a string str. The buffer method appends the encoding to the buffer.

obj can be any of the supported Lua types — it doesn't need to be a Lua table.

This function may throw an error when attempting to serialize unsupported object types, circular references or deeply nested tables.
]]
---@param obj any
---@return Luajit.Buffer
function buf:encode(obj)
end

--[[
Creates a string from the buffer data, but doesn't consume it. The buffer remains unchanged.

Buffer objects also define a __tostring metamethod. This means buffers can be passed to the global tostring() function and many other functions that accept this in place of strings. The important internal uses in functions like io.write() are short-circuited to avoid the creation of an intermediate string object.

```lua
str = buf:tostring()
str = tostring(buf)
```
]]
function buf:tostring()
end

--[[
The string buffer library allows **high-performance manipulation of string-like data**.

Unlike Lua strings, which are constants, string buffers are **mutable** sequences of 8-bit (binary-transparent) characters. Data can be stored, formatted and encoded into a string buffer and later converted, extracted or decoded.

The convenient string buffer API simplifies common string manipulation tasks, that would otherwise require creating many intermediate strings. String buffers improve performance by eliminating redundant memory copies, object creation, string interning and garbage collection overhead. In conjunction with the FFI library, they allow zero-copy operations.

The string buffer libary also includes a high-performance [serializer](https://luapower.com/files/luapower/csrc/luajit/src/doc/serialize) for Lua objects.
## Work in Progress

**This library is a work in progress. More functionality will be added soon.**

## Using the String Buffer Library

The string buffer library is built into LuaJIT by default, but it's not loaded by default. Add this to the start of every Lua file that needs one of its functions:

```lua
local buffer = require("string.buffer")
```

The convention for the syntax shown on this page is that buffer refers to the buffer library and buf refers to an individual buffer object.

Please note the difference between a Lua function call, e.g. buffer.new() (with a dot) and a Lua method call, e.g. buf:reset() (with a colon).
]]
---@class Luajit.LibBuffer
local buffer = {}

--[[
The options table passed to buffer.new() may contain the following members (all optional):

+   dict is a Lua table holding a **dictionary of strings** that commonly occur as table keys of objects you are serializing. These keys are compactly encoded as indexes during serialization. A well chosen dictionary saves space and improves serialization performance.
+   metatable is a Lua table holding a **dictionary of metatables** for the table objects you are serializing.

dict needs to be an array of strings and metatable needs to be an array of tables. Both starting at index 1 and without holes (no nil inbetween). The tables are anchored in the buffer object and internally modified into a two-way index (don't do this yourself, just pass a plain array). The tables must not be modified after they have been passed to buffer.new().

The dict and metatable tables used by the encoder and decoder must be the same. Put the most common entries at the front. Extend at the end to ensure backwards-compatibility — older encodings can then still be read. You may also set some indexes to false to explicitly drop backwards-compatibility. Old encodings that use these indexes will throw an error when decoded.

Metatables that are not found in the metatable dictionary are ignored when encoding. Decoding returns a table with a nil metatable.

Note: parsing and preparation of the options table is somewhat expensive. Create a buffer object only once and recycle it for multiple uses. Avoid mixing encoder and decoder buffers, since the buf:set() method frees the already allocated buffer space:

```lua
local options = {
  dict = { "commonly", "used", "string", "keys" },
}
local buf_enc = buffer.new(options)
local buf_dec = buffer.new(options)

local function encode(obj)
  return buf_enc:reset():encode(obj):get()
end

local function decode(str)
  return buf_dec:set(str):decode()
end
```

]]
---@class Luajit.LibBuffer.SerializationOptions
---@field dict string[]
---@field metatable string[]

--[[
Creates a new buffer object.

The optional size argument ensures a minimum initial buffer size. This is strictly an optimization when the required buffer size is known beforehand. The buffer space will grow as needed, in any case.

The optional table options sets various [serialization options](#serialize_options).
]]
---@overload fun(options:Luajit.LibBuffer.SerializationOptions)
---@param size integer
---@param options Luajit.LibBuffer.SerializationOptions
function buffer.new(size, options)
end

--[[

```lua
buf = buf:encode(obj)
```

Serializes (encodes) the Lua object obj. The stand-alone function returns a string str. The buffer method appends the encoding to the buffer.

obj can be any of the supported Lua types — it doesn't need to be a Lua table.

This function may throw an error when attempting to serialize unsupported object types, circular references or deeply nested tables.

### Streaming Serialization

In some contexts, it's desirable to do piecewise serialization of large datasets, also known as *streaming*.

This serialization format can be safely concatenated and supports streaming. Multiple encodings can simply be appended to a buffer and later decoded individually:

```lua
local buf = buffer.new()
buf:encode(obj1)
buf:encode(obj2)
local copy1 = buf:decode()
local copy2 = buf:decode()
```

Here's how to iterate over a stream:

```lua
while #buf ~= 0 do
  local obj = buf:decode()
  -- Do something with obj.
end
```

Since the serialization format doesn't prepend a length to its encoding, network applications may need to transmit the length, too.

### Serialization Format Specification

This serialization format is designed for **internal use** by LuaJIT applications. Serialized data is upwards-compatible and portable across all supported LuaJIT platforms.

It's an **8-bit binary format** and not human-readable. It uses e.g. embedded zeroes and stores embedded Lua string objects unmodified, which are 8-bit-clean, too. Encoded data can be safely concatenated for streaming and later decoded one top-level object at a time.

The encoding is reasonably compact, but tuned for maximum performance, not for minimum space usage. It compresses well with any of the common byte-oriented data compression algorithms.

Although documented here for reference, this format is explicitly **not** intended to be a 'public standard' for structured data interchange across computer languages (like JSON or MessagePack). Please do not use it as such.

The specification is given below as a context-free grammar with a top-level object as the starting point. Alternatives are separated by the | symbol and * indicates repeats. Grouping is implicit or indicated by {…}. Terminals are either plain hex numbers, encoded as bytes, or have a .format suffix.

```
object    → nil | false | true
          | null | lightud32 | lightud64
          | int | num | tab | tab_mt
          | int64 | uint64 | complex
          | string

nil       → 0x00
false     → 0x01
true      → 0x02

null      → 0x03                            // NULL lightuserdata
lightud32 → 0x04 data.I                   // 32 bit lightuserdata
lightud64 → 0x05 data.L                   // 64 bit lightuserdata

int       → 0x06 int.I                                 // int32_t
num       → 0x07 double.L

tab       → 0x08                                   // Empty table
          | 0x09 h.U h*{object object}          // Key/value hash
          | 0x0a a.U a*object                    // 0-based array
          | 0x0b a.U a*object h.U h*{object object}      // Mixed
          | 0x0c a.U (a-1)*object                // 1-based array
          | 0x0d a.U (a-1)*object h.U h*{object object}  // Mixed
tab_mt    → 0x0e (index-1).U tab          // Metatable dict entry

int64     → 0x10 int.L                             // FFI int64_t
uint64    → 0x11 uint.L                           // FFI uint64_t
complex   → 0x12 re.L im.L                         // FFI complex

string    → (0x20+len).U len*char.B
          | 0x0f (index-1).U                 // String dict entry

.B = 8 bit
.I = 32 bit little-endian
.L = 64 bit little-endian
.U = prefix-encoded 32 bit unsigned number n:
     0x00..0xdf   → n.B
     0xe0..0x1fdf → (0xe0|(((n-0xe0)>>8)&0x1f)).B ((n-0xe0)&0xff).B
   0x1fe0..       → 0xff n.I
```

The stand-alone function de-serializes (decodes) the string str, the buffer method de-serializes one object from the buffer. Both return a Lua object obj.

The returned object may be any of the supported Lua types — even nil.

This function may throw an error when fed with malformed or incomplete encoded data. The stand-alone function throws when there's left-over data after decoding a single top-level object. The buffer method leaves any left-over data in the buffer.
]]
---@param str string
---@return any obj
function buffer.decode(str)
end

--[[
The stand-alone function de-serializes (decodes) the string str, the buffer method de-serializes one object from the buffer. Both return a Lua object obj.

The returned object may be any of the supported Lua types — even nil.

This function may throw an error when fed with malformed or incomplete encoded data. The stand-alone function throws when there's left-over data after decoding a single top-level object. The buffer method leaves any left-over data in the buffer.
]]
---@param obj any
---@return string
function buffer.encode(obj)
end

return buffer
