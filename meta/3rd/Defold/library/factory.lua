---Factory API documentation
---Functions for controlling factory components which are used to
---dynamically spawn game objects into the runtime.
---@class factory
factory = {}
---loaded
factory.STATUS_LOADED = nil
---loading
factory.STATUS_LOADING = nil
---unloaded
factory.STATUS_UNLOADED = nil
---The URL identifies which factory should create the game object.
---If the game object is created inside of the frame (e.g. from an update callback), the game object will be created instantly, but none of its component will be updated in the same frame.
---Properties defined in scripts in the created game object can be overridden through the properties-parameter below.
---See go.property for more information on script properties.
--- Calling factory.create <> on a factory that is marked as dynamic without having loaded resources
---using factory.load <> will synchronously load and create resources which may affect application performance.
---@param url string|hash|url # the factory that should create a game object.
---@param position vector3? # the position of the new game object, the position of the game object calling factory.create() is used by default, or if the value is nil.
---@param rotation quaternion? # the rotation of the new game object, the rotation of the game object calling factory.create() is used by default, or if the value is nil.
---@param properties table? # the properties defined in a script attached to the new game object.
---@param scale number|vector3? # the scale of the new game object (must be greater than 0), the scale of the game object containing the factory is used by default, or if the value is nil
---@return hash # the global id of the spawned game object
function factory.create(url, position, rotation, properties, scale) end

---This returns status of the factory.
---Calling this function when the factory is not marked as dynamic loading always returns
---factory.STATUS_LOADED.
---@param url string|hash|url? # the factory component to get status from
---@return constant # status of the factory component
function factory.get_status(url) end

---Resources are referenced by the factory component until the existing (parent) collection is destroyed or factory.unload is called.
---Calling this function when the factory is not marked as dynamic loading does nothing.
---@param url string|hash|url? # the factory component to load
---@param complete_function (fun(self: object, url: url, result: boolean))? # function to call when resources are loaded.
function factory.load(url, complete_function) end

---This decreases the reference count for each resource loaded with factory.load. If reference is zero, the resource is destroyed.
---Calling this function when the factory is not marked as dynamic loading does nothing.
---@param url string|hash|url? # the factory component to unload
function factory.unload(url) end




return factory