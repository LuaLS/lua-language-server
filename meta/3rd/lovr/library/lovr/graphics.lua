---@meta

---
---The graphics module renders graphics and performs computation using the GPU.
---
---@class lovr.graphics
lovr.graphics = {}

---
---TODO
---
---@param stage lovr.ShaderStage # TODO
---@param source lovr.ShaderSource # TODO
---@return lovr.Blob bytecode # TODO
function lovr.graphics.compileShader(stage, source) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@return number r # The red component of the background color.
---@return number g # The green component of the background color.
---@return number b # The blue component of the background color.
---@return number a # The alpha component of the background color.
function lovr.graphics.getBackgroundColor() end

---
---Creates a temporary Buffer.
---
---
---### NOTE:
---The format table can contain a list of `FieldType`s or a list of tables to provide extra information about each field.
---
---Each inner table has the following keys:
---
---- `type` is the `FieldType` of the field and is required.
---- `offset` is the byte offset of the field.
---
---Any fields with a `nil` offset will be placed next
---  to each other sequentially in memory, subject to any padding required by the Buffer's layout.
---  In practice this means that you probably want to provide an `offset` for either all of the
---  fields or none of them.
---- `location` is the vertex attribute location of each field.
---
---This is used to match up each
---  field with an attribute declared in a shader, and doesn't have any purpose when binding the
---  buffer as a uniform or storage buffer.
---
---Any fields with a `nil` location will use an
---  autoincrementing location starting at zero.
---
---Named locations are not currently supported, but
---  may be added in the future.
---
---If no table or Blob is used to define the initial Buffer contents, its data will be undefined.
---
---There is currently a max of 16 fields.
---
---@overload fun(data: table, type: lovr.FieldType):lovr.Buffer
---@overload fun(length: number, format: table):lovr.Buffer
---@overload fun(data: table, format: table):lovr.Buffer
---@overload fun(blob: lovr.Blob, type: lovr.FieldType):lovr.Buffer
---@overload fun(blob: lovr.Blob, format: table):lovr.Buffer
---@param length number # The length of the Buffer.
---@param type lovr.FieldType # The type of each item in the Buffer.
---@return lovr.Buffer buffer # The new Buffer.
function lovr.graphics.getBuffer(length, type) end

---
---Returns the default Font.
---
---The default font is Varela Round, created at 32px with a spread value of `4.0`.
---
---It's used by `Pass:text` if no Font is provided.
---
---@return lovr.Font font # The default Font object.
function lovr.graphics.getDefaultFont() end

---
---Returns information about the graphics device and driver.
---
---
---### NOTE:
---The device and vendor ID numbers will usually be PCI IDs, which are standardized numbers consisting of 4 hex digits.
---
---Various online databases and system utilities can be used to look up these numbers.
---
---Here are some example vendor IDs for a few popular GPU manufacturers:
---
---<table>
---  <thead>
---    <tr>
---      <td>ID</td>
---      <td>Vendor</td>
---    </tr>
---  </thead>
---  <tbody>
---    <tr>
---      <td><code>0x1002</code></td>
---      <td>Advanced Micro Devices, Inc.</td>
---    </tr>
---    <tr>
---      <td><code>0x8086</code></td>
---      <td>Intel Corporation</td>
---    </tr>
---    <tr>
---      <td><code>0x10de</code></td>
---      <td>NVIDIA Corporation</td>
---    </tr>
---  </tbody> </table>
---
---It is not currently possible to get the version of the driver, although this could be added.
---
---Regarding multiple GPUs: If OpenXR is enabled, the OpenXR runtime has control over which GPU is used, which ensures best compatibility with the VR headset.
---
---Otherwise, the "first" GPU returned by the renderer will be used.
---
---There is currently no other way to pick a GPU to use.
---
---@return {id: number, vendor: number, name: string, renderer: string, subgroupSize: number, discrete: boolean} device # nil
function lovr.graphics.getDevice() end

---
---Returns a table indicating which features are supported by the GPU.
---
---@return {textureBC: boolean, textureASTC: boolean, wireframe: boolean, depthClamp: boolean, indirectDrawFirstInstance: boolean, float64: boolean, int64: boolean, int16: boolean} features # 
function lovr.graphics.getFeatures() end

---
---Returns limits of the current GPU.
---
---
---### NOTE:
---The limit ranges are as follows:
---
---<table>
---  <thead>
---    <tr>
---      <td>Limit</td>
---      <td>Minimum</td>
---      <td>Maximum</td>
---    </tr>
---  </thead>
---  <tbody>
---    <tr>
---      <td><code>textureSize2D</code></td>
---      <td>4096</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>textureSize3D</code></td>
---      <td>256</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>textureSizeCube</code></td>
---      <td>4096</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>textureLayers</code></td>
---      <td>256</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>renderSize</code></td>
---      <td>{ 4096, 4096, 6 }</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>uniformBuffersPerStage</code></td>
---      <td>9</td>
---      <td>32*</td>
---    </tr>
---    <tr>
---      <td><code>storageBuffersPerStage</code></td>
---      <td>4</td>
---      <td>32*</td>
---    </tr>
---    <tr>
---      <td><code>sampledTexturesPerStage</code></td>
---      <td>32</td>
---      <td>32*</td>
---    </tr>
---    <tr>
---      <td><code>storageTexturesPerStage</code></td>
---      <td>4</td>
---      <td>32*</td>
---    </tr>
---    <tr>
---      <td><code>samplersPerStage</code></td>
---      <td>15</td>
---      <td>32*</td>
---    </tr>
---    <tr>
---      <td><code>resourcesPerShader</code></td>
---      <td>32</td>
---      <td>32*</td>
---    </tr>
---    <tr>
---      <td><code>uniformBufferRange</code></td>
---      <td>65536</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>storageBufferRange</code></td>
---      <td>134217728 (128MB)</td>
---      <td>1073741824 (1GB)*</td>
---    </tr>
---    <tr>
---      <td><code>uniformBufferAlign</code></td>
---      <td></td>
---      <td>256</td>
---    </tr>
---    <tr>
---      <td><code>storageBufferAlign</code></td>
---      <td></td>
---      <td>64</td>
---    </tr>
---    <tr>
---      <td><code>vertexAttributes</code></td>
---      <td>16</td>
---      <td>16*</td>
---    </tr>
---    <tr>
---      <td><code>vertexBufferStride</code></td>
---      <td>2048</td>
---      <td>65535*</td>
---    </tr>
---    <tr>
---      <td><code>vertexShaderOutputs</code></td>
---      <td>64</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>clipDistances</code></td>
---      <td>0</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>cullDistances</code></td>
---      <td>0</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>clipAndCullDistances</code></td>
---      <td>0</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>computeDispatchCount</code></td>
---      <td>{ 65536, 65536, 65536 }</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>computeWorkgroupSize</code></td>
---      <td>{ 128, 128, 64 }</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>computeWorkgroupVolume</code></td>
---      <td>128</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>computeSharedMemory</code></td>
---      <td>16384 (16KB)</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>pushConstantSize</code></td>
---      <td>128</td>
---      <td>256*</td>
---    </tr>
---    <tr>
---      <td><code>indirectDrawCount</code></td>
---      <td>1</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>instances</code></td>
---      <td>134217727</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>anisotropy</code></td>
---      <td>0.0</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td><code>pointSize</code></td>
---      <td>1.0</td>
---      <td></td>
---    </tr>
---  </tbody> </table>
---
---Note: in the table above, `*` means that LÖVR itself is imposing a cap on the limit, instead of the GPU.
---
---@return {textureSize2D: number, textureSize3D: number, textureSizeCube: number, textureLayers: number, renderSize: table, uniformBuffersPerStage: number, storageBuffersPerStage: number, sampledTexturesPerStage: number, storageTexturesPerStage: number, samplersPerStage: number, resourcesPerShader: number, uniformBufferRange: number, storageBufferRange: number, uniformBufferAlign: number, storageBufferAlign: number, vertexAttributes: number, vertexBufferStride: number, vertexShaderOutputs: number, clipDistances: number, cullDistances: number, clipAndCullDistances: number, workgroupCount: table, workgroupSize: table, totalWorkgroupSize: number, computeSharedMemory: number, shaderConstantSize: number, indirectDrawCount: number, instances: number, anisotropy: number, pointSize: number} limits # 
function lovr.graphics.getLimits() end

---
---TODO
---
---@overload fun(type: lovr.PassType, texture: lovr.Texture):lovr.Pass
---@overload fun(type: lovr.PassType, canvas: table):lovr.Pass
---@param type lovr.PassType # TODO
---@return lovr.Pass pass # The new Pass.
function lovr.graphics.getPass(type) end

---
---TODO
---
---@return {memory: {total: number, buffer: number, texture: number}, objects: {buffers: number, textures: number, samplers: number, shaders: number}, frame: {scratchMemory: number, renderPasses: number, computePasses: number, transferPasses: number, pipelineBinds: number, bundleBinds: number, drawCalls: number, dispatches: number, workgroups: number, copies: number}, internal: {blocks: number, canvases: number, pipelines: number, layouts: number, bunches: number}} stats # Graphics statistics.
function lovr.graphics.getStats() end

---
---Returns the window pass.
---
---This is a builtin render `Pass` object that renders to the desktop window texture.
---
---If the desktop window was not open when the graphics module was initialized, this function will return `nil`.
---
---
---### NOTE:
---- TODO is the same pass always returned
---- TODO does the texture change
---- TODO what settings does the Pass use (incl conf.lua)
---- TODO is it reset
---
---@return lovr.Pass pass # The window pass, or `nil` if there is no window.
function lovr.graphics.getWindowPass() end

---
---TODO
---
---@param format lovr.TextureFormat # TODO
---@return boolean supported # TODO
function lovr.graphics.isFormatSupported(format) end

---
---Creates a Buffer.
---
---
---### NOTE:
---The format table can contain a list of `FieldType`s or a list of tables to provide extra information about each field.
---
---Each inner table has the following keys:
---
---- `type` is the `FieldType` of the field and is required.
---- `offset` is the byte offset of the field.
---
---Any fields with a `nil` offset will be placed next
---  to each other sequentially in memory, subject to any padding required by the Buffer's layout.
---  In practice this means that you probably want to provide an `offset` for either all of the
---  fields or none of them.
---- `location` is the vertex attribute location of each field.
---
---This is used to match up each
---  field with an attribute declared in a shader, and doesn't have any purpose when binding the
---  buffer as a uniform or storage buffer.
---
---Any fields with a `nil` location will use an
---  autoincrementing location starting at zero.
---
---Named locations are not currently supported, but
---  may be added in the future.
---
---If no table or Blob is used to define the initial Buffer contents, its data will be undefined.
---
---There is currently a max of 16 fields.
---
---@overload fun(data: table, type: lovr.FieldType):lovr.Buffer
---@overload fun(length: number, format: table):lovr.Buffer
---@overload fun(data: table, format: table):lovr.Buffer
---@overload fun(blob: lovr.Blob, type: lovr.FieldType):lovr.Buffer
---@overload fun(blob: lovr.Blob, format: table):lovr.Buffer
---@param length number # The length of the Buffer.
---@param type lovr.FieldType # The type of each item in the Buffer.
---@return lovr.Buffer buffer # The new Buffer.
function lovr.graphics.newBuffer(length, type) end

---
---TODO
---
---@overload fun(blob: lovr.Blob, size?: number, spread?: number):lovr.Font
---@overload fun(size?: number, spread?: number):lovr.Font
---@overload fun(rasterizer: lovr.Rasterizer, spread?: number):lovr.Font
---@param filename string # TODO
---@param size? number # TODO
---@param spread? number # TODO
---@return lovr.Font font # The new Font.
function lovr.graphics.newFont(filename, size, spread) end

---
---TODO
---
---@overload fun(options: table):lovr.Material
---@param texture lovr.Texture # TODO
---@return lovr.Material material # TODO
function lovr.graphics.newMaterial(texture) end

---
---TODO
---
---@overload fun(blob: lovr.Blob, options: table):lovr.Model
---@overload fun(modelData: lovr.ModelData):lovr.Model
---@param filename string # TODO
---@param options {mipmaps: boolean} # Model options.
---@return lovr.Model model # The new Model.
function lovr.graphics.newModel(filename, options) end

---
---TODO
---
---@param options {filter: table, wrap: table, compare: lovr.CompareMode, anisotropy: number, mipmaprange: table} # TODO
---@return lovr.Sampler sampler # TODO
function lovr.graphics.newSampler(options) end

---
---TODO
---
---@overload fun(compute: lovr.ShaderSource, options: table):lovr.Shader
---@param vertex lovr.ShaderSource # TODO
---@param fragment lovr.ShaderSource # TODO
---@param options {flags: table, label: string} # Shader options.
---@return lovr.Shader shader # TODO
function lovr.graphics.newShader(vertex, fragment, options) end

---
---TODO
---
---@param type lovr.TallyType # The type of the Tally, which controls what "thing" it measures.
---@param count number # The number of slots in the Tally.  Each slot performs one measurement.
---@param views? number # Tally objects with the `time` type can only be used in render passes with a certain number of views.  This is ignored for other types of tallies.
---@return lovr.Tally tally # The new Tally.
function lovr.graphics.newTally(type, count, views) end

---
---TODO
---
---@overload fun(width: number, height: number, options: table):lovr.Texture
---@overload fun(width: number, height: number, depth: number, options: table):lovr.Texture
---@overload fun(image: string, options: table):lovr.Texture
---@overload fun(images: table, options: table):lovr.Texture
---@param filename string # TODO
---@param options {type: lovr.TextureType, format: lovr.TextureFormat, linear: boolean, samples: number, mipmaps: number, usage: table, label: string} # Texture options.
---@return lovr.Texture texture # TODO
function lovr.graphics.newTexture(filename, options) end

---
---Presents the window texture to the desktop window.
---
---This function is called automatically by the default implementation of `lovr.run`, so it normally does not need to be called.
---
---
---### NOTE:
---This should be called after submitting the window pass (`lovr.graphics.getWindowPass`).
---
---If the window texture has not been rendered to since the last present, this function does nothing.
---
function lovr.graphics.present() end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(hex: number, a?: number)
---@overload fun(color: table)
---@param r number # The red component of the background color.
---@param g number # The green component of the background color.
---@param b number # The blue component of the background color.
---@param a? number # The alpha component of the background color.
function lovr.graphics.setBackgroundColor(r, g, b, a) end

---
---TODO
---
---@overload fun(t: table):boolean
---@vararg lovr.Pass # The pass objects to submit.  Falsy values will be skipped.
---@return boolean true # Always returns true, for convenience when returning from `lovr.draw`.
function lovr.graphics.submit(...) end

---
---TODO
---
function lovr.graphics.wait() end

---
---A Buffer is a block of GPU memory.
---
---Buffers are similar to Lua tables or arrays: they have a length and store a list of values.
---
---The length of a Buffer and its format (the type of each value) are declared upfront and can't be changed.
---
---Each value of a Buffer consists of one or more fields, and each field has a type.
---
---For example, if a Buffer is used to store vertices, each value might store 3 fields for the position, normal vector, and UV coordinates of a vertex.
---
---Buffers are commonly used for:
---
---- Mesh data: Buffers hold the data that define the vertices in a mesh. Buffers also store the
---  vertex indices of a mesh, which define the order the vertices are connected together into
---  triangles. These are often called vertex buffers and index buffers.
---- Shader data: Buffers can be bound to a Shader, letting the Shader read arbitrary data. For
---  example, Lua code could create a Buffer with the positions and colors of all the lights in a
---  scene, which a Shader can use to do lighting calculations.
---- Compute: Compute shaders can write data to Buffers.
---
---This GPU-generated data can be used in
---  later rendering work or sent back to Lua.
---- Indirect: Indirect rendering is an advanced technique where instructions for rendering work
---  are recorded to a Buffer (potentially by a compute shader) and later drawn.
---
---There are two types of Buffers:
---
---- **Temporary** buffers are very inexpensive to create, and writing to them from Lua is fast.
---  However, they become invalid at the end of `lovr.draw` (i.e. when `lovr.graphics.submit` is
---  called).
---
---The GPU is slightly slower at accessing data from temporary buffers, and compute
---  shaders can not write to them.
---
---They are designed for storing data that changes every frame.
---- **Permanent** buffers are more expensive to create, and updating their contents requires a
---  transfer from CPU memory to VRAM.
---
---They act like normal LÖVR objects and don't need to be
---  recreated every frame.
---
---They often have faster performance when used by the GPU, and compute
---  shaders can write to them.
---
---They are great for large pieces of data that are initialized once
---  at load time, or data that is updated infrequently.
---
---@class lovr.Buffer
local Buffer = {}

---
---Clears some or all of the data in the Buffer to zero.
---
---This is supported for both temporary and permanent Buffers.
---
---Permanent Buffers can also be cleared in a transfer pass using `Pass:clear`.
---
---
---### NOTE:
---Clearing a permanent buffer requires the byte offset and byte count of the cleared range to be a multiple of 4.
---
---This will usually be true for most field types.
---
---@param index? number # The index of the first item to clear.
---@param count? number # The number of items to clear.  If `nil`, clears as many items as possible.
function Buffer:clear(index, count) end

---
---Returns the format of the Buffer.
---
---This is the list of fields that comprise each item in the buffer.
---
---Each field has a type, byte offset, and vertex attribute location.
---
---@return table format # The format of the Buffer.
function Buffer:getFormat() end

---
---Returns the length of the Buffer.
---
---@return number length # The length of the Buffer.
function Buffer:getLength() end

---
---Returns a raw pointer to the Buffer's memory as a lightuserdata, intended for use with the LuaJIT ffi or for passing to C libraries.
---
---This is only available for temporary buffers, and as such the pointer is only valid until `lovr.graphics.submit` is called.
---
---@return lightuserdata pointer # A pointer to the Buffer's memory.
function Buffer:getPointer() end

---
---Returns the size of the Buffer, in bytes.
---
---This is the same as `length * stride`.
---
---@return number size # The size of the Buffer, in bytes.
function Buffer:getSize() end

---
---Returns the distance between each item in the Buffer, in bytes.
---
---
---### NOTE:
---When a Buffer is created, the stride can be set explicitly, otherwise it will be automatically computed based on the fields in the Buffer.
---
---Strides can not be zero, and can not be smaller than the size of a single item.
---
---To work around this, bind the Buffer as a storage buffer and fetch data from the buffer manually.
---
---@return number stride # The stride of the Buffer, in bytes.
function Buffer:getStride() end

---
---Returns whether the Buffer is temporary.
---
---@return boolean temporary # Whether the Buffer is temporary.
function Buffer:isTemporary() end

---
---Changes data in the Buffer using a table or a Blob.
---
---This is supported for both temporary and permanent buffers.
---
---All passes submitted to the GPU will use the new data.
---
---It is also possible to change the data in permanent buffers inside of a transfer pass using `Pass:copy`.
---
---Using a transfer pass allows the copy to happen after other passes in the frame.
---
---
---### NOTE:
---When using a table, the table can contain a nested table for each value in the Buffer, or it can be a flat list of field component values.
---
---It is not possible to mix both nested tables and flat values.
---
---For each item updated, components of each field in the item (according to the Buffer's format) are read from either the nested subtable or the table itself.
---
---A single number can be used to update a field with a scalar type.
---
---Multiple numbers or a `lovr.math` vector can be used to update a field with a vector or mat4 type.
---
---Multiple numbers can be used to update mat2 and mat3 fields.
---
---When updating normalized field types, components read from the table will be clamped to the normalized range ([0,1] or [-1,1]).
---
---In the Buffer, each field is written at its byte offset according to the Buffer's format, and subsequent items are separated by the byte stride of the Buffer.
---
---Any missing components for an updated field will be set to zero.
---
---@overload fun(self: lovr.Buffer, blob: lovr.Blob, sourceOffset?: number, destinationOffset?: number, size?: number)
---@param data table # A flat or nested table of items to copy to the Buffer (see notes for format).
---@param sourceIndex? number # The index in the table to copy from.
---@param destinationIndex? number # The index of the first value in the Buffer to update.
---@param count? number # The number of values to update.  `nil` will copy as many items as possible, based on the lengths of the source and destination.
function Buffer:setData(data, sourceIndex, destinationIndex, count) end

---
---TODO
---
---@class lovr.Font
local Font = {}

---
---TODO
---
---@return number ascent # TODO
function Font:getAscent() end

---
---TODO
---
---@return number descent # TODO
function Font:getDescent() end

---
---TODO
---
---@return number height # TODO
function Font:getHeight() end

---
---TODO
---
---@param first lovr.Codepoint # TODO
---@param second lovr.Codepoint # TODO
---@return number kerning # TODO
function Font:getKerning(first, second) end

---
---TODO
---
---@return number spacing # TODO
function Font:getLineSpacing() end

---
---TODO
---
---@param text lovr.Text # TODO
---@param wrap number # TODO
---@return table lines # TODO
function Font:getLines(text, wrap) end

---
---TODO
---
---@return number density # TODO
function Font:getPixelDensity() end

---
---TODO
---
---@return lovr.Rasterizer rasterizer # The Rasterizer.
function Font:getRasterizer() end

---
---Returns a table of vertices for a piece of text, along with a Material to use when rendering it. The Material may change over time if the Font's texture atlas needs to be resized to make room for more glyphs.
---
---
---### NOTE:
---Each vertex is a table of 4 floating point numbers with the following data:
---
---    { x, y, u, v }
---
---These could be placed in a vertex buffer using the following buffer format:
---
---    { 'vec2:VertexPosition', 'vec2:VertexUV' }
---
---@param text lovr.Text # TODO
---@param wrap number # TODO
---@param halign lovr.HorizontalAlign # TODO
---@param valign lovr.VerticalAlign # TODO
---@return table vertices # The table of vertices.  See below for the format of each vertex.
---@return lovr.Material material # A Material to use when rendering the vertices.
function Font:getVertices(text, wrap, halign, valign) end

---
---TODO
---
---@param text lovr.Text # TODO
---@return number width # TODO
function Font:getWidth(text) end

---
---TODO
---
---@param spacing number # TODO
function Font:setLineSpacing(spacing) end

---
---TODO
---
---@param density number # TODO
function Font:setPixelDensity(density) end

---
---TODO
---
---@class lovr.Material
local Material = {}

---
---Returns the properties of the Material in a table.
---
---@return table properties # The Material properties.
function Material:getProperties() end

---
---Sets a texture for a Material.
---
---Several predefined `MaterialTexture`s are supported.
---
---Any texture that is `nil` will use a single white pixel as a fallback.
---
---
---### NOTE:
---Textures must have a `TextureType` of `2d` to be used with Materials.
---
---@overload fun(self: lovr.Material, texture: lovr.Texture)
---@param textureType? lovr.MaterialTexture # The type of texture to set.
---@param texture lovr.Texture # The texture to apply, or `nil` to use the default.
function Material:setTexture(textureType, texture) end

---
---TODO
---
---@class lovr.Model
local Model = {}

---
---TODO
---
---
---### NOTE:
---TODO What happens if the timestamp is before the first keyframe? TODO Does it loop?
---
---@overload fun(self: lovr.Model, index: number, time: number, blend?: number)
---@param name string # The name of an animation in the model file.
---@param time number # The timestamp to evaluate the keyframes at, in seconds.
---@param blend? number # How much of the animation's pose to blend into the nodes, from 0 to 1.
function Model:animate(name, time, blend) end

---
---Returns the number of animations in the Model.
---
---@return number count # The number of animations in the Model.
function Model:getAnimationCount() end

---
---TODO
---
---
---### NOTE:
---TODO how is duration calculated?
---
---@overload fun(self: lovr.Model, name: string):number
---@param index number # The animation index.
---@return number duration # TODO
function Model:getAnimationDuration(index) end

---
---TODO
---
---@param index number # TODO
---@return string name # The name of the animation.
function Model:getAnimationName(index) end

---
---Returns the 6 values of the Model's axis-aligned bounding box.
---
---@return number minx # The minimum x coordinate of the vertices in the Model.
---@return number maxx # The maximum x coordinate of the vertices in the Model.
---@return number miny # The minimum y coordinate of the vertices in the Model.
---@return number maxy # The maximum y coordinate of the vertices in the Model.
---@return number minz # The minimum z coordinate of the vertices in the Model.
---@return number maxz # The maximum z coordinate of the vertices in the Model.
function Model:getBoundingBox() end

---
---Returns a sphere approximately enclosing the vertices in the Model.
---
---@return number x # The x coordinate of the position of the sphere.
---@return number y # The y coordinate of the position of the sphere.
---@return number z # The z coordinate of the position of the sphere.
---@return number radius # The radius of the bounding sphere.
function Model:getBoundingSphere() end

---
---Returns the center of the Model's axis-aligned bounding box, relative to the Model's origin.
---
---@return number x # The x offset of the center of the bounding box.
---@return number y # The y offset of the center of the bounding box.
---@return number z # The z offset of the center of the bounding box.
function Model:getCenter() end

---
---Returns the ModelData this Model was created from.
---
---@return lovr.ModelData data # The ModelData.
function Model:getData() end

---
---Returns the depth of the Model, computed from its axis-aligned bounding box.
---
---@return number depth # The depth of the Model.
function Model:getDepth() end

---
---Returns the width, height, and depth of the Model, computed from its axis-aligned bounding box.
---
---@return number width # The width of the Model.
---@return number height # The height of the Model.
---@return number depth # The depth of the Model.
function Model:getDimensions() end

---
---Returns the height of the Model, computed from its axis-aligned bounding box.
---
---@return number height # The height of the Model.
function Model:getHeight() end

---
---TODO
---
---@return lovr.Buffer buffer # TODO
function Model:getIndexBuffer() end

---
---TODO
---
---@overload fun(self: lovr.Model, index: number):lovr.Material
---@param name string # The name of the Material to return.
---@return lovr.Material material # The material.
function Model:getMaterial(name) end

---
---Returns the number of materials in the Model.
---
---@return number count # The number of materials in the Model.
function Model:getMaterialCount() end

---
---TODO
---
---@param index number # TODO
---@return string name # The name of the material.
function Model:getMaterialName(index) end

---
---Returns extra information stored in the model file.
---
---Currently this is only implemented for glTF models and returns the JSON string from the glTF or glb file.
---
---The metadata can be used to get application-specific data or add support for glTF extensions not supported by LÖVR.
---
---@return string metadata # The metadata from the model file.
function Model:getMetadata() end

---
---Given a parent node, this function returns a table with the indices of its children.
---
---
---### NOTE:
---If the node does not have any children, this function returns an empty table.
---
---@overload fun(self: lovr.Model, name: string):table
---@param index number # The index of the parent node.
---@return table children # A table containing a node index for each child of the node.
function Model:getNodeChildren(index) end

---
---Returns the number of nodes in the model.
---
---@return number count # The number of nodes in the model.
function Model:getNodeCount() end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, index: number):lovr.MeshMode, lovr.Material, number, number, number
---@param node number # The index of the node.
---@param index number # The index of the draw.
---@return lovr.MeshMode mode # Whether the vertices are points, lines, or triangles.
---@return lovr.Material material # The Material used by the draw.
---@return number start # The offset of the first vertex in the draw.
---@return number count # The number of vertices in the draw.
---@return number base # The base vertex of the draw (added to each instance value), or nil if the draw does not use an index buffer.
function Model:getNodeDraw(node, index) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string):number
---@param index number # The index of a node.
---@return number count # The number of draws in the node.
function Model:getNodeDrawCount(index) end

---
---TODO
---
---@param index number # TODO
---@return string name # TODO
function Model:getNodeName(index) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, origin?: lovr.OriginType):number, number, number, number
---@param index number # The index of the node.
---@param origin? lovr.OriginType # Whether the orientation should be returned relative to the root node or the node's parent.
---@return number angle # The number of radians the node is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Model:getNodeOrientation(index, origin) end

---
---Given a child node, this function returns the index of its parent.
---
---@overload fun(self: lovr.Model, name: string):number
---@param index number # The index of the child node.
---@return number parent # The index of the parent.
function Model:getNodeParent(index) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, origin?: lovr.OriginType):number, number, number, number, number, number, number
---@param index number # The index of a node.
---@param origin? lovr.OriginType # Whether the pose should be returned relative to the root node or the node's parent.
---@return number x # The x position of the node.
---@return number y # The y position of the node.
---@return number z # The z position of the node.
---@return number angle # The number of radians the node is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Model:getNodePose(index, origin) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, space?: lovr.OriginType):number, number, number
---@param index number # The index of the node.
---@param space? lovr.OriginType # Whether the position should be returned relative to the root node or the node's parent.
---@return number x # The x coordinate.
---@return number y # The y coordinate.
---@return number z # The z coordinate.
function Model:getNodePosition(index, space) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, origin?: lovr.OriginType):number, number, number
---@param index number # The index of the node.
---@param origin? lovr.OriginType # Whether the scale should be returned relative to the root node or the node's parent.
---@return number x # The x scale.
---@return number y # The y scale.
---@return number z # The z scale.
function Model:getNodeScale(index, origin) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, origin?: lovr.OriginType):number, number, number, number, number, number, number, number, number, number
---@param index number # The index of a node.
---@param origin? lovr.OriginType # Whether the transform should be returned relative to the root node or the node's parent.
---@return number x # The x position of the node.
---@return number y # The y position of the node.
---@return number z # The z position of the node.
---@return number sx # The x scale of the node.
---@return number sy # The y scale of the node.
---@return number sz # The z scale of the node.
---@return number angle # The number of radians the node is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Model:getNodeTransform(index, origin) end

---
---Returns the index of the model's root node.
---
---@return number root # The index of the root node.
function Model:getRootNode() end

---
---TODO
---
---@return lovr.Texture texture # TODO
function Model:getTexture() end

---
---Returns the number of textures in the Model.
---
---@return number count # The number of textures in the Model.
function Model:getTextureCount() end

---
---Returns the total number of triangles in the Model.
---
---
---### NOTE:
---This isn't always related to the length of the vertex buffer, since a mesh in the Model could be drawn by multiple nodes.
---
---@return number count # The total number of triangles in the Model.
function Model:getTriangleCount() end

---
---Returns 2 tables containing mesh data for the Model.
---
---The first table is a list of vertex positions and contains 3 numbers for the x, y, and z coordinate of each vertex.
---
---The second table is a list of triangles and contains 1-based indices into the first table representing the first, second, and third vertices that make up each triangle.
---
---The vertex positions will be affected by node transforms.
---
---
---### NOTE:
---After this function is called on a Model once, the result is cached (in its ModelData).
---
---@return table vertices # The triangle vertex positions, returned as a flat (non-nested) table of numbers.  The position of each vertex is given as an x, y, and z coordinate.
---@return table indices # The vertex indices.  Every 3 indices describes a triangle.
function Model:getTriangles() end

---
---TODO
---
---@return lovr.Buffer buffer # TODO
function Model:getVertexBuffer() end

---
---Returns the total vertex count of the Model.
---
---
---### NOTE:
---This isn't always the same as the length of the vertex buffer, since a mesh in the Model could be drawn by multiple nodes.
---
---@return number count # The total number of vertices.
function Model:getVertexCount() end

---
---Returns the width of the Model, computed from its axis-aligned bounding box.
---
---@return number width # The width of the Model.
function Model:getWidth() end

---
---TODO
---
---
---### NOTE:
---TODO it's computed as skinCount TODO it's different from animationCount
---
---@return boolean jointed # Whether the animation uses joints for skeletal animation.
function Model:hasJoints() end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, orientation: lovr.rotation, blend?: number)
---@param index number # The index of the node.
---@param orientation lovr.rotation # The target orientation.
---@param blend? number # A number from 0 to 1 indicating how much of the target orientation to blend in.  A value of 0 will not change the node's orientation at all, whereas 1 will fully blend to the target orientation.
function Model:setNodeOrientation(index, orientation, blend) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, position: lovr.vector3, orientation: lovr.rotation, blend?: number)
---@param index number # The index of the node.
---@param position lovr.vector3 # The target position.
---@param orientation lovr.rotation # The target orientation.
---@param blend? number # A number from 0 to 1 indicating how much of the target pose to blend in.  A value of 0 will not change the node's pose at all, whereas 1 will fully blend to the target pose.
function Model:setNodePose(index, position, orientation, blend) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, position: lovr.vector3, blend?: number)
---@param index number # The index of the node.
---@param position lovr.vector3 # The target position.
---@param blend? number # A number from 0 to 1 indicating how much of the target position to blend in.  A value of 0 will not change the node's position at all, whereas 1 will fully blend to the target position.
function Model:setNodePosition(index, position, blend) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, scale: lovr.vector3, blend?: number)
---@param index number # The index of the node.
---@param scale lovr.vector3 # The target scale.
---@param blend? number # A number from 0 to 1 indicating how much of the target scale to blend in.  A value of 0 will not change the node's scale at all, whereas 1 will fully blend to the target scale.
function Model:setNodeScale(index, scale, blend) end

---
---TODO
---
---@overload fun(self: lovr.Model, name: string, transform: lovr.transform, blend?: number)
---@param index number # The index of the node.
---@param transform lovr.transform # The target transform.
---@param blend? number # A number from 0 to 1 indicating how much of the target transform to blend in.  A value of 0 will not change the node's transform at all, whereas 1 will fully blend to the target transform.
function Model:setNodeTransform(index, transform, blend) end

---
---TODO
---
---@class lovr.Pass
local Pass = {}

---
---TODO
---
---@param src lovr.Texture # TODO
---@param dst lovr.Texture # TODO
---@param srcx? number # TODO
---@param srcy? number # TODO
---@param srcz? number # TODO
---@param dstx? number # TODO
---@param dsty? number # TODO
---@param dstz? number # TODO
---@param srcw? number # TODO
---@param srch? number # TODO
---@param srcd? number # TODO
---@param dstw? number # TODO
---@param dsth? number # TODO
---@param dstd? number # TODO
---@param srclevel? number # TODO
---@param dstlevel? number # TODO
function Pass:blit(src, dst, srcx, srcy, srcz, dstx, dsty, dstz, srcw, srch, srcd, dstw, dsth, dstd, srclevel, dstlevel) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param transform lovr.Transform3 # The transform to apply to the box.
---@param style? lovr.DrawStyle # Whether the box should be drawn filled or outlined.
function Pass:box(transform, style) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, p1: lovr.Point3, p2: lovr.Point3, segments?: number)
---@param transform lovr.TransformXY2 # The transform to apply to the capsule.  The x and y scale is the radius, the z scale is the length.
---@param segments? number # The number of circular segments to render.
function Pass:capsule(transform, segments) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param transform lovr.Transform # The transform to apply to the circle.
---@param style? lovr.DrawStyle # Whether the circle should be filled or outlined.
---@param angle1? number # The angle of the beginning of the arc.
---@param angle2? number # angle of the end of the arc.
---@param segments? number # The number of segments to render.
function Pass:circle(transform, style, angle1, angle2, segments) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, texture: lovr.Texture, color: lovr.Color, layer?: number, layers?: number, level?: number, levels?: number)
---@param buffer lovr.Buffer # The Buffer to clear.
---@param offset number # TODO
---@param extent number # TODO
function Pass:clear(buffer, offset, extent) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, buffer: lovr.Buffer, offset?: number)
---@param x? number # How many workgroups to dispatch in the x dimension.
---@param y? number # How many workgroups to dispatch in the y dimension.
---@param z? number # How many workgroups to dispatch in the z dimension.
function Pass:compute(x, y, z) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param transform lovr.TransformXY2 # The transform to apply to the cone.  The x and y scale is the radius, the z scale is the length.
---@param segments? number # The number of circular segments to render.
function Pass:cone(transform, segments) end

---
---TODO
---
---@overload fun(self: lovr.Pass, blob: lovr.Blob, bufferdst: lovr.Buffer, srcoffset?: number, dstoffset?: number, size?: number)
---@overload fun(self: lovr.Pass, buffersrc: lovr.Buffer, bufferdst: lovr.Buffer, srcoffset?: number, dstoffset?: number, size?: number)
---@overload fun(self: lovr.Pass, image: lovr.Image, texturedst: lovr.Texture, srcx?: number, srcy?: number, dstx?: number, dsty?: number, width?: number, height?: number, srclayer?: number, dstlayer?: number, layers?: number, srclevel?: number, dstlevel?: number)
---@overload fun(self: lovr.Pass, texturesrc: lovr.Texture, texturedst: lovr.Texture, srcx?: number, srcy?: number, dstx?: number, dsty?: number, width?: number, height?: number, srclayer?: number, dstlayer?: number, layers?: number, srclevel?: number, dstlevel?: number)
---@overload fun(self: lovr.Pass, tally: lovr.Tally, srcindex?: number, dstoffset?: number, count?: number)
---@param table table # TODO
---@param bufferdst lovr.Buffer # TODO
---@param srcindex? number # TODO
---@param dstindex? number # TODO
---@param count? number # TODO
function Pass:copy(table, bufferdst, srcindex, dstindex, count) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param transform lovr.Transform # The transform to apply to the cube.
---@param style? lovr.DrawStyle # Whether the cube should be drawn filled or outlined.
function Pass:cube(transform, style) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, p1: lovr.Point3, p2: lovr.Point3, capped?: boolean, angle1?: number, angle2?: number, segments?: number)
---@param transform lovr.TransformXY2 # The transform to apply to the cylinder.  The x and y scale is the radius, the z scale is the length.
---@param capped? boolean # Whether the tops and bottoms of the cylinder should be rendered.
---@param angle1? number # The angle of the beginning of the arc.
---@param angle2? number # angle of the end of the arc.
---@param segments? number # The number of circular segments to render.
function Pass:cylinder(transform, capped, angle1, angle2, segments) end

---
---TODO
---
---@overload fun(self: lovr.Pass, model: lovr.Model, transform: lovr.Transform, nodename: string, children: boolean, instances: number)
---@param model lovr.Model # The model to draw.
---@param transform lovr.Transform # The transform of the object.
---@param nodeindex number # TODO
---@param children boolean # TODO
---@param instances number # TODO
function Pass:draw(model, transform, nodeindex, children, instances) end

---
---TODO
---
---@overload fun(self: lovr.Pass)
---@param texture lovr.Texture # The texture to fill.
function Pass:fill(texture) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@return table clears # TODO
function Pass:getClear() end

---
---TODO
---
---@return number width # TODO
---@return number height # TODO
function Pass:getDimensions() end

---
---TODO
---
---@return number height # TODO
function Pass:getHeight() end

---
---Returns the projection for a single view.
---
---@overload fun(self: lovr.Pass, view: number, matrix: lovr.Mat4):lovr.Mat4
---@param view number # The view index.
---@return number left # The left field of view angle, in radians.
---@return number right # The right field of view angle, in radians.
---@return number up # The top field of view angle, in radians.
---@return number down # The bottom field of view angle, in radians.
function Pass:getProjection(view) end

---
---TODO
---
---@return number samples # TODO
function Pass:getSampleCount() end

---
---TODO
---
---@return table target # TODO
function Pass:getTarget() end

---
---TODO
---
---@return lovr.PassType type # The type of the Pass.
function Pass:getType() end

---
---TODO
---
---@return number views # TODO
function Pass:getViewCount() end

---
---Get the pose of a single view.
---
---@overload fun(self: lovr.Pass, view: number, matrix: lovr.Mat4, invert: boolean):lovr.Mat4
---@param view number # The view index.
---@return number x # The x position of the viewer, in meters.
---@return number y # The y position of the viewer, in meters.
---@return number z # The z position of the viewer, in meters.
---@return number angle # The number of radians the viewer is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Pass:getViewPose(view) end

---
---TODO
---
---@return number width # TODO
function Pass:getWidth() end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, t: table)
---@overload fun(self: lovr.Pass, v1: lovr.Vec3, v2: lovr.Vec3, ...)
---@param x1 number # The x coordinate of the first point.
---@param y1 number # The y coordinate of the first point.
---@param z1 number # The z coordinate of the first point.
---@param x2 number # The x coordinate of the next point.
---@param y2 number # The y coordinate of the next point.
---@param z2 number # The z coordinate of the next point.
---@vararg any # More points to add to the line.
function Pass:line(x1, y1, z1, x2, y2, z2, ...) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, vertices?: lovr.Buffer, indices: lovr.Buffer, transform: lovr.transform, start?: number, count?: number, instances?: number)
---@overload fun(self: lovr.Pass, vertices?: lovr.Buffer, indices: lovr.Buffer, draws: lovr.Buffer, drawcount: number, offset: number, stride: number)
---@param vertices? lovr.Buffer # TODO
---@param transform lovr.transform # The transform to apply to the mesh.
---@param start? number # The 1-based index of the first vertex to render from the vertex buffer (or the first index, when using an index buffer).
---@param count? number # The number of vertices to render (or the number of indices, when using an index buffer). When `nil`, as many vertices or indices as possible will be drawn (based on the length of the Buffers and `start`).
---@param instances? number # The number of copies of the mesh to render.
function Pass:mesh(vertices, transform, start, count, instances) end

---
---TODO
---
---@param texture lovr.Texture # TODO
---@param base? number # TODO
---@param count? number # TODO
function Pass:mipmap(texture, base, count) end

---
---TODO
---
function Pass:origin() end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param transform lovr.Transform2 # The transform to apply to the plane.
---@param style? lovr.DrawStyle # Whether the plane should be drawn filled or outlined.
---@param columns? number # The number of horizontal segments in the plane.
---@param rows? number # The number of vertical segments in the plane.
function Pass:plane(transform, style, columns, rows) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, t: table)
---@overload fun(self: lovr.Pass, v: lovr.Vec3, ...)
---@param x number # The x coordinate of the first point.
---@param y number # The y coordinate of the first point.
---@param z number # The z coordinate of the first point.
---@vararg any # More points.
function Pass:points(x, y, z, ...) end

---
---TODO
---
---
---### NOTE:
---TODO stack balancing/error
---
---@param stack? lovr.StackType # The type of stack to pop.
function Pass:pop(stack) end

---
---TODO
---
---
---### NOTE:
---TODO stack balancing/error
---
---@param stack? lovr.StackType # The type of stack to push.
function Pass:push(stack) end

---
---TODO
---
---@overload fun(self: lovr.Pass, texture: lovr.Texture, x?: number, y?: number, layer?: number, level?: number, width?: number, height?: number):lovr.Readback
---@overload fun(self: lovr.Pass, tally: lovr.Tally, index: number, count: number):lovr.Readback
---@param buffer lovr.Buffer # TODO
---@param index number # TODO
---@param count number # TODO
---@return lovr.Readback readback # TODO
function Pass:read(buffer, index, count) end

---
---TODO
---
---
---### NOTE:
---TODO axis does not need to be normalized TODO order matters
---
---@overload fun(self: lovr.Pass, q: lovr.Quat)
---@param angle? number # The number of radians to rotate around the axis of rotation.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
function Pass:rotate(angle, ax, ay, az) end

---
---TODO
---
---@overload fun(self: lovr.Pass, v: lovr.Vec3)
---@param x? number # The amount to scale the x axis.
---@param y? number # The amount to scale the y axis.
---@param z? number # The amount to scale the z axis.
function Pass:scale(x, y, z) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, name: string, texture: lovr.Texture)
---@overload fun(self: lovr.Pass, name: string, sampler: lovr.Sampler)
---@overload fun(self: lovr.Pass, name: string, constant: any)
---@overload fun(self: lovr.Pass, binding: number, buffer: lovr.Buffer)
---@overload fun(self: lovr.Pass, binding: number, texture: lovr.Texture)
---@overload fun(self: lovr.Pass, binding: number, sampler: lovr.Sampler)
---@param name string # The name of the Shader variable.
---@param buffer lovr.Buffer # The Buffer to assign.
function Pass:send(name, buffer) end

---
---TODO
---
---@param enable boolean # Whether alpha to coverage should be enabled.
function Pass:setAlphaToCoverage(enable) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param blend lovr.BlendMode # The blend mode.
---@param alphaBlend lovr.BlendAlphaMode # The alpha blend mode.
function Pass:setBlendMode(blend, alphaBlend) end

---
---TODO
---
---@param color lovr.Color # The new color.
function Pass:setColor(color) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param r boolean # Whether the red component should be affected by drawing.
---@param g boolean # Whether the green component should be affected by drawing.
---@param b boolean # Whether the blue component should be affected by drawing.
---@param a boolean # Whether the alpha component should be affected by drawing.
function Pass:setColorWrite(r, g, b, a) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param mode? lovr.CullMode # Whether `front` faces, `back` faces, or `none` of the faces should be culled.
function Pass:setCullMode(mode) end

---
---TODO
---
---
---### NOTE:
---TODO depthClamp feature!
---
---@param enable boolean # Whether depth clamp should be enabled.
function Pass:setDepthClamp(enable) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param offset? number # The depth offset.
---@param sloped? number # The sloped depth offset.
function Pass:setDepthOffset(offset, sloped) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass)
---@param test lovr.CompareMode # The new depth test to use.
function Pass:setDepthTest(test) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param write boolean # The new depth write setting.
function Pass:setDepthWrite(write) end

---
---TODO
---
---@param font lovr.Font # The Font to use when rendering text.
function Pass:setFont(font) end

---
---TODO
---
---@param material lovr.Material # TODO
function Pass:setMaterial(material) end

---
---TODO
---
---@param mode lovr.MeshMode # TODO
function Pass:setMeshMode(mode) end

---
---Sets the projection for a single view.
---
---4 field of view angles can be used, similar to the field of view returned by `lovr.headset.getViewAngles`.
---
---Alternatively, a projection matrix can be used for other types of projections like orthographic, oblique, etc.
---
---There is also a shorthand string "orthographic" that can be used to configure an orthographic projection.
---
---Up to 6 views are supported.
---
---When rendering to the headset, both projections are changed to match the ones used by the headset.
---
---This is also available by calling `lovr.headset.getViewAngles`.
---
---
---### NOTE:
---A far clipping plane of 0.0 can be used for an infinite far plane with reversed Z range.
---
---This is the default.
---
---@overload fun(self: lovr.Pass, view: number, matrix: lovr.Mat4)
---@param view number # The index of the view to update.
---@param left number # The left field of view angle, in radians.
---@param right number # The right field of view angle, in radians.
---@param up number # The top field of view angle, in radians.
---@param down number # The bottom field of view angle, in radians.
---@param near? number # The near clipping plane distance, in meters.
---@param far? number # The far clipping plane distance, in meters.
function Pass:setProjection(view, left, right, up, down, near, far) end

---
---TODO
---
---@param sampler lovr.Sampler # TODO
function Pass:setSampler(sampler) end

---
---TODO
---
---
---### NOTE:
---TODO not floating point, negative, limits, not pipeline, initial pass state
---
---@param x number # The x coordinate of the upper-left corner of the scissor rectangle.
---@param y number # The y coordinate of the upper-left corner of the scissor rectangle.
---@param w number # The width of the scissor rectangle.
---@param h number # The height of the scissor rectangle.
function Pass:setScissor(x, y, w, h) end

---
---TODO
---
---@overload fun(self: lovr.Pass, default: lovr.DefaultShader)
---@overload fun(self: lovr.Pass)
---@param shader lovr.Shader # A custom Shader object to use for rendering.
function Pass:setShader(shader) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass)
---@param test lovr.CompareMode # The new stencil test to use.
---@param value number # The stencil value to compare against.
---@param mask? number # An optional mask to apply to stencil values before the comparison.
function Pass:setStencilTest(test, value, mask) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, actions: table, value?: number, mask?: number)
---@overload fun(self: lovr.Pass)
---@param action lovr.StencilAction # How pixels drawn will update the stencil buffer.
---@param value? number # When using the 'replace' action, this is the value to replace with.
---@param mask? number # An optional mask to apply to stencil values before writing.
function Pass:setStencilWrite(action, value, mask) end

---
---Sets the pose for a single view.
---
---Objects rendered in this view will appear as though the camera is positioned using the given pose.
---
---Up to 6 views are supported.
---
---When rendering to the headset, views are changed to match the eye positions.
---
---These view poses are also available using `lovr.headset.getViewPose`.
---
---@overload fun(self: lovr.Pass, view: number, matrix: lovr.Mat4, inverted: boolean)
---@param view number # The index of the view to update.
---@param x number # The x position of the viewer, in meters.
---@param y number # The y position of the viewer, in meters.
---@param z number # The z position of the viewer, in meters.
---@param angle number # The number of radians the viewer is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Pass:setViewPose(view, x, y, z, angle, ax, ay, az) end

---
---TODO
---
---
---### NOTE:
---TODO floating point, negative, flipped depth range, limits, not pipeline, initial pass state, what the hell is depth range
---
---@param x number # The x coordinate of the upper-left corner of the viewport.
---@param y number # The y coordinate of the upper-left corner of the viewport.
---@param w number # The width of the viewport.
---@param h number # The height of the viewport.
---@param minDepth? number # The min component of the depth range.
---@param maxDepth? number # The max component of the depth range.
function Pass:setViewport(x, y, w, h, minDepth, maxDepth) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param winding lovr.Winding # Whether triangle vertices are ordered `clockwise` or `counterclockwise`.
function Pass:setWinding(winding) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param enable boolean # Whether wireframe rendering should be enabled.
function Pass:setWireframe(enable) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass)
---@param skybox lovr.Texture # The skybox to render.  Its `TextureType` can be `cube` to render as a cubemap, or `2d` to render as an equirectangular (spherical) 2D image.
function Pass:skybox(skybox) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param transform lovr.transform # The transform to apply to the sphere.
---@param longitudes? number # The number of "horizontal" segments.
---@param latitudes? number # The number of "vertical" segments.
function Pass:sphere(transform, longitudes, latitudes) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@overload fun(self: lovr.Pass, colortext: table, transform: lovr.transform, wrap?: number, halign?: lovr.HorizontalAlign, valign?: lovr.VerticalAlign)
---@param text string # The text to render.
---@param transform lovr.transform # The transform of the text.
---@param wrap? number # The maximum width of each line in meters (before scale is applied).  When zero, the text will not wrap.
---@param halign? lovr.HorizontalAlign # The horizontal alignment.
---@param valign? lovr.VerticalAlign # The vertical alignment.
function Pass:text(text, transform, wrap, halign, valign) end

---
---TODO
---
---@param tally lovr.Tally # TODO
---@param index number # TODO
function Pass:tick(tally, index) end

---
---TODO
---
---@param tally lovr.Tally # TODO
---@param index number # TODO
function Pass:tock(tally, index) end

---
---TODO
---
---
---### NOTE:
---TODO
---
---@param transform lovr.TransformXY2 # The transform to apply to the torus.  The x scale is the radius, the z scale is the thickness.
---@param tsegments? number # The number of toroidal (circular) segments to render.
---@param psegments? number # The number of poloidal (tubular) segments to render.
function Pass:torus(transform, tsegments, psegments) end

---
---TODO
---
---
---### NOTE:
---TODO you can use combos of numbers/vectors/quats too (or use meta Transform type to explain)
---
---@overload fun(self: lovr.Pass, transform: lovr.Mat4)
---@param x? number # The x component of the translation.
---@param y? number # The y component of the translation.
---@param z? number # The z component of the translation.
---@param sx? number # The x scale factor.
---@param sy? number # The y scale factor.
---@param sz? number # The z scale factor.
---@param angle? number # The number of radians to rotate around the axis of rotation.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
function Pass:transform(x, y, z, sx, sy, sz, angle, ax, ay, az) end

---
---TODO
---
---
---### NOTE:
---Order matters when scaling, translating, and rotating the coordinate system.
---
---@overload fun(self: lovr.Pass, v: lovr.Vec3)
---@param x? number # The amount to translate on the x axis.
---@param y? number # The amount to translate on the y axis.
---@param z? number # The amount to translate on the z axis.
function Pass:translate(x, y, z) end

---
---TODO
---
---@class lovr.Readback
local Readback = {}

---
---Returns the Readback's data as a Blob.
---
---
---### NOTE:
---TODO what if it's an image?!
---
---@return lovr.Blob blob # The Blob.
function Readback:getBlob() end

---
---Returns the data from the Readback, as a table.
---
---
---### NOTE:
---TODO what if the readback is a buffer/texture?!
---
---@return table data # A table containing the values that were read back.
function Readback:getData() end

---
---Returns the Readback's data as an Image.
---
---
---### NOTE:
---TODO what if it's a buffer or tally?!
---
---@return lovr.Image image # The Image.
function Readback:getImage() end

---
---Returns whether the Readback has completed on the GPU and its data is available.
---
---@return boolean complete # Whether the readback is complete.
function Readback:isComplete() end

---
---Blocks the CPU until the Readback is finished on the GPU.
---
---
---### NOTE:
---TODO what if the readback will never complete?!
---
---@return boolean waited # Whether the CPU had to be blocked for waiting.
function Readback:wait() end

---
---TODO
---
---@class lovr.Sampler
local Sampler = {}

---
---TODO
---
---@return number anisotropy # TODO
function Sampler:getAnisotropy() end

---
---TODO
---
---@return lovr.CompareMode compare # TODO
function Sampler:getCompareMode() end

---
---TODO
---
---@return lovr.FilterMode min # TODO
---@return lovr.FilterMode mag # TODO
---@return lovr.FilterMode mip # TODO
function Sampler:getFilter() end

---
---TODO
---
---@return number min # TODO
---@return number max # TODO
function Sampler:getMipmapRange() end

---
---TODO
---
---@return lovr.WrapMode x # TODO
---@return lovr.WrapMode y # TODO
---@return lovr.WrapMode z # TODO
function Sampler:getWrap() end

---
---TODO
---
---@class lovr.Shader
local Shader = {}

---
---TODO
---
---@param source lovr.Shader # The Shader to clone.
---@param flags table # TODO
---@return lovr.Shader shader # The new Shader.
function Shader:clone(source, flags) end

---
---TODO
---
---@return lovr.ShaderType type # The type of the Shader.
function Shader:getType() end

---
---Returns the workgroup size of a compute shader.
---
---TODO what is it.
---
---@return number x # The x size of a workgroup.
---@return number y # The y size of a workgroup.
---@return number z # The z size of a workgroup.
function Shader:getWorkgroupSize() end

---
---TODO
---
---@overload fun(self: lovr.Shader, location: number):boolean
---@param name string # The name of an attribute.
---@return boolean exists # Whether the Shader has the attribute.
function Shader:hasAttribute(name) end

---
---TODO
---
---@param stage lovr.ShaderStage # The stage.
---@return boolean exists # Whether the Shader has the stage.
function Shader:hasStage(stage) end

---
---TODO
---
---@class lovr.Tally
local Tally = {}

---
---Returns the number of slots in the Tally.
---
---@return number count # The number of slots in the Tally.
function Tally:getCount() end

---
---TODO
---
---@return lovr.TallyType type # TODO
function Tally:getType() end

---
---Tally objects with the `time` type can only be used in render passes with a certain number of views.
---
---This returns that number.
---
---@return number views # The number of views the Tally is compatible with.
function Tally:getViewCount() end

---
---Textures are multidimensional blocks of memory on the GPU, contrasted with `Buffer`s which are similar but one-dimensional.
---
---Textures can be used to provide material data to Shaders, and they are also used as the destination for rendering operations.
---
---Textures can be created from image filenames, `Image` objects, or they can be left blank and created with a width, height, and depth.
---
---Each Texture has a type (`TextureType`).
---
---2D Textures are the most common and are often used to store color image data, but there are also cubemaps for skyboxes, 3D textures for volumetric info, and array textures which store a sequence of 2D images.
---
---The format of a Texture (`TextureFormat`) defines the size and number of channels of each pixel.
---
---Textures can have mipmaps, which are a precomputed set of progressively smaller versions of the Texture.
---
---Mipmaps help make the Texture look smoother at smaller sizes, and also improve the performance of reading data from the Texture in a Shader.
---
---When used as a render target, the Texture can store multiple different color samples for each pixel, which can be averaged together after rendering to do antialiasing (this is called multisample antialiasing, or MSAA).
---
---It is possible to create multiple views of a single Texture.
---
---A texture view references a subset of the array layers and mipmap levels of its parent texture, and can be bound to a Shader or used as a render target just like a normal texture.
---
---@class lovr.Texture
local Texture = {}

---
---Returns the width, height, and depth of the Texture.
---
---@return number width # The width of the Texture.
---@return number height # The height of the Texture.
---@return number depth # The depth of the Texture.
function Texture:getDimensions() end

---
---Returns the format of the texture.
---
---The default is `rgba8`.
---
---@return lovr.TextureFormat format # The format of the Texture.
function Texture:getFormat() end

---
---Returns the height of the Texture, in pixels.
---
---@return number height # The height of the Texture, in pixels.
function Texture:getHeight() end

---
---Returns the layer count of the Texture.
---
---2D textures always have 1 layer and cubemaps always have 6 layers.
---
---For 3D and array textures, this is the number of images stored in the texture. 3D textures represent a spatial 3D volume, whereas array textures are multiple layers of distinct 2D images.
---
---@return number layers # The layer count of the Texture.
function Texture:getLayerCount() end

---
---Returns the number of mipmap levels in the Texture.
---
---This is set when the Texture is created. By default, textures are created with a full set of mipmap levels, and mipmaps are generated if the images used to create the texture do not include mipmaps.
---
---
---### NOTE:
---Each mipmap level will be half the size of the previous (larger) mipmap level, down to a single pixel.
---
---This means the maximum number of mipmap levels is given by `log2(max(width, height))` for non-3D textures and `log2(max(width, height, depth))` for 3D textures.
---
---@return number mipmaps # The number of mipmap levels in the Texture.
function Texture:getMipmapCount() end

---
---Returns the parent of a Texture view, which is the Texture that it references.
---
---Returns `nil` if the Texture is not a view.
---
---@return lovr.Texture parent # The parent of the texture, or `nil` if the texture is not a view.
function Texture:getParent() end

---
---Returns the number of multisample antialiasing (MSAA) samples in the Texture.
---
---Multisampling is used for antialiasing when rendering to the Texture.
---
---Using more samples will cause the Texture to use additional memory but reduce aliasing artifacts.
---
---
---### NOTE:
---Currently, the sample count must be either 1 or 4.
---
---@return number samples # The number of samples in the Texture.
function Texture:getSampleCount() end

---
---Returns the type of the texture.
---
---@return lovr.TextureType type # The type of the Texture.
function Texture:getType() end

---
---Returns the width of the Texture, in pixels.
---
---@return number width # The width of the Texture, in pixels.
function Texture:getWidth() end

---
---Returns whether a Texture was created with a set of `TextureUsage` flags.
---
---Usage flags are specified when the Texture is created, and restrict what you can do with a Texture object.
---
---By default, only the `sample` usage is enabled.
---
---Applying a smaller set of usage flags helps LÖVR optimize things better.
---
---@vararg lovr.TextureUsage # One or more usage flags.
---@return boolean supported # Whether the Texture has all the provided usage flags.
function Texture:hasUsage(...) end

---
---Returns whether a Texture is a texture view, created with `Texture:newView`.
---
---@return boolean view # Whether the Texture is a texture view.
function Texture:isView() end

---
---Creates a new Texture view.
---
---A texture view does not store any pixels on its own, but instead uses the pixel data of a "parent" Texture object.
---
---The width, height, format, sample count, and usage flags all match the parent.
---
---The view may have a different `TextureType` from the parent, and it may reference a subset of the parent texture's images and mipmap levels.
---
---Texture views can be used as render targets in a render pass and they can be bound to Shaders. They can not currently be used for transfer operations.
---
---They are used for:
---
---- Reinterpretation of texture contents.
---
---For example, a cubemap can be treated as
---  an array texture.
---- Rendering to a particular image or mipmap level of a texture.
---- Binding a particular image or mipmap level to a shader.
---
---@param parent lovr.Texture # The parent Texture to create the view of.
---@param type lovr.TextureType # The texture type of the view.
---@param layer? number # The index of the first layer in the view.
---@param layerCount? number # The number of layers in the view, or `nil` to use all remaining layers.
---@param mipmap? number # The index of the first mipmap in the view.
---@param mipmapCount? number # The number of mipmaps in the view, or `nil` to use all remaining mipmaps.
---@return lovr.Texture view # The new texture view.
function Texture:newView(parent, type, layer, layerCount, mipmap, mipmapCount) end

---
---The different ways to pack Buffer fields into memory.
---
---The default is `packed`, which is suitable for vertex buffers and index buffers.
---
---It doesn't add any padding between elements, and so it doesn't waste any space.
---
---However, this layout won't necessarily work for uniform buffers and storage buffers.
---
---The `std140` layout corresponds to the std140 layout used for uniform buffers in GLSL.
---
---It adds the most padding between fields, and requires the stride to be a multiple of 16.
---
---Example:
---
---``` layout(std140) uniform ObjectScales { float scales[64]; }; ```
---
---The `std430` layout corresponds to the std430 layout used for storage buffers in GLSL.
---
---It adds some padding between certain types, and may round up the stride.
---
---Example:
---
---``` layout(std430) buffer TileSizes { vec2 sizes[]; } ```
---
---@alias lovr.BufferLayout
---
---The packed layout, without any padding.
---
---| "packed"
---
---The std140 layout.
---
---| "std140"
---
---The std430 layout.
---
---| "std430"

---
---Different types for `Buffer` fields.
---
---These are scalar, vector, or matrix types, usually packed into small amounts of space to reduce the amount of memory they occupy.
---
---The names are encoded as follows:
---
---- The data type:
---  - `i` for signed integer
---  - `u` for unsigned integer
---  - `sn` for signed normalized (-1 to 1)
---  - `un` for unsigned normalized (0 to 1)
---  - `f` for floating point
---- The bit depth of each component
---- The letter `x` followed by the component count (for vectors)
---
---
---### NOTE:
---In addition to these values, the following aliases can be used:
---
---<table>
---  <thead>
---    <tr>
---      <td>Alias</td>
---      <td>Maps to</td>
---    </tr>
---  </thead>
---  <tbody>
---    <tr>
---      <td><code>vec2</code></td>
---      <td><code>f32x2</code></td>
---    </tr>
---    <tr>
---      <td><code>vec3</code></td>
---      <td><code>f32x3</code></td>
---    </tr>
---    <tr>
---      <td><code>vec4</code></td>
---      <td><code>f32x4</code></td>
---    </tr>
---    <tr>
---      <td><code>int</code></td>
---      <td><code>i32</code></td>
---    </tr>
---    <tr>
---      <td><code>uint</code></td>
---      <td><code>u32</code></td>
---    </tr>
---    <tr>
---      <td><code>float</code></td>
---      <td><code>f32</code></td>
---    </tr>
---    <tr>
---      <td><code>color</code></td>
---      <td><code>un8x4</code></td>
---    </tr>
---  </tbody> </table>
---
---Additionally, the following convenience rules apply:
---
---- Field types can end in an `s`, which will be stripped off.
---- Field types can end in `x1`, which will be stripped off.
---
---So you can write, e.g. `lovr.graphics.newBuffer(4, 'floats')`, which is cute!
---
---@alias lovr.FieldType
---
---Four 8-bit signed integers.
---
---| "i8x4"
---
---Four 8-bit unsigned integers.
---
---| "u8x4"
---
---Four 8-bit signed normalized values.
---
---| "sn8x4"
---
---Four 8-bit unsigned normalized values (aka `color`).
---
---| "un8x4"
---
---Three 10-bit unsigned normalized values, and 2 padding bits (aka `normal`).
---
---| "un10x3"
---
---One 16-bit signed integer.
---
---| "i16"
---
---Two 16-bit signed integers.
---
---| "i16x2"
---
---Four 16-bit signed integers.
---
---| "i16x4"
---
---One 16-bit unsigned integer.
---
---| "u16"
---
---Two 16-bit unsigned integers.
---
---| "u16x2"
---
---Four 16-bit unsigned integers.
---
---| "u16x4"
---
---Two 16-bit signed normalized values.
---
---| "sn16x2"
---
---Four 16-bit signed normalized values.
---
---| "sn16x4"
---
---Two 16-bit unsigned normalized values.
---
---| "un16x2"
---
---Four 16-bit unsigned normalized values.
---
---| "un16x4"
---
---One 32-bit signed integer (aka `int`).
---
---| "i32"
---
---Two 32-bit signed integers.
---
---| "i32x2"
---
---Two 32-bit signed integers.
---
---| "i32x2"
---
---Three 32-bit signed integers.
---
---| "i32x3"
---
---Four 32-bit signed integers.
---
---| "i32x4"
---
---One 32-bit unsigned integer (aka `uint`).
---
---| "u32"
---
---Two 32-bit unsigned integers.
---
---| "u32x2"
---
---Three 32-bit unsigned integers.
---
---| "u32x3"
---
---Four 32-bit unsigned integers.
---
---| "u32x4"
---
---Two 16-bit floating point numbers.
---
---| "f16x2"
---
---Four 16-bit floating point numbers.
---
---| "f16x4"
---
---One 32-bit floating point number (aka `float`).
---
---| "f32"
---
---Two 32-bit floating point numbers (aka `vec2`).
---
---| "f32x2"
---
---Three 32-bit floating point numbers (aka `vec3`).
---
---| "f32x3"
---
---Four 32-bit floating point numbers (aka `vec4`).
---
---| "f32x4"
---
---A 2x2 matrix containing four 32-bit floats.
---
---| "mat2"
---
---A 3x3 matrix containing nine 32-bit floats.
---
---| "mat3"
---
---A 4x4 matrix containing sixteen 32-bit floats.
---
---| "mat4"

---
---TODO
---
---@alias lovr.MeshMode
---
---TODO
---
---| "points"
---
---TODO
---
---| "lines"
---
---TODO
---
---| "triangles"

---
---TODO
---
---@alias lovr.PassType
---
---TODO
---
---| "render"
---
---TODO
---
---| "compute"
---
---TODO
---
---| "transfer"

---
---TODO
---
---@alias lovr.ShaderStage
---
---TODO
---
---| "vertex"
---
---TODO
---
---| "fragment"
---
---TODO
---
---| "compute"

---
---TODO
---
---@alias lovr.ShaderType
---
---TODO
---
---| "graphics"
---
---TODO
---
---| "compute"

---
---TODO
---
---@alias lovr.StackType
---
---TODO
---
---| "transform"

---| "state"

---
---TODO
---
---@alias lovr.TallyType
---
---Each slot measures elapsed time in nanoseconds.
---
---| "time"
---
---Each slot measures the approximate number of pixels affected by rendering.
---
---| "pixel"
---
---Each slot measures the number of times different shader stages are invoked.
---
---| "shader"

---
---These are the different ways `Texture` objects can be used.
---
---These are passed in to `lovr.graphics.isFormatSupported` to see which texture operations are supported by the GPU for a given format.
---
---@alias lovr.TextureFeature
---
---The Texture can be sampled (e.g. a `texture2D` or `sampler2D` variable in shaders).
---
---| "sample"
---
---The Texture can be used with a `Sampler` using a `FilterMode` of `linear`.
---
---| "filter"
---
---The Texture can be rendered to by using it as a target in a render `Pass`.
---
---| "render"
---
---Blending can be enabled when rendering to this format in a render pass.
---
---| "blend"
---
---The Texture can be sent to an image variable in shaders (e.g. `image2D`).
---
---| "storage"
---
---Atomic operations can be used on storage textures with this format.
---
---| "atomic"
---
---Source textures in `Pass:blit` can use this format.
---
---| "blitsrc"
---
---Destination textures in `Pass:blit` can use this format.
---
---| "blitdst"

---
---Different types of textures.
---
---Textures are multidimensional blocks of GPU memory, and the texture's type determines how many dimensions there are, and adds some semantics about what the 3rd dimension means.
---
---@alias lovr.TextureType
---
---A single 2D image, the most common type.
---
---| "2d"
---
---A 3D image, where a sequence of 2D images defines a 3D volume.
---
---Each mipmap level of a 3D texture gets smaller in the x, y, and z axes, unlike cubemap and array textures.
---
---| "3d"
---
---Six 2D images that define the faces of a cubemap, used for skyboxes or other "directional" images.
---
---| "cube"
---
---Array textures are sequences of distinct 2D images.
---
---| "array"

---
---These are the different things `Texture`s can be used for.
---
---When creating a Texture, a set of these flags can be provided, restricting what operations are allowed on the texture.
---
---Using a smaller set of flags may improve performance.
---
---If none are provided, the only usage flag applied is `sample`.
---
---@alias lovr.TextureUsage
---
---Whether the texture can be sampled from in Shaders (i.e. used in a material, or bound to a variable with a `texture` type, like `texture2D`).
---
---| "sample"
---
---Whether the texture can be rendered to (i.e. by using it as a render target in `lovr.graphics.pass`).
---
---| "render"
---
---Whether the texture can be used as a storage texture for compute operations (i.e. bound to a variable with an `image` type, like `image2D`).
---
---| "storage"
---
---Whether the texture can be used in a transfer pass.
---
---| "transfer"
