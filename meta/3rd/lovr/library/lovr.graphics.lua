---@meta

---
---The `lovr.graphics` module renders graphics to displays.
---
---Anything rendered using this module will automatically show up in the VR headset if one is connected, otherwise it will just show up in a window on the desktop.
---
---@class lovr.graphics
lovr.graphics = {}

---
---Draws an arc.
---
---
---### NOTE:
---The local normal vector of the circle is `(0, 0, 1)`.
---
---@overload fun(material: lovr.Material, x?: number, y?: number, z?: number, radius?: number, angle?: number, ax?: number, ay?: number, az?: number, start?: number, end?: number, segments?: number)
---@overload fun(mode: lovr.DrawStyle, transform: lovr.mat4, start?: number, end?: number, segments?: number)
---@overload fun(material: lovr.Material, transform: lovr.mat4, start?: number, end?: number, segments?: number)
---@overload fun(mode: lovr.DrawStyle, arcmode?: lovr.ArcMode, x?: number, y?: number, z?: number, radius?: number, angle?: number, ax?: number, ay?: number, az?: number, start?: number, end?: number, segments?: number)
---@overload fun(material: lovr.Material, arcmode?: lovr.ArcMode, x?: number, y?: number, z?: number, radius?: number, angle?: number, ax?: number, ay?: number, az?: number, start?: number, end?: number, segments?: number)
---@overload fun(mode: lovr.DrawStyle, arcmode?: lovr.ArcMode, transform: lovr.mat4, start?: number, end?: number, segments?: number)
---@overload fun(material: lovr.Material, arcmode?: lovr.ArcMode, transform: lovr.mat4, start?: number, end?: number, segments?: number)
---@param mode lovr.DrawStyle # Whether the arc is filled or outlined.
---@param x? number # The x coordinate of the center of the arc.
---@param y? number # The y coordinate of the center of the arc.
---@param z? number # The z coordinate of the center of the arc.
---@param radius? number # The radius of the arc, in meters.
---@param angle? number # The rotation of the arc around its rotation axis, in radians.
---@param ax? number # The x coordinate of the arc's axis of rotation.
---@param ay? number # The y coordinate of the arc's axis of rotation.
---@param az? number # The z coordinate of the arc's axis of rotation.
---@param start? number # The starting angle of the arc, in radians.
---@param end? number # The ending angle of the arc, in radians.
---@param segments? number # The number of segments to use for the full circle. A smaller number of segments will be used, depending on how long the arc is.
function lovr.graphics.arc(mode, x, y, z, radius, angle, ax, ay, az, start, end, segments) end

---
---Draws a box.
---
---This is similar to `lovr.graphics.cube` except you can have different values for the width, height, and depth of the box.
---
---@overload fun(material: lovr.Material, x?: number, y?: number, z?: number, width?: number, height?: number, depth?: number, angle?: number, ax?: number, ay?: number, az?: number)
---@overload fun(mode: lovr.DrawStyle, transform: lovr.mat4)
---@overload fun(material: lovr.Material, transform: lovr.mat4)
---@param mode lovr.DrawStyle # How to draw the box.
---@param x? number # The x coordinate of the center of the box.
---@param y? number # The y coordinate of the center of the box.
---@param z? number # The z coordinate of the center of the box.
---@param width? number # The width of the box, in meters.
---@param height? number # The height of the box, in meters.
---@param depth? number # The depth of the box, in meters.
---@param angle? number # The rotation of the box around its rotation axis, in radians.
---@param ax? number # The x coordinate of the axis of rotation.
---@param ay? number # The y coordinate of the axis of rotation.
---@param az? number # The z coordinate of the axis of rotation.
function lovr.graphics.box(mode, x, y, z, width, height, depth, angle, ax, ay, az) end

---
---Draws a 2D circle.
---
---
---### NOTE:
---The local normal vector of the circle is `(0, 0, 1)`.
---
---@overload fun(material: lovr.Material, x?: number, y?: number, z?: number, radius?: number, angle?: number, ax?: number, ay?: number, az?: number, segments?: number)
---@overload fun(mode: lovr.DrawStyle, transform: lovr.mat4, segments?: number)
---@overload fun(material: lovr.Material, transform: lovr.mat4, segments?: number)
---@param mode lovr.DrawStyle # Whether the circle is filled or outlined.
---@param x? number # The x coordinate of the center of the circle.
---@param y? number # The y coordinate of the center of the circle.
---@param z? number # The z coordinate of the center of the circle.
---@param radius? number # The radius of the circle, in meters.
---@param angle? number # The rotation of the circle around its rotation axis, in radians.
---@param ax? number # The x coordinate of the circle's axis of rotation.
---@param ay? number # The y coordinate of the circle's axis of rotation.
---@param az? number # The z coordinate of the circle's axis of rotation.
---@param segments? number # The number of segments to use for the circle geometry.  Higher numbers increase smoothness but increase rendering cost slightly.
function lovr.graphics.circle(mode, x, y, z, radius, angle, ax, ay, az, segments) end

---
---Clears the screen, resetting the color, depth, and stencil information to default values.
---
---This function is called automatically by `lovr.run` at the beginning of each frame to clear out the data from the previous frame.
---
---
---### NOTE:
---The first two variants of this function can be mixed and matched, meaning you can use booleans for some of the values and numeric values for others.
---
---If you are using `lovr.graphics.setStencilTest`, it will not affect how the screen gets cleared. Instead, you can use `lovr.graphics.fill` to draw a fullscreen quad, which will get masked by the active stencil.
---
---@overload fun(r: number, g: number, b: number, a: number, z?: number, s?: number)
---@overload fun(hex: number)
---@param color? boolean # Whether or not to clear color information on the screen.
---@param depth? boolean # Whether or not to clear the depth information on the screen.
---@param stencil? boolean # Whether or not to clear the stencil information on the screen.
function lovr.graphics.clear(color, depth, stencil) end

---
---This function runs a compute shader on the GPU.
---
---Compute shaders must be created with `lovr.graphics.newComputeShader` and they should implement the `void compute();` GLSL function. Running a compute shader doesn't actually do anything, but the Shader can modify data stored in `Texture`s or `ShaderBlock`s to get interesting things to happen.
---
---When running the compute shader, you can specify the number of times to run it in 3 dimensions, which is useful to iterate over large numbers of elements like pixels or array elements.
---
---
---### NOTE:
---Only compute shaders created with `lovr.graphics.newComputeShader` can be used here.
---
---There are GPU-specific limits on the `x`, `y`, and `z` values which can be queried in the `compute` entry of `lovr.graphics.getLimits`.
---
---@param shader lovr.Shader # The compute shader to run.
---@param x? number # The amount of times to run in the x direction.
---@param y? number # The amount of times to run in the y direction.
---@param z? number # The amount of times to run in the z direction.
function lovr.graphics.compute(shader, x, y, z) end

---
---Create the desktop window, usually used to mirror the headset display.
---
---
---### NOTE:
---This function can only be called once.
---
---It is normally called internally, but you can override this by setting window to `nil` in conf.lua.
---
---See `lovr.conf` for more information.
---
---The window must be created before any `lovr.graphics` functions can be used.
---
---@param flags? {width: number, height: number, fullscreen: boolean, resizable: boolean, msaa: number, title: string, icon: string, vsync: number} # Flags to customize the window's appearance and behavior.
function lovr.graphics.createWindow(flags) end

---
---Draws a cube.
---
---@overload fun(material: lovr.Material, x?: number, y?: number, z?: number, size?: number, angle?: number, ax?: number, ay?: number, az?: number)
---@overload fun(mode: lovr.DrawStyle, transform: lovr.mat4)
---@overload fun(material: lovr.Material, transform: lovr.mat4)
---@param mode lovr.DrawStyle # How to draw the cube.
---@param x? number # The x coordinate of the center of the cube.
---@param y? number # The y coordinate of the center of the cube.
---@param z? number # The z coordinate of the center of the cube.
---@param size? number # The size of the cube, in meters.
---@param angle? number # The rotation of the cube around its rotation axis, in radians.
---@param ax? number # The x coordinate of the cube's axis of rotation.
---@param ay? number # The y coordinate of the cube's axis of rotation.
---@param az? number # The z coordinate of the cube's axis of rotation.
function lovr.graphics.cube(mode, x, y, z, size, angle, ax, ay, az) end

---
---Draws a cylinder.
---
---
---### NOTE:
---Currently, cylinders don't have UVs.
---
---@overload fun(material: lovr.Material, x?: number, y?: number, z?: number, length?: number, angle?: number, ax?: number, ay?: number, az?: number, r1?: number, r2?: number, capped?: boolean, segments?: number)
---@param x? number # The x coordinate of the center of the cylinder.
---@param y? number # The y coordinate of the center of the cylinder.
---@param z? number # The z coordinate of the center of the cylinder.
---@param length? number # The length of the cylinder, in meters.
---@param angle? number # The rotation of the cylinder around its rotation axis, in radians.
---@param ax? number # The x coordinate of the cylinder's axis of rotation.
---@param ay? number # The y coordinate of the cylinder's axis of rotation.
---@param az? number # The z coordinate of the cylinder's axis of rotation.
---@param r1? number # The radius of one end of the cylinder.
---@param r2? number # The radius of the other end of the cylinder.
---@param capped? boolean # Whether the top and bottom should be rendered.
---@param segments? number # The number of radial segments to use for the cylinder.  If nil, the segment count is automatically determined from the radii.
function lovr.graphics.cylinder(x, y, z, length, angle, ax, ay, az, r1, r2, capped, segments) end

---
---Discards pixel information in the active Canvas or display.
---
---This is mostly used as an optimization hint for the GPU, and is usually most helpful on mobile devices.
---
---@param color? boolean # Whether or not to discard color information.
---@param depth? boolean # Whether or not to discard depth information.
---@param stencil? boolean # Whether or not to discard stencil information.
function lovr.graphics.discard(color, depth, stencil) end

---
---Draws a fullscreen textured quad.
---
---
---### NOTE:
---This function ignores stereo rendering, so it will stretch the input across the entire Canvas if it's stereo.
---
---Special shaders are currently required for correct stereo fills.
---
---@overload fun()
---@param texture lovr.Texture # The texture to use.
---@param u? number # The x component of the uv offset.
---@param v? number # The y component of the uv offset.
---@param w? number # The width of the Texture to render, in uv coordinates.
---@param h? number # The height of the Texture to render, in uv coordinates.
function lovr.graphics.fill(texture, u, v, w, h) end

---
---Flushes the internal queue of draw batches.
---
---Under normal circumstances this is done automatically when needed, but the ability to flush manually may be helpful if you're integrating a LÖVR project with some external rendering code.
---
function lovr.graphics.flush() end

---
---Returns whether or not alpha sampling is enabled.
---
---Alpha sampling is also known as alpha-to-coverage.
---
---When it is enabled, the alpha channel of a pixel is factored into how antialiasing is computed, so the edges of a transparent texture will be correctly antialiased.
---
---
---### NOTE:
---- Alpha sampling is disabled by default.
---- This feature can be used for a simple transparency effect, pixels with an alpha of zero will
---  have their depth value discarded, allowing things behind them to show through (normally you
---  have to sort objects or write a shader for this).
---
---@return boolean enabled # Whether or not alpha sampling is enabled.
function lovr.graphics.getAlphaSampling() end

---
---Returns the current background color.
---
---Color components are from 0.0 to 1.0.
---
---
---### NOTE:
---The default background color is `(0.0, 0.0, 0.0, 1.0)`.
---
---@return number r # The red component of the background color.
---@return number g # The green component of the background color.
---@return number b # The blue component of the background color.
---@return number a # The alpha component of the background color.
function lovr.graphics.getBackgroundColor() end

---
---Returns the current blend mode.
---
---The blend mode controls how each pixel's color is blended with the previous pixel's color when drawn.
---
---If blending is disabled, `nil` will be returned.
---
---
---### NOTE:
---The default blend mode is `alpha` and `alphamultiply`.
---
---@return lovr.BlendMode blend # The current blend mode.
---@return lovr.BlendAlphaMode alphaBlend # The current alpha blend mode.
function lovr.graphics.getBlendMode() end

---
---Returns the active Canvas.
---
---Usually when you render something it will render directly to the headset.
---
---If a Canvas object is active, things will be rendered to the textures attached to the Canvas instead.
---
---@return lovr.Canvas canvas # The active Canvas, or `nil` if no canvas is set.
function lovr.graphics.getCanvas() end

---
---Returns the current global color factor.
---
---Color components are from 0.0 to 1.0.
---
---Every pixel drawn will be multiplied (i.e. tinted) by this color.
---
---
---### NOTE:
---The default color is `(1.0, 1.0, 1.0, 1.0)`.
---
---@return number r # The red component of the color.
---@return number g # The green component of the color.
---@return number b # The blue component of the color.
---@return number a # The alpha component of the color.
function lovr.graphics.getColor() end

---
---Returns a boolean for each color channel (red, green, blue, alpha) indicating whether it is enabled.
---
---When a color channel is enabled, it will be affected by drawing commands and clear commands.
---
---
---### NOTE:
---By default, all color channels are enabled.
---
---Disabling all of the color channels can be useful if you only want to write to the depth buffer or the stencil buffer.
---
function lovr.graphics.getColorMask() end

---
---Returns the default filter mode for new Textures.
---
---This controls how textures are sampled when they are minified, magnified, or stretched.
---
---
---### NOTE:
---The default filter is `trilinear`.
---
---@return lovr.FilterMode mode # The filter mode.
---@return number anisotropy # The level of anisotropy.
function lovr.graphics.getDefaultFilter() end

---
---Returns the current depth test settings.
---
---
---### NOTE:
---The depth test is an advanced technique to control how 3D objects overlap each other when they are rendered.
---
---It works as follows:
---
---- Each pixel keeps track of its z value as well as its color.
---- If `write` is enabled when something is drawn, then any pixels that are drawn will have their
---  z values updated.
---- Additionally, anything drawn will first compare the existing z value of a pixel with the new z
---  value.
---
---The `compareMode` setting determines how this comparison is performed.
---
---If the
---  comparison succeeds, the new pixel will overwrite the previous one, otherwise that pixel won't
---  be rendered to.
---
---Smaller z values are closer to the camera.
---
---The default compare mode is `lequal`, which usually gives good results for normal 3D rendering.
---
---@return lovr.CompareMode compareMode # The current comparison method for depth testing.
---@return boolean write # Whether pixels will have their z value updated when rendered to.
function lovr.graphics.getDepthTest() end

---
---Returns the dimensions of the desktop window.
---
---@return number width # The width of the window, in pixels.
---@return number height # The height of the window, in pixels.
function lovr.graphics.getDimensions() end

---
---Returns whether certain features are supported by the system\'s graphics card.
---
---@return {astc: boolean, compute: boolean, dxt: boolean, instancedstereo: boolean, multiview: boolean, timers: boolean} features # A table of features and whether or not they are supported.
function lovr.graphics.getFeatures() end

---
---Returns the active font.
---
---@return lovr.Font font # The active font object.
function lovr.graphics.getFont() end

---
---Returns the height of the desktop window.
---
---@return number height # The height of the window, in pixels.
function lovr.graphics.getHeight() end

---
---Returns information about the maximum limits of the graphics card, such as the maximum texture size or the amount of supported antialiasing.
---
---@return {anisotropy: number, blocksize: number, pointsize: number, texturemsaa: number, texturesize: number, compute: table} limits # The table of limits.
function lovr.graphics.getLimits() end

---
---Returns the current line width.
---
---
---### NOTE:
---The default line width is `1`.
---
---@return number width # The current line width, in pixels.
function lovr.graphics.getLineWidth() end

---
---Returns the pixel density of the window.
---
---On "high-dpi" displays, this will be `2.0`, indicating that there are 2 pixels for every window coordinate.
---
---On a normal display it will be `1.0`, meaning that the pixel to window-coordinate ratio is 1:1.
---
---
---### NOTE:
---If the window isn't created yet, this function will return 0.
---
---@return number density # The pixel density of the window.
function lovr.graphics.getPixelDensity() end

---
---Returns the current point size.
---
---
---### NOTE:
---The default point size is `1.0`.
---
---@return number size # The current point size, in pixels.
function lovr.graphics.getPointSize() end

---
---Returns the projection for a single view.
---
---
---### NOTE:
---Non-stereo rendering will only use the first view.
---
---The projection matrices are available as the `mat4 lovrProjections[2]` variable in shaders.
---
---The current projection matrix is available as `lovrProjection`.
---
---@overload fun(view: number, matrix: lovr.Mat4):lovr.Mat4
---@param view number # The view index.
---@return number left # The left field of view angle, in radians.
---@return number right # The right field of view angle, in radians.
---@return number up # The top field of view angle, in radians.
---@return number down # The bottom field of view angle, in radians.
function lovr.graphics.getProjection(view) end

---
---Returns the active shader.
---
---@return lovr.Shader shader # The active shader object, or `nil` if none is active.
function lovr.graphics.getShader() end

---
---Returns graphics-related performance statistics for the current frame.
---
---@return {drawcalls: number, renderpasses: number, shaderswitches: number, buffers: number, textures: number, buffermemory: number, texturememory: number} stats # The table of stats.
function lovr.graphics.getStats() end

---
---Returns the current stencil test.
---
---The stencil test lets you mask out pixels that meet certain criteria, based on the contents of the stencil buffer.
---
---The stencil buffer can be modified using `lovr.graphics.stencil`.
---
---After rendering to the stencil buffer, the stencil test can be set to control how subsequent drawing functions are masked by the stencil buffer.
---
---
---### NOTE:
---Stencil values are between 0 and 255.
---
---By default, the stencil test is disabled.
---
---@return lovr.CompareMode compareMode # The comparison method used to decide if a pixel should be visible, or nil if the stencil test is disabled.
---@return number compareValue # The value stencil values are compared against, or nil if the stencil test is disabled.
function lovr.graphics.getStencilTest() end

---
---Get the pose of a single view.
---
---@overload fun(view: number, matrix: lovr.Mat4, invert: boolean):lovr.Mat4
---@param view number # The view index.
---@return number x # The x position of the viewer, in meters.
---@return number y # The y position of the viewer, in meters.
---@return number z # The z position of the viewer, in meters.
---@return number angle # The number of radians the viewer is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function lovr.graphics.getViewPose(view) end

---
---Returns the width of the desktop window.
---
---@return number width # The width of the window, in pixels.
function lovr.graphics.getWidth() end

---
---Returns the current polygon winding.
---
---The winding direction determines which face of a triangle is the front face and which is the back face.
---
---This lets the graphics engine cull the back faces of polygons, improving performance.
---
---
---### NOTE:
---Culling is initially disabled and must be enabled using `lovr.graphics.setCullingEnabled`.
---
---The default winding direction is counterclockwise.
---
---@return lovr.Winding winding # The current winding direction.
function lovr.graphics.getWinding() end

---
---Returns whether the desktop window is currently created.
---
---
---### NOTE:
---Most of the `lovr.graphics` functionality will only work if a window is created.
---
---@return boolean present # Whether a window is created.
function lovr.graphics.hasWindow() end

---
---Returns whether or not culling is active.
---
---Culling is an optimization that avoids rendering the back face of polygons.
---
---This improves performance by reducing the number of polygons drawn, but requires that the vertices in triangles are specified in a consistent clockwise or counter clockwise order.
---
---
---### NOTE:
---Culling is disabled by default.
---
---@return boolean isEnabled # Whether or not culling is enabled.
function lovr.graphics.isCullingEnabled() end

---
---Returns a boolean indicating whether or not wireframe rendering is enabled.
---
---
---### NOTE:
---Wireframe rendering is initially disabled.
---
---Wireframe rendering is only supported on desktop systems.
---
---@return boolean isWireframe # Whether or not wireframe rendering is enabled.
function lovr.graphics.isWireframe() end

---
---Draws lines between points.
---
---Each point will be connected to the previous point in the list.
---
---@overload fun(points: table)
---@param x1 number # The x coordinate of the first point.
---@param y1 number # The y coordinate of the first point.
---@param z1 number # The z coordinate of the first point.
---@param x2 number # The x coordinate of the second point.
---@param y2 number # The y coordinate of the second point.
---@param z2 number # The z coordinate of the second point.
---@vararg number # More points.
function lovr.graphics.line(x1, y1, z1, x2, y2, z2, ...) end

---
---Creates a new Canvas.
---
---You can specify Textures to attach to it, or just specify a width and height and attach textures later using `Canvas:setTexture`.
---
---Once created, you can render to the Canvas using `Canvas:renderTo`, or `lovr.graphics.setCanvas`.
---
---
---### NOTE:
---Textures created by this function will have `clamp` as their `WrapMode`.
---
---Stereo Canvases will either have their width doubled or use array textures for their attachments, depending on their implementation.
---
---@overload fun(..., flags?: table):lovr.Canvas
---@overload fun(attachments: table, flags?: table):lovr.Canvas
---@param width number # The width of the canvas, in pixels.
---@param height number # The height of the canvas, in pixels.
---@param flags? {format: lovr.TextureFormat, depth: lovr.TextureFormat, stereo: boolean, msaa: number, mipmaps: boolean} # Optional settings for the Canvas.
---@return lovr.Canvas canvas # The new Canvas.
function lovr.graphics.newCanvas(width, height, flags) end

---
---Creates a new compute Shader, used for running generic compute operations on the GPU.
---
---
---### NOTE:
---Compute shaders are not supported on all hardware, use `lovr.graphics.getFeatures` to check if they're available on the current system.
---
---The source code for a compute shader needs to implement the `void compute();` GLSL function. This function doesn't return anything, but the compute shader is able to write data out to `Texture`s or `ShaderBlock`s.
---
---The GLSL version used for compute shaders is GLSL 430.
---
---Currently, up to 32 shader flags are supported.
---
---@param source string # The code or filename of the compute shader.
---@param options? {flags: table} # Optional settings for the Shader.
---@return lovr.Shader shader # The new compute Shader.
function lovr.graphics.newComputeShader(source, options) end

---
---Creates a new Font.
---
---It can be used to render text with `lovr.graphics.print`.
---
---Currently, the only supported font format is TTF.
---
---
---### NOTE:
---Larger font sizes will lead to more detailed curves at the cost of performance.
---
---@overload fun(size?: number, padding?: number, spread?: number):lovr.Font
---@overload fun(rasterizer: lovr.Rasterizer, padding?: number, spread?: number):lovr.Font
---@param filename string # The filename of the font file.
---@param size? number # The size of the font, in pixels.
---@param padding? number # The number of pixels of padding around each glyph.
---@param spread? number # The range of the distance field, in pixels.
---@return lovr.Font font # The new Font.
function lovr.graphics.newFont(filename, size, padding, spread) end

---
---Creates a new Material.
---
---Materials are sets of colors, textures, and other parameters that affect the appearance of objects.
---
---They can be applied to `Model`s, `Mesh`es, and most graphics primitives accept a Material as an optional first argument.
---
---
---### NOTE:
---- Scalar properties will default to `1.0`.
---- Color properties will default to `(1.0, 1.0, 1.0, 1.0)`, except for `emissive` which will
---  default to `(0.0, 0.0, 0.0, 0.0)`.
---- Textures will default to `nil` (a single 1x1 white pixel will be used for them).
---
---@overload fun(texture: lovr.Texture, r?: number, g?: number, b?: number, a?: number):lovr.Material
---@overload fun(canvas: lovr.Canvas, r?: number, g?: number, b?: number, a?: number):lovr.Material
---@overload fun(r?: number, g?: number, b?: number, a?: number):lovr.Material
---@overload fun(hex?: number, a?: number):lovr.Material
---@return lovr.Material material # The new Material.
function lovr.graphics.newMaterial() end

---
---Creates a new Mesh.
---
---Meshes contain the data for an arbitrary set of vertices, and can be drawn. You must specify either the capacity for the Mesh or an initial set of vertex data.
---
---Optionally, a custom format table can be used to specify the set of vertex attributes the mesh will provide to the active shader.
---
---The draw mode and usage hint can also optionally be specified.
---
---The default data type for an attribute is `float`, and the default component count is 1.
---
---
---### NOTE:
---Once created, the size and format of the Mesh cannot be changed.'
---
---The default mesh format is:
---
---    {
---      { 'lovrPosition',    'float', 3 },
---      { 'lovrNormal',      'float', 3 },
---      { 'lovrTexCoord',    'float', 2 }
---    }
---
---@overload fun(vertices: table, mode?: lovr.DrawMode, usage?: lovr.MeshUsage, readable?: boolean):lovr.Mesh
---@overload fun(blob: lovr.Blob, mode?: lovr.DrawMode, usage?: lovr.MeshUsage, readable?: boolean):lovr.Mesh
---@overload fun(format: table, size: number, mode?: lovr.DrawMode, usage?: lovr.MeshUsage, readable?: boolean):lovr.Mesh
---@overload fun(format: table, vertices: table, mode?: lovr.DrawMode, usage?: lovr.MeshUsage, readable?: boolean):lovr.Mesh
---@overload fun(format: table, blob: lovr.Blob, mode?: lovr.DrawMode, usage?: lovr.MeshUsage, readable?: boolean):lovr.Mesh
---@param size number # The maximum number of vertices the Mesh can store.
---@param mode? lovr.DrawMode # How the Mesh will connect its vertices into triangles.
---@param usage? lovr.MeshUsage # An optimization hint indicating how often the data in the Mesh will be updated.
---@param readable? boolean # Whether vertices from the Mesh can be read.
---@return lovr.Mesh mesh # The new Mesh.
function lovr.graphics.newMesh(size, mode, usage, readable) end

---
---Creates a new Model from a file.
---
---The supported 3D file formats are OBJ, glTF, and STL.
---
---
---### NOTE:
---Diffuse and emissive textures will be loaded in the sRGB encoding, all other textures will be loaded as linear.
---
---Currently, the following features are not supported by the model importer:
---
---- OBJ: Quads are not supported (only triangles).
---- glTF: Sparse accessors are not supported.
---- glTF: Morph targets are not supported.
---- glTF: base64 images are not supported (base64 buffer data works though).
---- glTF: Only the default scene is loaded.
---- glTF: Currently, each skin in a Model can have up to 48 joints.
---- STL: ASCII STL files are not supported.
---
---@overload fun(modelData: lovr.ModelData):lovr.Model
---@param filename string # The filename of the model to load.
---@return lovr.Model model # The new Model.
function lovr.graphics.newModel(filename) end

---
---Creates a new Shader.
---
---
---### NOTE:
---The `flags` table should contain string keys, with boolean or numeric values.
---
---These flags can be used to customize the behavior of Shaders from Lua, by using the flags in the shader source code.
---
---Numeric flags will be available as constants named `FLAG_<flagName>`.
---
---Boolean flags can be used with `#ifdef` and will only be defined if the value in the Lua table was `true`.
---
---The following flags are used by shaders provided by LÖVR:
---
---- `animated` is a boolean flag that will cause the shader to position vertices based on the pose
---  of an animated skeleton.
---
---This should usually only be used for animated `Model`s, since it
---  needs a skeleton to work properly and is slower than normal rendering.
---- `alphaCutoff` is a numeric flag that can be used to implement simple "cutout" style
---  transparency, where pixels with alpha below a certain threshold will be discarded.
---
---The value
---  of the flag should be a number between 0.0 and 1.0, representing the alpha threshold.
---- `uniformScale` is a boolean flag used for optimization.
---
---If the Shader is only going to be
---  used with objects that have a *uniform* scale (i.e. the x, y, and z components of the scale
---  are all the same number), then this flag can be set to use a faster method to compute the
---  `lovrNormalMatrix` uniform variable.
---- `multicanvas` is a boolean flag that should be set when rendering to multiple Textures
---  attached to a `Canvas`.
---
---When set, the fragment shader should implement the `colors` function
---  instead of the `color` function, and can write color values to the `lovrCanvas` array instead
---  of returning a single color.
---
---Each color in the array gets written to the corresponding
---  texture attached to the canvas.
---- `highp` is a boolean flag specific to mobile GPUs that changes the default precision for
---  fragment shaders to use high precision instead of the default medium precision.
---
---This can fix
---  visual issues caused by a lack of precision, but isn't guaranteed to be supported on some
---  lower-end systems.
---- The following flags are used only by the `standard` PBR shader:
---  - `normalMap` should be set to `true` to render objects with a normal map, providing a more
---  detailed, bumpy appearance.
---
---Currently, this requires the model to have vertex tangents.
---  - `emissive` should be set to `true` to apply emissive maps to rendered objects.
---
---This is
---    usually used to apply glowing lights or screens to objects, since the emissive texture is
---    not affected at all by lighting.
---  - `indirectLighting` is an *awesome* boolean flag that will apply realistic reflections and
---    lighting to the surface of an object, based on a specially-created skybox.
---
---See the
---    `Standard Shader` guide for more information.
---  - `occlusion` is a boolean flag that uses the ambient occlusion texture in the model.
---
---It only
---    affects indirect lighting, so it will only have an effect if the `indirectLighting` flag is
---    also enabled.
---  - `skipTonemap` is a flag that will skip the tonemapping process.
---
---Tonemapping is an important
---    process that maps the high definition physical color values down to a 0 - 1 range for
---    display.
---
---There are lots of different tonemapping algorithms that give different artistic
---    effects.
---
---The default tonemapping in the standard shader is the ACES algorithm, but you can
---    use this flag to turn off ACES and use your own tonemapping.
---
---Currently, up to 32 shader flags are supported.
---
---The `stereo` option is only necessary for Android.
---
---Currently on Android, only stereo shaders can be used with stereo Canvases, and mono Shaders can only be used with mono Canvases.
---
---@overload fun(default: lovr.DefaultShader, options?: table):lovr.Shader
---@param vertex string # The code or filename of the vertex shader.  If nil, the default vertex shader is used.
---@param fragment string # The code or filename of the fragment shader.  If nil, the default fragment shader is used.
---@param options? {flags: table, stereo: boolean} # Optional settings for the Shader.
---@return lovr.Shader shader # The new Shader.
function lovr.graphics.newShader(vertex, fragment, options) end

---
---Creates a new ShaderBlock from a table of variable definitions with their names and types.
---
---
---### NOTE:
---`compute` blocks can only be true if compute shaders are supported, see `lovr.graphics.getFeatures`.
---
---Compute blocks may be slightly slower than uniform blocks, but they can also be much, much larger.
---
---Uniform blocks are usually limited to around 16 kilobytes in size, depending on hardware.
---
---@param type lovr.BlockType # Whether the block will be used for read-only uniform data or compute shaders.
---@param uniforms table # A table where the keys are uniform names and the values are uniform types.  Uniform arrays can be specified by supplying a table as the uniform's value containing the type and the array size.
---@param flags? {usage: lovr.BufferUsage, readable: boolean} # Optional settings.
---@return lovr.ShaderBlock shaderBlock # The new ShaderBlock.
function lovr.graphics.newShaderBlock(type, uniforms, flags) end

---
---Creates a new Texture from an image file.
---
---
---### NOTE:
---The "linear" flag should be set to true for textures that don't contain color information, such as normal maps.
---
---Right now the supported image file formats are png, jpg, hdr, dds (DXT1, DXT3, DXT5), ktx, and astc.
---
---@overload fun(images: table, flags?: table):lovr.Texture
---@overload fun(width: number, height: number, depth: number, flags?: table):lovr.Texture
---@overload fun(blob: lovr.Blob, flags?: table):lovr.Texture
---@overload fun(image: lovr.Image, flags?: table):lovr.Texture
---@param filename string # The filename of the image to load.
---@param flags? {linear: boolean, mipmaps: boolean, type: lovr.TextureType, format: lovr.TextureFormat, msaa: number} # Optional settings for the texture.
---@return lovr.Texture texture # The new Texture.
function lovr.graphics.newTexture(filename, flags) end

---
---Resets the transformation to the origin.
---
---
---### NOTE:
---This is called at the beginning of every frame to reset the coordinate space.
---
function lovr.graphics.origin() end

---
---Draws a plane with a given position, size, and orientation.
---
---
---### NOTE:
---The `u`, `v`, `w`, `h` arguments can be used to select a subregion of the diffuse texture to apply to the plane.
---
---One efficient technique for rendering many planes with different textures is to pack all of the textures into a single image, and then use the uv arguments to select a sub-rectangle to use for each plane.
---
---@overload fun(material: lovr.Material, x?: number, y?: number, z?: number, width?: number, height?: number, angle?: number, ax?: number, ay?: number, az?: number, u?: number, v?: number, w?: number, h?: number)
---@param mode lovr.DrawStyle # How to draw the plane.
---@param x? number # The x coordinate of the center of the plane.
---@param y? number # The y coordinate of the center of the plane.
---@param z? number # The z coordinate of the center of the plane.
---@param width? number # The width of the plane, in meters.
---@param height? number # The height of the plane, in meters.
---@param angle? number # The number of radians to rotate around the rotation axis.
---@param ax? number # The x component of the rotation axis.
---@param ay? number # The y component of the rotation axis.
---@param az? number # The z component of the rotation axis.
---@param u? number # The u coordinate of the texture.
---@param v? number # The v coordinate of the texture.
---@param w? number # The width of the texture UVs to render.
---@param h? number # The height of the texture UVs to render.
function lovr.graphics.plane(mode, x, y, z, width, height, angle, ax, ay, az, u, v, w, h) end

---
---Draws one or more points.
---
---@overload fun(points: table)
---@param x number # The x coordinate of the point.
---@param y number # The y coordinate of the point.
---@param z number # The z coordinate of the point.
---@vararg number # More points.
function lovr.graphics.points(x, y, z, ...) end

---
---Pops the current transform from the stack, returning to the transformation that was applied before `lovr.graphics.push` was called.
---
---
---### NOTE:
---An error is thrown if there isn't a transform to pop.
---
---This can happen if you forget to call push before calling pop, or if you have an unbalanced sequence of pushes and pops.
---
function lovr.graphics.pop() end

---
---Presents the results of pending drawing operations to the window.
---
---This is automatically called after `lovr.draw` by the default `lovr.run` function.
---
function lovr.graphics.present() end

---
---Draws text in 3D space using the active font.
---
---
---### NOTE:
---Unicode text is supported.
---
---Use `\n` to add line breaks.
---
---`\t` will be rendered as four spaces.
---
---LÖVR uses a fancy technique for font rendering called multichannel signed distance fields.
---
---This leads to crisp text in VR, but requires a special shader to use.
---
---LÖVR internally switches to the appropriate shader, but only when the default shader is already set.
---
---If you see strange font artifacts, make sure you switch back to the default shader by using `lovr.graphics.setShader()` before you draw text.
---
---@param str string # The text to render.
---@param x? number # The x coordinate of the center of the text.
---@param y? number # The y coordinate of the center of the text.
---@param z? number # The z coordinate of the center of the text.
---@param scale? number # The scale of the text.
---@param angle? number # The number of radians to rotate the text around its rotation axis.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param wrap? number # The maximum width of each line, in meters (before scale is applied).  Set to 0 or nil for no wrapping.
---@param halign? lovr.HorizontalAlign # The horizontal alignment.
---@param valign? lovr.VerticalAlign # The vertical alignment.
function lovr.graphics.print(str, x, y, z, scale, angle, ax, ay, az, wrap, halign, valign) end

---
---Pushes a copy of the current transform onto the transformation stack.
---
---After changing the transform using `lovr.graphics.translate`, `lovr.graphics.rotate`, and `lovr.graphics.scale`, the original state can be restored using `lovr.graphics.pop`.
---
---
---### NOTE:
---An error is thrown if more than 64 matrices are pushed.
---
---This can happen accidentally if a push isn't followed by a corresponding pop.
---
function lovr.graphics.push() end

---
---Resets all graphics state to the initial values.
---
function lovr.graphics.reset() end

---
---Rotates the coordinate system around an axis.
---
---The rotation will last until `lovr.draw` returns or the transformation is popped off the transformation stack.
---
---
---### NOTE:
---Order matters when scaling, translating, and rotating the coordinate system.
---
---@param angle? number # The amount to rotate the coordinate system by, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
function lovr.graphics.rotate(angle, ax, ay, az) end

---
---Scales the coordinate system in 3 dimensions.
---
---This will cause objects to appear bigger or smaller.
---
---The scaling will last until `lovr.draw` returns or the transformation is popped off the transformation stack.
---
---
---### NOTE:
---Order matters when scaling, translating, and rotating the coordinate system.
---
---@param x? number # The amount to scale on the x axis.
---@param y? number # The amount to scale on the y axis.
---@param z? number # The amount to scale on the z axis.
function lovr.graphics.scale(x, y, z) end

---
---Enables or disables alpha sampling.
---
---Alpha sampling is also known as alpha-to-coverage.
---
---When it is enabled, the alpha channel of a pixel is factored into how antialiasing is computed, so the edges of a transparent texture will be correctly antialiased.
---
---
---### NOTE:
---- Alpha sampling is disabled by default.
---- This feature can be used for a simple transparency effect, pixels with an alpha of zero will
---  have their depth value discarded, allowing things behind them to show through (normally you
---  have to sort objects or write a shader for this).
---
---@param enabled boolean # Whether or not alpha sampling is enabled.
function lovr.graphics.setAlphaSampling(enabled) end

---
---Sets the background color used to clear the screen.
---
---Color components are from 0.0 to 1.0.
---
---
---### NOTE:
---The default background color is `(0.0, 0.0, 0.0, 1.0)`.
---
---@overload fun(hex: number, a?: number)
---@overload fun(color: table)
---@param r number # The red component of the background color.
---@param g number # The green component of the background color.
---@param b number # The blue component of the background color.
---@param a? number # The alpha component of the background color.
function lovr.graphics.setBackgroundColor(r, g, b, a) end

---
---Sets the blend mode.
---
---The blend mode controls how each pixel's color is blended with the previous pixel's color when drawn.
---
---
---### NOTE:
---The default blend mode is `alpha` and `alphamultiply`.
---
---@overload fun()
---@param blend lovr.BlendMode # The blend mode.
---@param alphaBlend lovr.BlendAlphaMode # The alpha blend mode.
function lovr.graphics.setBlendMode(blend, alphaBlend) end

---
---Sets or disables the active Canvas object.
---
---If there is an active Canvas, things will be rendered to the Textures attached to that Canvas instead of to the headset.
---
---@param canvas? lovr.Canvas # The new active Canvas object, or `nil` to just render to the headset.
function lovr.graphics.setCanvas(canvas) end

---
---Sets the color used for drawing objects.
---
---Color components are from 0.0 to 1.0.
---
---Every pixel drawn will be multiplied (i.e. tinted) by this color.
---
---This is a global setting, so it will affect all subsequent drawing operations.
---
---
---### NOTE:
---The default color is `(1.0, 1.0, 1.0, 1.0)`.
---
---@overload fun(hex: number, a?: number)
---@overload fun(color: table)
---@param r number # The red component of the color.
---@param g number # The green component of the color.
---@param b number # The blue component of the color.
---@param a? number # The alpha component of the color.
function lovr.graphics.setColor(r, g, b, a) end

---
---Enables and disables individual color channels.
---
---When a color channel is enabled, it will be affected by drawing commands and clear commands.
---
---
---### NOTE:
---By default, all color channels are enabled.
---
---Disabling all of the color channels can be useful if you only want to write to the depth buffer or the stencil buffer.
---
---@param r boolean # Whether the red color channel should be enabled.
---@param g boolean # Whether the green color channel should be enabled.
---@param b boolean # Whether the blue color channel should be enabled.
---@param a boolean # Whether the alpha color channel should be enabled.
function lovr.graphics.setColorMask(r, g, b, a) end

---
---Enables or disables culling.
---
---Culling is an optimization that avoids rendering the back face of polygons.
---
---This improves performance by reducing the number of polygons drawn, but requires that the vertices in triangles are specified in a consistent clockwise or counter clockwise order.
---
---
---### NOTE:
---Culling is disabled by default.
---
---@param isEnabled boolean # Whether or not culling should be enabled.
function lovr.graphics.setCullingEnabled(isEnabled) end

---
---Sets the default filter mode for new Textures.
---
---This controls how textures are sampled when they are minified, magnified, or stretched.
---
---
---### NOTE:
---The default filter is `trilinear`.
---
---The maximum supported anisotropy level can be queried using `lovr.graphics.getLimits`.
---
---@param mode lovr.FilterMode # The filter mode.
---@param anisotropy number # The level of anisotropy to use.
function lovr.graphics.setDefaultFilter(mode, anisotropy) end

---
---Sets the current depth test.
---
---The depth test controls how overlapping objects are rendered.
---
---
---### NOTE:
---The depth test is an advanced technique to control how 3D objects overlap each other when they are rendered.
---
---It works as follows:
---
---- Each pixel keeps track of its z value as well as its color.
---- If `write` is enabled when something is drawn, then any pixels that are drawn will have their
---  z values updated.
---- Additionally, anything drawn will first compare the existing z value of a pixel with the new z
---  value.
---
---The `compareMode` setting determines how this comparison is performed.
---
---If the
---  comparison succeeds, the new pixel will overwrite the previous one, otherwise that pixel won't
---  be rendered to.
---
---Smaller z values are closer to the camera.
---
---The default compare mode is `lequal`, which usually gives good results for normal 3D rendering.
---
---@param compareMode? lovr.CompareMode # The new depth test.  Use `nil` to disable the depth test.
---@param write? boolean # Whether pixels will have their z value updated when rendered to.
function lovr.graphics.setDepthTest(compareMode, write) end

---
---Sets the active font used to render text with `lovr.graphics.print`.
---
---@param font? lovr.Font # The font to use.  If `nil`, the default font is used (Varela Round).
function lovr.graphics.setFont(font) end

---
---Sets the width of lines rendered using `lovr.graphics.line`.
---
---
---### NOTE:
---The default line width is `1`.
---
---GPU driver support for line widths is poor.
---
---The actual width of lines may be different from what is set here.
---
---In particular, some graphics drivers only support a line width of `1`.
---
---Currently this function only supports integer values from 1 to 255.
---
---@param width? number # The new line width, in pixels.
function lovr.graphics.setLineWidth(width) end

---
---Sets the width of drawn points, in pixels.
---
---
---### NOTE:
---The default point size is `1.0`.
---
---@param size? number # The new point size.
function lovr.graphics.setPointSize(size) end

---
---Sets the projection for a single view.
---
---4 field of view angles can be used, similar to the field of view returned by `lovr.headset.getViewAngles`.
---
---Alternatively, a projection matrix can be used for other types of projections like orthographic, oblique, etc.
---
---Two views are supported, one for each eye.
---
---When rendering to the headset, both projections are changed to match the ones used by the headset.
---
---
---### NOTE:
---Non-stereo rendering will only use the first view.
---
---The projection matrices are available as the `mat4 lovrProjections[2]` variable in shaders.
---
---The current projection matrix is available as `lovrProjection`.
---
---@overload fun(view: number, matrix: lovr.Mat4)
---@param view number # The index of the view to update.
---@param left number # The left field of view angle, in radians.
---@param right number # The right field of view angle, in radians.
---@param up number # The top field of view angle, in radians.
---@param down number # The bottom field of view angle, in radians.
function lovr.graphics.setProjection(view, left, right, up, down) end

---
---Sets or disables the Shader used for drawing.
---
---@overload fun()
---@param shader lovr.Shader # The shader to use.
function lovr.graphics.setShader(shader) end

---
---Sets the stencil test.
---
---The stencil test lets you mask out pixels that meet certain criteria, based on the contents of the stencil buffer.
---
---The stencil buffer can be modified using `lovr.graphics.stencil`.
---
---After rendering to the stencil buffer, the stencil test can be set to control how subsequent drawing functions are masked by the stencil buffer.
---
---
---### NOTE:
---Stencil values are between 0 and 255.
---
---By default, the stencil test is disabled.
---
---@overload fun()
---@param compareMode lovr.CompareMode # The comparison method used to decide if a pixel should be visible, or nil if the stencil test is disabled.
---@param compareValue number # The value to compare stencil values to.
function lovr.graphics.setStencilTest(compareMode, compareValue) end

---
---Sets the pose for a single view.
---
---Objects rendered in this view will appear as though the camera is positioned using the given pose.
---
---Two views are supported, one for each eye.
---
---When rendering to the headset, both views are changed to match the estimated eye positions.
---
---These view poses are also available using `lovr.headset.getViewPose`.
---
---
---### NOTE:
---Non-stereo rendering will only use the first view.
---
---The inverted view poses (view matrices) are available as the `mat4 lovrViews[2]` variable in shaders.
---
---The current view matrix is available as `lovrView`.
---
---@overload fun(view: number, matrix: lovr.Mat4, inverted: boolean)
---@param view number # The index of the view to update.
---@param x number # The x position of the viewer, in meters.
---@param y number # The y position of the viewer, in meters.
---@param z number # The z position of the viewer, in meters.
---@param angle number # The number of radians the viewer is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function lovr.graphics.setViewPose(view, x, y, z, angle, ax, ay, az) end

---
---Sets the polygon winding.
---
---The winding direction determines which face of a triangle is the front face and which is the back face.
---
---This lets the graphics engine cull the back faces of polygons, improving performance.
---
---The default is counterclockwise.
---
---
---### NOTE:
---Culling is initially disabled and must be enabled using `lovr.graphics.setCullingEnabled`.
---
---The default winding direction is counterclockwise.
---
---@param winding lovr.Winding # The new winding direction.
function lovr.graphics.setWinding(winding) end

---
---Enables or disables wireframe rendering.
---
---This is meant to be used as a debugging tool.
---
---
---### NOTE:
---Wireframe rendering is initially disabled.
---
---Wireframe rendering is only supported on desktop systems.
---
---@param wireframe boolean # Whether or not wireframe rendering should be enabled.
function lovr.graphics.setWireframe(wireframe) end

---
---Render a skybox from a texture.
---
---Two common kinds of skybox textures are supported: A 2D equirectangular texture with a spherical coordinates can be used, or a "cubemap" texture created from 6 images.
---
---@param texture lovr.Texture # The texture to use.
function lovr.graphics.skybox(texture) end

---
---Draws a sphere.
---
---@overload fun(material: lovr.Material, x?: number, y?: number, z?: number, radius?: number, angle?: number, ax?: number, ay?: number, az?: number)
---@param x? number # The x coordinate of the center of the sphere.
---@param y? number # The y coordinate of the center of the sphere.
---@param z? number # The z coordinate of the center of the sphere.
---@param radius? number # The radius of the sphere, in meters.
---@param angle? number # The rotation of the sphere around its rotation axis, in radians.
---@param ax? number # The x coordinate of the sphere's axis of rotation.
---@param ay? number # The y coordinate of the sphere's axis of rotation.
---@param az? number # The z coordinate of the sphere's axis of rotation.
function lovr.graphics.sphere(x, y, z, radius, angle, ax, ay, az) end

---
---Renders to the stencil buffer using a function.
---
---
---### NOTE:
---Stencil values are between 0 and 255.
---
---@overload fun(callback: function, action?: lovr.StencilAction, value?: number, initial?: number)
---@param callback function # The function that will be called to render to the stencil buffer.
---@param action? lovr.StencilAction # How to modify the stencil value of pixels that are rendered to.
---@param value? number # If `action` is "replace", this is the value that pixels are replaced with.
---@param keep? boolean # If false, the stencil buffer will be cleared to zero before rendering.
function lovr.graphics.stencil(callback, action, value, keep) end

---
---Starts a named timer on the GPU, which can be stopped using `lovr.graphics.tock`.
---
---
---### NOTE:
---The timer can be stopped by calling `lovr.graphics.tock` using the same name.
---
---All drawing commands between the tick and the tock will be timed.
---
---It is not possible to nest calls to tick and tock.
---
---GPU timers are not supported on all systems.
---
---Check the `timers` feature using `lovr.graphics.getFeatures` to see if it is supported on the current system.
---
---@param label string # The name of the timer.
function lovr.graphics.tick(label) end

---
---Stops a named timer on the GPU, previously started with `lovr.graphics.tick`.
---
---
---### NOTE:
---All drawing commands between tick and tock will be timed.
---
---It is not possible to nest calls to tick and tock.
---
---The results are delayed, and might be `nil` for the first few frames.
---
---This function returns the most recent available timer value.
---
---GPU timers are not supported on all systems.
---
---Check the `timers` feature using `lovr.graphics.getFeatures` to see if it is supported on the current system.
---
---@param label string # The name of the timer.
---@return number time # The number of seconds elapsed, or `nil` if the data isn't ready yet.
function lovr.graphics.tock(label) end

---
---Apply a transform to the coordinate system, changing its translation, rotation, and scale using a single function.
---
---A `mat4` can also be used.
---
---The transformation will last until `lovr.draw` returns or the transformation is popped off the transformation stack.
---
---@overload fun(transform: lovr.mat4)
---@param x? number # The x component of the translation.
---@param y? number # The y component of the translation.
---@param z? number # The z component of the translation.
---@param sx? number # The x scale factor.
---@param sy? number # The y scale factor.
---@param sz? number # The z scale factor.
---@param angle? number # The number of radians to rotate around the rotation axis.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
function lovr.graphics.transform(x, y, z, sx, sy, sz, angle, ax, ay, az) end

---
---Translates the coordinate system in three dimensions.
---
---All graphics operations that use coordinates will behave as if they are offset by the translation value.
---
---The translation will last until `lovr.draw` returns or the transformation is popped off the transformation stack.
---
---
---### NOTE:
---Order matters when scaling, translating, and rotating the coordinate system.
---
---@param x? number # The amount to translate on the x axis.
---@param y? number # The amount to translate on the y axis.
---@param z? number # The amount to translate on the z axis.
function lovr.graphics.translate(x, y, z) end

---
---A Canvas is also known as a framebuffer or render-to-texture.
---
---It allows you to render to a texture instead of directly to the screen.
---
---This lets you postprocess or transform the results later before finally rendering them to the screen.
---
---After creating a Canvas, you can attach Textures to it using `Canvas:setTexture`.
---
---
---### NOTE:
---Up to four textures can be attached to a Canvas and anything rendered to the Canvas will be broadcast to all attached Textures.
---
---If you want to do render different things to different textures, use the `multicanvas` shader flag when creating your shader and implement the `void colors` function instead of the usual `vec4 color` function.
---
---You can then assign different output colors to `lovrCanvas[0]`, `lovrCanvas[1]`, etc. instead of returning a single color. Each color written to the array will end up in the corresponding texture attached to the Canvas.
---
---@class lovr.Canvas
local Canvas = {}

---
---Returns the depth buffer used by the Canvas as a Texture.
---
---If the Canvas was not created with a readable depth buffer (the `depth.readable` flag in `lovr.graphics.newCanvas`), then this function will return `nil`.
---
---@return lovr.Texture texture # The depth Texture of the Canvas.
function Canvas:getDepthTexture() end

---
---Returns the dimensions of the Canvas, its Textures, and its depth buffer.
---
---
---### NOTE:
---The dimensions of a Canvas can not be changed after it is created.
---
---@return number width # The width of the Canvas, in pixels.
---@return number height # The height of the Canvas, in pixels.
function Canvas:getDimensions() end

---
---Returns the height of the Canvas, its Textures, and its depth buffer.
---
---
---### NOTE:
---The height of a Canvas can not be changed after it is created.
---
---@return number height # The height of the Canvas, in pixels.
function Canvas:getHeight() end

---
---Returns the number of multisample antialiasing samples to use when rendering to the Canvas. Increasing this number will make the contents of the Canvas appear more smooth at the cost of performance.
---
---It is common to use powers of 2 for this value.
---
---
---### NOTE:
---All textures attached to the Canvas must be created with this MSAA value.
---
---@return number samples # The number of MSAA samples.
function Canvas:getMSAA() end

---
---Returns the set of Textures currently attached to the Canvas.
---
---
---### NOTE:
---Up to 4 Textures can be attached at once.
---
function Canvas:getTexture() end

---
---Returns the width of the Canvas, its Textures, and its depth buffer.
---
---
---### NOTE:
---The width of a Canvas can not be changed after it is created.
---
---@return number width # The width of the Canvas, in pixels.
function Canvas:getWidth() end

---
---Returns whether the Canvas was created with the `stereo` flag.
---
---Drawing something to a stereo Canvas will draw it to two viewports in the left and right half of the Canvas, using transform information from two different eyes.
---
---@return boolean stereo # Whether the Canvas is stereo.
function Canvas:isStereo() end

---
---Returns a new Image containing the contents of a Texture attached to the Canvas.
---
---
---### NOTE:
---The Image will have the same pixel format as the Texture that is read from.
---
---@param index? number # The index of the Texture to read from.
---@return lovr.Image image # The new Image.
function Canvas:newImage(index) end

---
---Renders to the Canvas using a function.
---
---All graphics functions inside the callback will affect the Canvas contents instead of directly rendering to the headset.
---
---This can be used in `lovr.update`.
---
---
---### NOTE:
---Make sure you clear the contents of the canvas before rendering by using `lovr.graphics.clear`. Otherwise there might be data in the canvas left over from a previous frame.
---
---Also note that the transform stack is not modified by this function.
---
---If you plan on modifying the transform stack inside your callback it may be a good idea to use `lovr.graphics.push` and `lovr.graphics.pop` so you can revert to the previous transform afterwards.
---
---@param callback function # The function to use to render to the Canvas.
---@vararg any # Additional arguments to pass to the callback.
function Canvas:renderTo(callback, ...) end

---
---Attaches one or more Textures to the Canvas.
---
---When rendering to the Canvas, everything will be drawn to all attached Textures.
---
---You can attach different layers of an array, cubemap, or volume texture, and also attach different mipmap levels of Textures.
---
---
---### NOTE:
---There are some restrictions on how textures can be attached:
---
---- Up to 4 textures can be attached at once.
---- Textures must have the same dimensions and multisample settings as the Canvas.
---
---To specify layers and mipmaps to attach, specify them after the Texture.
---
---You can also optionally wrap them in a table.
---
---@vararg any # One or more Textures to attach to the Canvas.
function Canvas:setTexture(...) end

---
---A Font is an object created from a TTF file.
---
---It can be used to render text with `lovr.graphics.print`.
---
---@class lovr.Font
local Font = {}

---
---Returns the maximum distance that any glyph will extend above the Font's baseline.
---
---Units are generally in meters, see `Font:getPixelDensity`.
---
---@return number ascent # The ascent of the Font.
function Font:getAscent() end

---
---Returns the baseline of the Font.
---
---This is where the characters "rest on", relative to the y coordinate of the drawn text.
---
---Units are generally in meters, see `Font:setPixelDensity`.
---
---@return number baseline # The baseline of the Font.
function Font:getBaseline() end

---
---Returns the maximum distance that any glyph will extend below the Font's baseline.
---
---Units are generally in meters, see `Font:getPixelDensity` for more information.
---
---Note that due to the coordinate system for fonts, this is a negative value.
---
---@return number descent # The descent of the Font.
function Font:getDescent() end

---
---Returns the height of a line of text.
---
---Units are in meters, see `Font:setPixelDensity`.
---
---@return number height # The height of a rendered line of text.
function Font:getHeight() end

---
---Returns the current line height multiplier of the Font.
---
---The default is 1.0.
---
---@return number lineHeight # The line height.
function Font:getLineHeight() end

---
---Returns the current pixel density for the Font.
---
---The default is 1.0.
---
---Normally, this is in pixels per meter.
---
---When rendering to a 2D texture, the units are pixels.
---
---@return number pixelDensity # The current pixel density.
function Font:getPixelDensity() end

---
---Returns the underlying `Rasterizer` object for a Font.
---
---@return lovr.Rasterizer rasterizer # The rasterizer.
function Font:getRasterizer() end

---
---Returns the width and line count of a string when rendered using the font, taking into account an optional wrap limit.
---
---
---### NOTE:
---To get the correct units returned, make sure the pixel density is set with
---    `Font:setPixelDensity`.
---
---@param text string # The text to get the width of.
---@param wrap? number # The width at which to wrap lines, or 0 for no wrap.
---@return number width # The maximum width of any line in the text.
---@return number lines # The number of lines in the wrapped text.
---@return number lastwidth # The width of the last line of text (to assist in text layout).
function Font:getWidth(text, wrap) end

---
---Returns whether the Font has a set of glyphs.
---
---Any combination of strings and numbers (corresponding to character codes) can be specified.
---
---This function will return true if the Font is able to render *all* of the glyphs.
---
---
---### NOTE:
---It is a good idea to use this function when you're rendering an unknown or user-supplied string to avoid utterly embarrassing crashes.
---
---@vararg any # Strings or numbers to test.
---@return boolean has # Whether the Font has the glyphs.
function Font:hasGlyphs(...) end

---
---Sets the line height of the Font, which controls how far lines apart lines are vertically separated.
---
---This value is a ratio and the default is 1.0.
---
---@param lineHeight number # The new line height.
function Font:setLineHeight(lineHeight) end

---
---Sets the pixel density for the Font.
---
---Normally, this is in pixels per meter.
---
---When rendering to a 2D texture, the units are pixels.
---
---@overload fun(self: lovr.Font)
---@param pixelDensity number # The new pixel density.
function Font:setPixelDensity(pixelDensity) end

---
---A Material is an object used to control how objects appear, through coloring, texturing, and shading.
---
---The Material itself holds sets of colors, textures, and other parameters that are made available to Shaders.
---
---@class lovr.Material
local Material = {}

---
---Returns a color property for a Material.
---
---Different types of colors are supported for different lighting parameters.
---
---Colors default to `(1.0, 1.0, 1.0, 1.0)` and are gamma corrected.
---
---@param colorType? lovr.MaterialColor # The type of color to get.
---@return number r # The red component of the color.
---@return number g # The green component of the color.
---@return number b # The blue component of the color.
---@return number a # The alpha component of the color.
function Material:getColor(colorType) end

---
---Returns a numeric property of a Material.
---
---Scalar properties default to 1.0.
---
---@param scalarType lovr.MaterialScalar # The type of property to get.
---@return number x # The value of the property.
function Material:getScalar(scalarType) end

---
---Returns a texture for a Material.
---
---Several predefined `MaterialTexture`s are supported.
---
---Any texture that is `nil` will use a single white pixel as a fallback.
---
---@param textureType? lovr.MaterialTexture # The type of texture to get.
---@return lovr.Texture texture # The texture that is set, or `nil` if no texture is set.
function Material:getTexture(textureType) end

---
---Returns the transformation applied to texture coordinates of the Material.
---
---
---### NOTE:
---Although texture coordinates will automatically be transformed by the Material's transform, the material transform is exposed as the `mat3 lovrMaterialTransform` uniform variable in shaders, allowing it to be used for other purposes.
---
---@return number ox # The texture coordinate x offset.
---@return number oy # The texture coordinate y offset.
---@return number sx # The texture coordinate x scale.
---@return number sy # The texture coordinate y scale.
---@return number angle # The texture coordinate rotation, in radians.
function Material:getTransform() end

---
---Sets a color property for a Material.
---
---Different types of colors are supported for different lighting parameters.
---
---Colors default to `(1.0, 1.0, 1.0, 1.0)` and are gamma corrected.
---
---@overload fun(self: lovr.Material, r: number, g: number, b: number, a?: number)
---@overload fun(self: lovr.Material, colorType?: lovr.MaterialColor, hex: number, a?: number)
---@overload fun(self: lovr.Material, hex: number, a?: number)
---@param colorType? lovr.MaterialColor # The type of color to set.
---@param r number # The red component of the color.
---@param g number # The green component of the color.
---@param b number # The blue component of the color.
---@param a? number # The alpha component of the color.
function Material:setColor(colorType, r, g, b, a) end

---
---Sets a numeric property of a Material.
---
---Scalar properties default to 1.0.
---
---@param scalarType lovr.MaterialScalar # The type of property to set.
---@param x number # The value of the property.
function Material:setScalar(scalarType, x) end

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
---Sets the transformation applied to texture coordinates of the Material.
---
---This lets you offset, scale, or rotate textures as they are applied to geometry.
---
---
---### NOTE:
---Although texture coordinates will automatically be transformed by the Material's transform, the material transform is exposed as the `mat3 lovrMaterialTransform` uniform variable in shaders, allowing it to be used for other purposes.
---
---@param ox number # The texture coordinate x offset.
---@param oy number # The texture coordinate y offset.
---@param sx number # The texture coordinate x scale.
---@param sy number # The texture coordinate y scale.
---@param angle number # The texture coordinate rotation, in radians.
function Material:setTransform(ox, oy, sx, sy, angle) end

---
---A Mesh is a low-level graphics object that stores and renders a list of vertices.
---
---Meshes are really flexible since you can pack pretty much whatever you want in them.
---
---This makes them great for rendering arbitrary geometry, but it also makes them kinda difficult to use since you have to place each vertex yourself.
---
---It's possible to batch geometry with Meshes too.
---
---Instead of drawing a shape 100 times, it's much faster to pack 100 copies of the shape into a Mesh and draw the Mesh once.
---
---Even storing just one copy in the Mesh and drawing that 100 times is usually faster.
---
---Meshes are also a good choice if you have an object that changes its shape over time.
---
---
---### NOTE:
---Each vertex in a Mesh can hold several pieces of data.
---
---For example, you might want a vertex to keep track of its position, color, and a weight.
---
---Each one of these pieces of information is called a vertex **attribute**.
---
---A vertex attribute must have a name, a type, and a size.
---
---Here's what the "position" attribute would look like as a Lua table:
---
---    { 'vPosition', 'float', 3 } -- 3 floats, one for x, y, and z
---
---Every vertex in a Mesh must have the same set of attributes.
---
---We call this set of attributes the **format** of the Mesh, and it's specified as a simple table of attributes.
---
---For example, we could represent the format described above as:
---
---    {
---      { 'vPosition', 'float', 3 },
---      { 'vColor',    'byte',  4 },
---      { 'vWeight',   'int',   1 }
---    }
---
---When creating a Mesh, you can give it any format you want, or use the default.
---
---The default Mesh format looks like this:
---
---    {
---      { 'lovrPosition',    'float', 3 },
---      { 'lovrNormal',      'float', 3 },
---      { 'lovrTexCoord',    'float', 2 }
---    }
---
---Great, so why do we go through the trouble of naming everything in our vertex and saying what type and size it is?  The cool part is that we can access this data in a Shader.
---
---We can write a vertex Shader that has `in` variables for every vertex attribute in our Mesh:
---
---    in vec3 vPosition;
---    in vec4 vColor;
---    in int vWeight;
---
---    vec4 position(mat4 projection, mat4 transform, vec4 vertex) {
---      // Here we can access the vPosition, vColor, and vWeight of each vertex in the Mesh!
---    }
---
---Specifying custom vertex data is really powerful and is often used for lighting, animation, and more!
---
---For more on the different data types available for the attributes, see `AttributeType`.
---
---@class lovr.Mesh
local Mesh = {}

---
---Attaches attributes from another Mesh onto this one.
---
---This can be used to share vertex data across multiple meshes without duplicating the data, and can also be used for instanced rendering by using the `divisor` parameter.
---
---
---### NOTE:
---The attribute divisor is a  number used to control how the attribute data relates to instancing. If 0, then the attribute data is considered "per vertex", and each vertex will get the next element of the attribute's data.
---
---If the divisor 1 or more, then the attribute data is considered "per instance", and every N instances will get the next element of the attribute data.
---
---To prevent cycles, it is not possible to attach attributes onto a Mesh that already has attributes attached to a different Mesh.
---
---@overload fun(self: lovr.Mesh, mesh: lovr.Mesh, divisor?: number, ...)
---@overload fun(self: lovr.Mesh, mesh: lovr.Mesh, divisor?: number, attributes: table)
---@param mesh lovr.Mesh # The Mesh to attach attributes from.
---@param divisor? number # The attribute divisor for all attached attributes.
function Mesh:attachAttributes(mesh, divisor) end

---
---Detaches attributes that were attached using `Mesh:attachAttributes`.
---
---@overload fun(self: lovr.Mesh, mesh: lovr.Mesh, ...)
---@overload fun(self: lovr.Mesh, mesh: lovr.Mesh, attributes: table)
---@param mesh lovr.Mesh # A Mesh.  The names of all of the attributes from this Mesh will be detached.
function Mesh:detachAttributes(mesh) end

---
---Draws the contents of the Mesh.
---
---@overload fun(self: lovr.Mesh, transform: lovr.mat4, instances?: number)
---@param x? number # The x coordinate to draw the Mesh at.
---@param y? number # The y coordinate to draw the Mesh at.
---@param z? number # The z coordinate to draw the Mesh at.
---@param scale? number # The scale to draw the Mesh at.
---@param angle? number # The angle to rotate the Mesh around the axis of rotation, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param instances? number # The number of copies of the Mesh to draw.
function Mesh:draw(x, y, z, scale, angle, ax, ay, az, instances) end

---
---Get the draw mode of the Mesh, which controls how the vertices are connected together.
---
---@return lovr.DrawMode mode # The draw mode of the Mesh.
function Mesh:getDrawMode() end

---
---Retrieve the current draw range for the Mesh.
---
---The draw range is a subset of the vertices of the Mesh that will be drawn.
---
---@return number start # The index of the first vertex that will be drawn, or nil if no draw range is set.
---@return number count # The number of vertices that will be drawn, or nil if no draw range is set.
function Mesh:getDrawRange() end

---
---Get the Material applied to the Mesh.
---
---@return lovr.Material material # The current material applied to the Mesh.
function Mesh:getMaterial() end

---
---Gets the data for a single vertex in the Mesh.
---
---The set of data returned depends on the Mesh's vertex format.
---
---The default vertex format consists of 8 floating point numbers: the vertex position, the vertex normal, and the texture coordinates.
---
---@param index number # The index of the vertex to retrieve.
function Mesh:getVertex(index) end

---
---Returns the components of a specific attribute of a single vertex in the Mesh.
---
---
---### NOTE:
---Meshes without a custom format have the vertex position as their first attribute, the normal vector as the second attribute, and the texture coordinate as the third attribute.
---
---@param index number # The index of the vertex to retrieve the attribute of.
---@param attribute number # The index of the attribute to retrieve the components of.
function Mesh:getVertexAttribute(index, attribute) end

---
---Returns the maximum number of vertices the Mesh can hold.
---
---
---### NOTE:
---The size can only be set when creating the Mesh, and cannot be changed afterwards.
---
---A subset of the Mesh's vertices can be rendered, see `Mesh:setDrawRange`.
---
---@return number size # The number of vertices the Mesh can hold.
function Mesh:getVertexCount() end

---
---Get the format table of the Mesh's vertices.
---
---The format table describes the set of data that each vertex contains.
---
---@return table format # The table of vertex attributes.  Each attribute is a table containing the name of the attribute, the `AttributeType`, and the number of components.
function Mesh:getVertexFormat() end

---
---Returns the current vertex map for the Mesh.
---
---The vertex map is a list of indices in the Mesh, allowing the reordering or reuse of vertices.
---
---@overload fun(self: lovr.Mesh, t: table):table
---@overload fun(self: lovr.Mesh, blob: lovr.Blob)
---@return table map # The list of indices in the vertex map, or `nil` if no vertex map is set.
function Mesh:getVertexMap() end

---
---Returns whether or not a vertex attribute is enabled.
---
---Disabled attributes won't be sent to shaders.
---
---@param attribute string # The name of the attribute.
---@return boolean enabled # Whether or not the attribute is enabled when drawing the Mesh.
function Mesh:isAttributeEnabled(attribute) end

---
---Sets whether a vertex attribute is enabled.
---
---Disabled attributes won't be sent to shaders.
---
---@param attribute string # The name of the attribute.
---@param enabled boolean # Whether or not the attribute is enabled when drawing the Mesh.
function Mesh:setAttributeEnabled(attribute, enabled) end

---
---Set a new draw mode for the Mesh.
---
---@param mode lovr.DrawMode # The new draw mode for the Mesh.
function Mesh:setDrawMode(mode) end

---
---Set the draw range for the Mesh.
---
---The draw range is a subset of the vertices of the Mesh that will be drawn.
---
---@overload fun(self: lovr.Mesh)
---@param start number # The first vertex that will be drawn.
---@param count number # The number of vertices that will be drawn.
function Mesh:setDrawRange(start, count) end

---
---Applies a Material to the Mesh.
---
---This will cause it to use the Material's properties whenever it is rendered.
---
---@param material lovr.Material # The Material to apply.
function Mesh:setMaterial(material) end

---
---Update a single vertex in the Mesh.
---
---
---### NOTE:
---Any unspecified components will be set to 0.
---
---@param index number # The index of the vertex to set.
---@vararg number # The attributes of the vertex.
function Mesh:setVertex(index, ...) end

---
---Set the components of a specific attribute of a vertex in the Mesh.
---
---
---### NOTE:
---Meshes without a custom format have the vertex position as their first attribute, the normal vector as the second attribute, and the texture coordinate as the third attribute.
---
---@param index number # The index of the vertex to update.
---@param attribute number # The index of the attribute to update.
---@vararg number # The new components for the attribute.
function Mesh:setVertexAttribute(index, attribute, ...) end

---
---Sets the vertex map.
---
---The vertex map is a list of indices in the Mesh, allowing the reordering or reuse of vertices.
---
---Often, a vertex map is used to improve performance, since it usually requires less data to specify the index of a vertex than it does to specify all of the data for a vertex.
---
---@overload fun(self: lovr.Mesh, blob: lovr.Blob, size?: number)
---@param map table # The new vertex map.  Each element of the table is an index of a vertex.
function Mesh:setVertexMap(map) end

---
---Updates multiple vertices in the Mesh.
---
---
---### NOTE:
---The start index plus the number of vertices in the table should not exceed the maximum size of the Mesh.
---
---@overload fun(self: lovr.Mesh, blob: lovr.Blob, start?: number, count?: number)
---@param vertices table # The new set of vertices.
---@param start? number # The index of the vertex to start replacing at.
---@param count? number # The number of vertices to replace.  If nil, all vertices will be used.
function Mesh:setVertices(vertices, start, count) end

---
---A Model is a drawable object loaded from a 3D file format.
---
---The supported 3D file formats are OBJ, glTF, and STL.
---
---@class lovr.Model
local Model = {}

---
---Applies an animation to the current pose of the Model.
---
---The animation is evaluated at the specified timestamp, and mixed with the current pose of the Model using the alpha value.
---
---An alpha value of 1.0 will completely override the pose of the Model with the animation's pose.
---
---
---### NOTE:
---For animations to properly show up, use a Shader created with the `animated` flag set to `true`. See `lovr.graphics.newShader` for more.
---
---Animations are always mixed in with the current pose, and the pose only ever changes by calling `Model:animate` and `Model:pose`.
---
---To clear the pose of a Model to the default, use `Model:pose(nil)`.
---
---@overload fun(self: lovr.Model, index: number, time: number, alpha?: number)
---@param name string # The name of an animation.
---@param time number # The timestamp to evaluate the keyframes at, in seconds.
---@param alpha? number # How much of the animation to mix in, from 0 to 1.
function Model:animate(name, time, alpha) end

---
---Draw the Model.
---
---@overload fun(self: lovr.Model, transform: lovr.mat4, instances?: number)
---@param x? number # The x coordinate to draw the Model at.
---@param y? number # The y coordinate to draw the Model at.
---@param z? number # The z coordinate to draw the Model at.
---@param scale? number # The scale to draw the Model at.
---@param angle? number # The angle to rotate the Model around the axis of rotation, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param instances? number # The number of copies of the Model to draw.
function Model:draw(x, y, z, scale, angle, ax, ay, az, instances) end

---
---Returns a bounding box that encloses the vertices of the Model.
---
---@return number minx # The minimum x coordinate of the box.
---@return number maxx # The maximum x coordinate of the box.
---@return number miny # The minimum y coordinate of the box.
---@return number maxy # The maximum y coordinate of the box.
---@return number minz # The minimum z coordinate of the box.
---@return number maxz # The maximum z coordinate of the box.
function Model:getAABB() end

---
---Returns the number of animations in the Model.
---
---@return number count # The number of animations in the Model.
function Model:getAnimationCount() end

---
---Returns the duration of an animation in the Model, in seconds.
---
---@overload fun(self: lovr.Model, index: number):number
---@param name string # The name of the animation.
---@return number duration # The duration of the animation, in seconds.
function Model:getAnimationDuration(name) end

---
---Returns the name of one of the animations in the Model.
---
---@param index number # The index of the animation to get the name of.
---@return string name # The name of the animation.
function Model:getAnimationName(index) end

---
---Returns a Material loaded from the Model, by name or index.
---
---This includes `Texture` objects and other properties like colors, metalness/roughness, and more.
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
---Returns the name of one of the materials in the Model.
---
---@param index number # The index of the material to get the name of.
---@return string name # The name of the material.
function Model:getMaterialName(index) end

---
---Returns the number of nodes (bones) in the Model.
---
---@return number count # The number of nodes in the Model.
function Model:getNodeCount() end

---
---Returns the name of one of the nodes (bones) in the Model.
---
---@param index number # The index of the node to get the name of.
---@return string name # The name of the node.
function Model:getNodeName(index) end

---
---Returns the pose of a single node in the Model in a given `CoordinateSpace`.
---
---
---### NOTE:
---For skinned nodes to render correctly, use a Shader created with the `animated` flag set to `true`.
---
---See `lovr.graphics.newShader` for more.
---
---@overload fun(self: lovr.Model, index: number, space?: lovr.CoordinateSpace):number, number, number, number, number, number, number
---@param name string # The name of the node.
---@param space? lovr.CoordinateSpace # Whether the pose should be returned relative to the node's parent or relative to the root node of the Model.
---@return number x # The x position of the node.
---@return number y # The y position of the node.
---@return number z # The z position of the node.
---@return number angle # The number of radians the node is rotated around its rotational axis.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Model:getNodePose(name, space) end

---
---Returns 2 tables containing mesh data for the Model.
---
---The first table is a list of vertex positions and contains 3 numbers for the x, y, and z coordinate of each vertex.
---
---The second table is a list of triangles and contains 1-based indices into the first table representing the first, second, and third vertices that make up each triangle.
---
---The vertex positions will be affected by node transforms.
---
---@return table vertices # A flat table of numbers containing vertex positions.
---@return table indices # A flat table of numbers containing triangle vertex indices.
function Model:getTriangles() end

---
---Returns whether the Model has any nodes associated with animated joints.
---
---This can be used to approximately determine whether an animated shader needs to be used with an arbitrary Model.
---
---
---### NOTE:
---A model can still be animated even if this function returns false, since node transforms can still be animated with keyframes without skinning.
---
---These types of animations don't need to use a Shader with the `animated = true` flag, though.
---
---@return boolean skeletal # Whether the Model has any nodes that use skeletal animation.
function Model:hasJoints() end

---
---Applies a pose to a single node of the Model.
---
---The input pose is assumed to be relative to the pose of the node's parent.
---
---This is useful for applying inverse kinematics (IK) to a chain of bones in a skeleton.
---
---The alpha parameter can be used to mix between the node's current pose and the input pose.
---
---
---### NOTE:
---For skinned nodes to render correctly, use a Shader created with the `animated` flag set to `true`.
---
---See `lovr.graphics.newShader` for more.
---
---@overload fun(self: lovr.Model, index: number, x: number, y: number, z: number, angle: number, ax: number, ay: number, az: number, alpha?: number)
---@overload fun(self: lovr.Model)
---@param name string # The name of the node.
---@param x number # The x position.
---@param y number # The y position.
---@param z number # The z position.
---@param angle number # The angle of rotation around the axis, in radians.
---@param ax number # The x component of the rotation axis.
---@param ay number # The y component of the rotation axis.
---@param az number # The z component of the rotation axis.
---@param alpha? number # How much of the pose to mix in, from 0 to 1.
function Model:pose(name, x, y, z, angle, ax, ay, az, alpha) end

---
---Shaders are GLSL programs that transform the way vertices and pixels show up on the screen. They can be used for lighting, postprocessing, particles, animation, and much more.
---
---You can use `lovr.graphics.setShader` to change the active Shader.
---
---
---### NOTE:
---GLSL version `330` is used on desktop systems, and `300 es` on WebGL/Android.
---
---The default vertex shader:
---
---    vec4 position(mat4 projection, mat4 transform, vec4 vertex) {
---      return projection * transform * vertex;
---    }
---
---The default fragment shader:
---
---    vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) {
---      return graphicsColor * lovrDiffuseColor * lovrVertexColor * texture(image, uv);
---    }
---
---Additionally, the following headers are prepended to the shader source, giving you convenient access to a default set of uniform variables and vertex attributes.
---
---Vertex shader header:
---
---    in vec3 lovrPosition; // The vertex position
---    in vec3 lovrNormal; // The vertex normal vector
---    in vec2 lovrTexCoord;
---    in vec4 lovrVertexColor;
---    in vec3 lovrTangent;
---    in uvec4 lovrBones;
---    in vec4 lovrBoneWeights;
---    in uint lovrDrawID;
---    out vec4 lovrGraphicsColor;
---    uniform mat4 lovrModel;
---    uniform mat4 lovrView;
---    uniform mat4 lovrProjection;
---    uniform mat4 lovrTransform; // Model-View matrix
---    uniform mat3 lovrNormalMatrix; // Inverse-transpose of lovrModel
---    uniform mat3 lovrMaterialTransform;
---    uniform float lovrPointSize;
---    uniform mat4 lovrPose[48];
---    uniform int lovrViewportCount;
---    uniform int lovrViewID;
---    const mat4 lovrPoseMatrix; // Bone-weighted pose
---    const int lovrInstanceID; // Current instance ID
---
---Fragment shader header:
---
---    in vec2 lovrTexCoord;
---    in vec4 lovrVertexColor;
---    in vec4 lovrGraphicsColor;
---    out vec4 lovrCanvas[gl_MaxDrawBuffers];
---    uniform float lovrMetalness;
---    uniform float lovrRoughness;
---    uniform vec4 lovrDiffuseColor;
---    uniform vec4 lovrEmissiveColor;
---    uniform sampler2D lovrDiffuseTexture;
---    uniform sampler2D lovrEmissiveTexture;
---    uniform sampler2D lovrMetalnessTexture;
---    uniform sampler2D lovrRoughnessTexture;
---    uniform sampler2D lovrOcclusionTexture;
---    uniform sampler2D lovrNormalTexture;
---    uniform samplerCube lovrEnvironmentTexture;
---    uniform int lovrViewportCount;
---    uniform int lovrViewID;
---
---### Compute Shaders
---
---Compute shaders can be created with `lovr.graphics.newComputeShader` and run with `lovr.graphics.compute`.
---
---Currently, compute shaders are written with raw GLSL.
---
---There is no default compute shader, instead the `void compute();` function must be implemented.
---
---You can use the `layout` qualifier to specify a local work group size:
---
---    layout(local_size_x = X, local_size_y = Y, local_size_z = Z) in;
---
---And the following built in variables can be used:
---
---    in uvec3 gl_NumWorkGroups;       // The size passed to lovr.graphics.compute
---    in uvec3 gl_WorkGroupSize;       // The local work group size
---    in uvec3 gl_WorkGroupID;         // The current global work group
---    in uvec3 gl_LocalInvocationID;   // The current local work group
---    in uvec3 gl_GlobalInvocationID;  // A unique ID combining the global and local IDs
---    in uint gl_LocalInvocationIndex; // A 1D index of the LocalInvocationID
---
---Compute shaders don't return anything but they can write data to `Texture`s or `ShaderBlock`s. To bind a texture in a way that can be written to a compute shader, declare the uniforms with a type of `image2D`, `imageCube`, etc. instead of the usual `sampler2D` or `samplerCube`.
---
---Once a texture is bound to an image uniform, you can use the `imageLoad` and `imageStore` GLSL functions to read and write pixels in the image.
---
---Variables in `ShaderBlock`s can be written to using assignment syntax.
---
---LÖVR handles synchronization of textures and shader blocks so there is no need to use manual memory barriers to synchronize writes to resources from compute shaders.
---
---@class lovr.Shader
local Shader = {}

---
---Returns the type of the Shader, which will be "graphics" or "compute".
---
---Graphics shaders are created with `lovr.graphics.newShader` and can be used for rendering with `lovr.graphics.setShader`.
---
---Compute shaders are created with `lovr.graphics.newComputeShader` and can be run using `lovr.graphics.compute`.
---
---@return lovr.ShaderType type # The type of the Shader.
function Shader:getType() end

---
---Returns whether a Shader has a block.
---
---A block is added to the Shader code at creation time using `ShaderBlock:getShaderCode`.
---
---The block name (not the namespace) is used to link up the ShaderBlock object to the Shader.
---
---This function can be used to check if a Shader was created with a block using the given name.
---
---@param block string # The name of the block.
---@return boolean present # Whether the shader has the specified block.
function Shader:hasBlock(block) end

---
---Returns whether a Shader has a particular uniform variable.
---
---
---### NOTE:
---If a uniform variable is defined but unused in the shader, the shader compiler will optimize it out and the uniform will not report itself as present.
---
---@param uniform string # The name of the uniform variable.
---@return boolean present # Whether the shader has the specified uniform.
function Shader:hasUniform(uniform) end

---
---Updates a uniform variable in the Shader.
---
---
---### NOTE:
---The shader does not need to be active to update its uniforms.
---
---The following type combinations are supported:
---
---<table>
---  <thead>
---    <tr>
---      <td>Uniform type</td>
---      <td>LÖVR type</td>
---    </tr>
---  </thead>
---  <tbody>
---    <tr>
---      <td>float</td>
---      <td>number</td>
---    </tr>
---    <tr>
---      <td>int</td>
---      <td>number</td>
---    </tr>
---    <tr>
---      <td>vec2</td>
---      <td>{ x, y }</td>
---    </tr>
---    <tr>
---      <td>vec3</td>
---      <td>{ x, y, z } or vec3</td>
---    </tr>
---    <tr>
---      <td>vec4</td>
---      <td>{ x, y, z, w }</td>
---    </tr>
---    <tr>
---      <td>ivec2</td>
---      <td>{ x, y }</td>
---    </tr>
---    <tr>
---      <td>ivec3</td>
---      <td>{ x, y, z }</td>
---    </tr>
---    <tr>
---      <td>ivec4</td>
---      <td>{ x, y, z, w }</td>
---    </tr>
---    <tr>
---      <td>mat2</td>
---      <td>{ x, ... }</td>
---    </tr>
---    <tr>
---      <td>mat3</td>
---      <td>{ x, ... }</td>
---    </tr>
---    <tr>
---      <td>mat4</td>
---      <td>{ x, ... } or mat4</td>
---    </tr>
---    <tr>
---      <td>sampler</td>
---      <td>Texture</td>
---    </tr>
---    <tr>
---      <td>image</td>
---      <td>Texture</td>
---    </tr>
---  </tbody> </table>
---
---Uniform arrays can be wrapped in tables or passed as multiple arguments.
---
---Textures must match the type of sampler or image they are being sent to.
---
---The following sampler (and image) types are currently supported:
---
---- `sampler2D`
---- `sampler3D`
---- `samplerCube`
---- `sampler2DArray`
---
---`Blob`s can be used to pass arbitrary binary data to Shader variables.
---
---@param uniform string # The name of the uniform to update.
---@param value any # The new value of the uniform.
---@return boolean success # Whether the uniform exists and was updated.
function Shader:send(uniform, value) end

---
---Sends a ShaderBlock to a Shader.
---
---After the block is sent, you can update the data in the block without needing to resend the block.
---
---The block can be sent to multiple shaders and they will all see the same data from the block.
---
---
---### NOTE:
---The Shader does not need to be active to send it a block.
---
---Make sure the ShaderBlock's variables line up with the block variables declared in the shader code, otherwise you'll get garbage data in the block.
---
---An easy way to do this is to use `ShaderBlock:getShaderCode` to get a GLSL snippet that is compatible with the block.
---
---@param name string # The name of the block to send to.
---@param block lovr.ShaderBlock # The ShaderBlock to associate with the specified block.
---@param access? lovr.UniformAccess # How the Shader will use this block (used as an optimization hint).
function Shader:sendBlock(name, block, access) end

---
---Sends a Texture to a Shader for writing.
---
---This is meant to be used with compute shaders and only works with uniforms declared as `image2D`, `imageCube`, `image2DArray`, and `image3D`.
---
---The normal `Shader:send` function accepts Textures and should be used most of the time.
---
---@overload fun(self: lovr.Shader, name: string, index: number, texture: lovr.Texture, slice?: number, mipmap?: number, access?: lovr.UniformAccess)
---@param name string # The name of the image uniform.
---@param texture lovr.Texture # The Texture to assign.
---@param slice? number # The slice of a cube, array, or volume texture to use, or `nil` for all slices.
---@param mipmap? number # The mipmap of the texture to use.
---@param access? lovr.UniformAccess # Whether the image will be read from, written to, or both.
function Shader:sendImage(name, texture, slice, mipmap, access) end

---
---ShaderBlocks are objects that can hold large amounts of data and can be sent to Shaders.
---
---It is common to use "uniform" variables to send data to shaders, but uniforms are usually limited to a few kilobytes in size.
---
---ShaderBlocks are useful for a few reasons:
---
---- They can hold a lot more data.
---- Shaders can modify the data in them, which is really useful for compute shaders.
---- Setting the data in a ShaderBlock updates the data for all Shaders using the block, so you
---  don't need to go around setting the same uniforms in lots of different shaders.
---
---On systems that support compute shaders, ShaderBlocks can optionally be "writable".
---
---A writable ShaderBlock is a little bit slower than a non-writable one, but shaders can modify its contents and it can be much, much larger than a non-writable ShaderBlock.
---
---
---### NOTE:
---- A Shader can use up to 8 ShaderBlocks.
---- ShaderBlocks can not contain textures.
---- Some systems have bugs with `vec3` variables in ShaderBlocks.
---
---If you run into strange bugs,
---  try switching to a `vec4` for the variable.
---
---@class lovr.ShaderBlock
local ShaderBlock = {}

---
---Returns the byte offset of a variable in a ShaderBlock.
---
---This is useful if you want to manually send binary data to the ShaderBlock using a `Blob` in `ShaderBlock:send`.
---
---@param field string # The name of the variable to get the offset of.
---@return number offset # The byte offset of the variable.
function ShaderBlock:getOffset(field) end

---
---Before a ShaderBlock can be used in a Shader, the Shader has to have the block's variables defined in its source code.
---
---This can be a tedious process, so you can call this function to return a GLSL string that contains this definition.
---
---Roughly, it will look something like this:
---
---    layout(std140) uniform <label> {
---      <type> <name>[<count>];
---    } <namespace>;
---
---@param label string # The label of the block in the shader code.  This will be used to identify it when using `Shader:sendBlock`.
---@param namespace? string # The namespace to use when accessing the block's variables in the shader code.  This can be used to prevent naming conflicts if two blocks have variables with the same name.  If the namespace is nil, the block's variables will be available in the global scope.
---@return string code # The code that can be prepended to `Shader` code.
function ShaderBlock:getShaderCode(label, namespace) end

---
---Returns the size of the ShaderBlock's data, in bytes.
---
---@return number size # The size of the ShaderBlock, in bytes.
function ShaderBlock:getSize() end

---
---Returns the type of the ShaderBlock.
---
---@return lovr.BlockType type # The type of the ShaderBlock.
function ShaderBlock:getType() end

---
---Returns a variable in the ShaderBlock.
---
---
---### NOTE:
---This function is really slow!  Only read back values when you need to.
---
---Vectors and matrices will be returned as (flat) tables.
---
---@param name string # The name of the variable to read.
---@return any value # The value of the variable.
function ShaderBlock:read(name) end

---
---Updates a variable in the ShaderBlock.
---
---
---### NOTE:
---For scalar or vector types, use tables of numbers or `vec3`s for each vector.
---
---For matrix types, use tables of numbers or `mat4` objects.
---
---`Blob`s can also be used to pass arbitrary binary data to individual variables.
---
---@overload fun(self: lovr.ShaderBlock, blob: lovr.Blob, srcOffset?: number, dstOffset?: number, extent?: number):number
---@param variable string # The name of the variable to update.
---@param value any # The new value of the uniform.
function ShaderBlock:send(variable, value) end

---
---A Texture is an image that can be applied to `Material`s.
---
---The supported file formats are `.png`, `.jpg`, `.hdr`, `.dds`, `.ktx`, and `.astc`.
---
---DDS and ASTC are compressed formats, which are recommended because they're smaller and faster.
---
---@class lovr.Texture
local Texture = {}

---
---Returns the compare mode for the texture.
---
---@return lovr.CompareMode compareMode # The current compare mode, or `nil` if none is set.
function Texture:getCompareMode() end

---
---Returns the depth of the Texture, or the number of images stored in the Texture.
---
---@param mipmap? number # The mipmap level to get the depth of.  This is only valid for volume textures.
---@return number depth # The depth of the Texture.
function Texture:getDepth(mipmap) end

---
---Returns the dimensions of the Texture.
---
---@param mipmap? number # The mipmap level to get the dimensions of.
---@return number width # The width of the Texture, in pixels.
---@return number height # The height of the Texture, in pixels.
---@return number depth # The number of images stored in the Texture, for non-2D textures.
function Texture:getDimensions(mipmap) end

---
---Returns the current FilterMode for the Texture.
---
---@return lovr.FilterMode mode # The filter mode for the Texture.
---@return number anisotropy # The level of anisotropic filtering.
function Texture:getFilter() end

---
---Returns the format of the Texture.
---
---This describes how many color channels are in the texture as well as the size of each one.
---
---The most common format used is `rgba`, which contains red, green, blue, and alpha color channels.
---
---See `TextureFormat` for all of the possible formats.
---
---@return lovr.TextureFormat format # The format of the Texture.
function Texture:getFormat() end

---
---Returns the height of the Texture.
---
---@param mipmap? number # The mipmap level to get the height of.
---@return number height # The height of the Texture, in pixels.
function Texture:getHeight(mipmap) end

---
---Returns the number of mipmap levels of the Texture.
---
---@return number mipmaps # The number of mipmap levels in the Texture.
function Texture:getMipmapCount() end

---
---Returns the type of the Texture.
---
---@return lovr.TextureType type # The type of the Texture.
function Texture:getType() end

---
---Returns the width of the Texture.
---
---@param mipmap? number # The mipmap level to get the width of.
---@return number width # The width of the Texture, in pixels.
function Texture:getWidth(mipmap) end

---
---Returns the current WrapMode for the Texture.
---
---@return lovr.WrapMode horizontal # How the texture wraps horizontally.
---@return lovr.WrapMode vertical # How the texture wraps vertically.
function Texture:getWrap() end

---
---Replaces pixels in the Texture, sourcing from an `Image` object.
---
---@param image lovr.Image # The Image containing the pixels to use.  Currently, the Image needs to have the same dimensions as the source Texture.
---@param x? number # The x offset to replace at.
---@param y? number # The y offset to replace at.
---@param slice? number # The slice to replace.  Not applicable for 2D textures.
---@param mipmap? number # The mipmap to replace.
function Texture:replacePixels(image, x, y, slice, mipmap) end

---
---Sets the compare mode for a texture.
---
---This is only used for "shadow samplers", which are uniform variables in shaders with type `sampler2DShadow`.
---
---Sampling a shadow sampler uses a sort of virtual depth test, and the compare mode of the texture is used to control how the depth test is performed.
---
---@param compareMode? lovr.CompareMode # The new compare mode.  Use `nil` to disable the compare mode.
function Texture:setCompareMode(compareMode) end

---
---Sets the `FilterMode` used by the texture.
---
---
---### NOTE:
---The default setting for new textures can be set with `lovr.graphics.setDefaultFilter`.
---
---The maximum supported anisotropy level can be queried using `lovr.graphics.getLimits`.
---
---@param mode lovr.FilterMode # The filter mode.
---@param anisotropy number # The level of anisotropy to use.
function Texture:setFilter(mode, anisotropy) end

---
---Sets the wrap mode of a texture.
---
---The wrap mode controls how the texture is sampled when texture coordinates lie outside the usual 0 - 1 range.
---
---The default for both directions is `repeat`.
---
---@param horizontal lovr.WrapMode # How the texture should wrap horizontally.
---@param vertical? lovr.WrapMode # How the texture should wrap vertically.
function Texture:setWrap(horizontal, vertical) end

---
---Different ways arcs can be drawn with `lovr.graphics.arc`.
---
---@alias lovr.ArcMode
---
---The arc is drawn with the center of its circle included in the list of points (default).
---
---| "pie"
---
---The curve of the arc is drawn as a single line.
---
---| "open"
---
---The starting and ending points of the arc's curve are connected.
---
---| "closed"

---
---Here are the different data types available for vertex attributes in a Mesh.
---
---The ones that have a smaller range take up less memory, which improves performance a bit.
---
---The "u" stands for "unsigned", which means it can't hold negative values but instead has a larger positive range.
---
---@alias lovr.AttributeType
---
---A signed 8 bit number, from -128 to 127.
---
---| "byte"
---
---An unsigned 8 bit number, from 0 to 255.
---
---| "ubyte"
---
---A signed 16 bit number, from -32768 to 32767.
---
---| "short"
---
---An unsigned 16 bit number, from 0 to 65535.
---
---| "ushort"
---
---A signed 32 bit number, from -2147483648 to 2147483647.
---
---| "int"
---
---An unsigned 32 bit number, from 0 to 4294967295.
---
---| "uint"
---
---A 32 bit floating-point number (large range, but can start to lose precision).
---
---| "float"

---
---Different ways the alpha channel of pixels affects blending.
---
---
---### NOTE:
---The premultiplied mode should be used if pixels being drawn have already been blended, or "pre-multiplied", by the alpha channel.
---
---This happens when rendering a framebuffer that contains pixels with transparent alpha values, since the stored color values have already been faded by alpha and don't need to be faded a second time with the alphamultiply blend mode.
---
---@alias lovr.BlendAlphaMode
---
---Color channel values are multiplied by the alpha channel during blending.
---
---| "alphamultiply"
---
---Color channels are not multiplied by the alpha channel.
---
---This should be used if the pixels being drawn have already been blended, or "pre-multiplied", by the alpha channel.
---
---| "premultiplied"

---
---Blend modes control how overlapping pixels are blended together, similar to layers in Photoshop.
---
---@alias lovr.BlendMode
---
---Normal blending where the alpha value controls how the colors are blended.
---
---| "alpha"
---
---The incoming pixel color is added to the destination pixel color.
---
---| "add"
---
---The incoming pixel color is subtracted from the destination pixel color.
---
---| "subtract"
---
---The color channels from the two pixel values are multiplied together to produce a result.
---
---| "multiply"
---
---The maximum value from each color channel is used, resulting in a lightening effect.
---
---| "lighten"
---
---The minimum value from each color channel is used, resulting in a darkening effect.
---
---| "darken"
---
---The opposite of multiply: The pixel values are inverted, multiplied, and inverted again, resulting in a lightening effect.
---
---| "screen"

---
---There are two types of ShaderBlocks that can be used: `uniform` and `compute`.
---
---Uniform blocks are read only in shaders, can sometimes be a bit faster than compute blocks, and have a limited size (but the limit will be at least 16KB, you can check `lovr.graphics.getLimits` to check).
---
---Compute blocks can be written to by compute shaders, might be slightly slower than uniform blocks, and have a much, much larger maximum size.
---
---@alias lovr.BlockType
---
---A uniform block.
---
---| "uniform"
---
---A compute block.
---
---| "compute"

---
---This acts as a hint to the graphics driver about what kinds of data access should be optimized for.
---
---@alias lovr.BufferUsage
---
---A buffer that you intend to create once and never modify.
---
---| "static"
---
---A buffer which is modified occasionally.
---
---| "dynamic"
---
---A buffer which is entirely replaced on the order of every frame.
---
---| "stream"

---
---The method used to compare z values when deciding how to overlap rendered objects.
---
---This is called the "depth test", and it happens on a pixel-by-pixel basis every time new objects are drawn.
---
---If the depth test "passes" for a pixel, then the pixel color will be replaced by the new color and the depth value in the depth buffer will be updated.
---
---Otherwise, the pixel will not be changed and the depth value will not be updated.
---
---@alias lovr.CompareMode
---
---The depth test passes when the depth values are equal.
---
---| "equal"
---
---The depth test passes when the depth values are not equal.
---
---| "notequal"
---
---The depth test passes when the new depth value is less than the existing one.
---
---| "less"
---
---The depth test passes when the new depth value is less than or equal to the existing one.
---
---| "lequal"
---
---The depth test passes when the new depth value is greater than or equal to the existing one.
---
---| "gequal"
---
---The depth test passes when the new depth value is greater than the existing one.
---
---| "greater"

---
---Different coordinate spaces for nodes in a Model.
---
---@alias lovr.CoordinateSpace
---
---The coordinate space relative to the node's parent.
---
---| "local"
---
---The coordinate space relative to the root node of the Model.
---
---| "global"

---
---The following shaders are built in to LÖVR, and can be used as an argument to `lovr.graphics.newShader` instead of providing raw GLSL shader code.
---
---The shaders can be further customized by using the `flags` argument.
---
---If you pass in `nil` to `lovr.graphics.setShader`, LÖVR will automatically pick a DefaultShader to use based on whatever is being drawn.
---
---@alias lovr.DefaultShader
---
---A simple shader without lighting, using only colors and a diffuse texture.
---
---| "unlit"
---
---A physically-based rendering (PBR) shader, using advanced material properties.
---
---| "standard"
---
---A shader that renders a cubemap texture.
---
---| "cube"
---
---A shader that renders a 2D equirectangular texture with spherical coordinates.
---
---| "pano"
---
---A shader that renders font glyphs.
---
---| "font"
---
---A shader that passes its vertex coordinates unmodified to the fragment shader, used to render view-independent fixed geometry like fullscreen quads.
---
---| "fill"

---
---Meshes are lists of arbitrary vertices.
---
---These vertices can be connected in different ways, leading to different shapes like lines and triangles.
---
---@alias lovr.DrawMode
---
---Draw each vertex as a single point.
---
---| "points"
---
---The vertices represent a list of line segments. Each pair of vertices will have a line drawn between them.
---
---| "lines"
---
---The first two vertices have a line drawn between them, and each vertex after that will be connected to the previous vertex with a line.
---
---| "linestrip"
---
---Similar to linestrip, except the last vertex is connected back to the first.
---
---| "lineloop"
---
---The first three vertices define a triangle.
---
---Each vertex after that creates a triangle using the new vertex and last two vertices.
---
---| "strip"
---
---Each set of three vertices represents a discrete triangle.
---
---| "triangles"
---
---Draws a set of triangles.
---
---Each one shares the first vertex as a common point, leading to a fan-like shape.
---
---| "fan"

---
---Most graphics primitives can be drawn in one of two modes: a filled mode and a wireframe mode.
---
---@alias lovr.DrawStyle
---
---The shape is drawn as a filled object.
---
---| "fill"
---
---The shape is drawn as a wireframe object.
---
---| "line"

---
---The method used to downsample (or upsample) a texture.
---
---"nearest" can be used for a pixelated effect, whereas "linear" leads to more smooth results.
---
---Nearest is slightly faster than linear.
---
---@alias lovr.FilterMode
---
---Fast nearest-neighbor sampling.
---
---Leads to a pixelated style.
---
---| "nearest"
---
---Smooth pixel sampling.
---
---| "bilinear"
---
---Smooth pixel sampling, with smooth sampling across mipmap levels.
---
---| "trilinear"

---
---Different ways to horizontally align text when using `lovr.graphics.print`.
---
---@alias lovr.HorizontalAlign
---
---Left aligned lines of text.
---
---| "left"
---
---Centered aligned lines of text.
---
---| "center"
---
---Right aligned lines of text.
---
---| "right"

---
---The different types of color parameters `Material`s can hold.
---
---@alias lovr.MaterialColor
---
---The diffuse color.
---
---| "diffuse"
---
---The emissive color.
---
---| "emissive"

---
---The different types of float parameters `Material`s can hold.
---
---@alias lovr.MaterialScalar
---
---The constant metalness factor.
---
---| "metalness"
---
---The constant roughness factor.
---
---| "roughness"

---
---The different types of texture parameters `Material`s can hold.
---
---@alias lovr.MaterialTexture
---
---The diffuse texture.
---
---| "diffuse"
---
---The emissive texture.
---
---| "emissive"
---
---The metalness texture.
---
---| "metalness"
---
---The roughness texture.
---
---| "roughness"
---
---The ambient occlusion texture.
---
---| "occlusion"
---
---The normal map.
---
---| "normal"
---
---The environment map, should be specified as a cubemap texture.
---
---| "environment"

---
---Meshes can have a usage hint, describing how they are planning on being updated.
---
---Setting the usage hint allows the graphics driver optimize how it handles the data in the Mesh.
---
---@alias lovr.MeshUsage
---
---The Mesh contents will rarely change.
---
---| "static"
---
---The Mesh contents will change often.
---
---| "dynamic"
---
---The Mesh contents will change constantly, potentially multiple times each frame.
---
---| "stream"

---
---Shaders can be used for either rendering operations or generic compute tasks.
---
---Graphics shaders are created with `lovr.graphics.newShader` and compute shaders are created with `lovr.graphics.newComputeShader`.
---
---`Shader:getType` can be used on an existing Shader to figure out what type it is.
---
---@alias lovr.ShaderType
---
---A graphics shader.
---
---| "graphics"
---
---A compute shader.
---
---| "compute"

---
---How to modify pixels in the stencil buffer when using `lovr.graphics.stencil`.
---
---@alias lovr.StencilAction
---
---Stencil values will be replaced with a custom value.
---
---| "replace"
---
---Stencil values will increment every time they are rendered to.
---
---| "increment"
---
---Stencil values will decrement every time they are rendered to.
---
---| "decrement"
---
---Similar to `increment`, but the stencil value will be set to 0 if it exceeds 255.
---
---| "incrementwrap"
---
---Similar to `decrement`, but the stencil value will be set to 255 if it drops below 0.
---
---| "decrementwrap"
---
---Stencil values will be bitwise inverted every time they are rendered to.
---
---| "invert"

---
---Textures can store their pixels in different formats.
---
---The set of color channels and the number of bits stored for each channel can differ, allowing Textures to optimize their storage for certain kinds of image formats or rendering techniques.
---
---@alias lovr.TextureFormat
---
---Each pixel is 24 bits, or 8 bits for each channel.
---
---| "rgb"
---
---Each pixel is 32 bits, or 8 bits for each channel (including alpha).
---
---| "rgba"
---
---An rgba format where the colors occupy 4 bits instead of the usual 8.
---
---| "rgba4"
---
---Each pixel is 64 bits. Each channel is a 16 bit floating point number.
---
---| "rgba16f"
---
---Each pixel is 128 bits. Each channel is a 32 bit floating point number.
---
---| "rgba32f"
---
---A 16-bit floating point format with a single color channel.
---
---| "r16f"
---
---A 32-bit floating point format with a single color channel.
---
---| "r32f"
---
---A 16-bit floating point format with two color channels.
---
---| "rg16f"
---
---A 32-bit floating point format with two color channels.
---
---| "rg32f"
---
---A 16 bit format with 5-bit color channels and a single alpha bit.
---
---| "rgb5a1"
---
---A 32 bit format with 10-bit color channels and two alpha bits.
---
---| "rgb10a2"
---
---Each pixel is 32 bits, and packs three color channels into 10 or 11 bits each.
---
---| "rg11b10f"
---
---A 16 bit depth buffer.
---
---| "d16"
---
---A 32 bit floating point depth buffer.
---
---| "d32f"
---
---A depth buffer with 24 bits for depth and 8 bits for stencil.
---
---| "d24s8"

---
---Different types of Textures.
---
---@alias lovr.TextureType
---
---A 2D texture.
---
---| "2d"
---
---A 2D array texture with multiple independent 2D layers.
---
---| "array"
---
---A cubemap texture with 6 2D faces.
---
---| "cube"
---
---A 3D volumetric texture consisting of multiple 2D layers.
---
---| "volume"

---
---When binding writable resources to shaders using `Shader:sendBlock` and `Shader:sendImage`, an access pattern can be specified as a hint that says whether you plan to read or write to the resource (or both).
---
---Sometimes, LÖVR or the GPU driver can use this hint to get better performance or avoid stalling.
---
---@alias lovr.UniformAccess
---
---The Shader will use the resource in a read-only fashion.
---
---| "read"
---
---The Shader will use the resource in a write-only fashion.
---
---| "write"
---
---The resource will be available for reading and writing.
---
---| "readwrite"

---
---Different ways to vertically align text when using `lovr.graphics.print`.
---
---@alias lovr.VerticalAlign
---
---Align the top of the text to the origin.
---
---| "top"
---
---Vertically center the text.
---
---| "middle"
---
---Align the bottom of the text to the origin.
---
---| "bottom"

---
---Whether the points on triangles are specified in a clockwise or counterclockwise order.
---
---@alias lovr.Winding
---
---Triangle vertices are specified in a clockwise order.
---
---| "clockwise"
---
---Triangle vertices are specified in a counterclockwise order.
---
---| "counterclockwise"

---
---The method used to render textures when texture coordinates are outside of the 0-1 range.
---
---@alias lovr.WrapMode
---
---The texture will be clamped at its edges.
---
---| "clamp"
---
---The texture repeats.
---
---| "repeat"
---
---The texture will repeat, mirroring its appearance each time it repeats.
---
---| "mirroredrepeat"
