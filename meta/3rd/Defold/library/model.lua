---Model API documentation
---Model API documentation
---@class model
model = {}
---Cancels all animation on a model component.
---@param url string|hash|url # the model for which to cancel the animation
function model.cancel(url) end

---Gets the id of the game object that corresponds to a model skeleton bone.
---The returned game object can be used for parenting and transform queries.
---This function has complexity O(n), where n is the number of bones in the model skeleton.
---Game objects corresponding to a model skeleton bone can not be individually deleted.
---@param url string|hash|url # the model to query
---@param bone_id string|hash # id of the corresponding bone
---@return hash # id of the game object
function model.get_go(url, bone_id) end

---Plays an animation on a model component with specified playback
---mode and parameters.
---An optional completion callback function can be provided that will be called when
---the animation has completed playing. If no function is provided,
---a model_animation_done <> message is sent to the script that started the animation.
--- The callback is not called (or message sent) if the animation is
---cancelled with model.cancel <>. The callback is called (or message sent) only for
---animations that play with the following playback modes:
---
---
--- * go.PLAYBACK_ONCE_FORWARD
---
--- * go.PLAYBACK_ONCE_BACKWARD
---
--- * go.PLAYBACK_ONCE_PINGPONG
---@param url string|hash|url # the model for which to play the animation
---@param anim_id string|hash # id of the animation to play
---@param playback constant # playback mode of the animation
---@param play_properties table? # optional table with properties Play properties table:
---@param complete_function (fun(self: object, message_id: hash, message: table, sender: hash))? # function to call when the animation has completed.
function model.play_anim(url, anim_id, playback, play_properties, complete_function) end




return model