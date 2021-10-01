---@meta
--- 一张表一旦被 query 一次，其数据的生命期将一直维持调用 query 的该服务退出。目前没有手段主动消除对一张共享表的引用。
---@class sharetable
local sharetable = {}
---* 从一个源文件读取一个共享表，这个文件需要返回一个 table ，这个 table 可以被多个不同的服务读取。... 是传给这个文件的参数。
---* 可以多次 load 同一个 filename 的表，这样的话，对应的 table 会被更新。使用这张表的服务需要调用 update 更新。
---@param filename string
---@vararg any 传递的参数
---@return table
function sharetable.loadfile(filename, ...)
end
---* 和 loadfile 类似，但是是从一个字符串读取。
---* 推荐使用 sharetable.loadfile 创建这个共享表。
---* 因为使用 sharetable.loadtable 会经过一次序列化和拷贝，对于太大的表，这个过程非常的耗时。
---@param filename string
---@param source string
---@vararg any
---@return table
function sharetable.loadstring(filename, source, ...)
end
---* 直接将一个 table 共享。
---@param filename string
---@param tbl table
---@return table
function sharetable.loadtable(filename, tbl)
end
---* 以 filename 为 key 查找一个被共享的 table 。
---@param filename string
---@return table
function sharetable.query(filename)
end
---* 更新一个或多个 key 。
---@vararg ... keys
function sharetable.update(...)
end

return sharetable
