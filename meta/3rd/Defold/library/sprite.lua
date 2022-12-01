---Sprite API documentation
---Sprite API documentation
---@class sprite
sprite = {}
---Play an animation on a sprite component from its tile set
---An optional completion callback function can be provided that will be called when
---the animation has completed playing. If no function is provided,
---a animation_done <> message is sent to the script that started the animation.
---@param url string|hash|url # the sprite that should play the animation
---@param id  # hash name hash of the animation to play
---@param complete_function (fun(self: object, message_id: hash, message: table, sender: number))? # function to call when the animation has completed.
---@param play_properties table? # optional table with properties:
function sprite.play_flipbook(url, id, complete_function, play_properties) end

---Sets horizontal flipping of the provided sprite's animations.
---The sprite is identified by its URL.
---If the currently playing animation is flipped by default, flipping it again will make it appear like the original texture.
---@param url string|hash|url # the sprite that should flip its animations
---@param flip boolean # true if the sprite should flip its animations, false if not
function sprite.set_hflip(url, flip) end

---Sets vertical flipping of the provided sprite's animations.
---The sprite is identified by its URL.
---If the currently playing animation is flipped by default, flipping it again will make it appear like the original texture.
---@param url string|hash|url # the sprite that should flip its animations
---@param flip boolean # true if the sprite should flip its animations, false if not
function sprite.set_vflip(url, flip) end




return sprite