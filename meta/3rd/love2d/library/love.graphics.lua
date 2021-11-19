---@meta

---
---The primary responsibility for the love.graphics module is the drawing of lines, shapes, text, Images and other Drawable objects onto the screen. Its secondary responsibilities include loading external files (including Images and Fonts) into memory, creating specialized objects (such as ParticleSystems or Canvases) and managing screen geometry.
---
---LÖVE's coordinate system is rooted in the upper-left corner of the screen, which is at location (0, 0). The x axis is horizontal: larger values are further to the right. The y axis is vertical: larger values are further towards the bottom.
---
---In many cases, you draw images or shapes in terms of their upper-left corner.
---
---Many of the functions are used to manipulate the graphics coordinate system, which is essentially the way coordinates are mapped to the display. You can change the position, scale, and even rotation in this way.
---
---@class love.graphics
love.graphics = {}

---
---Applies the given Transform object to the current coordinate transformation.
---
---This effectively multiplies the existing coordinate transformation's matrix with the Transform object's internal matrix to produce the new coordinate transformation.
---
---@param transform love.Transform # The Transform object to apply to the current graphics coordinate transform.
function love.graphics.applyTransform(transform) end

---
---Draws a filled or unfilled arc at position (x, y). The arc is drawn from angle1 to angle2 in radians. The segments parameter determines how many segments are used to draw the arc. The more segments, the smoother the edge.
---
---@overload fun(drawmode: love.DrawMode, arctype: love.ArcType, x: number, y: number, radius: number, angle1: number, angle2: number, segments: number)
---@param drawmode love.DrawMode # How to draw the arc.
---@param x number # The position of the center along x-axis.
---@param y number # The position of the center along y-axis.
---@param radius number # Radius of the arc.
---@param angle1 number # The angle at which the arc begins.
---@param angle2 number # The angle at which the arc terminates.
---@param segments? number # The number of segments used for drawing the arc.
function love.graphics.arc(drawmode, x, y, radius, angle1, angle2, segments) end

---
---Creates a screenshot once the current frame is done (after love.draw has finished).
---
---Since this function enqueues a screenshot capture rather than executing it immediately, it can be called from an input callback or love.update and it will still capture all of what's drawn to the screen in that frame.
---
---@overload fun(callback: function)
---@overload fun(channel: love.Channel)
---@param filename string # The filename to save the screenshot to. The encoded image type is determined based on the extension of the filename, and must be one of the ImageFormats.
function love.graphics.captureScreenshot(filename) end

---
---Draws a circle.
---
---@overload fun(mode: love.DrawMode, x: number, y: number, radius: number, segments: number)
---@param mode love.DrawMode # How to draw the circle.
---@param x number # The position of the center along x-axis.
---@param y number # The position of the center along y-axis.
---@param radius number # The radius of the circle.
function love.graphics.circle(mode, x, y, radius) end

---
---Clears the screen or active Canvas to the specified color.
---
---This function is called automatically before love.draw in the default love.run function. See the example in love.run for a typical use of this function.
---
---Note that the scissor area bounds the cleared region.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---In versions prior to background color instead.
---
---@overload fun(r: number, g: number, b: number, a: number, clearstencil: boolean, cleardepth: boolean)
---@overload fun(color: table, ..., clearstencil: boolean, cleardepth: boolean)
---@overload fun(clearcolor: boolean, clearstencil: boolean, cleardepth: boolean)
function love.graphics.clear() end

---
---Discards (trashes) the contents of the screen or active Canvas. This is a performance optimization function with niche use cases.
---
---If the active Canvas has just been changed and the 'replace' BlendMode is about to be used to draw something which covers the entire screen, calling love.graphics.discard rather than calling love.graphics.clear or doing nothing may improve performance on mobile devices.
---
---On some desktop systems this function may do nothing.
---
---@overload fun(discardcolors: table, discardstencil: boolean)
---@param discardcolor? boolean # Whether to discard the texture(s) of the active Canvas(es) (the contents of the screen if no Canvas is active.)
---@param discardstencil? boolean # Whether to discard the contents of the stencil buffer of the screen / active Canvas.
function love.graphics.discard(discardcolor, discardstencil) end

---
---Draws a Drawable object (an Image, Canvas, SpriteBatch, ParticleSystem, Mesh, Text object, or Video) on the screen with optional rotation, scaling and shearing.
---
---Objects are drawn relative to their local coordinate system. The origin is by default located at the top left corner of Image and Canvas. All scaling, shearing, and rotation arguments transform the object relative to that point. Also, the position of the origin can be specified on the screen coordinate system.
---
---It's possible to rotate an object about its center by offsetting the origin to the center. Angles must be given in radians for rotation. One can also use a negative scaling factor to flip about its centerline. 
---
---Note that the offsets are applied before rotation, scaling, or shearing; scaling and shearing are applied before rotation.
---
---The right and bottom edges of the object are shifted at an angle defined by the shearing factors.
---
---When using the default shader anything drawn with this function will be tinted according to the currently selected color.  Set it to pure white to preserve the object's original colors.
---
---@overload fun(texture: love.Texture, quad: love.Quad, x: number, y: number, r: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number)
---@overload fun(drawable: love.Drawable, transform: love.Transform)
---@overload fun(texture: love.Texture, quad: love.Quad, transform: love.Transform)
---@param drawable love.Drawable # A drawable object.
---@param x? number # The position to draw the object (x-axis).
---@param y? number # The position to draw the object (y-axis).
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shearing factor (x-axis).
---@param ky? number # Shearing factor (y-axis).
function love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky) end

---
---Draws many instances of a Mesh with a single draw call, using hardware geometry instancing.
---
---Each instance can have unique properties (positions, colors, etc.) but will not by default unless a custom per-instance vertex attributes or the love_InstanceID GLSL 3 vertex shader variable is used, otherwise they will all render at the same position on top of each other.
---
---Instancing is not supported by some older GPUs that are only capable of using OpenGL ES 2 or OpenGL 2. Use love.graphics.getSupported to check.
---
---@overload fun(mesh: love.Mesh, instancecount: number, transform: love.Transform)
---@param mesh love.Mesh # The mesh to render.
---@param instancecount number # The number of instances to render.
---@param x? number # The position to draw the instances (x-axis).
---@param y? number # The position to draw the instances (y-axis).
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shearing factor (x-axis).
---@param ky? number # Shearing factor (y-axis).
function love.graphics.drawInstanced(mesh, instancecount, x, y, r, sx, sy, ox, oy, kx, ky) end

---
---Draws a layer of an Array Texture.
---
---@overload fun(texture: love.Texture, layerindex: number, quad: love.Quad, x: number, y: number, r: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number)
---@overload fun(texture: love.Texture, layerindex: number, transform: love.Transform)
---@overload fun(texture: love.Texture, layerindex: number, quad: love.Quad, transform: love.Transform)
---@param texture love.Texture # The Array Texture to draw.
---@param layerindex number # The index of the layer to use when drawing.
---@param x? number # The position to draw the texture (x-axis).
---@param y? number # The position to draw the texture (y-axis).
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shearing factor (x-axis).
---@param ky? number # Shearing factor (y-axis).
function love.graphics.drawLayer(texture, layerindex, x, y, r, sx, sy, ox, oy, kx, ky) end

---
---Draws an ellipse.
---
---@overload fun(mode: love.DrawMode, x: number, y: number, radiusx: number, radiusy: number, segments: number)
---@param mode love.DrawMode # How to draw the ellipse.
---@param x number # The position of the center along x-axis.
---@param y number # The position of the center along y-axis.
---@param radiusx number # The radius of the ellipse along the x-axis (half the ellipse's width).
---@param radiusy number # The radius of the ellipse along the y-axis (half the ellipse's height).
function love.graphics.ellipse(mode, x, y, radiusx, radiusy) end

---
---Immediately renders any pending automatically batched draws.
---
---LÖVE will call this function internally as needed when most state is changed, so it is not necessary to manually call it.
---
---The current batch will be automatically flushed by love.graphics state changes (except for the transform stack and the current color), as well as Shader:send and methods on Textures which change their state. Using a different Image in consecutive love.graphics.draw calls will also flush the current batch.
---
---SpriteBatches, ParticleSystems, Meshes, and Text objects do their own batching and do not affect automatic batching of other draws, aside from flushing the current batch when they're drawn.
---
function love.graphics.flushBatch() end

---
---Gets the current background color.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@return number r # The red component (0-1).
---@return number g # The green component (0-1).
---@return number b # The blue component (0-1).
---@return number a # The alpha component (0-1).
function love.graphics.getBackgroundColor() end

---
---Gets the blending mode.
---
---@return love.BlendMode mode # The current blend mode.
---@return love.BlendAlphaMode alphamode # The current blend alpha mode – it determines how the alpha of drawn objects affects blending.
function love.graphics.getBlendMode() end

---
---Gets the current target Canvas.
---
---@return love.Canvas canvas # The Canvas set by setCanvas. Returns nil if drawing to the real screen.
function love.graphics.getCanvas() end

---
---Gets the available Canvas formats, and whether each is supported.
---
---@overload fun(readable: boolean):table
---@return table formats # A table containing CanvasFormats as keys, and a boolean indicating whether the format is supported as values. Not all systems support all formats.
function love.graphics.getCanvasFormats() end

---
---Gets the current color.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@return number r # The red component (0-1).
---@return number g # The green component (0-1).
---@return number b # The blue component (0-1).
---@return number a # The alpha component (0-1).
function love.graphics.getColor() end

---
---Gets the active color components used when drawing. Normally all 4 components are active unless love.graphics.setColorMask has been used.
---
---The color mask determines whether individual components of the colors of drawn objects will affect the color of the screen. They affect love.graphics.clear and Canvas:clear as well.
---
---@return boolean r # Whether the red color component is active when rendering.
---@return boolean g # Whether the green color component is active when rendering.
---@return boolean b # Whether the blue color component is active when rendering.
---@return boolean a # Whether the alpha color component is active when rendering.
function love.graphics.getColorMask() end

---
---Gets the DPI scale factor of the window.
---
---The DPI scale factor represents relative pixel density. The pixel density inside the window might be greater (or smaller) than the 'size' of the window. For example on a retina screen in Mac OS X with the highdpi window flag enabled, the window may take up the same physical size as an 800x600 window, but the area inside the window uses 1600x1200 pixels. love.graphics.getDPIScale() would return 2 in that case.
---
---The love.window.fromPixels and love.window.toPixels functions can also be used to convert between units.
---
---The highdpi window flag must be enabled to use the full pixel density of a Retina screen on Mac OS X and iOS. The flag currently does nothing on Windows and Linux, and on Android it is effectively always enabled.
---
---@return number scale # The pixel scale factor associated with the window.
function love.graphics.getDPIScale() end

---
---Returns the default scaling filters used with Images, Canvases, and Fonts.
---
---@return love.FilterMode min # Filter mode used when scaling the image down.
---@return love.FilterMode mag # Filter mode used when scaling the image up.
---@return number anisotropy # Maximum amount of Anisotropic Filtering used.
function love.graphics.getDefaultFilter() end

---
---Gets the current depth test mode and whether writing to the depth buffer is enabled.
---
---This is low-level functionality designed for use with custom vertex shaders and Meshes with custom vertex attributes. No higher level APIs are provided to set the depth of 2D graphics such as shapes, lines, and Images.
---
---@return love.CompareMode comparemode # Depth comparison mode used for depth testing.
---@return boolean write # Whether to write update / write values to the depth buffer when rendering.
function love.graphics.getDepthMode() end

---
---Gets the width and height in pixels of the window.
---
---@return number width # The width of the window.
---@return number height # The height of the window.
function love.graphics.getDimensions() end

---
---Gets the current Font object.
---
---@return love.Font font # The current Font. Automatically creates and sets the default font, if none is set yet.
function love.graphics.getFont() end

---
---Gets whether triangles with clockwise- or counterclockwise-ordered vertices are considered front-facing.
---
---This is designed for use in combination with Mesh face culling. Other love.graphics shapes, lines, and sprites are not guaranteed to have a specific winding order to their internal vertices.
---
---@return love.VertexWinding winding # The winding mode being used. The default winding is counterclockwise ('ccw').
function love.graphics.getFrontFaceWinding() end

---
---Gets the height in pixels of the window.
---
---@return number height # The height of the window.
function love.graphics.getHeight() end

---
---Gets the raw and compressed pixel formats usable for Images, and whether each is supported.
---
---@return table formats # A table containing PixelFormats as keys, and a boolean indicating whether the format is supported as values. Not all systems support all formats.
function love.graphics.getImageFormats() end

---
---Gets the line join style.
---
---@return love.LineJoin join # The LineJoin style.
function love.graphics.getLineJoin() end

---
---Gets the line style.
---
---@return love.LineStyle style # The current line style.
function love.graphics.getLineStyle() end

---
---Gets the current line width.
---
---@return number width # The current line width.
function love.graphics.getLineWidth() end

---
---Gets whether back-facing triangles in a Mesh are culled.
---
---Mesh face culling is designed for use with low level custom hardware-accelerated 3D rendering via custom vertex attributes on Meshes, custom vertex shaders, and depth testing with a depth buffer.
---
---@return love.CullMode mode # The Mesh face culling mode in use (whether to render everything, cull back-facing triangles, or cull front-facing triangles).
function love.graphics.getMeshCullMode() end

---
---Gets the width and height in pixels of the window.
---
---love.graphics.getDimensions gets the dimensions of the window in units scaled by the screen's DPI scale factor, rather than pixels. Use getDimensions for calculations related to drawing to the screen and using the graphics coordinate system (calculating the center of the screen, for example), and getPixelDimensions only when dealing specifically with underlying pixels (pixel-related calculations in a pixel Shader, for example).
---
---@return number pixelwidth # The width of the window in pixels.
---@return number pixelheight # The height of the window in pixels.
function love.graphics.getPixelDimenions() end

---
---Gets the height in pixels of the window.
---
---The graphics coordinate system and DPI scale factor, rather than raw pixels. Use getHeight for calculations related to drawing to the screen and using the coordinate system (calculating the center of the screen, for example), and getPixelHeight only when dealing specifically with underlying pixels (pixel-related calculations in a pixel Shader, for example).
---
---@return number pixelheight # The height of the window in pixels.
function love.graphics.getPixelHeight() end

---
---Gets the width in pixels of the window.
---
---The graphics coordinate system and DPI scale factor, rather than raw pixels. Use getWidth for calculations related to drawing to the screen and using the coordinate system (calculating the center of the screen, for example), and getPixelWidth only when dealing specifically with underlying pixels (pixel-related calculations in a pixel Shader, for example).
---
---@return number pixelwidth # The width of the window in pixels.
function love.graphics.getPixelWidth() end

---
---Gets the point size.
---
---@return number size # The current point size.
function love.graphics.getPointSize() end

---
---Gets information about the system's video card and drivers.
---
---@return string name # The name of the renderer, e.g. 'OpenGL' or 'OpenGL ES'.
---@return string version # The version of the renderer with some extra driver-dependent version info, e.g. '2.1 INTEL-8.10.44'.
---@return string vendor # The name of the graphics card vendor, e.g. 'Intel Inc'. 
---@return string device # The name of the graphics card, e.g. 'Intel HD Graphics 3000 OpenGL Engine'.
function love.graphics.getRendererInfo() end

---
---Gets the current scissor box.
---
---@return number x # The x-component of the top-left point of the box.
---@return number y # The y-component of the top-left point of the box.
---@return number width # The width of the box.
---@return number height # The height of the box.
function love.graphics.getScissor() end

---
---Gets the current Shader. Returns nil if none is set.
---
---@return love.Shader shader # The currently active Shader, or nil if none is set.
function love.graphics.getShader() end

---
---Gets the current depth of the transform / state stack (the number of pushes without corresponding pops).
---
---@return number depth # The current depth of the transform and state love.graphics stack.
function love.graphics.getStackDepth() end

---
---Gets performance-related rendering statistics. 
---
---@overload fun(stats: table):table
---@return {drawcalls: number, canvasswitches: number, texturememory: number, images: number, canvases: number, fonts: number, shaderswitches: number, drawcallsbatched: number} stats # A table with the following fields:
function love.graphics.getStats() end

---
---Gets the current stencil test configuration.
---
---When stencil testing is enabled, the geometry of everything that is drawn afterward will be clipped / stencilled out based on a comparison between the arguments of this function and the stencil value of each pixel that the geometry touches. The stencil values of pixels are affected via love.graphics.stencil.
---
---Each Canvas has its own per-pixel stencil values.
---
---@return love.CompareMode comparemode # The type of comparison that is made for each pixel. Will be 'always' if stencil testing is disabled.
---@return number comparevalue # The value used when comparing with the stencil value of each pixel.
function love.graphics.getStencilTest() end

---
---Gets the optional graphics features and whether they're supported on the system.
---
---Some older or low-end systems don't always support all graphics features.
---
---@return table features # A table containing GraphicsFeature keys, and boolean values indicating whether each feature is supported.
function love.graphics.getSupported() end

---
---Gets the system-dependent maximum values for love.graphics features.
---
---@return table limits # A table containing GraphicsLimit keys, and number values.
function love.graphics.getSystemLimits() end

---
---Gets the available texture types, and whether each is supported.
---
---@return table texturetypes # A table containing TextureTypes as keys, and a boolean indicating whether the type is supported as values. Not all systems support all types.
function love.graphics.getTextureTypes() end

---
---Gets the width in pixels of the window.
---
---@return number width # The width of the window.
function love.graphics.getWidth() end

---
---Sets the scissor to the rectangle created by the intersection of the specified rectangle with the existing scissor.  If no scissor is active yet, it behaves like love.graphics.setScissor.
---
---The scissor limits the drawing area to a specified rectangle. This affects all graphics calls, including love.graphics.clear.
---
---The dimensions of the scissor is unaffected by graphical transformations (translate, scale, ...).
---
---@param x number # The x-coordinate of the upper left corner of the rectangle to intersect with the existing scissor rectangle.
---@param y number # The y-coordinate of the upper left corner of the rectangle to intersect with the existing scissor rectangle.
---@param width number # The width of the rectangle to intersect with the existing scissor rectangle.
---@param height number # The height of the rectangle to intersect with the existing scissor rectangle.
function love.graphics.intersectScissor(x, y, width, height) end

---
---Converts the given 2D position from screen-space into global coordinates.
---
---This effectively applies the reverse of the current graphics transformations to the given position. A similar Transform:inverseTransformPoint method exists for Transform objects.
---
---@param screenX number # The x component of the screen-space position.
---@param screenY number # The y component of the screen-space position.
---@return number globalX # The x component of the position in global coordinates.
---@return number globalY # The y component of the position in global coordinates.
function love.graphics.inverseTransformPoint(screenX, screenY) end

---
---Gets whether the graphics module is able to be used. If it is not active, love.graphics function and method calls will not work correctly and may cause the program to crash.
---The graphics module is inactive if a window is not open, or if the app is in the background on iOS. Typically the app's execution will be automatically paused by the system, in the latter case.
---
---@return boolean active # Whether the graphics module is active and able to be used.
function love.graphics.isActive() end

---
---Gets whether gamma-correct rendering is supported and enabled. It can be enabled by setting t.gammacorrect = true in love.conf.
---
---Not all devices support gamma-correct rendering, in which case it will be automatically disabled and this function will return false. It is supported on desktop systems which have graphics cards that are capable of using OpenGL 3 / DirectX 10, and iOS devices that can use OpenGL ES 3.
---
---@return boolean gammacorrect # True if gamma-correct rendering is supported and was enabled in love.conf, false otherwise.
function love.graphics.isGammaCorrect() end

---
---Gets whether wireframe mode is used when drawing.
---
---@return boolean wireframe # True if wireframe lines are used when drawing, false if it's not.
function love.graphics.isWireframe() end

---
---Draws lines between points.
---
---@overload fun(points: table)
---@param x1 number # The position of first point on the x-axis.
---@param y1 number # The position of first point on the y-axis.
---@param x2 number # The position of second point on the x-axis.
---@param y2 number # The position of second point on the y-axis.
function love.graphics.line(x1, y1, x2, y2) end

---
---Creates a new array Image.
---
---An array image / array texture is a single object which contains multiple 'layers' or 'slices' of 2D sub-images. It can be thought of similarly to a texture atlas or sprite sheet, but it doesn't suffer from the same tile / quad bleeding artifacts that texture atlases do – although every sub-image must have the same dimensions.
---
---A specific layer of an array image can be drawn with love.graphics.drawLayer / SpriteBatch:addLayer, or with the Quad variant of love.graphics.draw and Quad:setLayer, or via a custom Shader.
---
---To use an array image in a Shader, it must be declared as a ArrayImage or sampler2DArray type (instead of Image or sampler2D). The Texel(ArrayImage image, vec3 texturecoord) shader function must be used to get pixel colors from a slice of the array image. The vec3 argument contains the texture coordinate in the first two components, and the 0-based slice index in the third component.
---
---@param slices table # A table containing filepaths to images (or File, FileData, ImageData, or CompressedImageData objects), in an array. Each sub-image must have the same dimensions. A table of tables can also be given, where each sub-table contains all mipmap levels for the slice index of that sub-table.
---@param settings? {mipmaps: boolean, linear: boolean, dpiscale: number} # Optional table of settings to configure the array image, containing the following fields:
---@return love.Image image # An Array Image object.
function love.graphics.newArrayImage(slices, settings) end

---
---Creates a new Canvas object for offscreen rendering.
---
---@overload fun(width: number, height: number):love.Canvas
---@overload fun(width: number, height: number, settings: table):love.Canvas
---@overload fun(width: number, height: number, layers: number, settings: table):love.Canvas
---@return love.Canvas canvas # A new Canvas with dimensions equal to the window's size in pixels.
function love.graphics.newCanvas() end

---
---Creates a new cubemap Image.
---
---Cubemap images have 6 faces (sides) which represent a cube. They can't be rendered directly, they can only be used in Shader code (and sent to the shader via Shader:send).
---
---To use a cubemap image in a Shader, it must be declared as a CubeImage or samplerCube type (instead of Image or sampler2D). The Texel(CubeImage image, vec3 direction) shader function must be used to get pixel colors from the cubemap. The vec3 argument is a normalized direction from the center of the cube, rather than explicit texture coordinates.
---
---Each face in a cubemap image must have square dimensions.
---
---For variants of this function which accept a single image containing multiple cubemap faces, they must be laid out in one of the following forms in the image:
---
---   +y
---
---+z +x -z
---
---   -y
---
---   -x
---
---or:
---
---   +y
---
----x +z +x -z
---
---   -y
---
---or:
---
---+x
---
----x
---
---+y
---
----y
---
---+z
---
----z
---
---or:
---
---+x -x +y -y +z -z
---
---@overload fun(faces: table, settings: table):love.Image
---@param filename string # The filepath to a cubemap image file (or a File, FileData, or ImageData).
---@param settings? {mipmaps: boolean, linear: boolean} # Optional table of settings to configure the cubemap image, containing the following fields:
---@return love.Image image # An cubemap Image object.
function love.graphics.newCubeImage(filename, settings) end

---
---Creates a new Font from a TrueType Font or BMFont file. Created fonts are not cached, in that calling this function with the same arguments will always create a new Font object.
---
---All variants which accept a filename can also accept a Data object instead.
---
---@overload fun(filename: string, size: number, hinting: love.HintingMode, dpiscale: number):love.Font
---@overload fun(filename: string, imagefilename: string):love.Font
---@overload fun(size: number, hinting: love.HintingMode, dpiscale: number):love.Font
---@param filename string # The filepath to the BMFont or TrueType font file.
---@return love.Font font # A Font object which can be used to draw text on screen.
function love.graphics.newFont(filename) end

---
---Creates a new Image from a filepath, FileData, an ImageData, or a CompressedImageData, and optionally generates or specifies mipmaps for the image.
---
---@overload fun(fileData: love.FileData, flags: table):love.Image
---@overload fun(imageData: love.ImageData, flags: table):love.Image
---@overload fun(compressedImageData: love.CompressedImageData, flags: table):love.Image
---@param filename string # The filepath to the image file.
---@param flags {dpiscale: number, linear: boolean, mipmaps: boolean} # A table containing the following fields:
---@return love.Image image # A new Image object which can be drawn on screen.
function love.graphics.newImage(filename, flags) end

---
---Creates a new specifically formatted image.
---
---In versions prior to 0.9.0, LÖVE expects ISO 8859-1 encoding for the glyphs string.
---
---@overload fun(imageData: love.ImageData, glyphs: string):love.Font
---@overload fun(filename: string, glyphs: string, extraspacing: number):love.Font
---@param filename string # The filepath to the image file.
---@param glyphs string # A string of the characters in the image in order from left to right.
---@return love.Font font # A Font object which can be used to draw text on screen.
function love.graphics.newImageFont(filename, glyphs) end

---
---Creates a new Mesh.
---
---Use Mesh:setTexture if the Mesh should be textured with an Image or Canvas when it's drawn.
---
---In versions prior to 11.0, color and byte component values were within the range of 0 to 255 instead of 0 to 1.
---
---@overload fun(vertexcount: number, mode: love.MeshDrawMode, usage: love.SpriteBatchUsage):love.Mesh
---@overload fun(vertexformat: table, vertices: table, mode: love.MeshDrawMode, usage: love.SpriteBatchUsage):love.Mesh
---@overload fun(vertexformat: table, vertexcount: number, mode: love.MeshDrawMode, usage: love.SpriteBatchUsage):love.Mesh
---@overload fun(vertexcount: number, texture: love.Texture, mode: love.MeshDrawMode):love.Mesh
---@param vertices {["1"]: number, ["2"]: number, ["3"]: number, ["4"]: number, ["5"]: number, ["6"]: number, ["7"]: number, ["8"]: number} # The table filled with vertex information tables for each vertex as follows:
---@param mode? love.MeshDrawMode # How the vertices are used when drawing. The default mode 'fan' is sufficient for simple convex polygons.
---@param usage? love.SpriteBatchUsage # The expected usage of the Mesh. The specified usage mode affects the Mesh's memory usage and performance.
---@return love.Mesh mesh # The new mesh.
function love.graphics.newMesh(vertices, mode, usage) end

---
---Creates a new ParticleSystem.
---
---@overload fun(texture: love.Texture, buffer: number):love.ParticleSystem
---@param image love.Image # The image to use.
---@param buffer? number # The max number of particles at the same time.
---@return love.ParticleSystem system # A new ParticleSystem.
function love.graphics.newParticleSystem(image, buffer) end

---
---Creates a new Quad.
---
---The purpose of a Quad is to use a fraction of an image to draw objects, as opposed to drawing entire image. It is most useful for sprite sheets and atlases: in a sprite atlas, multiple sprites reside in same image, quad is used to draw a specific sprite from that image; in animated sprites with all frames residing in the same image, quad is used to draw specific frame from the animation.
---
---@param x number # The top-left position in the Image along the x-axis.
---@param y number # The top-left position in the Image along the y-axis.
---@param width number # The width of the Quad in the Image. (Must be greater than 0.)
---@param height number # The height of the Quad in the Image. (Must be greater than 0.)
---@param sw number # The reference width, the width of the Image. (Must be greater than 0.)
---@param sh number # The reference height, the height of the Image. (Must be greater than 0.)
---@return love.Quad quad # The new Quad.
function love.graphics.newQuad(x, y, width, height, sw, sh) end

---
---Creates a new Shader object for hardware-accelerated vertex and pixel effects. A Shader contains either vertex shader code, pixel shader code, or both.
---
---Shaders are small programs which are run on the graphics card when drawing. Vertex shaders are run once for each vertex (for example, an image has 4 vertices - one at each corner. A Mesh might have many more.) Pixel shaders are run once for each pixel on the screen which the drawn object touches. Pixel shader code is executed after all the object's vertices have been processed by the vertex shader.
---
---@overload fun(pixelcode: string, vertexcode: string):love.Shader
---@param code string # The pixel shader or vertex shader code, or a filename pointing to a file with the code.
---@return love.Shader shader # A Shader object for use in drawing operations.
function love.graphics.newShader(code) end

---
---Creates a new SpriteBatch object.
---
---@overload fun(image: love.Image, maxsprites: number, usage: love.SpriteBatchUsage):love.SpriteBatch
---@overload fun(texture: love.Texture, maxsprites: number, usage: love.SpriteBatchUsage):love.SpriteBatch
---@param image love.Image # The Image to use for the sprites.
---@param maxsprites? number # The maximum number of sprites that the SpriteBatch can contain at any given time. Since version 11.0, additional sprites added past this number will automatically grow the spritebatch.
---@return love.SpriteBatch spriteBatch # The new SpriteBatch.
function love.graphics.newSpriteBatch(image, maxsprites) end

---
---Creates a new drawable Text object.
---
---@param font love.Font # The font to use for the text.
---@param textstring? string # The initial string of text that the new Text object will contain. May be nil.
---@return love.Text text # The new drawable Text object.
function love.graphics.newText(font, textstring) end

---
---Creates a new drawable Video. Currently only Ogg Theora video files are supported.
---
---@overload fun(videostream: love.VideoStream):love.Video
---@overload fun(filename: string, settings: table):love.Video
---@overload fun(filename: string, loadaudio: boolean):love.Video
---@overload fun(videostream: love.VideoStream, loadaudio: boolean):love.Video
---@param filename string # The file path to the Ogg Theora video file.
---@return love.Video video # A new Video.
function love.graphics.newVideo(filename) end

---
---Creates a new volume (3D) Image.
---
---Volume images are 3D textures with width, height, and depth. They can't be rendered directly, they can only be used in Shader code (and sent to the shader via Shader:send).
---
---To use a volume image in a Shader, it must be declared as a VolumeImage or sampler3D type (instead of Image or sampler2D). The Texel(VolumeImage image, vec3 texcoords) shader function must be used to get pixel colors from the volume image. The vec3 argument is a normalized texture coordinate with the z component representing the depth to sample at (ranging from 1).
---
---Volume images are typically used as lookup tables in shaders for color grading, for example, because sampling using a texture coordinate that is partway in between two pixels can interpolate across all 3 dimensions in the volume image, resulting in a smooth gradient even when a small-sized volume image is used as the lookup table.
---
---Array images are a much better choice than volume images for storing multiple different sprites in a single array image for directly drawing them.
---
---@param layers table # A table containing filepaths to images (or File, FileData, ImageData, or CompressedImageData objects), in an array. A table of tables can also be given, where each sub-table represents a single mipmap level and contains all layers for that mipmap.
---@param settings? {mipmaps: boolean, linear: boolean} # Optional table of settings to configure the volume image, containing the following fields:
---@return love.Image image # A volume Image object.
function love.graphics.newVolumeImage(layers, settings) end

---
---Resets the current coordinate transformation.
---
---This function is always used to reverse any previous calls to love.graphics.rotate, love.graphics.scale, love.graphics.shear or love.graphics.translate. It returns the current transformation state to its defaults.
---
function love.graphics.origin() end

---
---Draws one or more points.
---
---@overload fun(points: table)
---@overload fun(points: table)
---@param x number # The position of the first point on the x-axis.
---@param y number # The position of the first point on the y-axis.
function love.graphics.points(x, y) end

---
---Draw a polygon.
---
---Following the mode argument, this function can accept multiple numeric arguments or a single table of numeric arguments. In either case the arguments are interpreted as alternating x and y coordinates of the polygon's vertices.
---
---@overload fun(mode: love.DrawMode, vertices: table)
---@param mode love.DrawMode # How to draw the polygon.
function love.graphics.polygon(mode) end

---
---Pops the current coordinate transformation from the transformation stack.
---
---This function is always used to reverse a previous push operation. It returns the current transformation state to what it was before the last preceding push.
---
function love.graphics.pop() end

---
---Displays the results of drawing operations on the screen.
---
---This function is used when writing your own love.run function. It presents all the results of your drawing operations on the screen. See the example in love.run for a typical use of this function.
---
function love.graphics.present() end

---
---Draws text on screen. If no Font is set, one will be created and set (once) if needed.
---
---As of LOVE 0.7.1, when using translation and scaling functions while drawing text, this function assumes the scale occurs first.  If you don't script with this in mind, the text won't be in the right position, or possibly even on screen.
---
---love.graphics.print and love.graphics.printf both support UTF-8 encoding. You'll also need a proper Font for special characters.
---
---In versions prior to 11.0, color and byte component values were within the range of 0 to 255 instead of 0 to 1.
---
---@overload fun(coloredtext: table, x: number, y: number, angle: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number)
---@overload fun(text: string, transform: love.Transform)
---@overload fun(coloredtext: table, transform: love.Transform)
---@overload fun(text: string, font: love.Font, transform: love.Transform)
---@overload fun(coloredtext: table, font: love.Font, transform: love.Transform)
---@param text string # The text to draw.
---@param x? number # The position to draw the object (x-axis).
---@param y? number # The position to draw the object (y-axis).
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shearing factor (x-axis).
---@param ky? number # Shearing factor (y-axis).
function love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky) end

---
---Draws formatted text, with word wrap and alignment.
---
---See additional notes in love.graphics.print.
---
---The word wrap limit is applied before any scaling, rotation, and other coordinate transformations. Therefore the amount of text per line stays constant given the same wrap limit, even if the scale arguments change.
---
---In version 0.9.2 and earlier, wrapping was implemented by breaking up words by spaces and putting them back together to make sure things fit nicely within the limit provided. However, due to the way this is done, extra spaces between words would end up missing when printed on the screen, and some lines could overflow past the provided wrap limit. In version 0.10.0 and newer this is no longer the case.
---
---In versions prior to 11.0, color and byte component values were within the range of 0 to 255 instead of 0 to 1.
---
---@overload fun(text: string, font: love.Font, x: number, y: number, limit: number, align: love.AlignMode, r: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number)
---@overload fun(text: string, transform: love.Transform, limit: number, align: love.AlignMode)
---@overload fun(text: string, font: love.Font, transform: love.Transform, limit: number, align: love.AlignMode)
---@overload fun(coloredtext: table, x: number, y: number, limit: number, align: love.AlignMode, angle: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number)
---@overload fun(coloredtext: table, font: love.Font, x: number, y: number, limit: number, align: love.AlignMode, angle: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number)
---@overload fun(coloredtext: table, transform: love.Transform, limit: number, align: love.AlignMode)
---@overload fun(coloredtext: table, font: love.Font, transform: love.Transform, limit: number, align: love.AlignMode)
---@param text string # A text string.
---@param x number # The position on the x-axis.
---@param y number # The position on the y-axis.
---@param limit number # Wrap the line after this many horizontal pixels.
---@param align? love.AlignMode # The alignment.
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shearing factor (x-axis).
---@param ky? number # Shearing factor (y-axis).
function love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky) end

---
---Copies and pushes the current coordinate transformation to the transformation stack.
---
---This function is always used to prepare for a corresponding pop operation later. It stores the current coordinate transformation state into the transformation stack and keeps it active. Later changes to the transformation can be undone by using the pop operation, which returns the coordinate transform to the state it was in before calling push.
---
---@overload fun(stack: love.StackType)
function love.graphics.push() end

---
---Draws a rectangle.
---
---@overload fun(mode: love.DrawMode, x: number, y: number, width: number, height: number, rx: number, ry: number, segments: number)
---@param mode love.DrawMode # How to draw the rectangle.
---@param x number # The position of top-left corner along the x-axis.
---@param y number # The position of top-left corner along the y-axis.
---@param width number # Width of the rectangle.
---@param height number # Height of the rectangle.
function love.graphics.rectangle(mode, x, y, width, height) end

---
---Replaces the current coordinate transformation with the given Transform object.
---
---@param transform love.Transform # The Transform object to replace the current graphics coordinate transform with.
function love.graphics.replaceTransform(transform) end

---
---Resets the current graphics settings.
---
---Calling reset makes the current drawing color white, the current background color black, disables any active color component masks, disables wireframe mode and resets the current graphics transformation to the origin. It also sets both the point and line drawing modes to smooth and their sizes to 1.0.
---
function love.graphics.reset() end

---
---Rotates the coordinate system in two dimensions.
---
---Calling this function affects all future drawing operations by rotating the coordinate system around the origin by the given amount of radians. This change lasts until love.draw() exits.
---
---@param angle number # The amount to rotate the coordinate system in radians.
function love.graphics.rotate(angle) end

---
---Scales the coordinate system in two dimensions.
---
---By default the coordinate system in LÖVE corresponds to the display pixels in horizontal and vertical directions one-to-one, and the x-axis increases towards the right while the y-axis increases downwards. Scaling the coordinate system changes this relation.
---
---After scaling by sx and sy, all coordinates are treated as if they were multiplied by sx and sy. Every result of a drawing operation is also correspondingly scaled, so scaling by (2, 2) for example would mean making everything twice as large in both x- and y-directions. Scaling by a negative value flips the coordinate system in the corresponding direction, which also means everything will be drawn flipped or upside down, or both. Scaling by zero is not a useful operation.
---
---Scale and translate are not commutative operations, therefore, calling them in different orders will change the outcome.
---
---Scaling lasts until love.draw() exits.
---
---@param sx number # The scaling in the direction of the x-axis.
---@param sy? number # The scaling in the direction of the y-axis. If omitted, it defaults to same as parameter sx.
function love.graphics.scale(sx, sy) end

---
---Sets the background color.
---
---@overload fun()
---@overload fun()
---@param red number # The red component (0-1).
---@param green number # The green component (0-1).
---@param blue number # The blue component (0-1).
---@param alpha? number # The alpha component (0-1).
function love.graphics.setBackgroundColor(red, green, blue, alpha) end

---
---Sets the blending mode.
---
---@overload fun(mode: love.BlendMode, alphamode: love.BlendAlphaMode)
---@param mode love.BlendMode # The blend mode to use.
function love.graphics.setBlendMode(mode) end

---
---Captures drawing operations to a Canvas.
---
---@overload fun()
---@overload fun(canvas1: love.Canvas, canvas2: love.Canvas, ...)
---@overload fun(canvas: love.Canvas, slice: number, mipmap: number)
---@overload fun(setup: table)
---@param canvas love.Canvas # The new target.
---@param mipmap? number # The mipmap level to render to, for Canvases with mipmaps.
function love.graphics.setCanvas(canvas, mipmap) end

---
---Sets the color used for drawing.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@overload fun(rgba: table)
---@param red number # The amount of red.
---@param green number # The amount of green.
---@param blue number # The amount of blue.
---@param alpha? number # The amount of alpha.  The alpha value will be applied to all subsequent draw operations, even the drawing of an image.
function love.graphics.setColor(red, green, blue, alpha) end

---
---Sets the color mask. Enables or disables specific color components when rendering and clearing the screen. For example, if '''red''' is set to '''false''', no further changes will be made to the red component of any pixels.
---
---@overload fun()
---@param red boolean # Render red component.
---@param green boolean # Render green component.
---@param blue boolean # Render blue component.
---@param alpha boolean # Render alpha component.
function love.graphics.setColorMask(red, green, blue, alpha) end

---
---Sets the default scaling filters used with Images, Canvases, and Fonts.
---
---@param min love.FilterMode # Filter mode used when scaling the image down.
---@param mag love.FilterMode # Filter mode used when scaling the image up.
---@param anisotropy? number # Maximum amount of Anisotropic Filtering used.
function love.graphics.setDefaultFilter(min, mag, anisotropy) end

---
---Configures depth testing and writing to the depth buffer.
---
---This is low-level functionality designed for use with custom vertex shaders and Meshes with custom vertex attributes. No higher level APIs are provided to set the depth of 2D graphics such as shapes, lines, and Images.
---
---@overload fun()
---@param comparemode love.CompareMode # Depth comparison mode used for depth testing.
---@param write boolean # Whether to write update / write values to the depth buffer when rendering.
function love.graphics.setDepthMode(comparemode, write) end

---
---Set an already-loaded Font as the current font or create and load a new one from the file and size.
---
---It's recommended that Font objects are created with love.graphics.newFont in the loading stage and then passed to this function in the drawing stage.
---
---@param font love.Font # The Font object to use.
function love.graphics.setFont(font) end

---
---Sets whether triangles with clockwise- or counterclockwise-ordered vertices are considered front-facing.
---
---This is designed for use in combination with Mesh face culling. Other love.graphics shapes, lines, and sprites are not guaranteed to have a specific winding order to their internal vertices.
---
---@param winding love.VertexWinding # The winding mode to use. The default winding is counterclockwise ('ccw').
function love.graphics.setFrontFaceWinding(winding) end

---
---Sets the line join style. See LineJoin for the possible options.
---
---@param join love.LineJoin # The LineJoin to use.
function love.graphics.setLineJoin(join) end

---
---Sets the line style.
---
---@param style love.LineStyle # The LineStyle to use. Line styles include smooth and rough.
function love.graphics.setLineStyle(style) end

---
---Sets the line width.
---
---@param width number # The width of the line.
function love.graphics.setLineWidth(width) end

---
---Sets whether back-facing triangles in a Mesh are culled.
---
---This is designed for use with low level custom hardware-accelerated 3D rendering via custom vertex attributes on Meshes, custom vertex shaders, and depth testing with a depth buffer.
---
---By default, both front- and back-facing triangles in Meshes are rendered.
---
---@param mode love.CullMode # The Mesh face culling mode to use (whether to render everything, cull back-facing triangles, or cull front-facing triangles).
function love.graphics.setMeshCullMode(mode) end

---
---Creates and sets a new Font.
---
---@overload fun(filename: string, size: number):love.Font
---@overload fun(file: love.File, size: number):love.Font
---@overload fun(data: love.Data, size: number):love.Font
---@overload fun(rasterizer: love.Rasterizer):love.Font
---@param size? number # The size of the font.
---@return love.Font font # The new font.
function love.graphics.setNewFont(size) end

---
---Sets the point size.
---
---@param size number # The new point size.
function love.graphics.setPointSize(size) end

---
---Sets or disables scissor.
---
---The scissor limits the drawing area to a specified rectangle. This affects all graphics calls, including love.graphics.clear. 
---
---The dimensions of the scissor is unaffected by graphical transformations (translate, scale, ...).
---
---@overload fun()
---@param x number # x coordinate of upper left corner.
---@param y number # y coordinate of upper left corner.
---@param width number # width of clipping rectangle.
---@param height number # height of clipping rectangle.
function love.graphics.setScissor(x, y, width, height) end

---
---Sets or resets a Shader as the current pixel effect or vertex shaders. All drawing operations until the next ''love.graphics.setShader'' will be drawn using the Shader object specified.
---
---@overload fun()
---@param shader love.Shader # The new shader.
function love.graphics.setShader(shader) end

---
---Configures or disables stencil testing.
---
---When stencil testing is enabled, the geometry of everything that is drawn afterward will be clipped / stencilled out based on a comparison between the arguments of this function and the stencil value of each pixel that the geometry touches. The stencil values of pixels are affected via love.graphics.stencil.
---
---@overload fun()
---@param comparemode love.CompareMode # The type of comparison to make for each pixel.
---@param comparevalue number # The value to use when comparing with the stencil value of each pixel. Must be between 0 and 255.
function love.graphics.setStencilTest(comparemode, comparevalue) end

---
---Sets whether wireframe lines will be used when drawing.
---
---@param enable boolean # True to enable wireframe mode when drawing, false to disable it.
function love.graphics.setWireframe(enable) end

---
---Shears the coordinate system.
---
---@param kx number # The shear factor on the x-axis.
---@param ky number # The shear factor on the y-axis.
function love.graphics.shear(kx, ky) end

---
---Draws geometry as a stencil.
---
---The geometry drawn by the supplied function sets invisible stencil values of pixels, instead of setting pixel colors. The stencil buffer (which contains those stencil values) can act like a mask / stencil - love.graphics.setStencilTest can be used afterward to determine how further rendering is affected by the stencil values in each pixel.
---
---Stencil values are integers within the range of 255.
---
---@param stencilfunction function # Function which draws geometry. The stencil values of pixels, rather than the color of each pixel, will be affected by the geometry.
---@param action? love.StencilAction # How to modify any stencil values of pixels that are touched by what's drawn in the stencil function.
---@param value? number # The new stencil value to use for pixels if the 'replace' stencil action is used. Has no effect with other stencil actions. Must be between 0 and 255.
---@param keepvalues? boolean # True to preserve old stencil values of pixels, false to re-set every pixel's stencil value to 0 before executing the stencil function. love.graphics.clear will also re-set all stencil values.
function love.graphics.stencil(stencilfunction, action, value, keepvalues) end

---
---Converts the given 2D position from global coordinates into screen-space.
---
---This effectively applies the current graphics transformations to the given position. A similar Transform:transformPoint method exists for Transform objects.
---
---@param globalX number # The x component of the position in global coordinates.
---@param globalY number # The y component of the position in global coordinates.
---@return number screenX # The x component of the position with graphics transformations applied.
---@return number screenY # The y component of the position with graphics transformations applied.
function love.graphics.transformPoint(globalX, globalY) end

---
---Translates the coordinate system in two dimensions.
---
---When this function is called with two numbers, dx, and dy, all the following drawing operations take effect as if their x and y coordinates were x+dx and y+dy. 
---
---Scale and translate are not commutative operations, therefore, calling them in different orders will change the outcome.
---
---This change lasts until love.draw() exits or else a love.graphics.pop reverts to a previous love.graphics.push.
---
---Translating using whole numbers will prevent tearing/blurring of images and fonts draw after translating.
---
---@param dx number # The translation relative to the x-axis.
---@param dy number # The translation relative to the y-axis.
function love.graphics.translate(dx, dy) end

---
---Validates shader code. Check if specified shader code does not contain any errors.
---
---@overload fun(gles: boolean, pixelcode: string, vertexcode: string):boolean, string
---@param gles boolean # Validate code as GLSL ES shader.
---@param code string # The pixel shader or vertex shader code, or a filename pointing to a file with the code.
---@return boolean status # true if specified shader code doesn't contain any errors. false otherwise.
---@return string message # Reason why shader code validation failed (or nil if validation succeded).
function love.graphics.validateShader(gles, code) end

---
---A Canvas is used for off-screen rendering. Think of it as an invisible screen that you can draw to, but that will not be visible until you draw it to the actual visible screen. It is also known as "render to texture".
---
---By drawing things that do not change position often (such as background items) to the Canvas, and then drawing the entire Canvas instead of each item,  you can reduce the number of draw operations performed each frame.
---
---In versions prior to love.graphics.isSupported("canvas") could be used to check for support at runtime.
---
---@class love.Canvas: love.Texture, love.Drawable, love.Object
local Canvas = {}

---
---Generates mipmaps for the Canvas, based on the contents of the highest-resolution mipmap level.
---
---The Canvas must be created with mipmaps set to a MipmapMode other than 'none' for this function to work. It should only be called while the Canvas is not the active render target.
---
---If the mipmap mode is set to 'auto', this function is automatically called inside love.graphics.setCanvas when switching from this Canvas to another Canvas or to the main screen.
---
function Canvas:generateMipmaps() end

---
---Gets the number of multisample antialiasing (MSAA) samples used when drawing to the Canvas.
---
---This may be different than the number used as an argument to love.graphics.newCanvas if the system running LÖVE doesn't support that number.
---
---@return number samples # The number of multisample antialiasing samples used by the canvas when drawing to it.
function Canvas:getMSAA() end

---
---Gets the MipmapMode this Canvas was created with.
---
---@return love.MipmapMode mode # The mipmap mode this Canvas was created with.
function Canvas:getMipmapMode() end

---
---Generates ImageData from the contents of the Canvas.
---
---@overload fun(slice: number, mipmap: number, x: number, y: number, width: number, height: number):love.ImageData
---@return love.ImageData data # The new ImageData made from the Canvas' contents.
function Canvas:newImageData() end

---
---Render to the Canvas using a function.
---
---This is a shortcut to love.graphics.setCanvas:
---
---canvas:renderTo( func )
---
---is the same as
---
---love.graphics.setCanvas( canvas )
---
---func()
---
---love.graphics.setCanvas()
---
---@param func function # A function performing drawing operations.
function Canvas:renderTo(func) end

---
---Superclass for all things that can be drawn on screen. This is an abstract type that can't be created directly.
---
---@class love.Drawable: love.Object
local Drawable = {}

---
---Defines the shape of characters that can be drawn onto the screen.
---
---@class love.Font: love.Object
local Font = {}

---
---Gets the ascent of the Font.
---
---The ascent spans the distance between the baseline and the top of the glyph that reaches farthest from the baseline.
---
---@return number ascent # The ascent of the Font in pixels.
function Font:getAscent() end

---
---Gets the baseline of the Font.
---
---Most scripts share the notion of a baseline: an imaginary horizontal line on which characters rest. In some scripts, parts of glyphs lie below the baseline.
---
---@return number baseline # The baseline of the Font in pixels.
function Font:getBaseline() end

---
---Gets the DPI scale factor of the Font.
---
---The DPI scale factor represents relative pixel density. A DPI scale factor of 2 means the font's glyphs have twice the pixel density in each dimension (4 times as many pixels in the same area) compared to a font with a DPI scale factor of 1.
---
---The font size of TrueType fonts is scaled internally by the font's specified DPI scale factor. By default, LÖVE uses the screen's DPI scale factor when creating TrueType fonts.
---
---@return number dpiscale # The DPI scale factor of the Font.
function Font:getDPIScale() end

---
---Gets the descent of the Font.
---
---The descent spans the distance between the baseline and the lowest descending glyph in a typeface.
---
---@return number descent # The descent of the Font in pixels.
function Font:getDescent() end

---
---Gets the filter mode for a font.
---
---@return love.FilterMode min # Filter mode used when minifying the font.
---@return love.FilterMode mag # Filter mode used when magnifying the font.
---@return number anisotropy # Maximum amount of anisotropic filtering used.
function Font:getFilter() end

---
---Gets the height of the Font.
---
---The height of the font is the size including any spacing; the height which it will need.
---
---@return number height # The height of the Font in pixels.
function Font:getHeight() end

---
---Gets the line height.
---
---This will be the value previously set by Font:setLineHeight, or 1.0 by default.
---
---@return number height # The current line height.
function Font:getLineHeight() end

---
---Determines the maximum width (accounting for newlines) taken by the given string.
---
---@param text string # A string.
---@return number width # The width of the text.
function Font:getWidth(text) end

---
---Gets formatting information for text, given a wrap limit.
---
---This function accounts for newlines correctly (i.e. '\n').
---
---@param text string # The text that will be wrapped.
---@param wraplimit number # The maximum width in pixels of each line that ''text'' is allowed before wrapping.
---@return number width # The maximum width of the wrapped text.
---@return table wrappedtext # A sequence containing each line of text that was wrapped.
function Font:getWrap(text, wraplimit) end

---
---Gets whether the Font can render a character or string.
---
---@overload fun(character1: string, character2: string):boolean
---@overload fun(codepoint1: number, codepoint2: number):boolean
---@param text string # A UTF-8 encoded unicode string.
---@return boolean hasglyph # Whether the font can render all the UTF-8 characters in the string.
function Font:hasGlyphs(text) end

---
---Sets the fallback fonts. When the Font doesn't contain a glyph, it will substitute the glyph from the next subsequent fallback Fonts. This is akin to setting a 'font stack' in Cascading Style Sheets (CSS).
---
---@param fallbackfont1 love.Font # The first fallback Font to use.
function Font:setFallbacks(fallbackfont1) end

---
---Sets the filter mode for a font.
---
---@param min love.FilterMode # How to scale a font down.
---@param mag love.FilterMode # How to scale a font up.
---@param anisotropy? number # Maximum amount of anisotropic filtering used.
function Font:setFilter(min, mag, anisotropy) end

---
---Sets the line height.
---
---When rendering the font in lines the actual height will be determined by the line height multiplied by the height of the font. The default is 1.0.
---
---@param height number # The new line height.
function Font:setLineHeight(height) end

---
---Drawable image type.
---
---@class love.Image: love.Texture, love.Drawable, love.Object
local Image = {}

---
---Gets the flags used when the image was created.
---
---@return table flags # A table with ImageFlag keys.
function Image:getFlags() end

---
---Gets whether the Image was created from CompressedData.
---
---Compressed images take up less space in VRAM, and drawing a compressed image will generally be more efficient than drawing one created from raw pixel data.
---
---@return boolean compressed # Whether the Image is stored as a compressed texture on the GPU.
function Image:isCompressed() end

---
---Replace the contents of an Image.
---
---@param data love.ImageData # The new ImageData to replace the contents with.
---@param slice number # Which cubemap face, array index, or volume layer to replace, if applicable.
---@param mipmap? number # The mimap level to replace, if the Image has mipmaps.
---@param x? number # The x-offset in pixels from the top-left of the image to replace. The given ImageData's width plus this value must not be greater than the pixel width of the Image's specified mipmap level.
---@param y? number # The y-offset in pixels from the top-left of the image to replace. The given ImageData's height plus this value must not be greater than the pixel height of the Image's specified mipmap level.
---@param reloadmipmaps boolean # Whether to generate new mipmaps after replacing the Image's pixels. True by default if the Image was created with automatically generated mipmaps, false by default otherwise.
function Image:replacePixels(data, slice, mipmap, x, y, reloadmipmaps) end

---
---A 2D polygon mesh used for drawing arbitrary textured shapes.
---
---@class love.Mesh: love.Drawable, love.Object
local Mesh = {}

---
---Attaches a vertex attribute from a different Mesh onto this Mesh, for use when drawing. This can be used to share vertex attribute data between several different Meshes.
---
---@overload fun(name: string, mesh: love.Mesh, step: love.VertexAttributeStep, attachname: string)
---@param name string # The name of the vertex attribute to attach.
---@param mesh love.Mesh # The Mesh to get the vertex attribute from.
function Mesh:attachAttribute(name, mesh) end

---
---Removes a previously attached vertex attribute from this Mesh.
---
---@param name string # The name of the attached vertex attribute to detach.
---@return boolean success # Whether the attribute was successfully detached.
function Mesh:detachAttribute(name) end

---
---Gets the mode used when drawing the Mesh.
---
---@return love.MeshDrawMode mode # The mode used when drawing the Mesh.
function Mesh:getDrawMode() end

---
---Gets the range of vertices used when drawing the Mesh.
---
---@return number min # The index of the first vertex used when drawing, or the index of the first value in the vertex map used if one is set for this Mesh.
---@return number max # The index of the last vertex used when drawing, or the index of the last value in the vertex map used if one is set for this Mesh.
function Mesh:getDrawRange() end

---
---Gets the texture (Image or Canvas) used when drawing the Mesh.
---
---@return love.Texture texture # The Image or Canvas to texture the Mesh with when drawing, or nil if none is set.
function Mesh:getTexture() end

---
---Gets the properties of a vertex in the Mesh.
---
---In versions prior to 11.0, color and byte component values were within the range of 0 to 255 instead of 0 to 1.
---
---@overload fun(index: number):number, number, number, number, number, number, number, number
---@param index number # The one-based index of the vertex you want to retrieve the information for.
---@return number attributecomponent # The first component of the first vertex attribute in the specified vertex.
function Mesh:getVertex(index) end

---
---Gets the properties of a specific attribute within a vertex in the Mesh.
---
---Meshes without a custom vertex format specified in love.graphics.newMesh have position as their first attribute, texture coordinates as their second attribute, and color as their third attribute.
---
---@param vertexindex number # The index of the the vertex you want to retrieve the attribute for (one-based).
---@param attributeindex number # The index of the attribute within the vertex to be retrieved (one-based).
---@return number value1 # The value of the first component of the attribute.
---@return number value2 # The value of the second component of the attribute.
function Mesh:getVertexAttribute(vertexindex, attributeindex) end

---
---Gets the total number of vertices in the Mesh.
---
---@return number count # The total number of vertices in the mesh.
function Mesh:getVertexCount() end

---
---Gets the vertex format that the Mesh was created with.
---
---@return {attribute: table} format # The vertex format of the Mesh, which is a table containing tables for each vertex attribute the Mesh was created with, in the form of {attribute, ...}.
function Mesh:getVertexFormat() end

---
---Gets the vertex map for the Mesh. The vertex map describes the order in which the vertices are used when the Mesh is drawn. The vertices, vertex map, and mesh draw mode work together to determine what exactly is displayed on the screen.
---
---If no vertex map has been set previously via Mesh:setVertexMap, then this function will return nil in LÖVE 0.10.0+, or an empty table in 0.9.2 and older.
---
---@return table map # A table containing the list of vertex indices used when drawing.
function Mesh:getVertexMap() end

---
---Gets whether a specific vertex attribute in the Mesh is enabled. Vertex data from disabled attributes is not used when drawing the Mesh.
---
---@param name string # The name of the vertex attribute to be checked.
---@return boolean enabled # Whether the vertex attribute is used when drawing this Mesh.
function Mesh:isAttributeEnabled(name) end

---
---Enables or disables a specific vertex attribute in the Mesh. Vertex data from disabled attributes is not used when drawing the Mesh.
---
---@param name string # The name of the vertex attribute to enable or disable.
---@param enable boolean # Whether the vertex attribute is used when drawing this Mesh.
function Mesh:setAttributeEnabled(name, enable) end

---
---Sets the mode used when drawing the Mesh.
---
---@param mode love.MeshDrawMode # The mode to use when drawing the Mesh.
function Mesh:setDrawMode(mode) end

---
---Restricts the drawn vertices of the Mesh to a subset of the total.
---
---@overload fun()
---@param start number # The index of the first vertex to use when drawing, or the index of the first value in the vertex map to use if one is set for this Mesh.
---@param count number # The number of vertices to use when drawing, or number of values in the vertex map to use if one is set for this Mesh.
function Mesh:setDrawRange(start, count) end

---
---Sets the texture (Image or Canvas) used when drawing the Mesh.
---
---@overload fun()
---@param texture love.Texture # The Image or Canvas to texture the Mesh with when drawing.
function Mesh:setTexture(texture) end

---
---Sets the properties of a vertex in the Mesh.
---
---In versions prior to 11.0, color and byte component values were within the range of 0 to 255 instead of 0 to 1.
---
---@overload fun(index: number, vertex: table)
---@overload fun(index: number, x: number, y: number, u: number, v: number, r: number, g: number, b: number, a: number)
---@overload fun(index: number, vertex: table)
---@param index number # The index of the the vertex you want to modify (one-based).
---@param attributecomponent number # The first component of the first vertex attribute in the specified vertex.
function Mesh:setVertex(index, attributecomponent) end

---
---Sets the properties of a specific attribute within a vertex in the Mesh.
---
---Meshes without a custom vertex format specified in love.graphics.newMesh have position as their first attribute, texture coordinates as their second attribute, and color as their third attribute.
---
---@param vertexindex number # The index of the the vertex to be modified (one-based).
---@param attributeindex number # The index of the attribute within the vertex to be modified (one-based).
---@param value1 number # The new value for the first component of the attribute.
---@param value2 number # The new value for the second component of the attribute.
function Mesh:setVertexAttribute(vertexindex, attributeindex, value1, value2) end

---
---Sets the vertex map for the Mesh. The vertex map describes the order in which the vertices are used when the Mesh is drawn. The vertices, vertex map, and mesh draw mode work together to determine what exactly is displayed on the screen.
---
---The vertex map allows you to re-order or reuse vertices when drawing without changing the actual vertex parameters or duplicating vertices. It is especially useful when combined with different Mesh Draw Modes.
---
---@overload fun(vi1: number, vi2: number, vi3: number)
---@overload fun(data: love.Data, datatype: love.IndexDataType)
---@param map table # A table containing a list of vertex indices to use when drawing. Values must be in the range of Mesh:getVertexCount().
function Mesh:setVertexMap(map) end

---
---Replaces a range of vertices in the Mesh with new ones. The total number of vertices in a Mesh cannot be changed after it has been created. This is often more efficient than calling Mesh:setVertex in a loop.
---
---@overload fun(data: love.Data, startvertex: number)
---@overload fun(vertices: table)
---@param vertices {attributecomponent: number} # The table filled with vertex information tables for each vertex, in the form of {vertex, ...} where each vertex is a table in the form of {attributecomponent, ...}.
---@param startvertex? number # The index of the first vertex to replace.
function Mesh:setVertices(vertices, startvertex) end

---
---A ParticleSystem can be used to create particle effects like fire or smoke.
---
---The particle system has to be created using update it in the update callback to see any changes in the particles emitted.
---
---The particle system won't create any particles unless you call setParticleLifetime and setEmissionRate.
---
---@class love.ParticleSystem: love.Drawable, love.Object
local ParticleSystem = {}

---
---Creates an identical copy of the ParticleSystem in the stopped state.
---
---@return love.ParticleSystem particlesystem # The new identical copy of this ParticleSystem.
function ParticleSystem:clone() end

---
---Emits a burst of particles from the particle emitter.
---
---@param numparticles number # The amount of particles to emit. The number of emitted particles will be truncated if the particle system's max buffer size is reached.
function ParticleSystem:emit(numparticles) end

---
---Gets the maximum number of particles the ParticleSystem can have at once.
---
---@return number size # The maximum number of particles.
function ParticleSystem:getBufferSize() end

---
---Gets the series of colors applied to the particle sprite.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@return number r1 # First color, red component (0-1).
---@return number g1 # First color, green component (0-1).
---@return number b1 # First color, blue component (0-1).
---@return number a1 # First color, alpha component (0-1).
---@return number r2 # Second color, red component (0-1).
---@return number g2 # Second color, green component (0-1).
---@return number b2 # Second color, blue component (0-1).
---@return number a2 # Second color, alpha component (0-1).
---@return number r8 # Eighth color, red component (0-1).
---@return number g8 # Eighth color, green component (0-1).
---@return number b8 # Eighth color, blue component (0-1).
---@return number a8 # Eighth color, alpha component (0-1).
function ParticleSystem:getColors() end

---
---Gets the number of particles that are currently in the system.
---
---@return number count # The current number of live particles.
function ParticleSystem:getCount() end

---
---Gets the direction of the particle emitter (in radians).
---
---@return number direction # The direction of the emitter (radians).
function ParticleSystem:getDirection() end

---
---Gets the area-based spawn parameters for the particles.
---
---@return love.AreaSpreadDistribution distribution # The type of distribution for new particles.
---@return number dx # The maximum spawn distance from the emitter along the x-axis for uniform distribution, or the standard deviation along the x-axis for normal distribution.
---@return number dy # The maximum spawn distance from the emitter along the y-axis for uniform distribution, or the standard deviation along the y-axis for normal distribution.
---@return number angle # The angle in radians of the emission area.
---@return boolean directionRelativeToCenter # True if newly spawned particles will be oriented relative to the center of the emission area, false otherwise.
function ParticleSystem:getEmissionArea() end

---
---Gets the amount of particles emitted per second.
---
---@return number rate # The amount of particles per second.
function ParticleSystem:getEmissionRate() end

---
---Gets how long the particle system will emit particles (if -1 then it emits particles forever).
---
---@return number life # The lifetime of the emitter (in seconds).
function ParticleSystem:getEmitterLifetime() end

---
---Gets the mode used when the ParticleSystem adds new particles.
---
---@return love.ParticleInsertMode mode # The mode used when the ParticleSystem adds new particles.
function ParticleSystem:getInsertMode() end

---
---Gets the linear acceleration (acceleration along the x and y axes) for particles.
---
---Every particle created will accelerate along the x and y axes between xmin,ymin and xmax,ymax.
---
---@return number xmin # The minimum acceleration along the x axis.
---@return number ymin # The minimum acceleration along the y axis.
---@return number xmax # The maximum acceleration along the x axis.
---@return number ymax # The maximum acceleration along the y axis.
function ParticleSystem:getLinearAcceleration() end

---
---Gets the amount of linear damping (constant deceleration) for particles.
---
---@return number min # The minimum amount of linear damping applied to particles.
---@return number max # The maximum amount of linear damping applied to particles.
function ParticleSystem:getLinearDamping() end

---
---Gets the particle image's draw offset.
---
---@return number ox # The x coordinate of the particle image's draw offset.
---@return number oy # The y coordinate of the particle image's draw offset.
function ParticleSystem:getOffset() end

---
---Gets the lifetime of the particles.
---
---@return number min # The minimum life of the particles (in seconds).
---@return number max # The maximum life of the particles (in seconds).
function ParticleSystem:getParticleLifetime() end

---
---Gets the position of the emitter.
---
---@return number x # Position along x-axis.
---@return number y # Position along y-axis.
function ParticleSystem:getPosition() end

---
---Gets the series of Quads used for the particle sprites.
---
---@return table quads # A table containing the Quads used.
function ParticleSystem:getQuads() end

---
---Gets the radial acceleration (away from the emitter).
---
---@return number min # The minimum acceleration.
---@return number max # The maximum acceleration.
function ParticleSystem:getRadialAcceleration() end

---
---Gets the rotation of the image upon particle creation (in radians).
---
---@return number min # The minimum initial angle (radians).
---@return number max # The maximum initial angle (radians).
function ParticleSystem:getRotation() end

---
---Gets the amount of size variation (0 meaning no variation and 1 meaning full variation between start and end).
---
---@return number variation # The amount of variation (0 meaning no variation and 1 meaning full variation between start and end).
function ParticleSystem:getSizeVariation() end

---
---Gets the series of sizes by which the sprite is scaled. 1.0 is normal size. The particle system will interpolate between each size evenly over the particle's lifetime.
---
---@return number size1 # The first size.
---@return number size2 # The second size.
---@return number size8 # The eighth size.
function ParticleSystem:getSizes() end

---
---Gets the speed of the particles.
---
---@return number min # The minimum linear speed of the particles.
---@return number max # The maximum linear speed of the particles.
function ParticleSystem:getSpeed() end

---
---Gets the spin of the sprite.
---
---@return number min # The minimum spin (radians per second).
---@return number max # The maximum spin (radians per second).
---@return number variation # The degree of variation (0 meaning no variation and 1 meaning full variation between start and end).
function ParticleSystem:getSpin() end

---
---Gets the amount of spin variation (0 meaning no variation and 1 meaning full variation between start and end).
---
---@return number variation # The amount of variation (0 meaning no variation and 1 meaning full variation between start and end).
function ParticleSystem:getSpinVariation() end

---
---Gets the amount of directional spread of the particle emitter (in radians).
---
---@return number spread # The spread of the emitter (radians).
function ParticleSystem:getSpread() end

---
---Gets the tangential acceleration (acceleration perpendicular to the particle's direction).
---
---@return number min # The minimum acceleration.
---@return number max # The maximum acceleration.
function ParticleSystem:getTangentialAcceleration() end

---
---Gets the texture (Image or Canvas) used for the particles.
---
---@return love.Texture texture # The Image or Canvas used for the particles.
function ParticleSystem:getTexture() end

---
---Gets whether particle angles and rotations are relative to their velocities. If enabled, particles are aligned to the angle of their velocities and rotate relative to that angle.
---
---@return boolean enable # True if relative particle rotation is enabled, false if it's disabled.
function ParticleSystem:hasRelativeRotation() end

---
---Checks whether the particle system is actively emitting particles.
---
---@return boolean active # True if system is active, false otherwise.
function ParticleSystem:isActive() end

---
---Checks whether the particle system is paused.
---
---@return boolean paused # True if system is paused, false otherwise.
function ParticleSystem:isPaused() end

---
---Checks whether the particle system is stopped.
---
---@return boolean stopped # True if system is stopped, false otherwise.
function ParticleSystem:isStopped() end

---
---Moves the position of the emitter. This results in smoother particle spawning behaviour than if ParticleSystem:setPosition is used every frame.
---
---@param x number # Position along x-axis.
---@param y number # Position along y-axis.
function ParticleSystem:moveTo(x, y) end

---
---Pauses the particle emitter.
---
function ParticleSystem:pause() end

---
---Resets the particle emitter, removing any existing particles and resetting the lifetime counter.
---
function ParticleSystem:reset() end

---
---Sets the size of the buffer (the max allowed amount of particles in the system).
---
---@param size number # The buffer size.
function ParticleSystem:setBufferSize(size) end

---
---Sets a series of colors to apply to the particle sprite. The particle system will interpolate between each color evenly over the particle's lifetime.
---
---Arguments can be passed in groups of four, representing the components of the desired RGBA value, or as tables of RGBA component values, with a default alpha value of 1 if only three values are given. At least one color must be specified. A maximum of eight may be used.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@param r1 number # First color, red component (0-1).
---@param g1 number # First color, green component (0-1).
---@param b1 number # First color, blue component (0-1).
---@param a1 number # First color, alpha component (0-1).
---@param r2 number # Second color, red component (0-1).
---@param g2 number # Second color, green component (0-1).
---@param b2 number # Second color, blue component (0-1).
---@param a2 number # Second color, alpha component (0-1).
---@param r8 number # Eighth color, red component (0-1).
---@param g8 number # Eighth color, green component (0-1).
---@param b8 number # Eighth color, blue component (0-1).
---@param a8 number # Eighth color, alpha component (0-1).
function ParticleSystem:setColors(r1, g1, b1, a1, r2, g2, b2, a2, r8, g8, b8, a8) end

---
---Sets the direction the particles will be emitted in.
---
---@param direction number # The direction of the particles (in radians).
function ParticleSystem:setDirection(direction) end

---
---Sets area-based spawn parameters for the particles. Newly created particles will spawn in an area around the emitter based on the parameters to this function.
---
---@param distribution love.AreaSpreadDistribution # The type of distribution for new particles.
---@param dx number # The maximum spawn distance from the emitter along the x-axis for uniform distribution, or the standard deviation along the x-axis for normal distribution.
---@param dy number # The maximum spawn distance from the emitter along the y-axis for uniform distribution, or the standard deviation along the y-axis for normal distribution.
---@param angle? number # The angle in radians of the emission area.
---@param directionRelativeToCenter? boolean # True if newly spawned particles will be oriented relative to the center of the emission area, false otherwise.
function ParticleSystem:setEmissionArea(distribution, dx, dy, angle, directionRelativeToCenter) end

---
---Sets the amount of particles emitted per second.
---
---@param rate number # The amount of particles per second.
function ParticleSystem:setEmissionRate(rate) end

---
---Sets how long the particle system should emit particles (if -1 then it emits particles forever).
---
---@param life number # The lifetime of the emitter (in seconds).
function ParticleSystem:setEmitterLifetime(life) end

---
---Sets the mode to use when the ParticleSystem adds new particles.
---
---@param mode love.ParticleInsertMode # The mode to use when the ParticleSystem adds new particles.
function ParticleSystem:setInsertMode(mode) end

---
---Sets the linear acceleration (acceleration along the x and y axes) for particles.
---
---Every particle created will accelerate along the x and y axes between xmin,ymin and xmax,ymax.
---
---@param xmin number # The minimum acceleration along the x axis.
---@param ymin number # The minimum acceleration along the y axis.
---@param xmax? number # The maximum acceleration along the x axis.
---@param ymax? number # The maximum acceleration along the y axis.
function ParticleSystem:setLinearAcceleration(xmin, ymin, xmax, ymax) end

---
---Sets the amount of linear damping (constant deceleration) for particles.
---
---@param min number # The minimum amount of linear damping applied to particles.
---@param max? number # The maximum amount of linear damping applied to particles.
function ParticleSystem:setLinearDamping(min, max) end

---
---Set the offset position which the particle sprite is rotated around.
---
---If this function is not used, the particles rotate around their center.
---
---@param x number # The x coordinate of the rotation offset.
---@param y number # The y coordinate of the rotation offset.
function ParticleSystem:setOffset(x, y) end

---
---Sets the lifetime of the particles.
---
---@param min number # The minimum life of the particles (in seconds).
---@param max? number # The maximum life of the particles (in seconds).
function ParticleSystem:setParticleLifetime(min, max) end

---
---Sets the position of the emitter.
---
---@param x number # Position along x-axis.
---@param y number # Position along y-axis.
function ParticleSystem:setPosition(x, y) end

---
---Sets a series of Quads to use for the particle sprites. Particles will choose a Quad from the list based on the particle's current lifetime, allowing for the use of animated sprite sheets with ParticleSystems.
---
---@overload fun(quads: table)
---@param quad1 love.Quad # The first Quad to use.
---@param quad2 love.Quad # The second Quad to use.
function ParticleSystem:setQuads(quad1, quad2) end

---
---Set the radial acceleration (away from the emitter).
---
---@param min number # The minimum acceleration.
---@param max? number # The maximum acceleration.
function ParticleSystem:setRadialAcceleration(min, max) end

---
---Sets whether particle angles and rotations are relative to their velocities. If enabled, particles are aligned to the angle of their velocities and rotate relative to that angle.
---
---@param enable boolean # True to enable relative particle rotation, false to disable it.
function ParticleSystem:setRelativeRotation(enable) end

---
---Sets the rotation of the image upon particle creation (in radians).
---
---@param min number # The minimum initial angle (radians).
---@param max? number # The maximum initial angle (radians).
function ParticleSystem:setRotation(min, max) end

---
---Sets the amount of size variation (0 meaning no variation and 1 meaning full variation between start and end).
---
---@param variation number # The amount of variation (0 meaning no variation and 1 meaning full variation between start and end).
function ParticleSystem:setSizeVariation(variation) end

---
---Sets a series of sizes by which to scale a particle sprite. 1.0 is normal size. The particle system will interpolate between each size evenly over the particle's lifetime.
---
---At least one size must be specified. A maximum of eight may be used.
---
---@param size1 number # The first size.
---@param size2 number # The second size.
---@param size8 number # The eighth size.
function ParticleSystem:setSizes(size1, size2, size8) end

---
---Sets the speed of the particles.
---
---@param min number # The minimum linear speed of the particles.
---@param max? number # The maximum linear speed of the particles.
function ParticleSystem:setSpeed(min, max) end

---
---Sets the spin of the sprite.
---
---@param min number # The minimum spin (radians per second).
---@param max? number # The maximum spin (radians per second).
function ParticleSystem:setSpin(min, max) end

---
---Sets the amount of spin variation (0 meaning no variation and 1 meaning full variation between start and end).
---
---@param variation number # The amount of variation (0 meaning no variation and 1 meaning full variation between start and end).
function ParticleSystem:setSpinVariation(variation) end

---
---Sets the amount of spread for the system.
---
---@param spread number # The amount of spread (radians).
function ParticleSystem:setSpread(spread) end

---
---Sets the tangential acceleration (acceleration perpendicular to the particle's direction).
---
---@param min number # The minimum acceleration.
---@param max? number # The maximum acceleration.
function ParticleSystem:setTangentialAcceleration(min, max) end

---
---Sets the texture (Image or Canvas) to be used for the particles.
---
---@param texture love.Texture # An Image or Canvas to use for the particles.
function ParticleSystem:setTexture(texture) end

---
---Starts the particle emitter.
---
function ParticleSystem:start() end

---
---Stops the particle emitter, resetting the lifetime counter.
---
function ParticleSystem:stop() end

---
---Updates the particle system; moving, creating and killing particles.
---
---@param dt number # The time (seconds) since last frame.
function ParticleSystem:update(dt) end

---
---A quadrilateral (a polygon with four sides and four corners) with texture coordinate information.
---
---Quads can be used to select part of a texture to draw. In this way, one large texture atlas can be loaded, and then split up into sub-images.
---
---@class love.Quad: love.Object
local Quad = {}

---
---Gets reference texture dimensions initially specified in love.graphics.newQuad.
---
---@return number sw # The Texture width used by the Quad.
---@return number sh # The Texture height used by the Quad.
function Quad:getTextureDimensions() end

---
---Gets the current viewport of this Quad.
---
---@return number x # The top-left corner along the x-axis.
---@return number y # The top-left corner along the y-axis.
---@return number w # The width of the viewport.
---@return number h # The height of the viewport.
function Quad:getViewport() end

---
---Sets the texture coordinates according to a viewport.
---
---@param x number # The top-left corner along the x-axis.
---@param y number # The top-left corner along the y-axis.
---@param w number # The width of the viewport.
---@param h number # The height of the viewport.
---@param sw number # The reference width, the width of the Image. (Must be greater than 0.)
---@param sh number # The reference height, the height of the Image. (Must be greater than 0.)
function Quad:setViewport(x, y, w, h, sw, sh) end

---
---A Shader is used for advanced hardware-accelerated pixel or vertex manipulation. These effects are written in a language based on GLSL (OpenGL Shading Language) with a few things simplified for easier coding.
---
---Potential uses for shaders include HDR/bloom, motion blur, grayscale/invert/sepia/any kind of color effect, reflection/refraction, distortions, bump mapping, and much more! Here is a collection of basic shaders and good starting point to learn: https://github.com/vrld/moonshine
---
---@class love.Shader: love.Object
local Shader = {}

---
---Returns any warning and error messages from compiling the shader code. This can be used for debugging your shaders if there's anything the graphics hardware doesn't like.
---
---@return string warnings # Warning and error messages (if any).
function Shader:getWarnings() end

---
---Gets whether a uniform / extern variable exists in the Shader.
---
---If a graphics driver's shader compiler determines that a uniform / extern variable doesn't affect the final output of the shader, it may optimize the variable out. This function will return false in that case.
---
---@param name string # The name of the uniform variable.
---@return boolean hasuniform # Whether the uniform exists in the shader and affects its final output.
function Shader:hasUniform(name) end

---
---Sends one or more values to a special (''uniform'') variable inside the shader. Uniform variables have to be marked using the ''uniform'' or ''extern'' keyword, e.g.
---
---uniform float time;  // 'float' is the typical number type used in GLSL shaders.
---
---uniform float varsvec2 light_pos;
---
---uniform vec4 colors[4;
---
---The corresponding send calls would be
---
---shader:send('time', t)
---
---shader:send('vars',a,b)
---
---shader:send('light_pos', {light_x, light_y})
---
---shader:send('colors', {r1, g1, b1, a1},  {r2, g2, b2, a2},  {r3, g3, b3, a3},  {r4, g4, b4, a4})
---
---Uniform / extern variables are read-only in the shader code and remain constant until modified by a Shader:send call. Uniform variables can be accessed in both the Vertex and Pixel components of a shader, as long as the variable is declared in each.
---
---@overload fun(name: string, vector: table, ...)
---@overload fun(name: string, matrix: table, ...)
---@overload fun(name: string, texture: love.Texture)
---@overload fun(name: string, boolean: boolean, ...)
---@overload fun(name: string, matrixlayout: love.MatrixLayout, matrix: table, ...)
---@overload fun(name: string, data: love.Data, offset: number, size: number)
---@overload fun(name: string, data: love.Data, matrixlayout: love.MatrixLayout, offset: number, size: number)
---@param name string # Name of the number to send to the shader.
---@param number number # Number to send to store in the uniform variable.
function Shader:send(name, number) end

---
---Sends one or more colors to a special (''extern'' / ''uniform'') vec3 or vec4 variable inside the shader. The color components must be in the range of 1. The colors are gamma-corrected if global gamma-correction is enabled.
---
---Extern variables must be marked using the ''extern'' keyword, e.g.
---
---extern vec4 Color;
---
---The corresponding sendColor call would be
---
---shader:sendColor('Color', {r, g, b, a})
---
---Extern variables can be accessed in both the Vertex and Pixel stages of a shader, as long as the variable is declared in each.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@param name string # The name of the color extern variable to send to in the shader.
---@param color table # A table with red, green, blue, and optional alpha color components in the range of 1 to send to the extern as a vector.
function Shader:sendColor(name, color) end

---
---Using a single image, draw any number of identical copies of the image using a single call to love.graphics.draw(). This can be used, for example, to draw repeating copies of a single background image with high performance.
---
---A SpriteBatch can be even more useful when the underlying image is a texture atlas (a single image file containing many independent images); by adding Quads to the batch, different sub-images from within the atlas can be drawn.
---
---@class love.SpriteBatch: love.Drawable, love.Object
local SpriteBatch = {}

---
---Adds a sprite to the batch. Sprites are drawn in the order they are added.
---
---@overload fun(quad: love.Quad, x: number, y: number, r: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number):number
---@param x number # The position to draw the object (x-axis).
---@param y number # The position to draw the object (y-axis).
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shear factor (x-axis).
---@param ky? number # Shear factor (y-axis).
---@return number id # An identifier for the added sprite.
function SpriteBatch:add(x, y, r, sx, sy, ox, oy, kx, ky) end

---
---Adds a sprite to a batch created with an Array Texture.
---
---@overload fun(layerindex: number, quad: love.Quad, x: number, y: number, r: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number):number
---@overload fun(layerindex: number, transform: love.Transform):number
---@overload fun(layerindex: number, quad: love.Quad, transform: love.Transform):number
---@param layerindex number # The index of the layer to use for this sprite.
---@param x? number # The position to draw the sprite (x-axis).
---@param y? number # The position to draw the sprite (y-axis).
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shearing factor (x-axis).
---@param ky? number # Shearing factor (y-axis).
---@return number spriteindex # The index of the added sprite, for use with SpriteBatch:set or SpriteBatch:setLayer.
function SpriteBatch:addLayer(layerindex, x, y, r, sx, sy, ox, oy, kx, ky) end

---
---Attaches a per-vertex attribute from a Mesh onto this SpriteBatch, for use when drawing. This can be combined with a Shader to augment a SpriteBatch with per-vertex or additional per-sprite information instead of just having per-sprite colors.
---
---Each sprite in a SpriteBatch has 4 vertices in the following order: top-left, bottom-left, top-right, bottom-right. The index returned by SpriteBatch:add (and used by SpriteBatch:set) can used to determine the first vertex of a specific sprite with the formula 1 + 4 * ( id - 1 ).
---
---@param name string # The name of the vertex attribute to attach.
---@param mesh love.Mesh # The Mesh to get the vertex attribute from.
function SpriteBatch:attachAttribute(name, mesh) end

---
---Removes all sprites from the buffer.
---
function SpriteBatch:clear() end

---
---Immediately sends all new and modified sprite data in the batch to the graphics card.
---
---Normally it isn't necessary to call this method as love.graphics.draw(spritebatch, ...) will do it automatically if needed, but explicitly using SpriteBatch:flush gives more control over when the work happens.
---
---If this method is used, it generally shouldn't be called more than once (at most) between love.graphics.draw(spritebatch, ...) calls.
---
function SpriteBatch:flush() end

---
---Gets the maximum number of sprites the SpriteBatch can hold.
---
---@return number size # The maximum number of sprites the batch can hold.
function SpriteBatch:getBufferSize() end

---
---Gets the color that will be used for the next add and set operations.
---
---If no color has been set with SpriteBatch:setColor or the current SpriteBatch color has been cleared, this method will return nil.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@return number r # The red component (0-1).
---@return number g # The green component (0-1).
---@return number b # The blue component (0-1).
---@return number a # The alpha component (0-1).
function SpriteBatch:getColor() end

---
---Gets the number of sprites currently in the SpriteBatch.
---
---@return number count # The number of sprites currently in the batch.
function SpriteBatch:getCount() end

---
---Gets the texture (Image or Canvas) used by the SpriteBatch.
---
---@return love.Texture texture # The Image or Canvas used by the SpriteBatch.
function SpriteBatch:getTexture() end

---
---Changes a sprite in the batch. This requires the sprite index returned by SpriteBatch:add or SpriteBatch:addLayer.
---
---@overload fun(spriteindex: number, quad: love.Quad, x: number, y: number, r: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number)
---@param spriteindex number # The index of the sprite that will be changed.
---@param x number # The position to draw the object (x-axis).
---@param y number # The position to draw the object (y-axis).
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shear factor (x-axis).
---@param ky? number # Shear factor (y-axis).
function SpriteBatch:set(spriteindex, x, y, r, sx, sy, ox, oy, kx, ky) end

---
---Sets the color that will be used for the next add and set operations. Calling the function without arguments will disable all per-sprite colors for the SpriteBatch.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---In version 0.9.2 and older, the global color set with love.graphics.setColor will not work on the SpriteBatch if any of the sprites has its own color.
---
---@overload fun()
---@param r number # The amount of red.
---@param g number # The amount of green.
---@param b number # The amount of blue.
---@param a? number # The amount of alpha.
function SpriteBatch:setColor(r, g, b, a) end

---
---Restricts the drawn sprites in the SpriteBatch to a subset of the total.
---
---@overload fun()
---@param start number # The index of the first sprite to draw. Index 1 corresponds to the first sprite added with SpriteBatch:add.
---@param count number # The number of sprites to draw.
function SpriteBatch:setDrawRange(start, count) end

---
---Changes a sprite previously added with add or addLayer, in a batch created with an Array Texture.
---
---@overload fun(spriteindex: number, layerindex: number, quad: love.Quad, x: number, y: number, r: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number)
---@overload fun(spriteindex: number, layerindex: number, transform: love.Transform)
---@overload fun(spriteindex: number, layerindex: number, quad: love.Quad, transform: love.Transform)
---@param spriteindex number # The index of the existing sprite to replace.
---@param layerindex number # The index of the layer in the Array Texture to use for this sprite.
---@param x? number # The position to draw the sprite (x-axis).
---@param y? number # The position to draw the sprite (y-axis).
---@param r? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shearing factor (x-axis).
---@param ky? number # Shearing factor (y-axis).
function SpriteBatch:setLayer(spriteindex, layerindex, x, y, r, sx, sy, ox, oy, kx, ky) end

---
---Sets the texture (Image or Canvas) used for the sprites in the batch, when drawing.
---
---@param texture love.Texture # The new Image or Canvas to use for the sprites in the batch.
function SpriteBatch:setTexture(texture) end

---
---Drawable text.
---
---@class love.Text: love.Drawable, love.Object
local Text = {}

---
---Adds additional colored text to the Text object at the specified position.
---
---@overload fun(coloredtext: table, x: number, y: number, angle: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number):number
---@param textstring string # The text to add to the object.
---@param x? number # The position of the new text on the x-axis.
---@param y? number # The position of the new text on the y-axis.
---@param angle? number # The orientation of the new text in radians.
---@param sx? number # Scale factor on the x-axis.
---@param sy? number # Scale factor on the y-axis.
---@param ox? number # Origin offset on the x-axis.
---@param oy? number # Origin offset on the y-axis.
---@param kx? number # Shearing / skew factor on the x-axis.
---@param ky? number # Shearing / skew factor on the y-axis.
---@return number index # An index number that can be used with Text:getWidth or Text:getHeight.
function Text:add(textstring, x, y, angle, sx, sy, ox, oy, kx, ky) end

---
---Adds additional formatted / colored text to the Text object at the specified position.
---
---The word wrap limit is applied before any scaling, rotation, and other coordinate transformations. Therefore the amount of text per line stays constant given the same wrap limit, even if the scale arguments change.
---
---@overload fun(coloredtext: table, wraplimit: number, align: love.AlignMode, x: number, y: number, angle: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number):number
---@param textstring string # The text to add to the object.
---@param wraplimit number # The maximum width in pixels of the text before it gets automatically wrapped to a new line.
---@param align love.AlignMode # The alignment of the text.
---@param x number # The position of the new text (x-axis).
---@param y number # The position of the new text (y-axis).
---@param angle? number # Orientation (radians).
---@param sx? number # Scale factor (x-axis).
---@param sy? number # Scale factor (y-axis).
---@param ox? number # Origin offset (x-axis).
---@param oy? number # Origin offset (y-axis).
---@param kx? number # Shearing / skew factor (x-axis).
---@param ky? number # Shearing / skew factor (y-axis).
---@return number index # An index number that can be used with Text:getWidth or Text:getHeight.
function Text:addf(textstring, wraplimit, align, x, y, angle, sx, sy, ox, oy, kx, ky) end

---
---Clears the contents of the Text object.
---
function Text:clear() end

---
---Gets the width and height of the text in pixels.
---
---@overload fun(index: number):number, number
---@return number width # The width of the text. If multiple sub-strings have been added with Text:add, the width of the last sub-string is returned.
---@return number height # The height of the text. If multiple sub-strings have been added with Text:add, the height of the last sub-string is returned.
function Text:getDimensions() end

---
---Gets the Font used with the Text object.
---
---@return love.Font font # The font used with this Text object.
function Text:getFont() end

---
---Gets the height of the text in pixels.
---
---@overload fun(index: number):number
---@return number height # The height of the text. If multiple sub-strings have been added with Text:add, the height of the last sub-string is returned.
function Text:getHeight() end

---
---Gets the width of the text in pixels.
---
---@overload fun(index: number):number
---@return number width # The width of the text. If multiple sub-strings have been added with Text:add, the width of the last sub-string is returned.
function Text:getWidth() end

---
---Replaces the contents of the Text object with a new unformatted string.
---
---@overload fun(coloredtext: table)
---@param textstring string # The new string of text to use.
function Text:set(textstring) end

---
---Replaces the Font used with the text.
---
---@param font love.Font # The new font to use with this Text object.
function Text:setFont(font) end

---
---Replaces the contents of the Text object with a new formatted string.
---
---@overload fun(coloredtext: table, wraplimit: number, align: love.AlignMode)
---@param textstring string # The new string of text to use.
---@param wraplimit number # The maximum width in pixels of the text before it gets automatically wrapped to a new line.
---@param align love.AlignMode # The alignment of the text.
function Text:setf(textstring, wraplimit, align) end

---
---Superclass for drawable objects which represent a texture. All Textures can be drawn with Quads. This is an abstract type that can't be created directly.
---
---@class love.Texture: love.Drawable, love.Object
local Texture = {}

---
---Gets the DPI scale factor of the Texture.
---
---The DPI scale factor represents relative pixel density. A DPI scale factor of 2 means the texture has twice the pixel density in each dimension (4 times as many pixels in the same area) compared to a texture with a DPI scale factor of 1.
---
---For example, a texture with pixel dimensions of 100x100 with a DPI scale factor of 2 will be drawn as if it was 50x50. This is useful with high-dpi /  retina displays to easily allow swapping out higher or lower pixel density Images and Canvases without needing any extra manual scaling logic.
---
---@return number dpiscale # The DPI scale factor of the Texture.
function Texture:getDPIScale() end

---
---Gets the depth of a Volume Texture. Returns 1 for 2D, Cubemap, and Array textures.
---
---@return number depth # The depth of the volume Texture.
function Texture:getDepth() end

---
---Gets the comparison mode used when sampling from a depth texture in a shader.
---
---Depth texture comparison modes are advanced low-level functionality typically used with shadow mapping in 3D.
---
---@return love.CompareMode compare # The comparison mode used when sampling from this texture in a shader, or nil if setDepthSampleMode has not been called on this Texture.
function Texture:getDepthSampleMode() end

---
---Gets the width and height of the Texture.
---
---@return number width # The width of the Texture.
---@return number height # The height of the Texture.
function Texture:getDimensions() end

---
---Gets the filter mode of the Texture.
---
---@return love.FilterMode min # Filter mode to use when minifying the texture (rendering it at a smaller size on-screen than its size in pixels).
---@return love.FilterMode mag # Filter mode to use when magnifying the texture (rendering it at a smaller size on-screen than its size in pixels).
---@return number anisotropy # Maximum amount of anisotropic filtering used.
function Texture:getFilter() end

---
---Gets the pixel format of the Texture.
---
---@return love.PixelFormat format # The pixel format the Texture was created with.
function Texture:getFormat() end

---
---Gets the height of the Texture.
---
---@return number height # The height of the Texture.
function Texture:getHeight() end

---
---Gets the number of layers / slices in an Array Texture. Returns 1 for 2D, Cubemap, and Volume textures.
---
---@return number layers # The number of layers in the Array Texture.
function Texture:getLayerCount() end

---
---Gets the number of mipmaps contained in the Texture. If the texture was not created with mipmaps, it will return 1.
---
---@return number mipmaps # The number of mipmaps in the Texture.
function Texture:getMipmapCount() end

---
---Gets the mipmap filter mode for a Texture. Prior to 11.0 this method only worked on Images.
---
---@return love.FilterMode mode # The filter mode used in between mipmap levels. nil if mipmap filtering is not enabled.
---@return number sharpness # Value used to determine whether the image should use more or less detailed mipmap levels than normal when drawing.
function Texture:getMipmapFilter() end

---
---Gets the width and height in pixels of the Texture.
---
---Texture:getDimensions gets the dimensions of the texture in units scaled by the texture's DPI scale factor, rather than pixels. Use getDimensions for calculations related to drawing the texture (calculating an origin offset, for example), and getPixelDimensions only when dealing specifically with pixels, for example when using Canvas:newImageData.
---
---@return number pixelwidth # The width of the Texture, in pixels.
---@return number pixelheight # The height of the Texture, in pixels.
function Texture:getPixelDimensions() end

---
---Gets the height in pixels of the Texture.
---
---DPI scale factor, rather than pixels. Use getHeight for calculations related to drawing the texture (calculating an origin offset, for example), and getPixelHeight only when dealing specifically with pixels, for example when using Canvas:newImageData.
---
---@return number pixelheight # The height of the Texture, in pixels.
function Texture:getPixelHeight() end

---
---Gets the width in pixels of the Texture.
---
---DPI scale factor, rather than pixels. Use getWidth for calculations related to drawing the texture (calculating an origin offset, for example), and getPixelWidth only when dealing specifically with pixels, for example when using Canvas:newImageData.
---
---@return number pixelwidth # The width of the Texture, in pixels.
function Texture:getPixelWidth() end

---
---Gets the type of the Texture.
---
---@return love.TextureType texturetype # The type of the Texture.
function Texture:getTextureType() end

---
---Gets the width of the Texture.
---
---@return number width # The width of the Texture.
function Texture:getWidth() end

---
---Gets the wrapping properties of a Texture.
---
---This function returns the currently set horizontal and vertical wrapping modes for the texture.
---
---@return love.WrapMode horiz # Horizontal wrapping mode of the texture.
---@return love.WrapMode vert # Vertical wrapping mode of the texture.
---@return love.WrapMode depth # Wrapping mode for the z-axis of a Volume texture.
function Texture:getWrap() end

---
---Gets whether the Texture can be drawn and sent to a Shader.
---
---Canvases created with stencil and/or depth PixelFormats are not readable by default, unless readable=true is specified in the settings table passed into love.graphics.newCanvas.
---
---Non-readable Canvases can still be rendered to.
---
---@return boolean readable # Whether the Texture is readable.
function Texture:isReadable() end

---
---Sets the comparison mode used when sampling from a depth texture in a shader. Depth texture comparison modes are advanced low-level functionality typically used with shadow mapping in 3D.
---
---When using a depth texture with a comparison mode set in a shader, it must be declared as a sampler2DShadow and used in a GLSL 3 Shader. The result of accessing the texture in the shader will return a float between 0 and 1, proportional to the number of samples (up to 4 samples will be used if bilinear filtering is enabled) that passed the test set by the comparison operation.
---
---Depth texture comparison can only be used with readable depth-formatted Canvases.
---
---@param compare love.CompareMode # The comparison mode used when sampling from this texture in a shader.
function Texture:setDepthSampleMode(compare) end

---
---Sets the filter mode of the Texture.
---
---@param min love.FilterMode # Filter mode to use when minifying the texture (rendering it at a smaller size on-screen than its size in pixels).
---@param mag love.FilterMode # Filter mode to use when magnifying the texture (rendering it at a larger size on-screen than its size in pixels).
---@param anisotropy? number # Maximum amount of anisotropic filtering to use.
function Texture:setFilter(min, mag, anisotropy) end

---
---Sets the mipmap filter mode for a Texture. Prior to 11.0 this method only worked on Images.
---
---Mipmapping is useful when drawing a texture at a reduced scale. It can improve performance and reduce aliasing issues.
---
---In created with the mipmaps flag enabled for the mipmap filter to have any effect. In versions prior to 0.10.0 it's best to call this method directly after creating the image with love.graphics.newImage, to avoid bugs in certain graphics drivers.
---
---Due to hardware restrictions and driver bugs, in versions prior to 0.10.0 images that weren't loaded from a CompressedData must have power-of-two dimensions (64x64, 512x256, etc.) to use mipmaps.
---
---@overload fun()
---@param filtermode love.FilterMode # The filter mode to use in between mipmap levels. 'nearest' will often give better performance.
---@param sharpness? number # A positive sharpness value makes the texture use a more detailed mipmap level when drawing, at the expense of performance. A negative value does the reverse.
function Texture:setMipmapFilter(filtermode, sharpness) end

---
---Sets the wrapping properties of a Texture.
---
---This function sets the way a Texture is repeated when it is drawn with a Quad that is larger than the texture's extent, or when a custom Shader is used which uses texture coordinates outside of [0, 1]. A texture may be clamped or set to repeat in both horizontal and vertical directions.
---
---Clamped textures appear only once (with the edges of the texture stretching to fill the extent of the Quad), whereas repeated ones repeat as many times as there is room in the Quad.
---
---@param horiz love.WrapMode # Horizontal wrapping mode of the texture.
---@param vert? love.WrapMode # Vertical wrapping mode of the texture.
---@param depth? love.WrapMode # Wrapping mode for the z-axis of a Volume texture.
function Texture:setWrap(horiz, vert, depth) end

---
---A drawable video.
---
---@class love.Video: love.Drawable, love.Object
local Video = {}

---
---Gets the width and height of the Video in pixels.
---
---@return number width # The width of the Video.
---@return number height # The height of the Video.
function Video:getDimensions() end

---
---Gets the scaling filters used when drawing the Video.
---
---@return love.FilterMode min # The filter mode used when scaling the Video down.
---@return love.FilterMode mag # The filter mode used when scaling the Video up.
---@return number anisotropy # Maximum amount of anisotropic filtering used.
function Video:getFilter() end

---
---Gets the height of the Video in pixels.
---
---@return number height # The height of the Video.
function Video:getHeight() end

---
---Gets the audio Source used for playing back the video's audio. May return nil if the video has no audio, or if Video:setSource is called with a nil argument.
---
---@return love.Source source # The audio Source used for audio playback, or nil if the video has no audio.
function Video:getSource() end

---
---Gets the VideoStream object used for decoding and controlling the video.
---
---@return love.VideoStream stream # The VideoStream used for decoding and controlling the video.
function Video:getStream() end

---
---Gets the width of the Video in pixels.
---
---@return number width # The width of the Video.
function Video:getWidth() end

---
---Gets whether the Video is currently playing.
---
---@return boolean playing # Whether the video is playing.
function Video:isPlaying() end

---
---Pauses the Video.
---
function Video:pause() end

---
---Starts playing the Video. In order for the video to appear onscreen it must be drawn with love.graphics.draw.
---
function Video:play() end

---
---Rewinds the Video to the beginning.
---
function Video:rewind() end

---
---Sets the current playback position of the Video.
---
---@param offset number # The time in seconds since the beginning of the Video.
function Video:seek(offset) end

---
---Sets the scaling filters used when drawing the Video.
---
---@param min love.FilterMode # The filter mode used when scaling the Video down.
---@param mag love.FilterMode # The filter mode used when scaling the Video up.
---@param anisotropy? number # Maximum amount of anisotropic filtering used.
function Video:setFilter(min, mag, anisotropy) end

---
---Sets the audio Source used for playing back the video's audio. The audio Source also controls playback speed and synchronization.
---
---@param source? love.Source # The audio Source used for audio playback, or nil to disable audio synchronization.
function Video:setSource(source) end

---
---Gets the current playback position of the Video.
---
---@return number seconds # The time in seconds since the beginning of the Video.
function Video:tell() end

---
---Text alignment.
---
---@class love.AlignMode
---
---Align text center.
---
---@field center integer
---
---Align text left.
---
---@field left integer
---
---Align text right.
---
---@field right integer
---
---Align text both left and right.
---
---@field justify integer

---
---Different types of arcs that can be drawn.
---
---@class love.ArcType
---
---The arc is drawn like a slice of pie, with the arc circle connected to the center at its end-points.
---
---@field pie integer
---
---The arc circle's two end-points are unconnected when the arc is drawn as a line. Behaves like the "closed" arc type when the arc is drawn in filled mode.
---
---@field open integer
---
---The arc circle's two end-points are connected to each other.
---
---@field closed integer

---
---Types of particle area spread distribution.
---
---@class love.AreaSpreadDistribution
---
---Uniform distribution.
---
---@field uniform integer
---
---Normal (gaussian) distribution.
---
---@field normal integer
---
---Uniform distribution in an ellipse.
---
---@field ellipse integer
---
---Distribution in an ellipse with particles spawning at the edges of the ellipse.
---
---@field borderellipse integer
---
---Distribution in a rectangle with particles spawning at the edges of the rectangle.
---
---@field borderrectangle integer
---
---No distribution - area spread is disabled.
---
---@field none integer

---
---Different ways alpha affects color blending. See BlendMode and the BlendMode Formulas for additional notes.
---
---@class love.BlendAlphaMode
---
---The RGB values of what's drawn are multiplied by the alpha values of those colors during blending. This is the default alpha mode.
---
---@field alphamultiply integer
---
---The RGB values of what's drawn are '''not''' multiplied by the alpha values of those colors during blending. For most blend modes to work correctly with this alpha mode, the colors of a drawn object need to have had their RGB values multiplied by their alpha values at some point previously ("premultiplied alpha").
---
---@field premultiplied integer

---
---Different ways to do color blending. See BlendAlphaMode and the BlendMode Formulas for additional notes.
---
---@class love.BlendMode
---
---Alpha blending (normal). The alpha of what's drawn determines its opacity.
---
---@field alpha integer
---
---The colors of what's drawn completely replace what was on the screen, with no additional blending. The BlendAlphaMode specified in love.graphics.setBlendMode still affects what happens.
---
---@field replace integer
---
---'Screen' blending.
---
---@field screen integer
---
---The pixel colors of what's drawn are added to the pixel colors already on the screen. The alpha of the screen is not modified.
---
---@field add integer
---
---The pixel colors of what's drawn are subtracted from the pixel colors already on the screen. The alpha of the screen is not modified.
---
---@field subtract integer
---
---The pixel colors of what's drawn are multiplied with the pixel colors already on the screen (darkening them). The alpha of drawn objects is multiplied with the alpha of the screen rather than determining how much the colors on the screen are affected, even when the "alphamultiply" BlendAlphaMode is used.
---
---@field multiply integer
---
---The pixel colors of what's drawn are compared to the existing pixel colors, and the larger of the two values for each color component is used. Only works when the "premultiplied" BlendAlphaMode is used in love.graphics.setBlendMode.
---
---@field lighten integer
---
---The pixel colors of what's drawn are compared to the existing pixel colors, and the smaller of the two values for each color component is used. Only works when the "premultiplied" BlendAlphaMode is used in love.graphics.setBlendMode.
---
---@field darken integer
---
---Additive blend mode.
---
---@field additive integer
---
---Subtractive blend mode.
---
---@field subtractive integer
---
---Multiply blend mode.
---
---@field multiplicative integer
---
---Premultiplied alpha blend mode.
---
---@field premultiplied integer

---
---Different types of per-pixel stencil test and depth test comparisons. The pixels of an object will be drawn if the comparison succeeds, for each pixel that the object touches.
---
---@class love.CompareMode
---
---* stencil tests: the stencil value of the pixel must be equal to the supplied value.
---* depth tests: the depth value of the drawn object at that pixel must be equal to the existing depth value of that pixel.
---
---@field equal integer
---
---* stencil tests: the stencil value of the pixel must not be equal to the supplied value.
---* depth tests: the depth value of the drawn object at that pixel must not be equal to the existing depth value of that pixel.
---
---@field notequal integer
---
---* stencil tests: the stencil value of the pixel must be less than the supplied value.
---* depth tests: the depth value of the drawn object at that pixel must be less than the existing depth value of that pixel.
---
---@field less integer
---
---* stencil tests: the stencil value of the pixel must be less than or equal to the supplied value.
---* depth tests: the depth value of the drawn object at that pixel must be less than or equal to the existing depth value of that pixel.
---
---@field lequal integer
---
---* stencil tests: the stencil value of the pixel must be greater than or equal to the supplied value.
---* depth tests: the depth value of the drawn object at that pixel must be greater than or equal to the existing depth value of that pixel.
---
---@field gequal integer
---
---* stencil tests: the stencil value of the pixel must be greater than the supplied value.
---* depth tests: the depth value of the drawn object at that pixel must be greater than the existing depth value of that pixel.
---
---@field greater integer
---
---Objects will never be drawn.
---
---@field never integer
---
---Objects will always be drawn. Effectively disables the depth or stencil test.
---
---@field always integer

---
---How Mesh geometry is culled when rendering.
---
---@class love.CullMode
---
---Back-facing triangles in Meshes are culled (not rendered). The vertex order of a triangle determines whether it is back- or front-facing.
---
---@field back integer
---
---Front-facing triangles in Meshes are culled.
---
---@field front integer
---
---Both back- and front-facing triangles in Meshes are rendered.
---
---@field none integer

---
---Controls whether shapes are drawn as an outline, or filled.
---
---@class love.DrawMode
---
---Draw filled shape.
---
---@field fill integer
---
---Draw outlined shape.
---
---@field line integer

---
---How the image is filtered when scaling.
---
---@class love.FilterMode
---
---Scale image with linear interpolation.
---
---@field linear integer
---
---Scale image with nearest neighbor interpolation.
---
---@field nearest integer

---
---Graphics features that can be checked for with love.graphics.getSupported.
---
---@class love.GraphicsFeature
---
---Whether the "clampzero" WrapMode is supported.
---
---@field clampzero integer
---
---Whether the "lighten" and "darken" BlendModes are supported.
---
---@field lighten integer
---
---Whether multiple formats can be used in the same love.graphics.setCanvas call.
---
---@field multicanvasformats integer
---
---Whether GLSL 3 Shaders can be used.
---
---@field glsl3 integer
---
---Whether mesh instancing is supported.
---
---@field instancing integer
---
---Whether textures with non-power-of-two dimensions can use mipmapping and the 'repeat' WrapMode.
---
---@field fullnpot integer
---
---Whether pixel shaders can use "highp" 32 bit floating point numbers (as opposed to just 16 bit or lower precision).
---
---@field pixelshaderhighp integer
---
---Whether shaders can use the dFdx, dFdy, and fwidth functions for computing derivatives.
---
---@field shaderderivatives integer

---
---Types of system-dependent graphics limits checked for using love.graphics.getSystemLimits.
---
---@class love.GraphicsLimit
---
---The maximum size of points.
---
---@field pointsize integer
---
---The maximum width or height of Images and Canvases.
---
---@field texturesize integer
---
---The maximum number of simultaneously active canvases (via love.graphics.setCanvas.)
---
---@field multicanvas integer
---
---The maximum number of antialiasing samples for a Canvas.
---
---@field canvasmsaa integer
---
---The maximum number of layers in an Array texture.
---
---@field texturelayers integer
---
---The maximum width, height, or depth of a Volume texture.
---
---@field volumetexturesize integer
---
---The maximum width or height of a Cubemap texture.
---
---@field cubetexturesize integer
---
---The maximum amount of anisotropic filtering. Texture:setMipmapFilter internally clamps the given anisotropy value to the system's limit.
---
---@field anisotropy integer

---
---Vertex map datatype for Data variant of Mesh:setVertexMap.
---
---@class love.IndexDataType
---
---The vertex map is array of unsigned word (16-bit).
---
---@field uint16 integer
---
---The vertex map is array of unsigned dword (32-bit).
---
---@field uint32 integer

---
---Line join style.
---
---@class love.LineJoin
---
---The ends of the line segments beveled in an angle so that they join seamlessly.
---
---@field miter integer
---
---No cap applied to the ends of the line segments.
---
---@field none integer
---
---Flattens the point where line segments join together.
---
---@field bevel integer

---
---The styles in which lines are drawn.
---
---@class love.LineStyle
---
---Draw rough lines.
---
---@field rough integer
---
---Draw smooth lines.
---
---@field smooth integer

---
---How a Mesh's vertices are used when drawing.
---
---@class love.MeshDrawMode
---
---The vertices create a "fan" shape with the first vertex acting as the hub point. Can be easily used to draw simple convex polygons.
---
---@field fan integer
---
---The vertices create a series of connected triangles using vertices 1, 2, 3, then 3, 2, 4 (note the order), then 3, 4, 5, and so on.
---
---@field strip integer
---
---The vertices create unconnected triangles.
---
---@field triangles integer
---
---The vertices are drawn as unconnected points (see love.graphics.setPointSize.)
---
---@field points integer

---
---Controls whether a Canvas has mipmaps, and its behaviour when it does.
---
---@class love.MipmapMode
---
---The Canvas has no mipmaps.
---
---@field none integer
---
---The Canvas has mipmaps. love.graphics.setCanvas can be used to render to a specific mipmap level, or Canvas:generateMipmaps can (re-)compute all mipmap levels based on the base level.
---
---@field auto integer
---
---The Canvas has mipmaps, and all mipmap levels will automatically be recomputed when switching away from the Canvas with love.graphics.setCanvas.
---
---@field manual integer

---
---How newly created particles are added to the ParticleSystem.
---
---@class love.ParticleInsertMode
---
---Particles are inserted at the top of the ParticleSystem's list of particles.
---
---@field top integer
---
---Particles are inserted at the bottom of the ParticleSystem's list of particles.
---
---@field bottom integer
---
---Particles are inserted at random positions in the ParticleSystem's list of particles.
---
---@field random integer

---
---Usage hints for SpriteBatches and Meshes to optimize data storage and access.
---
---@class love.SpriteBatchUsage
---
---The object's data will change occasionally during its lifetime. 
---
---@field dynamic integer
---
---The object will not be modified after initial sprites or vertices are added.
---
---@field static integer
---
---The object data will always change between draws.
---
---@field stream integer

---
---Graphics state stack types used with love.graphics.push.
---
---@class love.StackType
---
---The transformation stack (love.graphics.translate, love.graphics.rotate, etc.)
---
---@field transform integer
---
---All love.graphics state, including transform state.
---
---@field all integer

---
---How a stencil function modifies the stencil values of pixels it touches.
---
---@class love.StencilAction
---
---The stencil value of a pixel will be replaced by the value specified in love.graphics.stencil, if any object touches the pixel.
---
---@field replace integer
---
---The stencil value of a pixel will be incremented by 1 for each object that touches the pixel. If the stencil value reaches 255 it will stay at 255.
---
---@field increment integer
---
---The stencil value of a pixel will be decremented by 1 for each object that touches the pixel. If the stencil value reaches 0 it will stay at 0.
---
---@field decrement integer
---
---The stencil value of a pixel will be incremented by 1 for each object that touches the pixel. If a stencil value of 255 is incremented it will be set to 0.
---
---@field incrementwrap integer
---
---The stencil value of a pixel will be decremented by 1 for each object that touches the pixel. If the stencil value of 0 is decremented it will be set to 255.
---
---@field decrementwrap integer
---
---The stencil value of a pixel will be bitwise-inverted for each object that touches the pixel. If a stencil value of 0 is inverted it will become 255.
---
---@field invert integer

---
---Types of textures (2D, cubemap, etc.)
---
---@class love.TextureType
---
---Regular 2D texture with width and height.
---
---@field ["2d"] integer
---
---Several same-size 2D textures organized into a single object. Similar to a texture atlas / sprite sheet, but avoids sprite bleeding and other issues.
---
---@field array integer
---
---Cubemap texture with 6 faces. Requires a custom shader (and Shader:send) to use. Sampling from a cube texture in a shader takes a 3D direction vector instead of a texture coordinate.
---
---@field cube integer
---
---3D texture with width, height, and depth. Requires a custom shader to use. Volume textures can have texture filtering applied along the 3rd axis.
---
---@field volume integer

---
---The frequency at which a vertex shader fetches the vertex attribute's data from the Mesh when it's drawn.
---
---Per-instance attributes can be used to render a Mesh many times with different positions, colors, or other attributes via a single love.graphics.drawInstanced call, without using the love_InstanceID vertex shader variable.
---
---@class love.VertexAttributeStep
---
---The vertex attribute will have a unique value for each vertex in the Mesh.
---
---@field pervertex integer
---
---The vertex attribute will have a unique value for each instance of the Mesh.
---
---@field perinstance integer

---
---How Mesh geometry vertices are ordered.
---
---@class love.VertexWinding
---
---Clockwise.
---
---@field cw integer
---
---Counter-clockwise.
---
---@field ccw integer

---
---How the image wraps inside a Quad with a larger quad size than image size. This also affects how Meshes with texture coordinates which are outside the range of 1 are drawn, and the color returned by the Texel Shader function when using it to sample from texture coordinates outside of the range of 1.
---
---@class love.WrapMode
---
---Clamp the texture. Appears only once. The area outside the texture's normal range is colored based on the edge pixels of the texture.
---
---@field clamp integer
---
---Repeat the texture. Fills the whole available extent.
---
---@field repeat integer
---
---Repeat the texture, flipping it each time it repeats. May produce better visual results than the repeat mode when the texture doesn't seamlessly tile.
---
---@field mirroredrepeat integer
---
---Clamp the texture. Fills the area outside the texture's normal range with transparent black (or opaque black for textures with no alpha channel.)
---
---@field clampzero integer
