---@meta

---
---The graphics module renders graphics and performs computation using the GPU.
---
---Most of the graphics functions are on the `Pass` object.
---
---@class lovr.graphics
lovr.graphics = {}

---
---Compiles shader code to SPIR-V bytecode.
---
---The bytecode can be passed to `lovr.graphics.newShader` to create shaders, which will be faster than creating it from GLSL. The bytecode is portable, so bytecode compiled on one platform will work on other platforms. This allows shaders to be precompiled in a build step.
---
---
---### NOTE:
---The input can be GLSL or SPIR-V.
---
---If it's SPIR-V, it will be returned unchanged as a Blob.
---
---If the shader fails to compile, an error will be thrown with the error message.
---
---@overload fun(stage: lovr.ShaderStage, blob: lovr.Blob):lovr.Blob
---@param stage lovr.ShaderStage # The type of shader to compile.
---@param source string # A string or filename with shader code.
---@return lovr.Blob bytecode # A Blob containing compiled SPIR-V code.
function lovr.graphics.compileShader(stage, source) end

---
---Returns the global background color.
---
---The textures in a render pass will be cleared to this color at the beginning of the pass if no other clear option is specified.
---
---Additionally, the headset and window will be cleared to this color before rendering.
---
---
---### NOTE:
---Setting the background color in `lovr.draw` will apply on the following frame, since the default pass is cleared before `lovr.draw` is called.
---
---Internally, this color is applied to the default pass objects when retrieving one of them using `lovr.headset.getPass` or `lovr.graphics.getPass`.
---
---Both are called automatically by the default `lovr.run` implementation.
---
---Using the background color to clear the display is expected to be more efficient than manually clearing after a render pass begins, especially on mobile GPUs.
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
---  In practice this means that an `offset` should be set for either all of the fields or none of
---  them.
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
---Creates and returns a temporary Pass object.
---
---
---### NOTE:
---Fun facts about render passes:
---
---- Textures must have been created with the `render` `TextureUsage`.
---- Textures must have the same dimensions, layer counts, and sample counts.
---- When rendering to textures with multiple layers, each draw will be broadcast to all layers.
---  Render passes have multiple "views" (cameras), and each layer uses a corresponding view,
---  allowing each layer to be rendered from a different viewpoint.
---
---This enables fast stereo
---  rendering, but can also be used to efficiently render to cubemaps.
---
---The `ViewIndex` variable
---  can also be used in shaders to set up any desired per-view behavior.
---- If `mipmap` is true, then any textures with mipmaps must have the `transfer` `TextureUsage`.
---- It's okay to have zero color textures, but in this case there must be a depth texture.
---- Setting `clear` to `false` for textures is usually very slow on mobile GPUs.
---- It's possible to render to a specific mipmap level of a Texture, or a subset of its layers, by
---  rendering to texture views, see `Texture:newView`.
---
---For `compute` and `transfer` passes, all of the commands in the pass act as though they run in parallel.
---
---This means that writing to the same element of a buffer twice, or writing to it and reading from it again is not guaranteed to work properly on all GPUs.
---
---LÖVR is not currently able to check for this.
---
---If compute or transfers need to be sequenced, multiple passes should be used.
---
---It is, however, completely fine to read and write to non-overlapping regions of the same buffer or texture.
---
---@overload fun(type: lovr.PassType, texture: lovr.Texture):lovr.Pass
---@overload fun(type: lovr.PassType, canvas: table):lovr.Pass
---@param type lovr.PassType # The type of pass to create.
---@return lovr.Pass pass # The new Pass.
function lovr.graphics.getPass(type) end

---
---Returns the window pass.
---
---This is a builtin render `Pass` object that renders to the desktop window texture.
---
---If the desktop window was not open when the graphics module was initialized, this function will return `nil`.
---
---
---### NOTE:
---`lovr.conf` may be used to change the settings for the pass:  `t.graphics.antialias` enables antialiasing, and `t.graphics.stencil` enables the stencil buffer.
---
---This pass clears the window texture to the background color, which can be changed using `lovr.graphics.setBackgroundColor`.
---
---@return lovr.Pass pass # The window pass, or `nil` if there is no window.
function lovr.graphics.getWindowPass() end

---
---Returns the type of operations the GPU supports for a texture format, if any.
---
---@param format lovr.TextureFormat # The texture format to query.
---@param features lovr.TextureFeature # Zero or more features to check.  If no features are given, this function will return whether the GPU supports *any* feature for this format.  Otherwise, this function will only return true if *all* of the input features are supported.
---@return boolean supported # Whether the GPU supports these operations for textures with this format.
function lovr.graphics.isFormatSupported(format, features) end

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
---Creates a new Font.
---
---@overload fun(blob: lovr.Blob, size?: number, spread?: number):lovr.Font
---@overload fun(size?: number, spread?: number):lovr.Font
---@overload fun(rasterizer: lovr.Rasterizer, spread?: number):lovr.Font
---@param filename string # A path to a TTF file.
---@param size? number # The size of the Font in pixels.  Larger sizes are slower to initialize and use more memory, but have better quality.
---@param spread? number # For signed distance field fonts (currently all fonts), the width of the SDF, in pixels.  The greater the distance the font is viewed from, the larger this value needs to be for the font to remain properly antialiased.  Increasing this will have a performance penalty similar to increasing the size of the font.
---@return lovr.Font font # The new Font.
function lovr.graphics.newFont(filename, size, spread) end

---
---Creates a new Material from a table of properties and textures.
---
---All fields are optional.
---
---Once a Material is created, its properties can not be changed.
---
---Instead, a new Material should be created with the updated properties.
---
---
---### NOTE:
---The non-texture material properties can be accessed in shaders using `Material.<property>`, where the property is the same as the Lua table key.
---
---The textures use capitalized names in shader code, e.g. `ColorTexture`.
---
---@param properties {color: lovr.Vec4, glow: lovr.Vec4, uvShift: lovr.Vec2, uvScale: lovr.Vec2, metalness: number, roughness: number, clearcoat: number, clearcoatRoughness: number, occlusionStrength: number, normalScale: number, alphaCutoff: number, texture: lovr.Texture, glowTexture: lovr.Texture, metalnessTexture: lovr.Texture, roughnessTexture: lovr.Texture, clearcoatTexture: lovr.Texture, occlusionTexture: lovr.Texture, normalTexture: lovr.Texture} # Material properties.
---@return lovr.Material material # The new material.
function lovr.graphics.newMaterial(properties) end

---
---Loads a 3D model from a file.
---
---Currently, OBJ, glTF, and binary STL files are supported.
---
---
---### NOTE:
---Currently, the following features are not supported by the model importer:
---
---- glTF: Morph targets are not supported.
---- glTF: Only the default scene is loaded.
---- glTF: Currently, each skin in a Model can have up to 256 joints.
---- glTF: Meshes can't appear multiple times in the node hierarchy with different skins, they need
---  to use 1 skin consistently.
---- glTF: `KHR_texture_transform` is supported, but all textures in a material will use the same
---  transform.
---- STL: ASCII STL files are not supported.
---
---Diffuse and emissive textures will be loaded using sRGB encoding, all other textures will be loaded as linear.
---
---@overload fun(blob: lovr.Blob, options?: table):lovr.Model
---@overload fun(modelData: lovr.ModelData, options?: table):lovr.Model
---@param filename string # The path to model file.
---@param options? {mipmaps: boolean} # Model options.
---@return lovr.Model model # The new Model.
function lovr.graphics.newModel(filename, options) end

---
---Creates a new Sampler.
---
---Samplers are immutable, meaning their parameters can not be changed after the sampler is created.
---
---Instead, a new sampler should be created with the updated properties.
---
---@param parameters {filter: {["[1]"]: lovr.FilterMode, ["[2]"]: lovr.FilterMode, ["[3]"]: lovr.FilterMode}, wrap: {["[1]"]: lovr.WrapMode, ["[2]"]: lovr.WrapMode, ["[3]"]: lovr.FilterMode}, compare: lovr.CompareMode, anisotropy: number, mipmaprange: table} # Parameters for the sampler.
---@return lovr.Sampler sampler # The new sampler.
function lovr.graphics.newSampler(parameters) end

---
---Creates a Shader, which is a small program that runs on the GPU.
---
---Shader code is usually written in GLSL and compiled to SPIR-V bytecode.
---
---SPIR-V is faster to load but requires a build step.
---
---Either form can be used to create a shader.
---
---@overload fun(compute: string, options: table):lovr.Shader
---@overload fun(default: lovr.DefaultShader, options: table):lovr.Shader
---@param vertex string # A string, path to a file, or Blob containing GLSL or SPIR-V code for the vertex stage.  Can also be a `DefaultShader` to use that shader's vertex code.
---@param fragment string # A string, path to a file, or Blob containing GLSL or SPIR-V code for the fragment stage. Can also be a `DefaultShader` to use that shader's fragment code.
---@param options {flags: table, label: string} # Shader options.
---@return lovr.Shader shader # The new shader.
function lovr.graphics.newShader(vertex, fragment, options) end

---
---Creates a new Tally.
---
---@param type lovr.TallyType # The type of the Tally, which controls what "thing" it measures.
---@param count number # The number of slots in the Tally.  Each slot holds one measurement.
---@param views? number # Tally objects with the `time` type can only be used in render passes with a certain number of views.  This is ignored for other types of tallies.
---@return lovr.Tally tally # The new Tally.
function lovr.graphics.newTally(type, count, views) end

---
---Creates a new Texture.
---
---Image filenames or `Image` objects can be used to provide the initial pixel data and the dimensions, format, and type.
---
---Alternatively, dimensions can be provided, which will create an empty texture.
---
---
---### NOTE:
---If no `type` is provided in the options table, LÖVR will guess the `TextureType` of the Texture based on the number of layers:
---
---- If there's only 1 layer, the type will be `2d`.
---- If there are 6 images provided, the type will be `cube`.
---- Otherwise, the type will be `array`.
---
---Note that an Image can contain multiple layers and mipmaps.
---
---When a single Image is provided, its layer count will be used as the Texture's layer count.
---
---If multiple Images are used to initialize the Texture, they must all have a single layer, and their dimensions, format, and mipmap counts must match.
---
---When providing cubemap images in a table, they can be in one of the following forms:
---
---    { 'px.png', 'nx.png', 'py.png', 'ny.png', 'pz.png', 'nz.png' }
---    { right = 'px.png', left = 'nx.png', top = 'py.png', bottom = 'ny.png', back = 'pz.png', front = 'nz.png' }
---    { px = 'px.png', nx = 'nx.png', py = 'py.png', ny = 'ny.png', pz = 'pz.png', nz = 'nz.png' }
---
---(Where 'p' stands for positive and 'n' stands for negative).
---
---If no `usage` is provided in the options table, LÖVR will guess the `TextureUsage` of the Texture.
---
---The `sample` usage is always included, but if the texture was created without any images then the texture will have the `render` usage as well.
---
---The supported image formats are png, jpg, hdr, dds, ktx1, ktx2, and astc.
---
---If image data is provided, mipmaps will be generated for any missing mipmap levels.
---
---@overload fun(width: number, height: number, options: table):lovr.Texture
---@overload fun(width: number, height: number, layers: number, options: table):lovr.Texture
---@overload fun(image: string, options: table):lovr.Texture
---@overload fun(images: table, options: table):lovr.Texture
---@overload fun(blob: lovr.Blob, options: table):lovr.Texture
---@param filename string # The filename of an image to load.
---@param options {type: lovr.TextureType, format: lovr.TextureFormat, linear: boolean, samples: number, mipmaps: any, usage: table, label: string} # Texture options.
---@return lovr.Texture texture # The new Texture.
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
---Changes the global background color.
---
---The textures in a render pass will be cleared to this color at the beginning of the pass if no other clear option is specified.
---
---Additionally, the headset and window will be cleared to this color before rendering.
---
---
---### NOTE:
---Setting the background color in `lovr.draw` will apply on the following frame, since the default pass is cleared before `lovr.draw` is called.
---
---Internally, this color is applied to the default pass objects when retrieving one of them using `lovr.headset.getPass` or `lovr.graphics.getPass`.
---
---Both are called automatically by the default `lovr.run` implementation.
---
---Using the background color to clear the display is expected to be more efficient than manually clearing after a render pass begins, especially on mobile GPUs.
---
---@overload fun(hex: number, a?: number)
---@overload fun(table: table)
---@param r number # The red component of the background color.
---@param g number # The green component of the background color.
---@param b number # The blue component of the background color.
---@param a? number # The alpha component of the background color.
function lovr.graphics.setBackgroundColor(r, g, b, a) end

---
---Submits work to the GPU.
---
---
---### NOTE:
---The submitted `Pass` objects will run in the order specified.
---
---Commands within a single Pass do not have any ordering guarantees.
---
---Submitting work to the GPU is not thread safe.
---
---No other `lovr.graphics` or `Pass` functions may run at the same time as `lovr.graphics.submit`.
---
---Calling this function will invalidate any temporary buffers or passes that were created during the frame.
---
---Submitting work to the GPU is a relatively expensive operation.
---
---It's a good idea to batch all `Pass` objects into 1 submission if possible, unless there's a good reason not to.
---
---One such reason would be that the frame has so much work that some of it needs to be submitted early to prevent the GPU from running out of things to do.
---
---Another would be for `Readback` objects.
---
---By default, this function is called with the default pass at the end of `lovr.draw` and `lovr.mirror`.
---
---It is valid to submit zero passes.
---
---This will send an empty batch of work to the GPU.
---
---@overload fun(t: table):boolean
---@vararg lovr.Pass # The pass objects to submit.  Falsy values will be skipped.
---@return boolean true # Always returns true, for convenience when returning from `lovr.draw`.
function lovr.graphics.submit(...) end

---
---Waits for all submitted GPU work to finish.
---
---A normal application that is trying to render graphics at a high framerate should never use this function, since waiting like this prevents the CPU from doing other useful work.
---
---Otherwise, reasons to use this function might be for debugging or to force a `Readback` to finish immediately.
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
---Clears some or all of the data in the **temporary** Buffer to zero.
---
---Permanent Buffers can be cleared in a transfer pass using `Pass:clear`.
---
---
---### NOTE:
---Clearing a permanent buffer requires the byte offset and byte count of the cleared range to be a multiple of 4.
---
---This will usually be true for most data types.
---
---@param index? number # The index of the first item to clear.
---@param count? number # The number of items to clear.  If `nil`, clears to the end of the Buffer.
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
---Returns a raw pointer to the Buffer's memory as a lightuserdata, intended for use with the LuaJIT FFI or for passing to C libraries.
---
---This is only available for temporary buffers, so the pointer is only valid until `lovr.graphics.submit` is called.
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
---Changes data in a temporary Buffer using a table or a Blob.
---
---Permanent buffers can be changed using `Pass:copy`.
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
---Font objects are used to render text with `Pass:text`.
---
---The active font can be changed using `Pass:setFont`.
---
---The default font is Varela Round, which is used when no font is active, and can be retrieved using `lovr.graphics.getDefaultFont`.
---
---Custom fonts can be loaded from TTF files using `lovr.graphics.newFont`.
---
---Each Font uses a `Rasterizer` to load the TTF file and create images for each glyph. As text is drawn, the Font uploads images from the Rasterizer to a GPU texture atlas as needed.
---
---The Font also performs text layout and mesh generation for strings of text.
---
---LÖVR uses a text rendering technique called "multichannel signed distance fields" (MSDF), which makes the font rendering remain crisp when text is viewed up close.
---
---
---### NOTE:
---MSDF text requires a special shader to work.
---
---LÖVR will automatically switch to this shader if no shader is active on the `Pass`.
---
---This font shader is also available as a `DefaultShader`.
---
---@class lovr.Font
local Font = {}

---
---Returns the ascent of the font.
---
---The ascent is the maximum amount glyphs ascend above the baseline.
---
---The units depend on the font's pixel density.
---
---With the default density, the units correspond to meters.
---
---@return number ascent # The ascent of the font.
function Font:getAscent() end

---
---Returns the descent of the font.
---
---The descent is the maximum amount glyphs descend below the baseline.
---
---The units depend on the font's pixel density.
---
---With the default density, the units correspond to meters.
---
---@return number descent # The descent of the font.
function Font:getDescent() end

---
---Returns the height of the font, sometimes also called the leading.
---
---This is the full height of a line of text, including the space between lines.
---
---Each line of a multiline string is separated on the y axis by this height, multiplied by the font's line spacing.
---
---The units depend on the font's pixel density.
---
---With the default density, the units correspond to meters.
---
---@return number height # The height of the font.
function Font:getHeight() end

---
---Returns the kerning between 2 glyphs.
---
---Kerning is a slight horizontal adjustment between 2 glyphs to improve the visual appearance.
---
---It will often be negative.
---
---The units depend on the font's pixel density.
---
---With the default density, the units correspond to meters.
---
---@overload fun(self: lovr.Font, firstCodepoint: number, second: string):number
---@overload fun(self: lovr.Font, first: string, secondCodepoint: number):number
---@overload fun(self: lovr.Font, firstCodepoint: number, secondCodepoint: number):number
---@param first string # The first character.
---@param second string # The second character.
---@return number keming # The kerning between the two glyphs.
function Font:getKerning(first, second) end

---
---Returns the line spacing of the Font.
---
---When spacing out lines, the height of the font is multiplied the line spacing to get the final spacing value.
---
---The default is 1.0.
---
---@return number spacing # The line spacing of the font.
function Font:getLineSpacing() end

---
---Returns a table of wrapped lines for a piece of text, given a line length limit.
---
---Newlines are handled correctly.
---
---The wrap limit units depend on the pixel density of the font.
---
---With the default pixel density, the units correspond to meters when the font is drawn at 1.0 scale.
---
---@overload fun(self: lovr.Font, strings: table, wrap: number):table
---@param string string # The text to wrap.
---@param wrap number # The line length to wrap at.
---@return table lines # A table strings, one for each wrapped line (without any color information).
function Font:getLines(string, wrap) end

---
---Returns the pixel density of the font.
---
---The density is a "pixels per world unit" factor that controls how the pixels in the font's texture are mapped to units in the coordinate space.
---
---The default pixel density is set to the height of the font.
---
---This means that lines of text rendered with a scale of 1.0 come out to 1 unit (meter) tall.
---
---However, if this font was drawn to a 2D texture where the units are in pixels, the font would still be drawn 1 unit (pixel) tall!  Scaling the coordinate space or the size of the text by the height of the font would fix this.
---
---However, a more convenient option is to set the pixel density of the font to 1.0 when doing 2D rendering to make the font's size match up with the pixels of the canvas.
---
---@return number density # The pixel density of the font.
function Font:getPixelDensity() end

---
---Returns the Rasterizer object backing the Font.
---
---@return lovr.Rasterizer rasterizer # The Rasterizer.
function Font:getRasterizer() end

---
---Returns a table of vertices for a piece of text, along with a Material to use when rendering it. The Material returned by this function may not be the same if the Font's texture atlas needs to be recreated with a bigger size to make room for more glyphs.
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
---@param halign lovr.HorizontalAlign # The horizontal align.
---@param valign lovr.VerticalAlign # The vertical align.
---@return table vertices # The table of vertices.  See below for the format of each vertex.
---@return lovr.Material material # A Material to use when rendering the vertices.
function Font:getVertices(halign, valign) end

---
---Returns the maximum width of a piece of text.
---
---This function does not perform wrapping but does respect newlines in the text.
---
---@overload fun(self: lovr.Font, strings: table):number
---@param string string # The text to measure.
---@return number width # The maximum width of the text.
function Font:getWidth(string) end

---
---Sets the line spacing of the Font.
---
---When spacing out lines, the height of the font is multiplied by the line spacing to get the final spacing value.
---
---The default is 1.0.
---
---@param spacing number # The new line spacing.
function Font:setLineSpacing(spacing) end

---
---Sets the pixel density of the font.
---
---The density is a "pixels per world unit" factor that controls how the pixels in the font's texture are mapped to units in the coordinate space.
---
---The default pixel density is set to the height of the font.
---
---This means that lines of text rendered with a scale of 1.0 come out to 1 unit (meter) tall.
---
---However, if this font was drawn to a 2D texture where the units are in pixels, the font would still be drawn 1 unit (pixel) tall!  Scaling the coordinate space or the size of the text by the height of the font would fix this.
---
---However, a more convenient option is to set the pixel density of the font to 1.0 when doing 2D rendering to make the font's size match up with the pixels of the canvas.
---
---@overload fun(self: lovr.Font)
---@param density number # The new pixel density of the font.
function Font:setPixelDensity(density) end

---
---Materials are a set of properties and textures that define the properties of a surface, like what color it is, how bumpy or shiny it is, etc. `Shader` code can use the data from a material to compute lighting.
---
---Materials are immutable, and can't be changed after they are created.
---
---Instead, a new Material should be created with the updated properties.
---
---`Pass:setMaterial` changes the active material, causing it to affect rendering until the active material is changed again.
---
---Using material objects is optional.
---
---`Pass:setMaterial` can take a `Texture`, and `Pass:setColor` can change the color of objects, so basic tinting and texturing of surfaces does not require a full material to be created.
---
---Also, a custom material system could be developed by sending textures and other data to shaders manually.
---
---`Model` objects will create materials for all of the materials defined in the model file.
---
---In shader code, non-texture material properties can be accessed as `Material.<property>`, and material textures can be accessed as `<Type>Texture`, e.g. `RoughnessTexture`.
---
---@class lovr.Material
local Material = {}

---
---Returns the properties of the Material in a table.
---
---@return table properties # The Material properties.
function Material:getProperties() end

---
---Models are 3D model assets loaded from files.
---
---Currently, OBJ, glTF, and binary STL files are supported.
---
---A model can be drawn using `Pass:draw`.
---
---The raw CPU data for a model is held in a `ModelData` object, which can be loaded on threads or reused for multiple Model instances.
---
---Models have a hierarchy of nodes which can have their transforms modified.
---
---Meshes are attached to these nodes.
---
---The same mesh can be attached to multiple nodes, allowing it to be drawn multiple times while only storing a single copy of its data.
---
---Models can have animations.
---
---Animations have keyframes which affect the transforms of nodes. Right now each model can only be drawn with a single animated pose per frame.
---
---Models can have materials, which are collections of properties and textures that define how its surface is affected by lighting.
---
---Each mesh in the model can use a single material.
---
---@class lovr.Model
local Model = {}

---
---Animates a Model by setting or blending the transforms of nodes using data stored in the keyframes of an animation.
---
---The animation from the model file is evaluated at the timestamp, resulting in a set of node properties.
---
---These properties are then applied to the nodes in the model, using an optional blend factor.
---
---If the animation doesn't have keyframes that target a given node, the node will remain unchanged.
---
---
---### NOTE:
---If the timestamp is larger than the duration of the animation, it will wrap back around to zero, so looping an animation doesn't require using the modulo operator.
---
---To change the speed of the animation, multiply the timestamp by a speed factor.
---
---For each animated property in the animation, if the timestamp used for the animation is less than the timestamp of the first keyframe, the data of the first keyframe will be used.
---
---This function can be called multiple times to layer and blend animations.
---
---The model joints will be drawn in the final resulting pose.
---
---`Model:resetNodeTransforms` can be used to reset the model nodes to their initial transforms, which is helpful to ensure animating starts from a clean slate.
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
---Returns the duration of an animation in the Model, in seconds.
---
---
---### NOTE:
---The duration of an animation is calculated as the largest timestamp of all of its keyframes.
---
---@overload fun(self: lovr.Model, name: string):number
---@param index number # The animation index.
---@return number duration # The duration of the animation, in seconds.
function Model:getAnimationDuration(index) end

---
---Returns the name of an animation in the Model.
---
---@param index number # The index of an animation.
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
---Returns the index buffer used by the Model.
---
---The index buffer describes the order used to draw the vertices in each mesh.
---
---@return lovr.Buffer buffer # The index buffer.
function Model:getIndexBuffer() end

---
---Returns a `Material` loaded from the Model.
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
---Returns the name of a material in the Model.
---
---@param index number # The index of a material.
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
---Returns the draw mode, material, and vertex range of a mesh in the model.
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
---Returns the number of meshes attached to a node.
---
---Each mesh is drawn individually.
---
---@overload fun(self: lovr.Model, name: string):number
---@param index number # The index of a node.
---@return number count # The number of draws in the node.
function Model:getNodeDrawCount(index) end

---
---Returns the name of a node.
---
---@param index number # The index of the node.
---@return string name # The name of the node.
function Model:getNodeName(index) end

---
---Returns the orientation of a node.
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
---Returns the pose (position and orientation) of a node.
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
---Returns the position of a node.
---
---@overload fun(self: lovr.Model, name: string, space?: lovr.OriginType):number, number, number
---@param index number # The index of the node.
---@param space? lovr.OriginType # Whether the position should be returned relative to the root node or the node's parent.
---@return number x # The x coordinate.
---@return number y # The y coordinate.
---@return number z # The z coordinate.
function Model:getNodePosition(index, space) end

---
---Returns the scale of a node.
---
---@overload fun(self: lovr.Model, name: string, origin?: lovr.OriginType):number, number, number
---@param index number # The index of the node.
---@param origin? lovr.OriginType # Whether the scale should be returned relative to the root node or the node's parent.
---@return number x # The x scale.
---@return number y # The y scale.
---@return number z # The z scale.
function Model:getNodeScale(index, origin) end

---
---Returns the transform (position, scale, and rotation) of a node.
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
---Returns one of the textures in the Model.
---
---@param index number # The index of the texture to get.
---@return lovr.Texture texture # The texture.
function Model:getTexture(index) end

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
---Returns a `Buffer` that holds the vertices of all of the meshes in the Model.
---
---@return lovr.Buffer buffer # The vertex buffer.
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
---Returns whether the Model has any skeletal animations.
---
---
---### NOTE:
---This will return when there's at least one skin in the model, as returned by `ModelData:getSkinCount`.
---
---Even if this function returns true, the model could still have non-skeletal animations.
---
---Right now a model can only be drawn with one skeletal pose per frame.
---
---@return boolean jointed # Whether the animation uses joint nodes for skeletal animation.
function Model:hasJoints() end

---
---Resets node transforms to the original ones defined in the model file.
---
function Model:resetNodeTransforms() end

---
---Sets or blends the orientation of a node to a new orientation.
---
---This sets the local orientation of the node, relative to its parent.
---
---@overload fun(self: lovr.Model, name: string, angle: number, ax: number, ay: number, az: number, blend?: number)
---@overload fun(self: lovr.Model, index: number, orientation: lovr.Quat, blend?: number)
---@overload fun(self: lovr.Model, name: string, orientation: lovr.Quat, blend?: number)
---@param index number # The index of the node.
---@param angle number # The number of radians the node should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@param blend? number # A number from 0 to 1 indicating how much of the target orientation to blend in.  A value of 0 will not change the node's orientation at all, whereas 1 will fully blend to the target orientation.
function Model:setNodeOrientation(index, angle, ax, ay, az, blend) end

---
---Sets or blends the pose (position and orientation) of a node to a new pose.
---
---This sets the local pose of the node, relative to its parent.
---
---The scale will remain unchanged.
---
---@overload fun(self: lovr.Model, name: string, x: number, y: number, z: number, angle: number, ax: number, ay: number, az: number, blend?: number)
---@overload fun(self: lovr.Model, index: number, position: lovr.Vec3, orientation: lovr.Quat, blend?: number)
---@overload fun(self: lovr.Model, name: string, position: lovr.Vec3, orientation: lovr.Quat, blend?: number)
---@param index number # The index of the node.
---@param x number # The x component of the position.
---@param y number # The y component of the position.
---@param z number # The z component of the position.
---@param angle number # The number of radians the node should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@param blend? number # A number from 0 to 1 indicating how much of the target pose to blend in.  A value of 0 will not change the node's pose at all, whereas 1 will fully blend to the target pose.
function Model:setNodePose(index, x, y, z, angle, ax, ay, az, blend) end

---
---Sets or blends the position of a node.
---
---This sets the local position of the node, relative to its parent.
---
---@overload fun(self: lovr.Model, name: string, x: number, y: number, z: number, blend?: number)
---@overload fun(self: lovr.Model, index: number, position: lovr.Vec3, blend?: number)
---@overload fun(self: lovr.Model, name: string, position: lovr.Vec3, blend?: number)
---@param index number # The index of the node.
---@param x number # The x coordinate of the new position.
---@param y number # The y coordinate of the new position.
---@param z number # The z coordinate of the new position.
---@param blend? number # A number from 0 to 1 indicating how much of the new position to blend in.  A value of 0 will not change the node's position at all, whereas 1 will fully blend to the target position.
function Model:setNodePosition(index, x, y, z, blend) end

---
---Sets or blends the scale of a node to a new scale.
---
---This sets the local scale of the node, relative to its parent.
---
---
---### NOTE:
---For best results when animating, it's recommended to keep the 3 scale components the same.
---
---@overload fun(self: lovr.Model, name: string, sx: number, sy: number, sz: number, blend?: number)
---@overload fun(self: lovr.Model, index: number, scale: lovr.Vec3, blend?: number)
---@overload fun(self: lovr.Model, name: string, scale: lovr.Vec3, blend?: number)
---@param index number # The index of the node.
---@param sx number # The x scale.
---@param sy number # The y scale.
---@param sz number # The z scale.
---@param blend? number # A number from 0 to 1 indicating how much of the new scale to blend in.  A value of 0 will not change the node's scale at all, whereas 1 will fully blend to the target scale.
function Model:setNodeScale(index, sx, sy, sz, blend) end

---
---Sets or blends the transform of a node to a new transform.
---
---This sets the local transform of the node, relative to its parent.
---
---
---### NOTE:
---For best results when animating, it's recommended to keep the 3 components of the scale the same.
---
---Even though the translation, scale, and rotation parameters are given in TSR order, they are applied in the normal TRS order.
---
---@overload fun(self: lovr.Model, name: string, x: number, y: number, z: number, sx: number, sy: number, sz: number, angle: number, ax: number, ay: number, az: number, blend?: number)
---@overload fun(self: lovr.Model, index: number, position: lovr.Vec3, scale: lovr.Vec3, orientation: lovr.Quat, blend?: number)
---@overload fun(self: lovr.Model, name: string, position: lovr.Vec3, scale: lovr.Vec3, orientation: lovr.Quat, blend?: number)
---@overload fun(self: lovr.Model, index: number, transform: lovr.Mat4, blend?: number)
---@overload fun(self: lovr.Model, name: string, transform: lovr.Mat4, blend?: number)
---@param index number # The index of the node.
---@param x number # The x component of the position.
---@param y number # The y component of the position.
---@param z number # The z component of the position.
---@param sx number # The x component of the scale.
---@param sy number # The y component of the scale.
---@param sz number # The z component of the scale.
---@param angle number # The number of radians the node should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@param blend? number # A number from 0 to 1 indicating how much of the target transform to blend in.  A value of 0 will not change the node's transform at all, whereas 1 will fully blend to the target transform.
function Model:setNodeTransform(index, x, y, z, sx, sy, sz, angle, ax, ay, az, blend) end

---
---Pass objects are used to record commands for the GPU.
---
---Commands can be recorded by calling functions on the Pass.
---
---After recording a set of passes, they can be submitted for the GPU to process using `lovr.graphics.submit`.
---
---Pass objects are **temporary** and only exist for a single frame.
---
---Once `lovr.graphics.submit` is called to end the frame, any passes that were created during that frame become **invalid**. Each frame, a new set of passes must be created and recorded.
---
---LÖVR tries to detect if you use a pass after it's invalid, but this error checking is not 100% accurate at the moment.
---
---There are 3 types of passes.
---
---Each type can record a specific type of command:
---
---- `render` passes render graphics to textures.
---- `compute` passes run compute shaders.
---- `transfer` passes can transfer data to/from GPU objects, like `Buffer` and `Texture`.
---
---@class lovr.Pass
local Pass = {}

---
---Copies data between textures.
---
---Similar to `Pass:copy`, except the source and destination sizes can be different.
---
---The pixels from the source texture will be scaled to the destination size. This can only be called on a transfer pass, which can be created with `lovr.graphics.getPass`.
---
---
---### NOTE:
---When blitting between 3D textures, the layer counts do not need to match, and the layers will be treated as a continuous axis (i.e. pixels will be smoothed between layers).
---
---When blitting between array textures, the layer counts must match, and the blit occurs as a sequence of distinct 2D blits layer-by-layer.
---
---@param src lovr.Texture # The texture to copy from.
---@param dst lovr.Texture # The texture to copy to.
---@param srcx? number # The x offset from the left of the source texture to blit from, in pixels.
---@param srcy? number # The y offset from the top of the source texture to blit from, in pixels.
---@param srcz? number # The index of the first layer in the source texture to blit from.
---@param dstx? number # The x offset from the left of the destination texture to blit to, in pixels.
---@param dsty? number # The y offset from the top of the destination texture to blit to, in pixels.
---@param dstz? number # The index of the first layer in the destination texture to blit to.
---@param srcw? number # The width of the region in the source texture to blit.  If nil, the region will extend to the right side of the texture.
---@param srch? number # The height of the region in the source texture to blit.  If nil, the region will extend to the bottom of the texture.
---@param srcd? number # The number of layers in the source texture to blit.
---@param dstw? number # The width of the region in the destination texture to blit to.  If nil, the region will extend to the right side of the texture.
---@param dsth? number # The height of the region in the destination texture to blit to.  If nil, the region will extend to the bottom of the texture.
---@param dstd? number # The number of the layers in the destination texture to blit to.
---@param srclevel? number # The index of the mipmap level in the source texture to blit from.
---@param dstlevel? number # The index of the mipmap level in the destination texture to blit to.
---@param filter? lovr.FilterMode # The filtering algorithm used when rescaling.
function Pass:blit(src, dst, srcx, srcy, srcz, dstx, dsty, dstz, srcw, srch, srcd, dstw, dsth, dstd, srclevel, dstlevel, filter) end

---
---Draw a box.
---
---This is like `Pass:cube`, except it takes 3 separate values for the scale.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, size: lovr.Vec3, orientation: lovr.Quat, style?: lovr.DrawStyle)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, style?: lovr.DrawStyle)
---@param x? number # The x coordinate of the center of the box.
---@param y? number # The y coordinate of the center of the box.
---@param z? number # The z coordinate of the center of the box.
---@param width? number # The width of the box.
---@param height? number # The height of the box.
---@param depth? number # The depth of the box.
---@param angle? number # The rotation of the box around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param style? lovr.DrawStyle # Whether the box should be drawn filled or outlined.
function Pass:box(x, y, z, width, height, depth, angle, ax, ay, az, style) end

---
---Draws a capsule.
---
---A capsule is shaped like a cylinder with a hemisphere on each end.
---
---
---### NOTE:
---The length of the capsule does not include the end caps.
---
---The local origin of the capsule is in the center, and the local z axis points towards the end caps.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, scale: lovr.Vec3, orientation: lovr.Quat, segments?: number)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, segments?: number)
---@overload fun(self: lovr.Pass, p1: lovr.Vec3, p2: lovr.Vec3, radius?: number, segments?: number)
---@param x? number # The x coordinate of the center of the capsule.
---@param y? number # The y coordinate of the center of the capsule.
---@param z? number # The z coordinate of the center of the capsule.
---@param radius? number # The radius of the capsule.
---@param length? number # The length of the capsule.
---@param angle? number # The rotation of the capsule around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param segments? number # The number of circular segments to render.
function Pass:capsule(x, y, z, radius, length, angle, ax, ay, az, segments) end

---
---Draws a circle.
---
---
---### NOTE:
---The local origin of the circle is in its center.
---
---The local z axis is perpendicular to the circle.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, radius?: number, orientation: lovr.Quat, style?: lovr.DrawStyle, angle1?: number, angle2?: number, segments?: number)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, style?: lovr.DrawStyle, angle1?: number, angle2?: number, segments?: number)
---@param x? number # The x coordinate of the center of the circle.
---@param y? number # The y coordinate of the center of the circle.
---@param z? number # The z coordinate of the center of the circle.
---@param radius? number # The radius of the circle.
---@param angle? number # The rotation of the circle around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param style? lovr.DrawStyle # Whether the circle should be filled or outlined.
---@param angle1? number # The angle of the beginning of the arc.
---@param angle2? number # angle of the end of the arc.
---@param segments? number # The number of segments to render.
function Pass:circle(x, y, z, radius, angle, ax, ay, az, style, angle1, angle2, segments) end

---
---Clears a Buffer or Texture.
---
---This can only be called on a transfer pass, which can be created with `lovr.graphics.getPass`.
---
---@overload fun(self: lovr.Pass, texture: lovr.Texture, color: lovr.Vec4, layer?: number, layers?: number, level?: number, levels?: number)
---@param buffer lovr.Buffer # The Buffer to clear.
---@param index? number # The index of the first item to clear.
---@param count? number # The number of items to clear.  If `nil`, clears to the end of the Buffer.
function Pass:clear(buffer, index, count) end

---
---Runs a compute shader.
---
---Before calling this, a compute shader needs to be active, using `Pass:setShader`.
---
---This can only be called on a Pass with the `compute` type, which can be created using `lovr.graphics.getPass`.
---
---
---### NOTE:
---Usually compute shaders are run many times in parallel: once for each pixel in an image, once per particle, once per object, etc.
---
---The 3 arguments represent how many times to run, or "dispatch", the compute shader, in up to 3 dimensions.
---
---Each element of this grid is called a **workgroup**.
---
---To make things even more complicated, each workgroup itself is made up of a set of "mini GPU threads", which are called **local workgroups**.
---
---Like workgroups, the local workgroup size can also be 3D.
---
---It's declared in the shader code, like this:
---
---    layout(local_size_x = w, local_size_y = h, local_size_z = d) in;
---
---All these 3D grids can get confusing, but the basic idea is to make the local workgroup size a small block of e.g. 32 particles or 8x8 pixels or 4x4x4 voxels, and then dispatch however many workgroups are needed to cover a list of particles, image, voxel field, etc.
---
---The reason to do it this way is that the GPU runs its threads in little fixed-size bundles called subgroups.
---
---Subgroups are usually 32 or 64 threads (the exact size is given by the `subgroupSize` property of `lovr.graphics.getDevice`) and all run together.
---
---If the local workgroup size was `1x1x1`, then the GPU would only run 1 thread per subgroup and waste the other 31 or 63.
---
---So for the best performance, be sure to set a local workgroup size bigger than 1!
---
---Inside the compute shader, a few builtin variables can be used to figure out which workgroup is running:
---
---- `uvec3 WorkgroupCount` is the workgroup count per axis (the `Pass:compute` arguments).
---- `uvec3 WorkgroupSize` is the local workgroup size (declared in the shader).
---- `uvec3 WorkgroupID` is the index of the current (global) workgroup.
---- `uvec3 LocalThreadID` is the index of the local workgroup inside its workgroup.
---- `uint LocalThreadIndex` is a 1D version of `LocalThreadID`.
---- `uvec3 GlobalThreadID` is the unique identifier for a thread within all workgroups in a
---  dispatch. It's equivalent to `WorkgroupID * WorkgroupSize + LocalThreadID` (usually what you
---  want!)
---
---Indirect compute dispatches are useful to "chain" compute shaders together, while keeping all of the data on the GPU.
---
---The first dispatch can do some computation and write some results to buffers, then the second indirect dispatch can use the data in those buffers to know how many times it should run.
---
---An example would be a compute shader that does some sort of object culling, writing the number of visible objects to a buffer along with the IDs of each one. Subsequent compute shaders can be indirectly dispatched to perform extra processing on the visible objects.
---
---Finally, an indirect draw can be used to render them.
---
---@overload fun(self: lovr.Pass, buffer: lovr.Buffer, offset?: number)
---@param x? number # The number of workgroups to dispatch in the x dimension.
---@param y? number # The number of workgroups to dispatch in the y dimension.
---@param z? number # The number of workgroups to dispatch in the z dimension.
function Pass:compute(x, y, z) end

---
---Draws a cone.
---
---
---### NOTE:
---The local origin is at the center of the base of the cone, and the negative z axis points towards the tip.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, scale: lovr.Vec3, orientation: lovr.Quat, segments?: number)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, segments?: number)
---@param x? number # The x coordinate of the center of the base of the cone.
---@param y? number # The y coordinate of the center of the base of the cone.
---@param z? number # The z coordinate of the center of the base of the cone.
---@param radius? number # The radius of the cone.
---@param length? number # The length of the cone.
---@param angle? number # The rotation of the cone around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param segments? number # The number of segments in the cone.
function Pass:cone(x, y, z, radius, length, angle, ax, ay, az, segments) end

---
---Copies data to or between `Buffer` and `Texture` objects.
---
---This can only be called on a transfer pass, which can be created with `lovr.graphics.getPass`.
---
---@overload fun(self: lovr.Pass, blob: lovr.Blob, bufferdst: lovr.Buffer, srcoffset?: number, dstoffset?: number, size?: number)
---@overload fun(self: lovr.Pass, buffersrc: lovr.Buffer, bufferdst: lovr.Buffer, srcoffset?: number, dstoffset?: number, size?: number)
---@overload fun(self: lovr.Pass, image: lovr.Image, texturedst: lovr.Texture, srcx?: number, srcy?: number, dstx?: number, dsty?: number, width?: number, height?: number, srclayer?: number, dstlayer?: number, layers?: number, srclevel?: number, dstlevel?: number)
---@overload fun(self: lovr.Pass, texturesrc: lovr.Texture, texturedst: lovr.Texture, srcx?: number, srcy?: number, dstx?: number, dsty?: number, width?: number, height?: number, srclayer?: number, dstlayer?: number, layers?: number, srclevel?: number, dstlevel?: number)
---@overload fun(self: lovr.Pass, tally: lovr.Tally, bufferdst: lovr.Buffer, srcindex?: number, dstoffset?: number, count?: number)
---@param table table # A table to copy to the buffer.
---@param bufferdst lovr.Buffer # The buffer to copy to.
---@param srcindex? number # The index of the first item to begin copying from.
---@param dstindex? number # The index of the first item in the buffer to begin copying to.
---@param count? number # The number of items to copy.  If nil, copies as many items as possible.
function Pass:copy(table, bufferdst, srcindex, dstindex, count) end

---
---Draws a cube.
---
---
---### NOTE:
---The local origin is in the center of the cube.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, size?: number, orientation: lovr.Quat, style?: lovr.DrawStyle)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, style?: lovr.DrawStyle)
---@param x? number # The x coordinate of the center of the cube.
---@param y? number # The y coordinate of the center of the cube.
---@param z? number # The z coordinate of the center of the cube.
---@param size? number # The size of the cube.
---@param angle? number # The rotation of the cube around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param style? lovr.DrawStyle # Whether the cube should be drawn filled or outlined.
function Pass:cube(x, y, z, size, angle, ax, ay, az, style) end

---
---Draws a cylinder.
---
---
---### NOTE:
---The local origin is in the center of the cylinder, and the length of the cylinder is along the z axis.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, scale: lovr.Vec3, orientation: lovr.Quat, capped?: boolean, angle1?: number, angle2?: number, segments?: number)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, capped?: boolean, angle1?: number, angle2?: number, segments?: number)
---@overload fun(self: lovr.Pass, p1: lovr.Vec3, p2: lovr.Vec3, radius?: number, capped?: boolean, angle1?: number, angle2?: number, segments?: number)
---@param x? number # The x coordinate of the center of the cylinder.
---@param y? number # The y coordinate of the center of the cylinder.
---@param z? number # The z coordinate of the center of the cylinder.
---@param radius? number # The radius of the cylinder.
---@param length? number # The length of the cylinder.
---@param angle? number # The rotation of the cylinder around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param capped? boolean # Whether the tops and bottoms of the cylinder should be rendered.
---@param angle1? number # The angle of the beginning of the arc.
---@param angle2? number # angle of the end of the arc.
---@param segments? number # The number of circular segments to render.
function Pass:cylinder(x, y, z, radius, length, angle, ax, ay, az, capped, angle1, angle2, segments) end

---
---Draws a model.
---
---@overload fun(self: lovr.Pass, model: lovr.Model, position: lovr.Vec3, scale?: number, orientation: lovr.Quat, nodeindex?: number, children?: boolean, instances?: number)
---@overload fun(self: lovr.Pass, model: lovr.Model, transform: lovr.Mat4, nodeindex?: number, children?: boolean, instances?: number)
---@overload fun(self: lovr.Pass, model: lovr.Model, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number, nodename?: string, children?: boolean, instances?: number)
---@overload fun(self: lovr.Pass, model: lovr.Model, position: lovr.Vec3, scale?: number, orientation: lovr.Quat, nodename?: string, children?: boolean, instances?: number)
---@overload fun(self: lovr.Pass, model: lovr.Model, transform: lovr.Mat4, nodename?: string, children?: boolean, instances?: number)
---@param model lovr.Model # The model to draw.
---@param x? number # The x coordinate to draw the model at.
---@param y? number # The y coordinate to draw the model at.
---@param z? number # The z coordinate to draw the model at.
---@param scale? number # The scale of the model.
---@param angle? number # The rotation of the model around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param nodeindex? number # The index of the node to draw.  If nil, the root node is drawn.
---@param children? boolean # Whether the children of the node should be drawn.
---@param instances? number # The number of instances to draw.
function Pass:draw(model, x, y, z, scale, angle, ax, ay, az, nodeindex, children, instances) end

---
---Draws a fullscreen triangle.
---
---The `fill` shader is used, which stretches the triangle across the screen.
---
---
---### NOTE:
---This function has some special behavior for array textures:
---
---- Filling a single-layer texture to a multi-layer canvas will mirror the texture to all layers,
---  just like regular drawing.
---- Filling a 2-layer texture to a mono canvas will render the 2 layers side-by-side.
---- Filling a multi-layer texture to a multi-layer canvas will do a layer-by-layer fill (the layer
---  counts must match).
---
---@overload fun(self: lovr.Pass)
---@param texture lovr.Texture # The texture to fill.  If nil, the texture from the active material is used.
function Pass:fill(texture) end

---
---Returns the clear values of the pass.
---
---@return table clears # The clear values for the pass.  Numeric keys will contain clear values for color textures, either as a table of r, g, b, a values or a boolean.  If the pass has a depth texture, there will also be `depth` and `stencil` keys containing the clear values or booleans.
function Pass:getClear() end

---
---Returns the dimensions of the textures attached to the render pass.
---
---
---### NOTE:
---If the pass is not a render pass, this function returns zeros.
---
---@return number width # The texture width.
---@return number height # The texture height.
function Pass:getDimensions() end

---
---Returns the height of the textures attached to the render pass.
---
---
---### NOTE:
---If the pass is not a render pass, this function returns zero.
---
---@return number height # The texture height.
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
---Returns the antialiasing setting of a render pass.
---
---@return number samples # The number of samples used for rendering.  Currently, will be 1 or 4.
function Pass:getSampleCount() end

---
---Returns the textures a render pass is rendering to.
---
---@return table target # A table of the color textures targeted by the pass, with an additional `depth` key if the pass has a depth texture.
function Pass:getTarget() end

---
---Returns the type of the pass (render, compute, or transfer).
---
---The type restricts what kinds of functions can be called on the pass.
---
---@return lovr.PassType type # The type of the Pass.
function Pass:getType() end

---
---Returns the view count of a render pass.
---
---This is the layer count of the textures it is rendering to.
---
---
---### NOTE:
---A render pass has one "camera" for each view.
---
---Whenever something is drawn, it is broadcast to each view (layer) of each texture, using the corresponding camera.
---
---@return number views # The view count.
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
---Returns the width of the textures attached to the render pass.
---
---
---### NOTE:
---If the pass is not a render pass, this function returns zero.
---
---@return number width # The texture width.
function Pass:getWidth() end

---
---Draws a line between points.
---
---`Pass:mesh` can also be used to draw line segments using the `line` `MeshMode`.
---
---
---### NOTE:
---There is currently no way to increase line thickness.
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
---Draws a mesh.
---
---
---### NOTE:
---The index buffer defines the order the vertices are drawn in.
---
---It can be used to reorder, reuse, or omit vertices from the mesh.
---
---When drawing without a vertex buffer, the `VertexIndex` variable can be used in shaders to compute the position of each vertex, possibly by reading data from other `Buffer` or `Texture` resources.
---
---The active `MeshMode` controls whether the vertices are drawn as points, lines, or triangles.
---
---The active `Material` is applied to the mesh.
---
---@overload fun(self: lovr.Pass, vertices?: lovr.Buffer, position: lovr.Vec3, scales: lovr.Vec3, orientation: lovr.Quat, start?: number, count?: number, instances?: number)
---@overload fun(self: lovr.Pass, vertices?: lovr.Buffer, transform: lovr.Mat4, start?: number, count?: number, instances?: number)
---@overload fun(self: lovr.Pass, vertices?: lovr.Buffer, indices: lovr.Buffer, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number, start?: number, count?: number, instances?: number, base?: number)
---@overload fun(self: lovr.Pass, vertices?: lovr.Buffer, indices: lovr.Buffer, position: lovr.Vec3, scales: lovr.Vec3, orientation: lovr.Quat, start?: number, count?: number, instances?: number, base?: number)
---@overload fun(self: lovr.Pass, vertices?: lovr.Buffer, indices: lovr.Buffer, transform: lovr.Mat4, start?: number, count?: number, instances?: number, base?: number)
---@overload fun(self: lovr.Pass, vertices?: lovr.Buffer, indices: lovr.Buffer, draws: lovr.Buffer, drawcount: number, offset: number, stride: number)
---@param vertices? lovr.Buffer # The buffer containing the vertices to draw.
---@param x? number # The x coordinate of the position to draw the mesh at.
---@param y? number # The y coordinate of the position to draw the mesh at.
---@param z? number # The z coordinate of the position to draw the mesh at.
---@param scale? number # The scale of the mesh.
---@param angle? number # The number of radians the mesh is rotated around its rotational axis.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param start? number # The 1-based index of the first vertex to render from the vertex buffer (or the first index, when using an index buffer).
---@param count? number # The number of vertices to render (or the number of indices, when using an index buffer). When `nil`, as many vertices or indices as possible will be drawn (based on the length of the Buffers and `start`).
---@param instances? number # The number of copies of the mesh to render.
function Pass:mesh(vertices, x, y, z, scale, angle, ax, ay, az, start, count, instances) end

---
---Generates mipmaps for a texture.
---
---This can only be called on a transfer pass, which can be created with `lovr.graphics.getPass`.
---
---When rendering to textures with a render pass, it's also possible to automatically regenerate mipmaps after rendering by adding the `mipmaps` flag when creating the pass.
---
---@param texture lovr.Texture # The texture to mipmap.
---@param base? number # The index of the mipmap used to generate the remaining mipmaps.
---@param count? number # The number of mipmaps to generate.  If nil, generates the remaining mipmaps.
function Pass:mipmap(texture, base, count) end

---
---Resets the transform back to the origin.
---
function Pass:origin() end

---
---Draws a plane.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, size: lovr.Vec2, orientation: lovr.Quat, style?: lovr.DrawStyle, columns?: number, rows?: number)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, style?: lovr.DrawStyle, columns?: number, rows?: number)
---@param x? number # The x coordinate of the center of the plane.
---@param y? number # The y coordinate of the center of the plane.
---@param z? number # The z coordinate of the center of the plane.
---@param width? number # The width of the plane.
---@param height? number # The height of the plane.
---@param angle? number # The rotation of the plane around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param style? lovr.DrawStyle # Whether the plane should be drawn filled or outlined.
---@param columns? number # The number of horizontal segments in the plane.
---@param rows? number # The number of vertical segments in the plane.
function Pass:plane(x, y, z, width, height, angle, ax, ay, az, style, columns, rows) end

---
---Draws points.
---
---`Pass:mesh` can also be used to draw points using a `Buffer`.
---
---
---### NOTE:
---To change the size of points, set the `pointSize` shader flag in `lovr.graphics.newShader` or write to the `PointSize` variable in the vertex shader.
---
---Points are always the same size on the screen, regardless of distance, and the units are in pixels.
---
---@overload fun(self: lovr.Pass, t: table)
---@overload fun(self: lovr.Pass, v: lovr.Vec3, ...)
---@param x number # The x coordinate of the first point.
---@param y number # The y coordinate of the first point.
---@param z number # The z coordinate of the first point.
---@vararg any # More points.
function Pass:points(x, y, z, ...) end

---
---Pops the transform or render state stack, restoring it to the state it was in when it was last pushed.
---
---
---### NOTE:
---If a stack is popped without a corresponding push, the stack "underflows" which causes an error.
---
---@param stack? lovr.StackType # The type of stack to pop.
function Pass:pop(stack) end

---
---Saves a copy of the transform or render states.
---
---Further changes can be made to the transform or render states, and afterwards `Pass:pop` can be used to restore the original state.
---
---Pushes and pops can be nested, but it's an error to pop without a corresponding push.
---
---
---### NOTE:
---Each stack has a limit of the number of copies it can store.
---
---There can be 16 transforms and 4 render states saved.
---
---The `state` stack does not save the camera info or shader variables changed with `Pass:send`.
---
---@param stack? lovr.StackType # The type of stack to push.
function Pass:push(stack) end

---
---Creates a `Readback` object which asynchronously downloads data from a `Buffer`, `Texture`, or `Tally`.
---
---The readback can be polled for completion, or, after this transfer pass is submitted, `Readback:wait` can be used to block until the download is complete.
---
---This can only be called on a transfer pass, which can be created with `lovr.graphics.getPass`.
---
---@overload fun(self: lovr.Pass, texture: lovr.Texture, x?: number, y?: number, layer?: number, level?: number, width?: number, height?: number):lovr.Readback
---@overload fun(self: lovr.Pass, tally: lovr.Tally, index: number, count: number):lovr.Readback
---@param buffer lovr.Buffer # The Buffer to download data from.
---@param index number # The index of the first item to download.
---@param count number # The number of items to download.
---@return lovr.Readback readback # The new readback.
function Pass:read(buffer, index, count) end

---
---Rotates the coordinate system.
---
---@overload fun(self: lovr.Pass, rotation: lovr.Quat)
---@param angle number # The amount to rotate the coordinate system by, in radians.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Pass:rotate(angle, ax, ay, az) end

---
---Scales the coordinate system.
---
---@overload fun(self: lovr.Pass, scale: lovr.Vec3)
---@param sx number # The x component of the scale.
---@param sy number # The y component of the scale.
---@param sz number # The z component of the scale.
function Pass:scale(sx, sy, sz) end

---
---Sends a value to a variable in the Pass's active `Shader`.
---
---The active shader is changed using using `Pass:setShader`.
---
---
---### NOTE:
---Shader variables can be in different "sets".
---
---Variables changed by this function must be in set #2, because LÖVR uses set #0 and set #1 internally.
---
---The new value will persist until a new shader is set that uses a different "type" for the binding number of the variable.
---
---See `Pass:setShader` for more details.
---
---@overload fun(self: lovr.Pass, name: string, texture: lovr.Texture)
---@overload fun(self: lovr.Pass, name: string, sampler: lovr.Sampler)
---@overload fun(self: lovr.Pass, name: string, constant: any)
---@overload fun(self: lovr.Pass, binding: number, buffer: lovr.Buffer, offset?: number, extent?: number)
---@overload fun(self: lovr.Pass, binding: number, texture: lovr.Texture)
---@overload fun(self: lovr.Pass, binding: number, sampler: lovr.Sampler)
---@param name string # The name of the Shader variable.
---@param buffer lovr.Buffer # The Buffer to assign.
---@param offset? number # An offset from the start of the buffer where data will be read, in bytes.
---@param extent? number # The number of bytes that will be available for reading.  If zero, as much data as possible will be bound, depending on the offset, buffer size, and the `uniformBufferRange` or `storageBufferRange` limit.
function Pass:send(name, buffer, offset, extent) end

---
---Sets whether alpha to coverage is enabled.
---
---Alpha to coverage factors the alpha of a pixel into antialiasing calculations.
---
---It can be used to get antialiased edges on textures with transparency.
---
---It's often used for foliage.
---
---
---### NOTE:
---By default, alpha to coverage is disabled.
---
---@param enable boolean # Whether alpha to coverage should be enabled.
function Pass:setAlphaToCoverage(enable) end

---
---Sets the blend mode.
---
---When a pixel is drawn, the blend mode controls how it is mixed with the color and alpha of the pixel underneath it.
---
---
---### NOTE:
---The default blend mode is `alpha` with the `alphamultiply` alpha mode.
---
---@overload fun(self: lovr.Pass)
---@param blend lovr.BlendMode # The blend mode.
---@param alphaBlend lovr.BlendAlphaMode # The alpha blend mode, used to control premultiplied alpha.
function Pass:setBlendMode(blend, alphaBlend) end

---
---Sets the color used for drawing.
---
---Color components are from 0 to 1.
---
---
---### NOTE:
---The default color is `(1, 1, 1, 1)`.
---
---@overload fun(self: lovr.Pass, t: table)
---@overload fun(self: lovr.Pass, hex: number, a?: number)
---@param r number # The red component of the color.
---@param g number # The green component of the color.
---@param b number # The blue component of the color.
---@param a? number # The alpha component of the color.
function Pass:setColor(r, g, b, a) end

---
---Sets the color channels affected by drawing, on a per-channel basis.
---
---Disabling color writes is often used to render to the depth or stencil buffer without affecting existing pixel colors.
---
---
---### NOTE:
---By default, color writes are enabled for all channels.
---
---@overload fun(self: lovr.Pass, r: boolean, g: boolean, b: boolean, a: boolean)
---@param enable boolean # Whether all color components should be affected by draws.
function Pass:setColorWrite(enable) end

---
---Sets whether the front or back faces of triangles are culled.
---
---
---### NOTE:
---The default cull mode is `none`.
---
---@param mode? lovr.CullMode # Whether `front` faces, `back` faces, or `none` of the faces should be culled.
function Pass:setCullMode(mode) end

---
---Enables or disables depth clamp.
---
---Normally, when pixels fall outside of the clipping planes, they are clipped (not rendered).
---
---Depth clamp will instead render these pixels, clamping their depth on to the clipping planes.
---
---
---### NOTE:
---This isn\'t supported on all GPUs.
---
---Use the `depthClamp` feature of `lovr.graphics.getFeatures` to check for support.
---
---If depth clamp is enabled when unsupported, it will silently fall back to depth clipping.
---
---Depth clamping is not enabled by default.
---
---@param enable boolean # Whether depth clamp should be enabled.
function Pass:setDepthClamp(enable) end

---
---Set the depth offset.
---
---This is a constant offset added to the depth value of pixels.
---
---It can be used to fix Z fighting when rendering decals or other nearly-overlapping objects.
---
---
---### NOTE:
---The default depth offset is zero for both values.
---
---@param offset? number # The depth offset.
---@param sloped? number # The sloped depth offset.
function Pass:setDepthOffset(offset, sloped) end

---
---Sets the depth test.
---
---
---### NOTE:
---When using LÖVR's default projection (reverse Z with infinite far plane) the default depth test is `gequal`, depth values of 0.0 are on the far plane and depth values of 1.0 are on the near plane, closer to the camera.
---
---A depth buffer must be present to use the depth test, but this is enabled by default.
---
---@overload fun(self: lovr.Pass)
---@param test lovr.CompareMode # The new depth test to use.
function Pass:setDepthTest(test) end

---
---Sets whether draws write to the depth buffer.
---
---When a pixel is drawn, if depth writes are enabled and the pixel passes the depth test, the depth buffer will be updated with the pixel's depth value.
---
---
---### NOTE:
---The default depth write is `true`.
---
---@param write boolean # Whether the depth buffer should be affected by draws.
function Pass:setDepthWrite(write) end

---
---Sets the font used for `Pass:text`.
---
---@param font lovr.Font # The Font to use when rendering text.
function Pass:setFont(font) end

---
---Sets the material.
---
---This will apply to most drawing, except for text, skyboxes, and models, which use their own materials.
---
---@overload fun(self: lovr.Pass, texture: lovr.Texture)
---@overload fun(self: lovr.Pass)
---@param material lovr.Material # The material to use for drawing.
function Pass:setMaterial(material) end

---
---Changes the way vertices are connected together when drawing using `Pass:mesh`.
---
---
---### NOTE:
---The default mesh mode is `triangles`.
---
---@param mode lovr.MeshMode # The mesh mode to use.
function Pass:setMeshMode(mode) end

---
---Sets the projection for a single view.
---
---4 field of view angles can be used, similar to the field of view returned by `lovr.headset.getViewAngles`.
---
---Alternatively, a projection matrix can be used for other types of projections like orthographic, oblique, etc.
---
---Up to 6 views are supported.
---
---The Pass returned by `lovr.headset.getPass` will have its views automatically configured to match the headset.
---
---
---### NOTE:
---A far clipping plane of 0.0 can be used for an infinite far plane with reversed Z range.
---
---This is the default because it improves depth precision and reduces Z fighting.
---
---Using a non-infinite far plane requires the depth buffer to be cleared to 1.0 instead of 0.0 and the default depth test to be changed to `lequal` instead of `gequal`.
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
---Sets the default `Sampler` to use when sampling textures.
---
---It is also possible to send a custom sampler to a shader using `Pass:send` and use that instead, which allows customizing the sampler on a per-texture basis.
---
---
---### NOTE:
---The `getPixel` shader helper function will use this sampler.
---
---@overload fun(self: lovr.Pass, sampler: lovr.Sampler)
---@param filter? lovr.FilterMode # The default filter mode to use when sampling textures (the `repeat` wrap mode will be used).
function Pass:setSampler(filter) end

---
---Sets the scissor rectangle.
---
---Any pixels outside the scissor rectangle will not be drawn.
---
---
---### NOTE:
---`x` and `y` can not be negative.
---
---The default scissor rectangle covers the entire dimensions of the render pass textures.
---
---@param x number # The x coordinate of the upper-left corner of the scissor rectangle.
---@param y number # The y coordinate of the upper-left corner of the scissor rectangle.
---@param w number # The width of the scissor rectangle.
---@param h number # The height of the scissor rectangle.
function Pass:setScissor(x, y, w, h) end

---
---Sets the active shader.
---
---In a render pass, the Shader will affect all drawing operations until it is changed again.
---
---In a compute pass, the Shader will be run when `Pass:compute` is called.
---
---
---### NOTE:
---Changing the shader will preserve resource bindings (the ones set using `Pass:send`) **unless** the new shader declares a resource for a binding number using a different type than the current shader.
---
---In this case, the resource "type" means one of the following:
---
---- Uniform buffer (`uniform`).
---- Storage buffer (`buffer`).
---- Sampled texture, (`uniform texture<type>`).
---- Storage texture, (`uniform image<type>`).
---- Sampler (`uniform sampler`).
---
---If the new shader doesn't declare a resource in a particular binding number, any resource there will be preserved.
---
---If there's a clash in resource types like this, the variable will be "cleared".
---
---Using a buffer variable that has been cleared is not well-defined, and may return random data or even crash the GPU.
---
---For textures, white pixels will be returned.
---
---Samplers will use `linear` filtering and the `repeat` wrap mode.
---
---Changing the shader will not clear push constants set in the `Constants` block.
---
---@overload fun(self: lovr.Pass, default: lovr.DefaultShader)
---@overload fun(self: lovr.Pass)
---@param shader lovr.Shader # The shader to use.
function Pass:setShader(shader) end

---
---Sets the stencil test.
---
---Any pixels that fail the stencil test won't be drawn.
---
---For example, setting the stencil test to `('equal', 1)` will only draw pixels that have a stencil value of 1. The stencil buffer can be modified by drawing while stencil writes are enabled with `lovr.graphics.setStencilWrite`.
---
---
---### NOTE:
---The stencil test is disabled by default.
---
---Setting the stencil test requires the `Pass` to have a depth texture with the `d24s8` or `d32fs8` format (the `s` means "stencil").
---
---The `t.graphics.stencil` and `t.headset.stencil` flags in `lovr.conf` can be used to request a stencil format for the default window and headset passes, respectively.
---
---@overload fun(self: lovr.Pass)
---@param test lovr.CompareMode # The new stencil test to use.
---@param value number # The stencil value to compare against.
---@param mask? number # An optional mask to apply to stencil values before the comparison.
function Pass:setStencilTest(test, value, mask) end

---
---Sets or disables stencil writes.
---
---When stencil writes are enabled, any pixels drawn will update the values in the stencil buffer using the `StencilAction` set.
---
---
---### NOTE:
---By default, stencil writes are disabled.
---
---Setting the stencil test requires the `Pass` to have a depth texture with the `d24s8` or `d32fs8` format (the `s` means "stencil").
---
---The `t.graphics.stencil` and `t.headset.stencil` flags in `lovr.conf` can be used to request a stencil format for the default window and headset passes, respectively.
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
---@overload fun(self: lovr.Pass, view: number, position: lovr.Vec3, orientation: lovr.Quat)
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
---Sets the viewport.
---
---Everything rendered will get mapped to the rectangle defined by the viewport.
---
---More specifically, this defines the transformation from normalized device coordinates to pixel coordinates.
---
---
---### NOTE:
---The viewport rectangle can use floating point numbers.
---
---A negative viewport height (with a y coordinate equal to the bottom of the viewport) can be used to flip the rendering vertically.
---
---The default viewport extends from `(0, 0)` to the dimensions of the target textures, with min depth and max depth respectively set to 0 and 1.
---
---@param x number # The x coordinate of the upper-left corner of the viewport.
---@param y number # The y coordinate of the upper-left corner of the viewport.
---@param w number # The width of the viewport.
---@param h number # The height of the viewport.  May be negative.
---@param dmin? number # The min component of the depth range.
---@param dmax? number # The max component of the depth range.
function Pass:setViewport(x, y, w, h, dmin, dmax) end

---
---Sets whether vertices in the clockwise or counterclockwise order vertices are considered the "front" face of a triangle.
---
---This is used for culling with `Pass:setCullMode`.
---
---
---### NOTE:
---The default winding is counterclockwise.
---
---LÖVR's builtin shapes are wound counterclockwise.
---
---@param winding lovr.Winding # Whether triangle vertices are ordered `clockwise` or `counterclockwise`.
function Pass:setWinding(winding) end

---
---Enables or disables wireframe rendering.
---
---This will draw all triangles as lines while active. It's intended to be used for debugging, since it usually has a performance cost.
---
---
---### NOTE:
---Wireframe rendering is disabled by default.
---
---There is currently no way to change the thickness of the lines.
---
---@param enable boolean # Whether wireframe rendering should be enabled.
function Pass:setWireframe(enable) end

---
---Draws a skybox.
---
---
---### NOTE:
---The skybox will be rotated based on the camera rotation.
---
---The skybox is drawn using a fullscreen triangle.
---
---The skybox uses a custom shader, so set the shader to `nil` before calling this function (unless explicitly using a custom shader).
---
---@overload fun(self: lovr.Pass)
---@param skybox lovr.Texture # The skybox to render.  Its `TextureType` can be `cube` to render as a cubemap, or `2d` to render as an equirectangular (spherical) 2D image.
function Pass:skybox(skybox) end

---
---Draws a sphere
---
---
---### NOTE:
---The local origin of the sphere is in its center.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, radius?: number, orientation: lovr.Quat, longitudes?: number, latitudes?: number)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, longitudes?: number, latitudes?: number)
---@param x? number # The x coordinate of the center of the sphere.
---@param y? number # The y coordinate of the center of the sphere.
---@param z? number # The z coordinate of the center of the sphere.
---@param radius? number # The radius of the sphere.
---@param angle? number # The rotation of the sphere around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param longitudes? number # The number of "horizontal" segments.
---@param latitudes? number # The number of "vertical" segments.
function Pass:sphere(x, y, z, radius, angle, ax, ay, az, longitudes, latitudes) end

---
---Draws text.
---
---The font can be changed using `Pass:setFont`.
---
---
---### NOTE:
---UTF-8 encoded strings are supported.
---
---Newlines will start a new line of text.
---
---Tabs will be rendered as four spaces.
---
---Carriage returns are ignored.
---
---With the default font pixel density, a scale of 1.0 makes the text height 1 meter.
---
---The wrap value does not take into account the text's scale.
---
---Text rendering requires a special shader, which will only be automatically used when the active shader is set to `nil`.
---
---Blending should be enabled when rendering text (it's on by default).
---
---This function can draw up to 16384 visible characters at a time, and will currently throw an error if the string is too long.
---
---@overload fun(self: lovr.Pass, text: string, position: lovr.Vec3, scale?: number, orientation: lovr.Quat, wrap?: number, halign?: lovr.HorizontalAlign, valign?: lovr.VerticalAlign)
---@overload fun(self: lovr.Pass, text: string, transform: lovr.Mat4, wrap?: number, halign?: lovr.HorizontalAlign, valign?: lovr.VerticalAlign)
---@overload fun(self: lovr.Pass, colortext: table, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number, wrap?: number, halign?: lovr.HorizontalAlign, valign?: lovr.VerticalAlign)
---@overload fun(self: lovr.Pass, colortext: table, position: lovr.Vec3, scale?: number, orientation: lovr.Quat, wrap?: number, halign?: lovr.HorizontalAlign, valign?: lovr.VerticalAlign)
---@overload fun(self: lovr.Pass, colortext: table, transform: lovr.Mat4, wrap?: number, halign?: lovr.HorizontalAlign, valign?: lovr.VerticalAlign)
---@param text string # The text to render.
---@param x? number # The x coordinate of the text origin.
---@param y? number # The y coordinate of the text origin.
---@param z? number # The z coordinate of the text origin.
---@param scale? number # The scale of the text (with the default pixel density, units are meters).
---@param angle? number # The rotation of the text around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param wrap? number # The maximum width of each line in meters (before scale is applied).  When zero, the text will not wrap.
---@param halign? lovr.HorizontalAlign # The horizontal alignment relative to the text origin.
---@param valign? lovr.VerticalAlign # The vertical alignment relative to the text origin.
function Pass:text(text, x, y, z, scale, angle, ax, ay, az, wrap, halign, valign) end

---
---Starts a GPU measurement.
---
---One of the slots in a `Tally` object will be used to hold the result. Commands on the Pass will continue being measured until `Pass:tock` is called with the same tally and slot combination.
---
---Afterwards, `Pass:read` can be used to read back the tally result, or the tally can be copied to a `Buffer`.
---
---
---### NOTE:
---`pixel` and `shader` measurements can not be nested, but `time` measurements can be nested.
---
---For `time` measurements, the view count of the pass (`Pass:getViewCount`) must match the view count of the tally, which defaults to `2`.
---
---@param tally lovr.Tally # The tally that will store the measurement.
---@param slot number # The index of the slot in the tally to store the measurement in.
function Pass:tick(tally, slot) end

---
---Stops a GPU measurement.
---
---`Pass:tick` must be called to start the measurement before this can be called.
---
---Afterwards, `Pass:read` can be used to read back the tally result, or the tally can be copied to a `Buffer`.
---
---@param tally lovr.Tally # The tally storing the measurement.
---@param slot number # The index of the slot in the tally storing the measurement.
function Pass:tock(tally, slot) end

---
---Draws a torus.
---
---
---### NOTE:
---The local origin is in the center of the torus, and the torus forms a circle around the local Z axis.
---
---@overload fun(self: lovr.Pass, position: lovr.Vec3, scale: lovr.Vec3, orientation: lovr.Quat, tsegments?: number, psegments?: number)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4, tsegments?: number, psegments?: number)
---@param x? number # The x coordinate of the center of the torus.
---@param y? number # The y coordinate of the center of the torus.
---@param z? number # The z coordinate of the center of the torus.
---@param radius? number # The radius of the torus.
---@param thickness? number # The thickness of the torus.
---@param angle? number # The rotation of the torus around its rotation axis, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param tsegments? number # The number of toroidal (circular) segments to render.
---@param psegments? number # The number of poloidal (tubular) segments to render.
function Pass:torus(x, y, z, radius, thickness, angle, ax, ay, az, tsegments, psegments) end

---
---Transforms the coordinate system.
---
---@overload fun(self: lovr.Pass, translation: lovr.Vec3, scale: lovr.Vec3, rotation: lovr.Quat)
---@overload fun(self: lovr.Pass, transform: lovr.Mat4)
---@param x number # The x component of the translation.
---@param y number # The y component of the translation.
---@param z number # The z component of the translation.
---@param sx number # The x component of the scale.
---@param sy number # The y component of the scale.
---@param sz number # The z component of the scale.
---@param angle number # The amount to rotate the coordinate system by, in radians.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Pass:transform(x, y, z, sx, sy, sz, angle, ax, ay, az) end

---
---Translates the coordinate system.
---
---
---### NOTE:
---Order matters when scaling, translating, and rotating the coordinate system.
---
---@overload fun(self: lovr.Pass, translation: lovr.Vec3)
---@param x number # The x component of the translation.
---@param y number # The y component of the translation.
---@param z number # The z component of the translation.
function Pass:translate(x, y, z) end

---
---Readbacks track the progress of an asynchronous read of a `Buffer`, `Texture`, or `Tally`.
---
---Once a Readback is created in a transfer pass, and the transfer pass is submitted, the Readback can be polled for completion or the CPU can wait for it to finish using `Readback:wait`.
---
---@class lovr.Readback
local Readback = {}

---
---Returns the Readback's data as a Blob.
---
---
---### NOTE:
---If the Readback is reading back a Texture, returns `nil`.
---
---@return lovr.Blob blob # The Blob.
function Readback:getBlob() end

---
---Returns the data from the Readback, as a table.
---
---
---### NOTE:
---This currently returns `nil` for readbacks of `Buffer` and `Texture` objects.
---
---Only readbacks of `Tally` objects return valid data.
---
---For `time` and `pixel` tallies, the table will have 1 number per slot that was read.
---
---For `shader` tallies, there will be 4 numbers for each slot.
---
---@return table data # A flat table of numbers containing the values that were read back.
function Readback:getData() end

---
---Returns the Readback's data as an Image.
---
---
---### NOTE:
---If the Readback is not reading back a Texture, returns `nil`.
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
---If the transfer pass that created the readback has not been submitted yet, no wait will occur and this function will return `false`.
---
---@return boolean waited # Whether the CPU had to be blocked for waiting.
function Readback:wait() end

---
---Samplers are objects that control how pixels are read from a texture.
---
---They can control whether the pixels are smoothed, whether the texture wraps at the edge of its UVs, and more.
---
---Each `Pass` has a default sampler that will be used by default, which can be changed using `Pass:setSampler`.
---
---Also, samplers can be declared in shaders using the following syntax:
---
---    layout(set = 2, binding = X) uniform sampler mySampler;
---
---A Sampler can be sent to the variable using `Pass:send('mySampler', sampler)`.
---
---The properties of a Sampler are immutable, and can't be changed after it's created.
---
---@class lovr.Sampler
local Sampler = {}

---
---Returns the anisotropy level of the Sampler.
---
---Anisotropy smooths out a texture's appearance when viewed at grazing angles.
---
---
---### NOTE:
---Not all GPUs support anisotropy.
---
---The maximum anisotropy level is given by the `anisotropy` limit of `lovr.graphics.getLimits`, which may be zero.
---
---It's very common for the maximum to be 16, however.
---
---@return number anisotropy # The anisotropy level of the sampler.
function Sampler:getAnisotropy() end

---
---Returns the compare mode of the Sampler.
---
---This is a feature typically only used for shadow mapping.
---
---Using a sampler with a compare mode requires it to be declared in a shader as a `samplerShadow` instead of a `sampler` variable, and used with a texture that has a depth format.
---
---The result of sampling a depth texture with a shadow sampler is a number between 0 and 1, indicating the percentage of sampled pixels that passed the comparison.
---
---@return lovr.CompareMode compare # The compare mode of the sampler.
function Sampler:getCompareMode() end

---
---Returns the filter mode of the Sampler.
---
---@return lovr.FilterMode min # The filter mode used when the texture is minified.
---@return lovr.FilterMode mag # The filter mode used when the texture is magnified.
---@return lovr.FilterMode mip # The filter mode used to select a mipmap level.
function Sampler:getFilter() end

---
---Returns the mipmap range of the Sampler.
---
---This is used to clamp the range of mipmap levels that can be accessed from a texture.
---
---@return number min # The minimum mipmap level that will be sampled (0 is the largest image).
---@return number max # The maximum mipmap level that will be sampled.
function Sampler:getMipmapRange() end

---
---Returns the wrap mode of the sampler, used to wrap or clamp texture coordinates when the extend outside of the 0-1 range.
---
---@return lovr.WrapMode x # The wrap mode used in the horizontal direction.
---@return lovr.WrapMode y # The wrap mode used in the vertical direction.
---@return lovr.WrapMode z # The wrap mode used in the "z" direction, for 3D textures only.
function Sampler:getWrap() end

---
---Shaders are small GPU programs.
---
---See the `Shaders` guide for a full introduction to Shaders.
---
---@class lovr.Shader
local Shader = {}

---
---Clones a shader.
---
---This creates an inexpensive copy of it with different flags.
---
---It can be used to create several variants of a shader with different behavior.
---
---@param source lovr.Shader # The Shader to clone.
---@param flags table # The flags used by the clone.
---@return lovr.Shader shader # The new Shader.
function Shader:clone(source, flags) end

---
---Returns whether the shader is a graphics or compute shader.
---
---@return lovr.ShaderType type # The type of the Shader.
function Shader:getType() end

---
---Returns the workgroup size of a compute shader.
---
---The workgroup size defines how many times a compute shader is invoked for each workgroup dispatched by `Pass:compute`.
---
---
---### NOTE:
---For example, if the workgroup size is `8x8x1` and `16x16x16` workgroups are dispatched, then the compute shader will run `16 * 16 * 16 * (8 * 8 * 1) = 262144` times.
---
---@return number x # The x size of a workgroup.
---@return number y # The y size of a workgroup.
---@return number z # The z size of a workgroup.
function Shader:getWorkgroupSize() end

---
---Returns whether the Shader has a vertex attribute, by name or location.
---
---@overload fun(self: lovr.Shader, location: number):boolean
---@param name string # The name of an attribute.
---@return boolean exists # Whether the Shader has the attribute.
function Shader:hasAttribute(name) end

---
---Returns whether the Shader has a given stage.
---
---@param stage lovr.ShaderStage # The stage.
---@return boolean exists # Whether the Shader has the stage.
function Shader:hasStage(stage) end

---
---Tally objects are able to measure events on the GPU.
---
---Tallies can measure three types of things:
---
---- `time` - measures elapsed GPU time.
---- `pixel` - measures how many pixels were rendered, which can be used for occlusion culling.
---- `shader` - measure how many times shaders were run.
---
---Tally objects can be created with up to 4096 slots.
---
---Each slot can hold a single measurement value.
---
---`Pass:tick` is used to begin a measurement, storing the result in one of the slots.
---
---All commands recorded on the Pass will be measured until `Pass:tock` is called with the same tally and slot.
---
---The measurement value stored in the slots can be copied to a `Buffer` using `Pass:copy`, or they can be read back to Lua using `Pass:read`.
---
---@class lovr.Tally
local Tally = {}

---
---Returns the number of slots in the Tally.
---
---@return number count # The number of slots in the Tally.
function Tally:getCount() end

---
---Returns the type of the tally, which is the thing it measures between `Pass:tick` and `Pass:tock`.
---
---@return lovr.TallyType type # The type of measurement.
function Tally:getType() end

---
---Tally objects with the `time` type can only be used in render passes with a certain number of views.
---
---This returns that number.
---
---@return number views # The number of views the Tally is compatible with.
function Tally:getViewCount() end

---
---Textures are multidimensional blocks of memory on the GPU, contrasted with `Buffer` objects which are one-dimensional.
---
---Textures are used as the destination for rendering operations, and textures loaded from images provide surface data to `Material` objects.
---
---@class lovr.Texture
local Texture = {}

---
---Returns the width, height, and depth of the Texture.
---
---@return number width # The width of the Texture.
---@return number height # The height of the Texture.
---@return number layers # The number of layers in the Texture.
function Texture:getDimensions() end

---
---Returns the format of the texture.
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
---3D and array textures have a variable number of layers.
---
---@return number layers # The layer count of the Texture.
function Texture:getLayerCount() end

---
---Returns the number of mipmap levels in the Texture.
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
---Returns the number of samples in the texture.
---
---Multiple samples are used for multisample antialiasing when rendering to the texture.
---
---Currently, the sample count is either 1 (not antialiased) or 4 (antialiased).
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
---The view may have a different `TextureType` from the parent, and it may reference a subset of the parent texture's layers and mipmap levels.
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
---@param type lovr.TextureType # The texture type of the view.
---@param layer? number # The index of the first layer in the view.
---@param layerCount? number # The number of layers in the view, or `nil` to use all remaining layers.
---@param mipmap? number # The index of the first mipmap in the view.
---@param mipmapCount? number # The number of mipmaps in the view, or `nil` to use all remaining mipmaps.
---@return lovr.Texture view # The new texture view.
function Texture:newView(type, layer, layerCount, mipmap, mipmapCount) end

---
---Controls whether premultiplied alpha is enabled.
---
---
---### NOTE:
---The premultiplied mode should be used if pixels being drawn have already been blended, or "pre-multiplied", by the alpha channel.
---
---This happens when rendering to a texture that contains pixels with transparent alpha values, since the stored color values have already been faded by alpha and don't need to be faded a second time with the alphamultiply blend mode.
---
---@alias lovr.BlendAlphaMode
---
---Color channel values are multiplied by the alpha channel during blending.
---
---| "alphamultiply"
---
---Color channel values are not multiplied by the alpha.
---
---Instead, it's assumed that the colors have already been multiplied by the alpha.
---
---This should be used if the pixels being drawn have already been blended, or "pre-multiplied".
---
---| "premultiplied"

---
---Different ways pixels can blend with the pixels behind them.
---
---@alias lovr.BlendMode
---
---Colors will be mixed based on alpha.
---
---| "alpha"
---
---Colors will be added to the existing color, alpha will not be changed.
---
---| "add"
---
---Colors will be subtracted from the existing color, alpha will not be changed.
---
---| "subtract"
---
---All color channels will be multiplied together, producing a darkening effect.
---
---| "multiply"
---
---The maximum value of each color channel will be used.
---
---| "lighten"
---
---The minimum value of each color channel will be used.
---
---| "darken"
---
---The opposite of multiply: the pixel colors are inverted, multiplied, and inverted again, producing a lightening effect.
---
---| "screen"

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
---    layout(std140) uniform ObjectScales { float scales[64]; };
---
---The `std430` layout corresponds to the std430 layout used for storage buffers in GLSL.
---
---It adds some padding between certain types, and may round up the stride.
---
---Example:
---
---    layout(std430) buffer TileSizes { vec2 sizes[]; }
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
---The method used to compare depth and stencil values when performing the depth and stencil tests. Also used for compare modes in `Sampler`s.
---
---
---### NOTE:
---This type can also be specified using mathematical notation, e.g. `=`, `>`, `<=`, etc. `notequal` can be provided as `~=` or `!=`.
---
---@alias lovr.CompareMode
---
---The test does not take place, and acts as though it always passes.
---
---| "none"
---
---The test passes if the values are equal.
---
---| "equal"
---
---The test passes if the values are not equal.
---
---| "notequal"
---
---The test passes if the value is less than the existing one.
---
---| "less"
---
---The test passes if the value is less than or equal to the existing one.
---
---| "lequal"
---
---The test passes if the value is greater than the existing one.
---
---| "greater"
---
---The test passes if the value is greater than or equal to the existing one.
---
---| "gequal"

---
---The different ways of doing triangle backface culling.
---
---@alias lovr.CullMode
---
---Both sides of triangles will be drawn.
---
---| "none"
---
---Skips rendering the back side of triangles.
---
---| "back"
---
---Skips rendering the front side of triangles.
---
---| "front"

---
---The set of shaders built in to LÖVR.
---
---These can be passed to `Pass:setShader` or `lovr.graphics.newShader` instead of writing GLSL code.
---
---The shaders can be further customized by using the `flags` option to change their behavior.
---
---If the active shader is set to `nil`, LÖVR picks one of these shaders to use.
---
---@alias lovr.DefaultShader
---
---Basic shader without lighting that uses colors and a texture.
---
---| "unlit"
---
---Shades triangles based on their normal, resulting in a cool rainbow effect.
---
---| "normal"
---
---Renders font glyphs.
---
---| "font"
---
---Renders cubemaps.
---
---| "cubemap"
---
---Renders spherical textures.
---
---| "equirect"
---
---Renders a fullscreen triangle.
---
---| "fill"

---
---Whether a shape should be drawn filled or outlined.
---
---@alias lovr.DrawStyle
---
---The shape will be filled in (the default).
---
---| "fill"
---
---The shape will be outlined.
---
---| "line"

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
---Like u16, but 1-indexed.
---
---| "index16"
---
---Like u32, but 1-indexed.
---
---| "index32"

---
---Controls how `Sampler` objects smooth pixels in textures.
---
---@alias lovr.FilterMode
---
---A pixelated appearance where the "nearest neighbor" pixel is used.
---
---| "nearest"
---
---A smooth appearance where neighboring pixels are averaged.
---
---| "linear"

---
---Different ways to horizontally align text with `Pass:text`.
---
---@alias lovr.HorizontalAlign
---
---Left-aligned text.
---
---| "left"
---
---Centered text.
---
---| "center"
---
---Right-aligned text.
---
---| "right"

---
---Different ways vertices in a mesh can be connected together and filled in with pixels.
---
---@alias lovr.MeshMode
---
---Each vertex is rendered as a single point.
---
---The size of the point can be controlled using the `pointSize` shader flag, or by writing to the `PointSize` variable in shaders.
---
---The maximum point size is given by the `pointSize` limit from `lovr.graphics.getLimits`.
---
---| "points"
---
---Pairs of vertices are connected with line segments.
---
---To draw a single line through all of the vertices, an index buffer can be used to repeat vertices.
---
---It is not currently possible to change the width of the lines, although cylinders or capsules can be used as an alternative.
---
---| "lines"
---
---Every 3 vertices form a triangle, which is filled in with pixels (unless `Pass:setWireframe` is used).
---
---This mode is the most commonly used.
---
---| "triangles"

---
---Different coordinate spaces for nodes in a `Model`.
---
---@alias lovr.OriginType
---
---Transforms are relative to the origin (root) of the Model.
---
---| "root"
---
---Transforms are relative to the parent of the node.
---
---| "parent"

---
---The three different types of `Pass` objects.
---
---Each Pass has a single type, which determines the type of work it does and which functions can be called on it.
---
---@alias lovr.PassType
---
---A render pass renders graphics to a set of up to four color textures and an optional depth texture.
---
---The textures all need to have the same dimensions and sample counts.
---
---The textures can have multiple layers, and all rendering work will be broadcast to each layer.
---
---Each layer can use a different camera pose, which is used for stereo rendering.
---
---| "render"
---
---A compute pass runs compute shaders.
---
---Compute passes usually only call `Pass:setShader`, `Pass:send`, and `Pass:compute`.
---
---All of the compute work in a single compute pass is run in parallel, so multiple compute passes should be used if one compute pass needs to happen after a different one.
---
---| "compute"
---
---A transfer pass copies data to and from GPU memory in `Buffer` and `Texture` objects. Transfer passes use `Pass:copy`, `Pass:clear`, `Pass:blit`, `Pass:mipmap`, and `Pass:read`. Similar to compute passes, all the work in a transfer pass happens in parallel, so multiple passes should be used if the transfers need to be ordered.
---
---| "transfer"

---
---Different shader stages.
---
---Graphics shaders have a `vertex` and `fragment` stage, and compute shaders have a single `compute` stage.
---
---@alias lovr.ShaderStage
---
---The vertex stage, which computes transformed vertex positions.
---
---| "vertex"
---
---The fragment stage, which computes pixel colors.
---
---| "fragment"
---
---The compute stage, which performs arbitrary computation.
---
---| "compute"

---
---The two types of shaders that can be created.
---
---@alias lovr.ShaderType
---
---A graphics shader with a vertex and pixel stage.
---
---| "graphics"
---
---A compute shader with a single compute stage.
---
---| "compute"

---
---Different types of stacks that can be pushed and popped with `Pass:push` and `Pass:pop`.
---
---@alias lovr.StackType
---
---The transform stack (`Pass:transform`, `Pass:translate`, etc.).
---
---| "transform"
---
---Graphics state, like `Pass:setColor`, `Pass:setFont`, etc.
---
---Notably this does not include camera poses/projections or shader variables changed with `Pass:send`.
---
---| "state"

---
---Different ways of updating the stencil buffer with `Pass:setStencilWrite`.
---
---@alias lovr.StencilAction
---
---Stencil buffer pixels will not be changed by draws.
---
---| "keep"
---
---Stencil buffer pixels will be set to zero.
---
---| "zero"
---
---Stencil buffer pixels will be replaced with a custom value.
---
---| "replace"
---
---Stencil buffer pixels will be incremented each time they're rendered to.
---
---| "increment"
---
---Stencil buffer pixels will be decremented each time they're rendered to.
---
---| "decrement"
---
---Similar to increment, but will wrap around to 0 when it exceeds 255.
---
---| "incrementwrap"
---
---Similar to decrement, but will wrap around to 255 when it goes below 0.
---
---| "decrementwrap"
---
---The bits in the stencil buffer pixels will be inverted.
---
---| "invert"

---
---These are the different metrics a `Tally` can measure.
---
---@alias lovr.TallyType
---
---Each slot measures elapsed time in nanoseconds.
---
---| "time"
---
---Each slot measures 4 numbers: the total number of vertices processed, the number of times the vertex shader was run, the number of triangles that were visible in the view, and the number of times the fragment shader was run.
---
---| "shader"
---
---Each slot measures the approximate number of pixels affected by rendering.
---
---| "pixel"

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
---Six square 2D images with the same dimensions that define the faces of a cubemap, used for skyboxes or other "directional" images.
---
---| "cube"
---
---Array textures are sequences of distinct 2D images that all have the same dimensions.
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

---
---Different ways to vertically align text with `Pass:text`.
---
---@alias lovr.VerticalAlign
---
---Top-aligned text.
---
---| "top"
---
---Centered text.
---
---| "middle"
---
---Bottom-aligned text.
---
---| "bottom"

---
---Indicates whether the front face of a triangle uses the clockwise or counterclockwise vertex order.
---
---@alias lovr.Winding
---
---Clockwise winding.
---
---| "clockwise"
---
---Counterclockwise winding.
---
---| "counterclockwise"

---
---Controls how `Sampler` objects wrap textures.
---
---@alias lovr.WrapMode
---
---Pixels will be clamped to the edge, with pixels outside the 0-1 uv range using colors from the nearest edge.
---
---| "clamp"
---
---Tiles the texture.
---
---| "repeat"
