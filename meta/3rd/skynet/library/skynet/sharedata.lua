---@meta
local sharedata = {}
---* 不可进行频繁的数据共享
---* 在当前节点内创建一个共享数据对象。
---* value 可以是一张 lua table ，但不可以有环。且 key 必须是字符串或 32bit 正整数。
---* value 还可以是一段 lua 文本代码，而 sharedata 模块将解析这段代码，把它封装到一个沙盒中运行，最终取得它返回的 table。如果它不返回 table ，则采用它的沙盒全局环境。
---* 如果 value 是一个以 @ 开头的字符串，这个字符串会被解释为一个文件名。sharedata 模块将加载该文件名指定的文件。
---@param name string
---@param value table | string
function sharedata.new(name, value)
end
---* 更新当前节点的共享数据对象。
---* 所有持有这个对象的服务都会自动去数据源头更新数据。但由于这是一个并行的过程，更新并不保证立刻生效。但使用共享数据的读取方一定能在同一个时间片（单次 skynet 消息处理过程）访问到同一版本的共享数据。
---* 更新过程是惰性的，如果你持有一个代理对象，但在更新数据后没有访问里面的数据，那么该代理对象会一直持有老版本的数据直到第一次访问。这个行为的副作用是：老版本的 C 对象会一直占用内存。如果你需要频繁更新数据，那么，为了加快内存回收，可以通知持有代理对象的服务在更新后，主动调用 sharedata.flush() 。
---@param name string
---@param value table | string
function sharedata.update(name, value)
end

---通知代理对象来更新数据
---一般在 update 后
function sharedata.flush()
end

---* 删除当前节点的共享数据对象。
---@param name string
function sharedata.delete(name)
end
---深拷贝
---@param name string
---@vararg string x.y.z
function sharedata.deepcopy(name, ...)
end

---获取当前节点的共享数据对象。
function sharedata.query(name)
end

return sharedata
