---@meta

---Library of https://github.com/cloudwu/luaecs

---We use a component id and a index in a component pooid, then we can
---get this component's entity id ,then get all other components.
---@class ITER
---@field index integer index of the component pool
---@field cid integer component type id
---@field iter ENTITY_GROUPITER #userdata

---Return depend the pattern, every pattern will be return a table.
---This is a C function, and it will be used as the __call metamethod of the
---ECSWorld#_groupiter 's return usedata's metatable.
---If the pattern of select is a component name but not a condition,then return
---is the component pool index and component id.
---@alias ENTITY_GROUPITER fun():ITER

---Every entity must defined which component it contains on new.
---@class ECSWorld
local meta = {}

---Register a component, use Lua table to describe data struct.
---The table is a name field and data field list, and can has a type field, field will be 'filed_name:type'.
---Then, will caulate the size of component type's data.
---Support type is: int, float, bool, int64, dword, word, byte, double, userdata
---* if type is `lua`, the size is ecs._LUAOBJECT, -1;
---* if type is `raw`, we must set the type's size explict;
---* or the size may bigger than 0, which caculated from the data field list.
---* or if the size is 0, it is a one value component, if it has type field, then the size is the type size;
---* or if the size litter then 0, it is a tag.
---```
---In C, this is init a component pool, every component pool's data will in a continus memory.
--- {name = 'vector', 'x:float','y:float'}  -- normal component
--- {name = 'object',type='lua'}}           -- lua component
--- {name = 'hp', type='int'}               -- one value component
--- {name = 'mark'},                        -- tag, default it boolean
----{name = 'rawobj', type='raw', size= '20'} -- raw object
--- {name = 'byname', order = true}         -- order tag
--- Then the c api _newtype will malloc a continus memory of the types' size.
---@param typeclass table
---@see ECSWorld#_newtype
function meta:register(typeclass)
end

---Construct a new entity, use Lua table to describe it.
---The key is the component type, must register it before,
---so, every kv pair is a component.
---Every component pool will get the new entity id.
---@param obj? table #{name = "hello", position= {x = 1, y = 2}}
---@return integer #eid
function meta:new(obj)
end

---Return the info of a list of component names.
---May be, for test use?
---@param t string[] component name list
---@return userdata #ctx info
---@see ECSWorld#_context
function meta:context(t)
end

---Select a patterns of entitys, the mainkey( first key) can't not be has absent condtion.
---The pattern is a space-separated combination of `componentname[:?]action`, and the `action` can be
---* in  : read the component
---* out : write the component
---* update : read / write
---* absent : check if the component is not exist
---* exist  (default) : check if the component is exist
---* new : create the component
---* ? means it's an optional action if the component is not exist
---NOTICE: If you use action `new` , you must guarantee the component is clear (None entity has this component) before iteration.
---If opt and inout is absent, the return is the id info of the entitys.{ {pooid, cid}}
---**Return value will only has components in he pattern**
---**Return value will like {component_index, component_id,ENTITY_GROUPITER,component1, component2}
---@param pat string #key [{opt inout}] , opt is : or ?, inout is in, out, update, exist(default), absent, new.like t:in, b:out, id?update
---@return ENTITY_GROUPITER #iter function
---@see ECSWorld#_groupiter
function meta:select(pat)
end

---Sync all then component of the entity represent by a iter to LUA
---@param iter number|ITER #ITER or entity id
---@return table
---@see ECSWorld#_read
---@see ECSWorld#access
---@see ECSWorld#fetch
function meta:readall(iter)
end

---Clear a component type of name `name`
---@param name string component name
---@see ECSWorld#_clear
function meta:clear(name)
end

---Clear all component types.
---@see ECSWorld#clear
function meta:clearall()
end

---Dump all indexes of a component of name `name`
---@param name string
---@return integer[]
---@see ECSWorld#_dumpid
function meta:dumpid(name)
end

---Update world, will free removed(default, or with tag `tagname`) entity.
---@param tagname? string #tagname, default is REMOVED, but we also can use other tag to delete entities.
---@see ECSWorld#_update
function meta:update(tagname)
end

local M = {
    _MAXTYPE       = 255,
    _METHODS       = meta,
    _TYPE_INT      = 0,
    _TYPE_FLOAT    = 1,
    _TYPE_BOOL     = 2,
    _TYPE_INT64    = 3,
    _TYPE_DWORD    = 4,
    _TYPE_WORD     = 5,
    _TYPE_BYTE     = 6,
    _TYPE_DOUBLE   = 7,
    _TYPE_USERDATA = 8,
    _TYPE_COUNT    = 9,
    _LUAOBJECT     = -1,
    _REMOVED       = 0,
    _ORDERKEY      = -2,
    NULL           = 0x0, -- userdata
}

---Lua function
---Construct a new LuaECS World
---@return ECSWorld
function M.world()
end

---Like new(obj), but use a specifie entity
---@param eid integer #entity id
---@param obj table #describe all component of the type
function meta:import(eid, obj)
end

-- Create a template first
---local t = w:template {
---	name = "foobar"
---}
-- instance the template into an entity, and add visible tag.
--- The additional components ( { visible = true } ) is optional.
--- local eid = w:template_instance(w:new(), t, { visible = true })
---Use a templat to Construct an entity.
---@param eid integer #entity id
---@param temp string #template name
---@param obj table
function meta:template_instance(eid, temp, obj)
end

---Get an entity's one component, can can write the value.
---@param eid integer
---@param pat string #only one key
---@param value? any # when with this values, is write.
---@return any|nil # pattern key is tag, return boolean; lua type, return lua data; else table; if write, return nil.
---@see ECSWorld#readall
---@see ECSWorld#fetch
function meta:access(eid, pat, value)
end

---Count the pattern 's object number
---@param pat string
---@return integer
function meta:count(pat)
end

---Extend an iter with pattern.
---@param iter ITER
---@param expat string
---@see ECSWorld#_read
function meta:extend(iter, expat) end

---Get component id by name
---@param name string
---@return integer #component id
function meta:component_id(name) end

---Persist Use
function meta:read_component(reader, name, offset, stride, n) end

---Get the first entity of pattern `pattern`
---We can use this as a signletone component.
---@param pattern string
---@return ITER
function meta:first(pattern) end

---Check  pattern `pattern` whether has entitys.
---Work same as ECSWorld#first but return boolean.
---@param pattern string
---@return boolean
function meta:check(pattern) end

---Register a template.
---@param obj table #component and value pairs
function meta:template(obj) end

---You can tags entities in groups with `w:group_enable(tagname, groupid1, groupid2,...)`
---Enable tag `tagname` on multi groups
---@param tagname string tagname
---@param ... number #group id s
---@see ECSWorld#_group_enable
function meta:group_enable(tagname, ...) end

---Get a component's type.
---@param name string
---@return string # tag | lua | c  | M._TYPE*
function meta:type(name) end

---This will reset `tagname`'s component pool.
---Set tag on entitys in pattern `pat`
---@param tagname string
---@param pat string
function meta:filter(tagname, pat) end

---Fetch entity's component with pattern `pat`
---You can use out, update and then w:sumit() to modify entity.
---@param eid integer
---@param pat? string
---@see ECSWorld#readall
---@see ECSWorld#access
---@return table # entity with pat specified component
function meta:fetch(eid, pat) end

----------- C API -------------
---C API
---Get the world size
---@return integer, integer #capaticy size, used size
function meta:memory() end

---C API
---shrink_component_pool
function meta:collect() end

---C API
---New component type.
---@param cid integer component id, cacul from the Lua
---@param size integer # size
---@see ECSWorld#register
function meta:_newtype(cid, size)
end

--- C API
---Return a new entity
---@return integer entity id
function meta:_newentity()
end

--- C API
---Check the entity is exist
---@param eid integer
---@return integer #entity's index in the world, start at 0
---@see ECSWorld#exist
function meta:_indexentity(eid) end

--- C API
---Add entity of id `eid` to the component pool of id `cid`, return the pool index.
---@param eid integer entity id
---@param cid integer component id,
---@return integer #pool index id
function meta:_addcomponent(eid, cid)
end

--- C API
---Update world.
---Remove all entity which removed(default) or  with component id `cid`, and will rearrange the world.
---@param cid? integer #tagid
---@see ECSWorld#update
function meta:_update(cid)
end

--- C API
---Clear component of id `cid`
---@param cid integer component id
---@see ECSWorld#clear
function meta:_clear(cid)
end

--- C API
---Return the info of a list of component ids.
---@param t integer[]
---@return userdata #ctx info
---@see ECSWorld#context
function meta:_context(t)
end

--- C API
---Return an iter function for a list of pattren.
---@param pat_desc table[] #{ {name, id, type, [opt, r, w, exist, absent, new] }
---@return ENTITY_GROUPITER #iter C function
function meta:_groupiter(pat_desc)
end

--- C API
function meta:_mergeiter(...) end

--- C API
---Get a iter of entity eid.
---@param eid integer
---@return ITER # the cid will by -1
function meta:_fetch(eid) end

--- C API
---Entity exists?
---@param eid integer
function meta:exist(eid) end

--- C API
--- Remove an entity with eid
--- The removed entity will has a tag REMOVED
---@param eid number
function meta:remove(eid)
end

---C API
---@param ref ENTITY_GROUPITER #the iter of component
---@param cv any #the inited component
---@param index integer #the index of the component pool
function meta:_object(ref, cv, index)
end

---@param pattern string
---@param iter ITER
function meta:_read(pattern, iter)
end

---C API
---Commit an mod of a group iter with out or new
---@param iter ITER
function meta:submit(iter) end

---@see ECSWorld:#first
function meta:_first(...) end

---Dump all id of a component of id `cid`
---@param cid integer
---@return integer[]
---@see ECSWorld#dumpid
function meta:_dumpid(cid)
end

---@see ECSWorld:count
function meta:_count(...) end

---@see ECSWorld:filter
function meta:_filter(...) end

function meta:_access(...) end

function meta:__gc(...) end

---C API
--- Add entity (eid) into a group with groupid (32bit integer)
---**NOTE:We can add entity to a group, but we can not remove it from a group.**
---**NOTE:We can iterate a group, but we can not random visit a group member.**
---@param groupid number #32bit
---@param eid number
function meta:group_add(groupid, eid) end

---C API. Add tag of group's entitys
---**NOTICE: this call will clear the the tag's component pool.**
---@param tagid number
---@param ... number #max number is 1024
---@see ECSWorld#group_enable
function meta:_group_enable(tagid, ...) end

---C api, get the eid list of a group
---@param groupid number
---@return table # eid list
function meta:group_get(groupid) end

return M
