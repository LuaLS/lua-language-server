---Rendering API documentation
---Rendering functions, messages and constants. The "render" namespace is
---accessible only from render scripts.
---The rendering API was originally built on top of OpenGL ES 2.0, and it uses a subset of the
---OpenGL computer graphics rendering API for rendering 2D and 3D computer
---graphics. Our current target is OpenGLES 3.0 with fallbacks to 2.0 on some platforms.
--- It is possible to create materials and write shaders that
---require features not in OpenGL ES 2.0, but those will not work cross platform.
---@class render
render = {}
render.BLEND_CONSTANT_ALPHA = nil
render.BLEND_CONSTANT_COLOR = nil
render.BLEND_DST_ALPHA = nil
render.BLEND_DST_COLOR = nil
render.BLEND_ONE = nil
render.BLEND_ONE_MINUS_CONSTANT_ALPHA = nil
render.BLEND_ONE_MINUS_CONSTANT_COLOR = nil
render.BLEND_ONE_MINUS_DST_ALPHA = nil
render.BLEND_ONE_MINUS_DST_COLOR = nil
render.BLEND_ONE_MINUS_SRC_ALPHA = nil
render.BLEND_ONE_MINUS_SRC_COLOR = nil
render.BLEND_SRC_ALPHA = nil
render.BLEND_SRC_ALPHA_SATURATE = nil
render.BLEND_SRC_COLOR = nil
render.BLEND_ZERO = nil
render.BUFFER_COLOR0_BIT = nil
render.BUFFER_COLOR1_BIT = nil
render.BUFFER_COLOR2_BIT = nil
render.BUFFER_COLOR3_BIT = nil
render.BUFFER_COLOR_BIT = nil
render.BUFFER_DEPTH_BIT = nil
render.BUFFER_STENCIL_BIT = nil
render.COMPARE_FUNC_ALWAYS = nil
render.COMPARE_FUNC_EQUAL = nil
render.COMPARE_FUNC_GEQUAL = nil
render.COMPARE_FUNC_GREATER = nil
render.COMPARE_FUNC_LEQUAL = nil
render.COMPARE_FUNC_LESS = nil
render.COMPARE_FUNC_NEVER = nil
render.COMPARE_FUNC_NOTEQUAL = nil
render.FACE_BACK = nil
render.FACE_FRONT = nil
render.FACE_FRONT_AND_BACK = nil
render.FILTER_LINEAR = nil
render.FILTER_NEAREST = nil
render.FORMAT_DEPTH = nil
render.FORMAT_LUMINANCE = nil
---May be nil if the format isn't supported
render.FORMAT_R16F = nil
---May be nil if the format isn't supported
render.FORMAT_R32F = nil
---May be nil if the format isn't supported
render.FORMAT_RG16F = nil
---May be nil if the format isn't supported
render.FORMAT_RG32F = nil
render.FORMAT_RGB = nil
---May be nil if the format isn't supported
render.FORMAT_RGB16F = nil
---May be nil if the format isn't supported
render.FORMAT_RGB32F = nil
render.FORMAT_RGBA = nil
---May be nil if the format isn't supported
render.FORMAT_RGBA16F = nil
---May be nil if the format isn't supported
render.FORMAT_RGBA32F = nil
render.FORMAT_STENCIL = nil
render.RENDER_TARGET_DEFAULT = nil
render.STATE_BLEND = nil
render.STATE_CULL_FACE = nil
render.STATE_DEPTH_TEST = nil
render.STATE_POLYGON_OFFSET_FILL = nil
render.STATE_STENCIL_TEST = nil
render.STENCIL_OP_DECR = nil
render.STENCIL_OP_DECR_WRAP = nil
render.STENCIL_OP_INCR = nil
render.STENCIL_OP_INCR_WRAP = nil
render.STENCIL_OP_INVERT = nil
render.STENCIL_OP_KEEP = nil
render.STENCIL_OP_REPLACE = nil
render.STENCIL_OP_ZERO = nil
render.WRAP_CLAMP_TO_BORDER = nil
render.WRAP_CLAMP_TO_EDGE = nil
render.WRAP_MIRRORED_REPEAT = nil
render.WRAP_REPEAT = nil
---Clear buffers in the currently enabled render target with specified value. If the render target has been created with multiple
---color attachments, all buffers will be cleared with the same value.
---@param buffers table # table with keys specifying which buffers to clear and values set to clear values. Available keys are:
function render.clear(buffers) end

---Constant buffers are used to set shader program variables and are optionally passed to the render.draw() function.
---The buffer's constant elements can be indexed like an ordinary Lua table, but you can't iterate over them with pairs() or ipairs().
---@return constant_buffer # new constant buffer
function render.constant_buffer() end

---Deletes a previously created render target.
---@param render_target render_target # render target to delete
function render.delete_render_target(render_target) end

---If a material is currently enabled, disable it.
---The name of the material must be specified in the ".render" resource set
---in the "game.project" setting.
function render.disable_material() end

---Disables a render state.
---@param state constant # state to disable
function render.disable_state(state) end

---Disables a texture unit for a render target that has previourly been enabled.
---@param unit number # texture unit to disable
function render.disable_texture(unit) end

---Draws all objects that match a specified predicate. An optional constant buffer can be
---provided to override the default constants. If no constants buffer is provided, a default
---system constants buffer is used containing constants as defined in materials and set through
---go.set <> (or particlefx.set_constant <>) on visual components.
---@param predicate predicate # predicate to draw for
---@param options table? # optional table with properties:
function render.draw(predicate, options) end

---Draws all 3d debug graphics such as lines drawn with "draw_line" messages and physics visualization.
---@param options table? # optional table with properties:
function render.draw_debug3d(options) end

---If another material was already enabled, it will be automatically disabled
---and the specified material is used instead.
---The name of the material must be specified in the ".render" resource set
---in the "game.project" setting.
---@param material_id string|hash # material id to enable
function render.enable_material(material_id) end

---Enables a particular render state. The state will be enabled until disabled.
---@param state constant # state to enable
function render.enable_state(state) end

---Sets the specified render target's specified buffer to be
---used as texture with the specified unit.
---A material shader can then use the texture to sample from.
---@param unit number # texture unit to enable texture for
---@param render_target render_target # render target from which to enable the specified texture unit
---@param buffer_type constant # buffer type from which to enable the texture
function render.enable_texture(unit, render_target, buffer_type) end

---Returns the logical window height that is set in the "game.project" settings.
---Note that the actual window pixel size can change, either by device constraints
---or user input.
---@return number # specified window height
function render.get_height() end

---Returns the specified buffer height from a render target.
---@param render_target render_target # render target from which to retrieve the buffer height
---@param buffer_type constant # which type of buffer to retrieve the height from
---@return number # the height of the render target buffer texture
function render.get_render_target_height(render_target, buffer_type) end

---Returns the specified buffer width from a render target.
---@param render_target render_target # render target from which to retrieve the buffer width
---@param buffer_type constant # which type of buffer to retrieve the width from
---@return number # the width of the render target buffer texture
function render.get_render_target_width(render_target, buffer_type) end

---Returns the logical window width that is set in the "game.project" settings.
---Note that the actual window pixel size can change, either by device constraints
---or user input.
---@return number # specified window width (number)
function render.get_width() end

---Returns the actual physical window height.
---Note that this value might differ from the logical height that is set in the
---"game.project" settings.
---@return number # actual window height
function render.get_window_height() end

---Returns the actual physical window width.
---Note that this value might differ from the logical width that is set in the
---"game.project" settings.
---@return number # actual window width
function render.get_window_width() end

---This function returns a new render predicate for objects with materials matching
---the provided material tags. The provided tags are combined into a bit mask
---for the predicate. If multiple tags are provided, the predicate matches materials
---with all tags ANDed together.
---The current limit to the number of tags that can be defined is 64.
---@param tags table # table of tags that the predicate should match. The tags can be of either hash or string type
---@return predicate # new predicate
function render.predicate(tags) end

---Creates a new render target according to the supplied
---specification table.
---The table should contain keys specifying which buffers should be created
---with what parameters. Each buffer key should have a table value consisting
---of parameters. The following parameter keys are available:
---
---Key                           Values
---format                        render.FORMAT_LUMINANCErender.FORMAT_RGBrender.FORMAT_RGBArender.FORMAT_DEPTHrender.FORMAT_STENCILrender.FORMAT_RGBA32Frender.FORMAT_RGBA16F
---width                         number
---height                        number
---min_filter                    render.FILTER_LINEARrender.FILTER_NEAREST
---mag_filter                    render.FILTER_LINEARrender.FILTER_NEAREST
---u_wrap                        render.WRAP_CLAMP_TO_BORDERrender.WRAP_CLAMP_TO_EDGErender.WRAP_MIRRORED_REPEATrender.WRAP_REPEAT
---v_wrap                        render.WRAP_CLAMP_TO_BORDERrender.WRAP_CLAMP_TO_EDGErender.WRAP_MIRRORED_REPEATrender.WRAP_REPEAT
---The render target can be created to support multiple color attachments. Each attachment can have different format settings and texture filters,
---but attachments must be added in sequence, meaning you cannot create a render target at slot 0 and 3.
---Instead it has to be created with all four buffer types ranging from [0..3] (as denoted by render.BUFFER_COLORX_BIT where 'X' is the attachment you want to create).
---@param name string # render target name
---@param parameters table # table of buffer parameters, see the description for available keys and values
---@return render_target # new render target
function render.render_target(name, parameters) end

---Specifies the arithmetic used when computing pixel values that are written to the frame
---buffer. In RGBA mode, pixels can be drawn using a function that blends the source RGBA
---pixel values with the destination pixel values already in the frame buffer.
---Blending is initially disabled.
---source_factor specifies which method is used to scale the source color components.
---destination_factor specifies which method is used to scale the destination color
---components.
---Source color components are referred to as (Rs,Gs,Bs,As).
---Destination color components are referred to as (Rd,Gd,Bd,Ad).
---The color specified by setting the blendcolor is referred to as (Rc,Gc,Bc,Ac).
---The source scale factor is referred to as (sR,sG,sB,sA).
---The destination scale factor is referred to as (dR,dG,dB,dA).
---The color values have integer values between 0 and (kR,kG,kB,kA), where kc = 2mc - 1 and mc is the number of bitplanes for that color. I.e for 8 bit color depth, color values are between 0 and 255.
---Available factor constants and corresponding scale factors:
---
---Factor constant               Scale factor (fR,fG,fB,fA)
---render.BLEND_ZERO             (0,0,0,0)
---render.BLEND_ONE              (1,1,1,1)
---render.BLEND_SRC_COLOR        (Rs/kR,Gs/kG,Bs/kB,As/kA)
---render.BLEND_ONE_MINUS_SRC_COLOR(1,1,1,1) - (Rs/kR,Gs/kG,Bs/kB,As/kA)
---render.BLEND_DST_COLOR        (Rd/kR,Gd/kG,Bd/kB,Ad/kA)
---render.BLEND_ONE_MINUS_DST_COLOR(1,1,1,1) - (Rd/kR,Gd/kG,Bd/kB,Ad/kA)
---render.BLEND_SRC_ALPHA        (As/kA,As/kA,As/kA,As/kA)
---render.BLEND_ONE_MINUS_SRC_ALPHA(1,1,1,1) - (As/kA,As/kA,As/kA,As/kA)
---render.BLEND_DST_ALPHA        (Ad/kA,Ad/kA,Ad/kA,Ad/kA)
---render.BLEND_ONE_MINUS_DST_ALPHA(1,1,1,1) - (Ad/kA,Ad/kA,Ad/kA,Ad/kA)
---render.BLEND_CONSTANT_COLOR   (Rc,Gc,Bc,Ac)
---render.BLEND_ONE_MINUS_CONSTANT_COLOR(1,1,1,1) - (Rc,Gc,Bc,Ac)
---render.BLEND_CONSTANT_ALPHA   (Ac,Ac,Ac,Ac)
---render.BLEND_ONE_MINUS_CONSTANT_ALPHA(1,1,1,1) - (Ac,Ac,Ac,Ac)
---render.BLEND_SRC_ALPHA_SATURATE(i,i,i,1) where i = min(As, kA - Ad) /kA
---The blended RGBA values of a pixel comes from the following equations:
---
---
--- * Rd = min(kR, Rs * sR + Rd * dR)
---
--- * Gd = min(kG, Gs * sG + Gd * dG)
---
--- * Bd = min(kB, Bs * sB + Bd * dB)
---
--- * Ad = min(kA, As * sA + Ad * dA)
---
---Blend function (render.BLEND_SRC_ALPHA, render.BLEND_ONE_MINUS_SRC_ALPHA) is useful for
---drawing with transparency when the drawn objects are sorted from farthest to nearest.
---It is also useful for drawing antialiased points and lines in arbitrary order.
---@param source_factor constant # source factor
---@param destination_factor constant # destination factor
function render.set_blend_func(source_factor, destination_factor) end

---Specifies whether the individual color components in the frame buffer is enabled for writing (true) or disabled (false). For example, if blue is false, nothing is written to the blue component of any pixel in any of the color buffers, regardless of the drawing operation attempted. Note that writing are either enabled or disabled for entire color components, not the individual bits of a component.
---The component masks are all initially true.
---@param red boolean # red mask
---@param green boolean # green mask
---@param blue boolean # blue mask
---@param alpha boolean # alpha mask
function render.set_color_mask(red, green, blue, alpha) end

---Specifies whether front- or back-facing polygons can be culled
---when polygon culling is enabled. Polygon culling is initially disabled.
---If mode is render.FACE_FRONT_AND_BACK, no polygons are drawn, but other
---primitives such as points and lines are drawn. The initial value for
---face_type is render.FACE_BACK.
---@param face_type constant # face type
function render.set_cull_face(face_type) end

---Specifies the function that should be used to compare each incoming pixel
---depth value with the value present in the depth buffer.
---The comparison is performed only if depth testing is enabled and specifies
---the conditions under which a pixel will be drawn.
---Function constants:
---
---
--- * render.COMPARE_FUNC_NEVER (never passes)
---
--- * render.COMPARE_FUNC_LESS (passes if the incoming depth value is less than the stored value)
---
--- * render.COMPARE_FUNC_LEQUAL (passes if the incoming depth value is less than or equal to the stored value)
---
--- * render.COMPARE_FUNC_GREATER (passes if the incoming depth value is greater than the stored value)
---
--- * render.COMPARE_FUNC_GEQUAL (passes if the incoming depth value is greater than or equal to the stored value)
---
--- * render.COMPARE_FUNC_EQUAL (passes if the incoming depth value is equal to the stored value)
---
--- * render.COMPARE_FUNC_NOTEQUAL (passes if the incoming depth value is not equal to the stored value)
---
--- * render.COMPARE_FUNC_ALWAYS (always passes)
---
---The depth function is initially set to render.COMPARE_FUNC_LESS.
---@param func constant # depth test function, see the description for available values
function render.set_depth_func(func) end

---Specifies whether the depth buffer is enabled for writing. The supplied mask governs
---if depth buffer writing is enabled (true) or disabled (false).
---The mask is initially true.
---@param depth boolean # depth mask
function render.set_depth_mask(depth) end

---Sets the scale and units used to calculate depth values.
---If render.STATE_POLYGON_OFFSET_FILL is enabled, each fragment's depth value
---is offset from its interpolated value (depending on the depth value of the
---appropriate vertices). Polygon offset can be used when drawing decals, rendering
---hidden-line images etc.
---factor specifies a scale factor that is used to create a variable depth
---offset for each polygon. The initial value is 0.
---units is multiplied by an implementation-specific value to create a
---constant depth offset. The initial value is 0.
---The value of the offset is computed as factor ? DZ + r ? units
---DZ is a measurement of the depth slope of the polygon which is the change in z (depth)
---values divided by the change in either x or y coordinates, as you traverse a polygon.
---The depth values are in window coordinates, clamped to the range [0, 1].
---r is the smallest value that is guaranteed to produce a resolvable difference.
---It's value is an implementation-specific constant.
---The offset is added before the depth test is performed and before the
---value is written into the depth buffer.
---@param factor number # polygon offset factor
---@param units number # polygon offset units
function render.set_polygon_offset(factor, units) end

---Sets the projection matrix to use when rendering.
---@param matrix matrix4 # projection matrix
function render.set_projection(matrix) end

---Sets a render target. Subsequent draw operations will be to the
---render target until it is replaced by a subsequent call to set_render_target.
---@param render_target render_target # render target to set. render.RENDER_TARGET_DEFAULT to set the default render target
---@param options table? # optional table with behaviour parameters
function render.set_render_target(render_target, options) end

---sets the render target size
---@param render_target render_target # render target to set size for
---@param width number # new render target width
---@param height number # new render target height
function render.set_render_target_size(render_target, width, height) end

---Stenciling is similar to depth-buffering as it enables and disables drawing on a
---per-pixel basis. First, GL drawing primitives are drawn into the stencil planes.
---Second, geometry and images are rendered but using the stencil planes to mask out
---where to draw.
---The stencil test discards a pixel based on the outcome of a comparison between the
---reference value ref and the corresponding value in the stencil buffer.
---func specifies the comparison function. See the table below for values.
---The initial value is render.COMPARE_FUNC_ALWAYS.
---ref specifies the reference value for the stencil test. The value is clamped to
---the range [0, 2n-1], where n is the number of bitplanes in the stencil buffer.
---The initial value is 0.
---mask is ANDed with both the reference value and the stored stencil value when the test
---is done. The initial value is all 1's.
---Function constant:
---
---
--- * render.COMPARE_FUNC_NEVER (never passes)
---
--- * render.COMPARE_FUNC_LESS (passes if (ref & mask) < (stencil & mask))
---
--- * render.COMPARE_FUNC_LEQUAL (passes if (ref & mask) <= (stencil & mask))
---
--- * render.COMPARE_FUNC_GREATER (passes if (ref & mask) > (stencil & mask))
---
--- * render.COMPARE_FUNC_GEQUAL (passes if (ref & mask) >= (stencil & mask))
---
--- * render.COMPARE_FUNC_EQUAL (passes if (ref & mask) = (stencil & mask))
---
--- * render.COMPARE_FUNC_NOTEQUAL (passes if (ref & mask) != (stencil & mask))
---
--- * render.COMPARE_FUNC_ALWAYS (always passes)
---@param func constant # stencil test function, see the description for available values
---@param ref number # reference value for the stencil test
---@param mask number # mask that is ANDed with both the reference value and the stored stencil value when the test is done
function render.set_stencil_func(func, ref, mask) end

---The stencil mask controls the writing of individual bits in the stencil buffer.
---The least significant n bits of the parameter mask, where n is the number of
---bits in the stencil buffer, specify the mask.
---Where a 1 bit appears in the mask, the corresponding
---bit in the stencil buffer can be written. Where a 0 bit appears in the mask,
---the corresponding bit in the stencil buffer is never written.
---The mask is initially all 1's.
---@param mask number # stencil mask
function render.set_stencil_mask(mask) end

---The stencil test discards a pixel based on the outcome of a comparison between the
---reference value ref and the corresponding value in the stencil buffer.
---To control the test, call render.set_stencil_func <>.
---This function takes three arguments that control what happens to the stored stencil
---value while stenciling is enabled. If the stencil test fails, no change is made to the
---pixel's color or depth buffers, and sfail specifies what happens to the stencil buffer
---contents.
---Operator constants:
---
---
--- * render.STENCIL_OP_KEEP (keeps the current value)
---
--- * render.STENCIL_OP_ZERO (sets the stencil buffer value to 0)
---
--- * render.STENCIL_OP_REPLACE (sets the stencil buffer value to ref, as specified by render.set_stencil_func <>)
---
--- * render.STENCIL_OP_INCR (increments the stencil buffer value and clamp to the maximum representable unsigned value)
---
--- * render.STENCIL_OP_INCR_WRAP (increments the stencil buffer value and wrap to zero when incrementing the maximum representable unsigned value)
---
--- * render.STENCIL_OP_DECR (decrements the current stencil buffer value and clamp to 0)
---
--- * render.STENCIL_OP_DECR_WRAP (decrements the current stencil buffer value and wrap to the maximum representable unsigned value when decrementing zero)
---
--- * render.STENCIL_OP_INVERT (bitwise inverts the current stencil buffer value)
---
---dppass and dpfail specify the stencil buffer actions depending on whether subsequent
---depth buffer tests succeed (dppass) or fail (dpfail).
---The initial value for all operators is render.STENCIL_OP_KEEP.
---@param sfail constant # action to take when the stencil test fails
---@param dpfail constant # the stencil action when the stencil test passes
---@param dppass constant # the stencil action when both the stencil test and the depth test pass, or when the stencil test passes and either there is no depth buffer or depth testing is not enabled
function render.set_stencil_op(sfail, dpfail, dppass) end

---Sets the view matrix to use when rendering.
---@param matrix matrix4 # view matrix to set
function render.set_view(matrix) end

---Set the render viewport to the specified rectangle.
---@param x number # left corner
---@param y number # bottom corner
---@param width number # viewport width
---@param height number # viewport height
function render.set_viewport(x, y, width, height) end




return render