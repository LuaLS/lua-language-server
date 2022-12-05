---Resource API documentation
---Functions and constants to access resources.
---@class resource
resource = {}
---LIVEUPDATE_BUNDLED_RESOURCE_MISMATCH
resource.LIVEUPDATE_BUNDLED_RESOURCE_MISMATCH = nil
---LIVEUPDATE_ENGINE_VERSION_MISMATCH
resource.LIVEUPDATE_ENGINE_VERSION_MISMATCH = nil
---LIVEUPDATE_FORMAT_ERROR
resource.LIVEUPDATE_FORMAT_ERROR = nil
---LIVEUPDATE_INVALID_RESOURCE
resource.LIVEUPDATE_INVALID_RESOURCE = nil
---LIVEUPDATE_OK
resource.LIVEUPDATE_OK = nil
---LIVEUPDATE_SCHEME_MISMATCH
resource.LIVEUPDATE_SCHEME_MISMATCH = nil
---LIVEUPDATE_SIGNATURE_MISMATCH
resource.LIVEUPDATE_SIGNATURE_MISMATCH = nil
---LIVEUPDATE_VERSION_MISMATCH
resource.LIVEUPDATE_VERSION_MISMATCH = nil
---luminance type texture format
resource.TEXTURE_FORMAT_LUMINANCE = nil
---RGB type texture format
resource.TEXTURE_FORMAT_RGB = nil
---RGBA type texture format
resource.TEXTURE_FORMAT_RGBA = nil
---2D texture type
resource.TEXTURE_TYPE_2D = nil
---Constructor-like function with two purposes:
---
---
--- * Load the specified resource as part of loading the script
---
--- * Return a hash to the run-time version of the resource
---
--- This function can only be called within go.property <> function calls.
---@param path string? # optional resource path string to the resource
---@return hash # a path hash to the binary version of the resource
function resource.atlas(path) end

---Constructor-like function with two purposes:
---
---
--- * Load the specified resource as part of loading the script
---
--- * Return a hash to the run-time version of the resource
---
--- This function can only be called within go.property <> function calls.
---@param path string? # optional resource path string to the resource
---@return hash # a path hash to the binary version of the resource
function resource.buffer(path) end

---Constructor-like function with two purposes:
---
---
--- * Load the specified resource as part of loading the script
---
--- * Return a hash to the run-time version of the resource
---
--- This function can only be called within go.property <> function calls.
---@param path string? # optional resource path string to the resource
---@return hash # a path hash to the binary version of the resource
function resource.font(path) end

---gets the buffer from a resource
---@param path hash|string # The path to the resource
---@return buffer # The resource buffer
function resource.get_buffer(path) end

---Return a reference to the Manifest that is currently loaded.
---@return number # reference to the Manifest that is currently loaded
function resource.get_current_manifest() end

---Gets the text metrics from a font
---@param url hash # the font to get the (unscaled) metrics from
---@param text string # text to measure
---@param options table? # A table containing parameters for the text. Supported entries:
---@return table # a table with the following fields:
function resource.get_text_metrics(url, text, options) end

---Is any liveupdate data mounted and currently in use?
---This can be used to determine if a new manifest or zip file should be downloaded.
---@return bool # true if a liveupdate archive (any format) has been loaded
function resource.is_using_liveupdate_data() end

---Loads the resource data for a specific resource.
---@param path string # The path to the resource
---@return buffer # Returns the buffer stored on disc
function resource.load(path) end

---Constructor-like function with two purposes:
---
---
--- * Load the specified resource as part of loading the script
---
--- * Return a hash to the run-time version of the resource
---
--- This function can only be called within go.property <> function calls.
---@param path string? # optional resource path string to the resource
---@return hash # a path hash to the binary version of the resource
function resource.material(path) end

---Sets the resource data for a specific resource
---@param path string|hash # The path to the resource
---@param buffer buffer # The buffer of precreated data, suitable for the intended resource type
function resource.set(path, buffer) end

---sets the buffer of a resource
---@param path hash|string # The path to the resource
---@param buffer buffer # The resource buffer
function resource.set_buffer(path, buffer) end

---Update internal sound resource (wavc/oggc) with new data
---@param path hash|string # The path to the resource
---@param buffer string # A lua string containing the binary sound data
function resource.set_sound(path, buffer) end

---Sets the pixel data for a specific texture.
---@param path hash|string # The path to the resource
---@param table table # A table containing info about the texture. Supported entries:
---@param buffer buffer # The buffer of precreated pixel data  Currently, only 1 mipmap is generated.
function resource.set_texture(path, table, buffer) end

---Stores a zip file and uses it for live update content. The contents of the
---zip file will be verified against the manifest to ensure file integrity.
---It is possible to opt out of the resource verification using an option passed
---to this function.
---The path is stored in the (internal) live update location.
---@param path string # the path to the original file on disc
---@param callback fun(self: object, status: constant) # the callback function executed after the storage has completed
---@param options table? # optional table with extra parameters. Supported entries:
function resource.store_archive(path, callback, options) end

---Create a new manifest from a buffer. The created manifest is verified
---by ensuring that the manifest was signed using the bundled public/private
---key-pair during the bundle process and that the manifest supports the current
---running engine version. Once the manifest is verified it is stored on device.
---The next time the engine starts (or is rebooted) it will look for the stored
---manifest before loading resources. Storing a new manifest allows the
---developer to update the game, modify existing resources, or add new
---resources to the game through LiveUpdate.
---@param manifest_buffer string # the binary data that represents the manifest
---@param callback fun(self: object, status: constant) # the callback function executed once the engine has attempted to store the manifest.
function resource.store_manifest(manifest_buffer, callback) end

---add a resource to the data archive and runtime index. The resource will be verified
---internally before being added to the data archive.
---@param manifest_reference number # The manifest to check against.
---@param data string # The resource data that should be stored.
---@param hexdigest string # The expected hash for the resource, retrieved through collectionproxy.missing_resources.
---@param callback fun(self: object, hexdigest: string, status: boolean) # The callback function that is executed once the engine has been attempted to store the resource.
function resource.store_resource(manifest_reference, data, hexdigest, callback) end

---Constructor-like function with two purposes:
---
---
--- * Load the specified resource as part of loading the script
---
--- * Return a hash to the run-time version of the resource
---
--- This function can only be called within go.property <> function calls.
---@param path string? # optional resource path string to the resource
---@return hash # a path hash to the binary version of the resource
function resource.texture(path) end

---Constructor-like function with two purposes:
---
---
--- * Load the specified resource as part of loading the script
---
--- * Return a hash to the run-time version of the resource
---
--- This function can only be called within go.property <> function calls.
---@param path string? # optional resource path string to the resource
---@return hash # a path hash to the binary version of the resource
function resource.tile_source(path) end




return resource