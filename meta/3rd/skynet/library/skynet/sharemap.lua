---@meta
---@class sharemapwriter
local sharemapwriter = {}
---@class sharemapreader
local sharemapreader = {}
---* 一个使用 stm 模块实现的，用于在服务间共享数据的模块
---* 这里使用了 sproto 来描述序列化数据
---* 其内部引用了代表 Lua 的源数据
---* 和由 stm 构造的 stmobj
---@class sharemap
local sharemap       = {}
---* 注册 sproto 协议描述文件
function sharemap.register(protofile)
end
---* 将 Lua 数据，按 sproto 描述中的 某一类型进行序列化后，构造 stm 对象
---@param typename string
---@param obj any
---@return sharemapwriter
function sharemap.writer(typename, obj)
end
---* writer 实际上是将一分 Lua 数据，经过 sproto 序列化后，重新放到内存中
function sharemap:commit()
end
---* writer 使用，生成一个指针，用来传递到其他服务
function sharemap:copy()
end
---* reader 使用，若stm对象有更新，将内存重新序列化出来。
function sharemap:update()
end
---* 为一 stm 对象构造一个 reader
---@param typename any
---@param stmcpy any
---@return sharemapreader
function sharemap.reader(typename, stmcpy)
end

---@type stmobj
sharemapwriter.__obj = nil
sharemapwriter.__data = nil
---@type string
sharemapwriter.__typename = nil
sharemapwriter.copy = sharemap.copy
sharemapwriter.commit = sharemap.commit

sharemapreader.__typename = nil
---@type stmobj
sharemapreader.__obj = nil
---反序列化后的数据
sharemapreader.__data = nil
---* 调用此方法，会将内存中的数据重新序列化
sharemapreader.__update = sharemap.update
return sharemap
