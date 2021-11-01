---@meta

---
---The `lovr.graphics` module renders graphics to displays.  Anything rendered using this module will automatically show up in the VR headset if one is connected, otherwise it will just show up in a window on the desktop.
---
---@class lovr.graphics
lovr.graphics = {}

---
---Draws an arc.
---
---@overload fun(material: lovr.Material, x: number, y: number, z: number, radius: number, angle: number, ax: number, ay: number, az: number, start: number, end: number, segments: number)
---@overload fun(mode: lovr.DrawStyle, transform: lovr.mat4, start: number, end: number, segments: number)
---@overload fun(material: lovr.Material, transform: lovr.mat4, start: number, end: number, segments: number)
---@overload fun(mode: lovr.DrawStyle, arcmode: lovr.ArcMode, x: number, y: number, z: number, radius: number, angle: number, ax: number, ay: number, az: number, start: number, end: number, segments: number)
---@overload fun(material: lovr.Material, arcmode: lovr.ArcMode, x: number, y: number, z: number, radius: number, angle: number, ax: number, ay: number, az: number, start: number, end: number, segments: number)
---@overload fun(mode: lovr.DrawStyle, arcmode: lovr.ArcMode, transform: lovr.mat4, start: number, end: number, segments: number)
---@overload fun(material: lovr.Material, arcmode: lovr.ArcMode, transform: lovr.mat4, start: number, end: number, segments: number)
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
---Draws a box.  This is similar to `lovr.graphics.cube` except you can have different values for the width, height, and depth of the box.
---
---@overload fun(material: lovr.Material, x: number, y: number, z: number, width: number, height: number, depth: number, angle: number, ax: number, ay: number, az: number)
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
---@overload fun(material: lovr.Material, x: number, y: number, z: number, radius: number, angle: number, ax: number, ay: number, az: number, segments: number)
---@overload fun(mode: lovr.DrawStyle, transform: lovr.mat4, segments: number)
---@overload fun(material: lovr.Material, transform: lovr.mat4, segments: number)
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
---Clears the screen, resetting the color, depth, and stencil information to default values.  This function is called automatically by `lovr.run` at the beginning of each frame to clear out the data from the previous frame.
---
---@overload fun(r: number, g: number, b: number, a: number, z: number, s: number)
---@overload fun(hex: number)
---@param color? boolean # Whether or not to clear color information on the screen.
---@param depth? boolean # Whether or not to clear the depth information on the screen.
---@param stencil? boolean # Whether or not to clear the stencil information on the screen.
function lovr.graphics.clear(color, depth, stencil) end

---
---This function runs a compute shader on the GPU.  Compute shaders must be created with `lovr.graphics.newComputeShader` and they should implement the `void compute();` GLSL function. Running a compute shader doesn't actually do anything, but the Shader can modify data stored in `Texture`s or `ShaderBlock`s to get interesting things to happen.
---
---When running the compute shader, you can specify the number of times to run it in 3 dimensions, which is useful to iterate over large numbers of elements like pixels or array elements.
---
---@param shader lovr.Shader # The compute shader to run.
---@param x? number # The amount of times to run in the x direction.
---@param y? number # The amount of times to run in the y direction.
---@param z? number # The amount of times to run in the z direction.
function lovr.graphics.compute(shader, x, y, z) end

---
---Create the desktop window, usually used to mirror the headset display.
---
---@param flags {width: number, height: number, fullscreen: boolean, resizable: boolean, msaa: number, title: string, icon: string, vsync: number} # Flags to customize the window's appearance and behavior.
function lovr.graphics.createWindow(flags) end

---
---Draws a cube.
---
---@overload fun(material: lovr.Material, x: number, y: number, z: number, size: number, angle: number, ax: number, ay: number, az: number)
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
---@overload fun(material: lovr.Material, x: number, y: number, z: number, length: number, angle: number, ax: number, ay: number, az: number, r1: number, r2: number, capped: boolean, segments: number)
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
---Discards pixel information in the active Canvas or display.  This is mostly used as an optimization hint for the GPU, and is usually most helpful on mobile devices.
---
---@param color? boolean # Whether or not to discard color information.
---@param depth? boolean # Whether or not to discard depth information.
---@param stencil? boolean # Whether or not to discard stencil information.
function lovr.graphics.discard(color, depth, stencil) end

---
---Draws a fullscreen textured quad.
---
---@overload fun()
---@param texture lovr.Texture # The texture to use.
---@param u? number # The x component of the uv offset.
---@param v? number # The y component of the uv offset.
---@param w? number # The width of the Texture to render, in uv coordinates.
---@param h? number # The height of the Texture to render, in uv coordinates.
function lovr.graphics.fill(texture, u, v, w, h) end

---
---Flushes the internal queue of draw batches.  Under normal circumstances this is done automatically when needed, but the ability to flush manually may be helpful if you're integrating a LÖVR project with some external rendering code.
---
function lovr.graphics.flush() end

---
---Returns whether or not alpha sampling is enabled.  Alpha sampling is also known as alpha-to-coverage.  When it is enabled, the alpha channel of a pixel is factored into how antialiasing is computed, so the edges of a transparent texture will be correctly antialiased.
---
---@return boolean enabled # Whether or not alpha sampling is enabled.
function lovr.graphics.getAlphaSampling() end

---
---Returns the current background color.  Color components are from 0.0 to 1.0.
---
---@return number r # The red component of the background color.
---@return number g # The green component of the background color.
---@return number b # The blue component of the background color.
---@return number a # The alpha component of the background color.
function lovr.graphics.getBackgroundColor() end

---
---Returns the current blend mode.  The blend mode controls how each pixel's color is blended with the previous pixel's color when drawn.
---
---If blending is disabled, `nil` will be returned.
---
---@return lovr.BlendMode blend # The current blend mode.
---@return lovr.BlendAlphaMode alphaBlend # The current alpha blend mode.
function lovr.graphics.getBlendMode() end

---
---Returns the active Canvas.  Usually when you render something it will render directly to the headset.  If a Canvas object is active, things will be rendered to the textures attached to the Canvas instead.
---
---@return lovr.Canvas canvas # The active Canvas, or `nil` if no canvas is set.
function lovr.graphics.getCanvas() end

---
---Returns the current global color factor.  Color components are from 0.0 to 1.0.  Every pixel drawn will be multiplied (i.e. tinted) by this color.
---
---@return number r # The red component of the color.
---@return number g # The green component of the color.
---@return number b # The blue component of the color.
---@return number a # The alpha component of the color.
function lovr.graphics.getColor() end

---
---Returns a boolean for each color channel (red, green, blue, alpha) indicating whether it is enabled.  When a color channel is enabled, it will be affected by drawing commands and clear commands.
---
function lovr.graphics.getColorMask() end

---
---Returns the default filter mode for new Textures.  This controls how textures are sampled when they are minified, magnified, or stretched.
---
---@return lovr.FilterMode mode # The filter mode.
---@return number anisotropy # The level of anisotropy.
function lovr.graphics.getDefaultFilter() end

---
---Returns the current depth test settings.
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
---@return number width # The current line width, in pixels.
function lovr.graphics.getLineWidth() end

---
---Returns the pixel density of the window.  On "high-dpi" displays, this will be `2.0`, indicating that there are 2 pixels for every window coordinate.  On a normal display it will be `1.0`, meaning that the pixel to window-coordinate ratio is 1:1.
---
---@return number density # The pixel density of the window.
function lovr.graphics.getPixelDensity() end

---
---Returns the current point size.
---
---@return number size # The current point size, in pixels.
function lovr.graphics.getPointSize() end

---
---Returns the projection for a single view.
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
---Returns the current stencil test.  The stencil test lets you mask out pixels that meet certain criteria, based on the contents of the stencil buffer.  The stencil buffer can be modified using `lovr.graphics.stencil`.  After rendering to the stencil buffer, the stencil test can be set to control how subsequent drawing functions are masked by the stencil buffer.
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
---Returns the current polygon winding.  The winding direction determines which face of a triangle is the front face and which is the back face.  This lets the graphics engine cull the back faces of polygons, improving performance.
---
---@return lovr.Winding winding # The current winding direction.
function lovr.graphics.getWinding() end

---
---Returns whether the desktop window is currently created.
---
---@return boolean present # Whether a window is created.
function lovr.graphics.hasWindow() end

---
---Returns whether or not culling is active.  Culling is an optimization that avoids rendering the back face of polygons.  This improves performance by reducing the number of polygons drawn, but requires that the vertices in triangles are specified in a consistent clockwise or counter clockwise order.
---
---@return boolean isEnabled # Whether or not culling is enabled.
function lovr.graphics.isCullingEnabled() end

---
---Returns a boolean indicating whether or not wireframe rendering is enabled.
---
---@return boolean isWireframe # Whether or not wireframe rendering is enabled.
function lovr.graphics.isWireframe() end

---
---Draws lines between points.  Each point will be connected to the previous point in the list.
---
---@overload fun(points: table)
---@param x1 number # The x coordinate of the first point.
---@param y1 number # The y coordinate of the first point.
---@param z1 number # The z coordinate of the first point.
---@param x2 number # The x coordinate of the second point.
---@param y2 number # The y coordinate of the second point.
---@param z2 number # The z coordinate of the second point.
function lovr.graphics.line(x1, y1, z1, x2, y2, z2) end

---
---Creates a new Canvas.  You can specify Textures to attach to it, or just specify a width and height and attach textures later using `Canvas:setTexture`.
---
---Once created, you can render to the Canvas using `Canvas:renderTo`, or `lovr.graphics.setCanvas`.
---
---@overload fun(..., flags: table):lovr.Canvas
---@overload fun(attachments: table, flags: table):lovr.Canvas
---@param width number # The width of the canvas, in pixels.
---@param height number # The height of the canvas, in pixels.
---@param flags? {format: lovr.TextureFormat, depth: lovr.TextureFormat, stereo: boolean, msaa: number, mipmaps: boolean} # Optional settings for the Canvas.
---@return lovr.Canvas canvas # The new Canvas.
function lovr.graphics.newCanvas(width, height, flags) end

---
---Creates a new compute Shader, used for running generic compute operations on the GPU.
---
---@param source string # The code or filename of the compute shader.
---@param options? {flags: table} # Optional settings for the Shader.
---@return lovr.Shader shader # The new compute Shader.
function lovr.graphics.newComputeShader(source, options) end

---
---Creates a new Font.  It can be used to render text with `lovr.graphics.print`.
---
---Currently, the only supported font format is TTF.
---
---@overload fun(size: number, padding: number, spread: number):lovr.Font
---@overload fun(rasterizer: lovr.Rasterizer, padding: number, spread: number):lovr.Font
---@param filename string # The filename of the font file.
---@param size? number # The size of the font, in pixels.
---@param padding? number # The number of pixels of padding around each glyph.
---@param spread? number # The range of the distance field, in pixels.
---@return lovr.Font font # The new Font.
function lovr.graphics.newFont(filename, size, padding, spread) end

---
---Creates a new Material.  Materials are sets of colors, textures, and other parameters that affect the appearance of objects.  They can be applied to `Model`s, `Mesh`es, and most graphics primitives accept a Material as an optional first argument.
---
---@overload fun(texture: lovr.Texture, r: number, g: number, b: number, a: number):lovr.Material
---@overload fun(canvas: lovr.Canvas, r: number, g: number, b: number, a: number):lovr.Material
---@overload fun(r: number, g: number, b: number, a: number):lovr.Material
---@overload fun(hex: number, a: number):lovr.Material
---@return lovr.Material material # The new Material.
function lovr.graphics.newMaterial() end

---
---Creates a new Mesh.  Meshes contain the data for an arbitrary set of vertices, and can be drawn. You must specify either the capacity for the Mesh or an initial set of vertex data.  Optionally, a custom format table can be used to specify the set of vertex attributes the mesh will provide to the active shader.  The draw mode and usage hint can also optionally be specified.
---
---The default data type for an attribute is `float`, and the default component count is 1.
---
---@overload fun(vertices: table, mode: lovr.DrawMode, usage: lovr.MeshUsage, readable: boolean):lovr.Mesh
---@overload fun(blob: lovr.Blob, mode: lovr.DrawMode, usage: lovr.MeshUsage, readable: boolean):lovr.Mesh
---@overload fun(format: table, size: number, mode: lovr.DrawMode, usage: lovr.MeshUsage, readable: boolean):lovr.Mesh
---@overload fun(format: table, vertices: table, mode: lovr.DrawMode, usage: lovr.MeshUsage, readable: boolean):lovr.Mesh
---@overload fun(format: table, blob: lovr.Blob, mode: lovr.DrawMode, usage: lovr.MeshUsage, readable: boolean):lovr.Mesh
---@param size number # The maximum number of vertices the Mesh can store.
---@param mode? lovr.DrawMode # How the Mesh will connect its vertices into triangles.
---@param usage? lovr.MeshUsage # An optimization hint indicating how often the data in the Mesh will be updated.
---@param readable? boolean # Whether vertices from the Mesh can be read.
---@return lovr.Mesh mesh # The new Mesh.
function lovr.graphics.newMesh(size, mode, usage, readable) end

---
---Creates a new Model from a file.  The supported 3D file formats are OBJ, glTF, and STL.
---
---@overload fun(modelData: lovr.ModelData):lovr.Model
---@param filename string # The filename of the model to load.
---@return lovr.Model model # The new Model.
function lovr.graphics.newModel(filename) end

---
---Creates a new Shader.
---
---@overload fun(default: lovr.DefaultShader, options: table):lovr.Shader
---@param vertex string # The code or filename of the vertex shader.  If nil, the default vertex shader is used.
---@param fragment string # The code or filename of the fragment shader.  If nil, the default fragment shader is used.
---@param options? {flags: table, stereo: boolean} # Optional settings for the Shader.
---@return lovr.Shader shader # The new Shader.
function lovr.graphics.newShader(vertex, fragment, options) end

---
---Creates a new ShaderBlock from a table of variable definitions with their names and types.
---
---@param type lovr.BlockType # Whether the block will be used for read-only uniform data or compute shaders.
---@param uniforms table # A table where the keys are uniform names and the values are uniform types.  Uniform arrays can be specified by supplying a table as the uniform's value containing the type and the array size.
---@param flags? {usage: lovr.BufferUsage, readable: boolean} # Optional settings.
---@return lovr.ShaderBlock shaderBlock # The new ShaderBlock.
function lovr.graphics.newShaderBlock(type, uniforms, flags) end

---
---Creates a new Texture from an image file.
---
---@overload fun(images: table, flags: table):lovr.Texture
---@overload fun(width: number, height: number, depth: number, flags: table):lovr.Texture
---@overload fun(blob: lovr.Blob, flags: table):lovr.Texture
---@overload fun(image: lovr.Image, flags: table):lovr.Texture
---@param filename string # The filename of the image to load.
---@param flags? {linear: boolean, mipmaps: boolean, type: lovr.TextureType, format: lovr.TextureFormat, msaa: number} # Optional settings for the texture.
---@return lovr.Texture texture # The new Texture.
function lovr.graphics.newTexture(filename, flags) end

---
---Resets the transformation to the origin.
---
function lovr.graphics.origin() end

---
---Draws a plane with a given position, size, and orientation.
---
---@overload fun(material: lovr.Material, x: number, y: number, z: number, width: number, height: number, angle: number, ax: number, ay: number, az: number, u: number, v: number, w: number, h: number)
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
function lovr.graphics.points(x, y, z) end

---
---Pops the current transform from the stack, returning to the transformation that was applied before `lovr.graphics.push` was called.
---
function lovr.graphics.pop() end

---
---Presents the results of pending drawing operations to the window.  This is automatically called after `lovr.draw` by the default `lovr.run` function.
---
function lovr.graphics.present() end

---
---Draws text in 3D space using the active font.
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
---Pushes a copy of the current transform onto the transformation stack.  After changing the transform using `lovr.graphics.translate`, `lovr.graphics.rotate`, and `lovr.graphics.scale`, the original state can be restored using `lovr.graphics.pop`.
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
---@param angle? number # The amount to rotate the coordinate system by, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
function lovr.graphics.rotate(angle, ax, ay, az) end

---
---Scales the coordinate system in 3 dimensions.  This will cause objects to appear bigger or smaller.
---
---The scaling will last until `lovr.draw` returns or the transformation is popped off the transformation stack.
---
---@param x? number # The amount to scale on the x axis.
---@param y? number # The amount to scale on the y axis.
---@param z? number # The amount to scale on the z axis.
function lovr.graphics.scale(x, y, z) end

---
---Enables or disables alpha sampling.  Alpha sampling is also known as alpha-to-coverage.  When it is enabled, the alpha channel of a pixel is factored into how antialiasing is computed, so the edges of a transparent texture will be correctly antialiased.
---
---@param enabled boolean # Whether or not alpha sampling is enabled.
function lovr.graphics.setAlphaSampling(enabled) end

---
---Sets the background color used to clear the screen.  Color components are from 0.0 to 1.0.
---
---@overload fun(hex: number, a: number)
---@overload fun(color: table)
---@param r number # The red component of the background color.
---@param g number # The green component of the background color.
---@param b number # The blue component of the background color.
---@param a? number # The alpha component of the background color.
function lovr.graphics.setBackgroundColor(r, g, b, a) end

---
---Sets the blend mode.  The blend mode controls how each pixel's color is blended with the previous pixel's color when drawn.
---
---@overload fun()
---@param blend lovr.BlendMode # The blend mode.
---@param alphaBlend lovr.BlendAlphaMode # The alpha blend mode.
function lovr.graphics.setBlendMode(blend, alphaBlend) end

---
---Sets or disables the active Canvas object.  If there is an active Canvas, things will be rendered to the Textures attached to that Canvas instead of to the headset.
---
---@param canvas? lovr.Canvas # The new active Canvas object, or `nil` to just render to the headset.
function lovr.graphics.setCanvas(canvas) end

---
---Sets the color used for drawing objects.  Color components are from 0.0 to 1.0.  Every pixel drawn will be multiplied (i.e. tinted) by this color.  This is a global setting, so it will affect all subsequent drawing operations.
---
---@overload fun(hex: number, a: number)
---@overload fun(color: table)
---@param r number # The red component of the color.
---@param g number # The green component of the color.
---@param b number # The blue component of the color.
---@param a? number # The alpha component of the color.
function lovr.graphics.setColor(r, g, b, a) end

---
---Enables and disables individual color channels.  When a color channel is enabled, it will be affected by drawing commands and clear commands.
---
---@param r boolean # Whether the red color channel should be enabled.
---@param g boolean # Whether the green color channel should be enabled.
---@param b boolean # Whether the blue color channel should be enabled.
---@param a boolean # Whether the alpha color channel should be enabled.
function lovr.graphics.setColorMask(r, g, b, a) end

---
---Enables or disables culling.  Culling is an optimization that avoids rendering the back face of polygons.  This improves performance by reducing the number of polygons drawn, but requires that the vertices in triangles are specified in a consistent clockwise or counter clockwise order.
---
---@param isEnabled boolean # Whether or not culling should be enabled.
function lovr.graphics.setCullingEnabled(isEnabled) end

---
---Sets the default filter mode for new Textures.  This controls how textures are sampled when they are minified, magnified, or stretched.
---
---@param mode lovr.FilterMode # The filter mode.
---@param anisotropy number # The level of anisotropy to use.
function lovr.graphics.setDefaultFilter(mode, anisotropy) end

---
---Sets the current depth test.  The depth test controls how overlapping objects are rendered.
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
---@param width? number # The new line width, in pixels.
function lovr.graphics.setLineWidth(width) end

---
---Sets the width of drawn points, in pixels.
---
---@param size? number # The new point size.
function lovr.graphics.setPointSize(size) end

---
---Sets the projection for a single view.  4 field of view angles can be used, similar to the field of view returned by `lovr.headset.getViewAngles`.  Alternatively, a projection matrix can be used for other types of projections like orthographic, oblique, etc.
---
---Two views are supported, one for each eye.  When rendering to the headset, both projections are changed to match the ones used by the headset.
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
---Sets the stencil test.  The stencil test lets you mask out pixels that meet certain criteria, based on the contents of the stencil buffer.  The stencil buffer can be modified using `lovr.graphics.stencil`.  After rendering to the stencil buffer, the stencil test can be set to control how subsequent drawing functions are masked by the stencil buffer.
---
---@overload fun()
---@param compareMode lovr.CompareMode # The comparison method used to decide if a pixel should be visible, or nil if the stencil test is disabled.
---@param compareValue number # The value to compare stencil values to.
function lovr.graphics.setStencilTest(compareMode, compareValue) end

---
---Sets the pose for a single view.  Objects rendered in this view will appear as though the camera is positioned using the given pose.
---
---Two views are supported, one for each eye.  When rendering to the headset, both views are changed to match the estimated eye positions.  These view poses are also available using `lovr.headset.getViewPose`.
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
---Sets the polygon winding.  The winding direction determines which face of a triangle is the front face and which is the back face.  This lets the graphics engine cull the back faces of polygons, improving performance.  The default is counterclockwise.
---
---@param winding lovr.Winding # The new winding direction.
function lovr.graphics.setWinding(winding) end

---
---Enables or disables wireframe rendering.  This is meant to be used as a debugging tool.
---
---@param wireframe boolean # Whether or not wireframe rendering should be enabled.
function lovr.graphics.setWireframe(wireframe) end

---
---Render a skybox from a texture.  Two common kinds of skybox textures are supported: A 2D equirectangular texture with a spherical coordinates can be used, or a "cubemap" texture created from 6 images.
---
---@param texture lovr.Texture # The texture to use.
function lovr.graphics.skybox(texture) end

---
---Draws a sphere.
---
---@overload fun(material: lovr.Material, x: number, y: number, z: number, radius: number, angle: number, ax: number, ay: number, az: number)
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
---@overload fun(callback: function, action: lovr.StencilAction, value: number, initial: number)
---@param callback function # The function that will be called to render to the stencil buffer.
---@param action? lovr.StencilAction # How to modify the stencil value of pixels that are rendered to.
---@param value? number # If `action` is "replace", this is the value that pixels are replaced with.
---@param keep? boolean # If false, the stencil buffer will be cleared to zero before rendering.
function lovr.graphics.stencil(callback, action, value, keep) end

---
---Starts a named timer on the GPU, which can be stopped using `lovr.graphics.tock`.
---
---@param label string # The name of the timer.
function lovr.graphics.tick(label) end

---
---Stops a named timer on the GPU, previously started with `lovr.graphics.tick`.
---
---@param label string # The name of the timer.
---@return number time # The number of seconds elapsed, or `nil` if the data isn't ready yet.
function lovr.graphics.tock(label) end

---
---Apply a transform to the coordinate system, changing its translation, rotation, and scale using a single function.  A `mat4` can also be used.
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
---Translates the coordinate system in three dimensions.  All graphics operations that use coordinates will behave as if they are offset by the translation value.
---
---The translation will last until `lovr.draw` returns or the transformation is popped off the transformation stack.
---
---@param x? number # The amount to translate on the x axis.
---@param y? number # The amount to translate on the y axis.
---@param z? number # The amount to translate on the z axis.
function lovr.graphics.translate(x, y, z) end

---
---Different ways arcs can be drawn with `lovr.graphics.arc`.
---
---@class lovr.ArcMode
---
---The arc is drawn with the center of its circle included in the list of points (default).
---
---@field pie integer
---
---The curve of the arc is drawn as a single line.
---
---@field open integer
---
---The starting and ending points of the arc's curve are connected.
---
---@field closed integer

---
---Here are the different data types available for vertex attributes in a Mesh.  The ones that have a smaller range take up less memory, which improves performance a bit.  The "u" stands for "unsigned", which means it can't hold negative values but instead has a larger positive range.
---
---@class lovr.AttributeType
---
---A signed 8 bit number, from -128 to 127.
---
---@field byte integer
---
---An unsigned 8 bit number, from 0 to 255.
---
---@field ubyte integer
---
---A signed 16 bit number, from -32768 to 32767.
---
---@field short integer
---
---An unsigned 16 bit number, from 0 to 65535.
---
---@field ushort integer
---
---A signed 32 bit number, from -2147483648 to 2147483647.
---
---@field int integer
---
---An unsigned 32 bit number, from 0 to 4294967295.
---
---@field uint integer
---
---A 32 bit floating-point number (large range, but can start to lose precision).
---
---@field float integer

---
---Different ways the alpha channel of pixels affects blending.
---
---@class lovr.BlendAlphaMode
---
---Color channel values are multiplied by the alpha channel during blending.
---
---@field alphamultiply integer
---
---Color channels are not multiplied by the alpha channel.  This should be used if the pixels being drawn have already been blended, or "pre-multiplied", by the alpha channel.
---
---@field premultiplied integer

---
---Blend modes control how overlapping pixels are blended together, similar to layers in Photoshop.
---
---@class lovr.BlendMode
---
---Normal blending where the alpha value controls how the colors are blended.
---
---@field alpha integer
---
---The incoming pixel color is added to the destination pixel color.
---
---@field add integer
---
---The incoming pixel color is subtracted from the destination pixel color.
---
---@field subtract integer
---
---The color channels from the two pixel values are multiplied together to produce a result.
---
---@field multiply integer
---
---The maximum value from each color channel is used, resulting in a lightening effect.
---
---@field lighten integer
---
---The minimum value from each color channel is used, resulting in a darkening effect.
---
---@field darken integer
---
---The opposite of multiply: The pixel values are inverted, multiplied, and inverted again, resulting in a lightening effect.
---
---@field screen integer

---
---There are two types of ShaderBlocks that can be used: `uniform` and `compute`.
---
---Uniform blocks are read only in shaders, can sometimes be a bit faster than compute blocks, and have a limited size (but the limit will be at least 16KB, you can check `lovr.graphics.getLimits` to check).
---
---Compute blocks can be written to by compute shaders, might be slightly slower than uniform blocks, and have a much, much larger maximum size.
---
---@class lovr.BlockType
---
---A uniform block.
---
---@field uniform integer
---
---A compute block.
---
---@field compute integer

---
---This acts as a hint to the graphics driver about what kinds of data access should be optimized for.
---
---@class lovr.BufferUsage
---
---A buffer that you intend to create once and never modify.
---
---@field static integer
---
---A buffer which is modified occasionally.
---
---@field dynamic integer
---
---A buffer which is entirely replaced on the order of every frame.
---
---@field stream integer

---
---The method used to compare z values when deciding how to overlap rendered objects.  This is called the "depth test", and it happens on a pixel-by-pixel basis every time new objects are drawn.  If the depth test "passes" for a pixel, then the pixel color will be replaced by the new color and the depth value in the depth buffer will be updated.  Otherwise, the pixel will not be changed and the depth value will not be updated.
---
---@class lovr.CompareMode
---
---The depth test passes when the depth values are equal.
---
---@field equal integer
---
---The depth test passes when the depth values are not equal.
---
---@field notequal integer
---
---The depth test passes when the new depth value is less than the existing one.
---
---@field less integer
---
---The depth test passes when the new depth value is less than or equal to the existing one.
---
---@field lequal integer
---
---The depth test passes when the new depth value is greater than or equal to the existing one.
---
---@field gequal integer
---
---The depth test passes when the new depth value is greater than the existing one.
---
---@field greater integer

---
---Different coordinate spaces for nodes in a Model.
---
---@class lovr.CoordinateSpace
---
---The coordinate space relative to the node's parent.
---
---@field local integer
---
---The coordinate space relative to the root node of the Model.
---
---@field global integer

---
---The following shaders are built in to LÖVR, and can be used as an argument to `lovr.graphics.newShader` instead of providing raw GLSL shader code.  The shaders can be further customized by using the `flags` argument.  If you pass in `nil` to `lovr.graphics.setShader`, LÖVR will automatically pick a DefaultShader to use based on whatever is being drawn.
---
---@class lovr.DefaultShader
---
---A simple shader without lighting, using only colors and a diffuse texture.
---
---@field unlit integer
---
---A physically-based rendering (PBR) shader, using advanced material properties.
---
---@field standard integer
---
---A shader that renders a cubemap texture.
---
---@field cube integer
---
---A shader that renders a 2D equirectangular texture with spherical coordinates.
---
---@field pano integer
---
---A shader that renders font glyphs.
---
---@field font integer
---
---A shader that passes its vertex coordinates unmodified to the fragment shader, used to render view-independent fixed geometry like fullscreen quads.
---
---@field fill integer

---
---Meshes are lists of arbitrary vertices.  These vertices can be connected in different ways, leading to different shapes like lines and triangles.
---
---@class lovr.DrawMode
---
---Draw each vertex as a single point.
---
---@field points integer
---
---The vertices represent a list of line segments. Each pair of vertices will have a line drawn between them.
---
---@field lines integer
---
---The first two vertices have a line drawn between them, and each vertex after that will be connected to the previous vertex with a line.
---
---@field linestrip integer
---
---Similar to linestrip, except the last vertex is connected back to the first.
---
---@field lineloop integer
---
---The first three vertices define a triangle.  Each vertex after that creates a triangle using the new vertex and last two vertices.
---
---@field strip integer
---
---Each set of three vertices represents a discrete triangle.
---
---@field triangles integer
---
---Draws a set of triangles.  Each one shares the first vertex as a common point, leading to a fan-like shape.
---
---@field fan integer

---
---Most graphics primitives can be drawn in one of two modes: a filled mode and a wireframe mode.
---
---@class lovr.DrawStyle
---
---The shape is drawn as a filled object.
---
---@field fill integer
---
---The shape is drawn as a wireframe object.
---
---@field line integer

---
---The method used to downsample (or upsample) a texture.  "nearest" can be used for a pixelated effect, whereas "linear" leads to more smooth results.  Nearest is slightly faster than linear.
---
---@class lovr.FilterMode
---
---Fast nearest-neighbor sampling.  Leads to a pixelated style.
---
---@field nearest integer
---
---Smooth pixel sampling.
---
---@field bilinear integer
---
---Smooth pixel sampling, with smooth sampling across mipmap levels.
---
---@field trilinear integer

---
---Different ways to horizontally align text when using `lovr.graphics.print`.
---
---@class lovr.HorizontalAlign
---
---Left aligned lines of text.
---
---@field left integer
---
---Centered aligned lines of text.
---
---@field center integer
---
---Right aligned lines of text.
---
---@field right integer

---
---The different types of color parameters `Material`s can hold.
---
---@class lovr.MaterialColor
---
---The diffuse color.
---
---@field diffuse integer
---
---The emissive color.
---
---@field emissive integer

---
---The different types of float parameters `Material`s can hold.
---
---@class lovr.MaterialScalar
---
---The constant metalness factor.
---
---@field metalness integer
---
---The constant roughness factor.
---
---@field roughness integer

---
---The different types of texture parameters `Material`s can hold.
---
---@class lovr.MaterialTexture
---
---The diffuse texture.
---
---@field diffuse integer
---
---The emissive texture.
---
---@field emissive integer
---
---The metalness texture.
---
---@field metalness integer
---
---The roughness texture.
---
---@field roughness integer
---
---The ambient occlusion texture.
---
---@field occlusion integer
---
---The normal map.
---
---@field normal integer
---
---The environment map, should be specified as a cubemap texture.
---
---@field environment integer

---
---Meshes can have a usage hint, describing how they are planning on being updated.  Setting the usage hint allows the graphics driver optimize how it handles the data in the Mesh.
---
---@class lovr.MeshUsage
---
---The Mesh contents will rarely change.
---
---@field static integer
---
---The Mesh contents will change often.
---
---@field dynamic integer
---
---The Mesh contents will change constantly, potentially multiple times each frame.
---
---@field stream integer

---
---Shaders can be used for either rendering operations or generic compute tasks.  Graphics shaders are created with `lovr.graphics.newShader` and compute shaders are created with `lovr.graphics.newComputeShader`.  `Shader:getType` can be used on an existing Shader to figure out what type it is.
---
---@class lovr.ShaderType
---
---A graphics shader.
---
---@field graphics integer
---
---A compute shader.
---
---@field compute integer

---
---How to modify pixels in the stencil buffer when using `lovr.graphics.stencil`.
---
---@class lovr.StencilAction
---
---Stencil values will be replaced with a custom value.
---
---@field replace integer
---
---Stencil values will increment every time they are rendered to.
---
---@field increment integer
---
---Stencil values will decrement every time they are rendered to.
---
---@field decrement integer
---
---Similar to `increment`, but the stencil value will be set to 0 if it exceeds 255.
---
---@field incrementwrap integer
---
---Similar to `decrement`, but the stencil value will be set to 255 if it drops below 0.
---
---@field decrementwrap integer
---
---Stencil values will be bitwise inverted every time they are rendered to.
---
---@field invert integer

---
---Textures can store their pixels in different formats.  The set of color channels and the number of bits stored for each channel can differ, allowing Textures to optimize their storage for certain kinds of image formats or rendering techniques.
---
---@class lovr.TextureFormat
---
---Each pixel is 24 bits, or 8 bits for each channel.
---
---@field rgb integer
---
---Each pixel is 32 bits, or 8 bits for each channel (including alpha).
---
---@field rgba integer
---
---An rgba format where the colors occupy 4 bits instead of the usual 8.
---
---@field rgba4 integer
---
---Each pixel is 64 bits. Each channel is a 16 bit floating point number.
---
---@field rgba16f integer
---
---Each pixel is 128 bits. Each channel is a 32 bit floating point number.
---
---@field rgba32f integer
---
---A 16-bit floating point format with a single color channel.
---
---@field r16f integer
---
---A 32-bit floating point format with a single color channel.
---
---@field r32f integer
---
---A 16-bit floating point format with two color channels.
---
---@field rg16f integer
---
---A 32-bit floating point format with two color channels.
---
---@field rg32f integer
---
---A 16 bit format with 5-bit color channels and a single alpha bit.
---
---@field rgb5a1 integer
---
---A 32 bit format with 10-bit color channels and two alpha bits.
---
---@field rgb10a2 integer
---
---Each pixel is 32 bits, and packs three color channels into 10 or 11 bits each.
---
---@field rg11b10f integer
---
---A 16 bit depth buffer.
---
---@field d16 integer
---
---A 32 bit floating point depth buffer.
---
---@field d32f integer
---
---A depth buffer with 24 bits for depth and 8 bits for stencil.
---
---@field d24s8 integer

---
---Different types of Textures.
---
---@class lovr.TextureType
---
---A 2D texture.
---
---@field ["2d"] integer
---
---A 2D array texture with multiple independent 2D layers.
---
---@field array integer
---
---A cubemap texture with 6 2D faces.
---
---@field cube integer
---
---A 3D volumetric texture consisting of multiple 2D layers.
---
---@field volume integer

---
---When binding writable resources to shaders using `Shader:sendBlock` and `Shader:sendImage`, an access pattern can be specified as a hint that says whether you plan to read or write to the resource (or both).  Sometimes, LÖVR or the GPU driver can use this hint to get better performance or avoid stalling.
---
---@class lovr.UniformAccess
---
---The Shader will use the resource in a read-only fashion.
---
---@field read integer
---
---The Shader will use the resource in a write-only fashion.
---
---@field write integer
---
---The resource will be available for reading and writing.
---
---@field readwrite integer

---
---Different ways to vertically align text when using `lovr.graphics.print`.
---
---@class lovr.VerticalAlign
---
---Align the top of the text to the origin.
---
---@field top integer
---
---Vertically center the text.
---
---@field middle integer
---
---Align the bottom of the text to the origin.
---
---@field bottom integer

---
---Whether the points on triangles are specified in a clockwise or counterclockwise order.
---
---@class lovr.Winding
---
---Triangle vertices are specified in a clockwise order.
---
---@field clockwise integer
---
---Triangle vertices are specified in a counterclockwise order.
---
---@field counterclockwise integer

---
---The method used to render textures when texture coordinates are outside of the 0-1 range.
---
---@class lovr.WrapMode
---
---The texture will be clamped at its edges.
---
---@field clamp integer
---
---The texture repeats.
---
---@field repeat integer
---
---The texture will repeat, mirroring its appearance each time it repeats.
---
---@field mirroredrepeat integer
