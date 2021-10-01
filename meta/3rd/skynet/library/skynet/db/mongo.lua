---@meta
local mongo            = {}

---@class mongo_client
---@field host string
---@field port number
---@field username string
---@field password string
---@field authdb string
---@field authmod string
---@field __id number
---@field __sock socketchannel
local mongo_client     = {}

---@class mongo_db
---@field connection mongo_client
---@field name string 
---@field full_name string
---@field database mongo_db
---@field _cmd string dbname.$cmd
local mongo_db         = {}

---@class mongo_collection
---@field connection mongo_client
---@field name string
---@field full_name string
---@field database boolean
local mongo_collection = {}

---@class mongo_cursor
local mongo_cursor     = {}
---建立一个客户端
---@param conf table {host, port, username, password, authdb, authmod}
---@return mongo_client
function mongo.client(conf)
end
---获取一个 mongo_db 对象
---@param dbname string
---@return mongo_db
function mongo_client:getDB(dbname)
end

---断开连接
function mongo_client:disconnect()
end
---以 self.admin:runCommand(...) 来执行命令
function mongo_client:runCommand(...)
end

---退出登录
function mongo_client:logout()
end

---验证登录
---@param user string
---@param pass string
function mongo_db:auth(user, pass)

end
---执行命令
function mongo_db:runCommand(cmd, cmd_v, ...)
end
---获取集合
---@param collection string
---@return mongo_collection
function mongo_db:getCollection(collection)
end
---获取集合
---@param collection string
---@return mongo_collection
function mongo_collection:getCollection(collection)
end

---向集合插入文档
---@param doc table
function mongo_collection:insert(doc)
end
---向集合安全的插入数据
---@param dco table
function mongo_collection:safe_insert(dco)
end

---插入批量数据
---@param docs table[]
function mongo_collection:batch_insert(docs)

end
---安全插入批量数据
---@param docs table[]
function mongo_collection:safe_batch_insert(docs)

end
---更新数据
---@param selector table
---@param update table
---@param upsert boolean
---@param multi boolean
function mongo_collection:update(selector, update, upsert, multi)

end
---安全更新数据
---@param selector table
---@param update table
---@param upsert boolean
---@param multi boolean
function mongo_collection:safe_update(selector, update, upsert, multi)

end

---删除数据
---@param selector table
---@param single boolean
function mongo_collection:delete(selector, single)

end
---安全删除数据
---@param selector table
---@param single boolean
function mongo_collection:safe_delete(selector, single)

end
---@param query table
---@param selector table
---@return mongo_cursor
function mongo_collection:find(query, selector)

end
---@param query table
---@param selector table
---@return table
function mongo_collection:findOne(query, selector)

end

---建立索引
---* collection:createIndex { { key1 = 1}, { key2 = 1 },  unique = true }
---* or collection:createIndex { "key1", "key2",  unique = true }
---* or collection:createIndex( { key1 = 1} , { unique = true } )	-- For compatibility
---@param arg1 table
---@param arg2 table
function mongo_collection:createIndex(arg1, arg2)

end
---建立多个索引
---@vararg table
function mongo_collection:createIndexs(...)

end
mongo_collection.ensureIndex = mongo_collection.createIndex

---删除集合
function mongo_collection:drop()

end
--- 删除索引
---* collection:dropIndex("age_1")
---* collection:dropIndex("*")
---@param indexName  string 
function mongo_collection:dropIndex(indexName)

end

---查找并修改
---* collection:findAndModify({query = {name = "userid"}, update = {["$inc"] = {nextid = 1}}, })
---* keys, value type
---* query, table
---* sort, table
---* remove, bool
---* update, table
---* new, bool
---* fields, bool
---* upsert, boolean
---@param doc table
function mongo_collection:findAndModify(doc)

end

---排序
---* cursor:sort { key = 1 } or cursor:sort( {key1 = 1}, {key2 = -1})
---@param key table
---@param key_v table
function mongo_cursor:sort(key, key_v, ...)
end
---跳过多少行
---@param amount number
function mongo_cursor:skip(amount)
end
---限制行数
---@param amount number
function mongo_cursor:limit(amount)
end
---统计行数
---@param with_limit_and_skip boolean
function mongo_cursor:count(with_limit_and_skip)
end
---是否有下一行
---@return boolean
function mongo_cursor:hasNext()
end
---下一行
---@return table
function mongo_cursor:next()
end
---关闭游标
function mongo_cursor:close()
end
return mongo
