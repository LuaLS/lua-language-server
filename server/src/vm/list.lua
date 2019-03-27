local Id = 0
local List = {}

local function get(id)
    return List[id]
end

local function add(obj)
    Id = Id + 1
    List[Id] = obj
    return Id
end

local function clear(id)
    List[id] = nil
end

return {
    get = get,
    add = add,
    clear = clear,
    list = List,
}
