---Collection factory API documentation
---Functions for controlling collection factory components which are
---used to dynamically spawn collections into the runtime.
---@class collectionfactory
collectionfactory = {}
---loaded
collectionfactory.STATUS_LOADED = nil
---loading
collectionfactory.STATUS_LOADING = nil
---unloaded
collectionfactory.STATUS_UNLOADED = nil
---The URL identifies the collectionfactory component that should do the spawning.
---Spawning is instant, but spawned game objects get their first update calls the following frame. The supplied parameters for position, rotation and scale
---will be applied to the whole collection when spawned.
---Script properties in the created game objects can be overridden through
---a properties-parameter table. The table should contain game object ids
---(hash) as keys and property tables as values to be used when initiating each
---spawned game object.
---See go.property for more information on script properties.
---The function returns a table that contains a key for each game object
---id (hash), as addressed if the collection file was top level, and the
---corresponding spawned instance id (hash) as value with a unique path
---prefix added to each instance.
--- Calling collectionfactory.create <> create on a collection factory that is marked as dynamic without having loaded resources
---using collectionfactory.load <> will synchronously load and create resources which may affect application performance.
---@param url string|hash|url # the collection factory component to be used
---@param position vector3? # position to assign to the newly spawned collection
---@param rotation quaternion? # rotation to assign to the newly spawned collection
---@param properties table? # table of script properties to propagate to any new game object instances
---@param scale number? # uniform scaling to apply to the newly spawned collection (must be greater than 0).
---@return table # a table mapping the id:s from the collection to the new instance id:s
function collectionfactory.create(url, position, rotation, properties, scale) end

---This returns status of the collection factory.
---Calling this function when the factory is not marked as dynamic loading always returns COMP_COLLECTION_FACTORY_STATUS_LOADED.
---@param url string|hash|url? # the collection factory component to get status from
---@return constant # status of the collection factory component
function collectionfactory.get_status(url) end

---Resources loaded are referenced by the collection factory component until the existing (parent) collection is destroyed or collectionfactory.unload is called.
---Calling this function when the factory is not marked as dynamic loading does nothing.
---@param url string|hash|url? # the collection factory component to load
---@param complete_function (fun(self: object, url: url, result: boolean))? # function to call when resources are loaded.
function collectionfactory.load(url, complete_function) end

---This decreases the reference count for each resource loaded with collectionfactory.load. If reference is zero, the resource is destroyed.
---Calling this function when the factory is not marked as dynamic loading does nothing.
---@param url string|hash|url? # the collection factory component to unload
function collectionfactory.unload(url) end




return collectionfactory