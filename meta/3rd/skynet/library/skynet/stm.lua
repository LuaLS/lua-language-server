---@meta
--- stm 构造的内存对象
---@class stmobj :userdata
---@deprecated
local stmobj = {}
setmetatable(stmobj, stmobj)
---* 更新对象，实际上就是重新替换一个序列化对象
stmobj.__call = function(pointer, sz)
end

---@class stm
local stm    = {}
---* 将一个指针，用来构造一个 stm 对象
---* 任何 Lua 数据想要用 stm 共享，必须先序列化，如 sharemap 使用  sproto 来进行
---* 我们也可以直接使用 skynet.pack skynet.unpack 来序列化
---@param pointer userdata | string
---@param sz number
---@return stmobj
---@deprecated
function stm.new(pointer, sz)
end
---* 可以从一个共享对象中生成一份读拷贝。它返回一个 stmcopy ，是一个 lightuserdata 。
---* 通常一定要把这个 lightuserdata 传到需要读取这份数据的服务。随意丢弃这个指针会导致内存泄露。
---* 注：一个拷贝只能供一个读取者使用，你不可以把这个指针传递给多个服务。如果你有多个读取者，为每个人调用 copy 生成一份读拷贝。
---@param stmobj stmobj
---@return lightuserdata
function stm.copy(stmobj)
end
---* 把一个 C 指针转换为一份读拷贝。只有经过转换，stm 才能正确的管理它的生命期。
---* 一般来说，其他服务就传递这个指针到另外服务，收到了这个指针后，需要调用此 API 转换成一个 内存对象
---* 再经过反序列化函数才能得到  Lua 的表示
---@param stmcopy lightuserdata
---@return userdata
function stm.newcopy(stmcopy)
end
return stm
