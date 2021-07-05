---@meta

---@class ccui.VideoPlayer :ccui.Widget
local VideoPlayer={ }
ccui.VideoPlayer=VideoPlayer




---* brief Get the local video file name.<br>
---* return The video file name.
---@return string
function VideoPlayer:getFileName () end
---* brief Get the URL of remoting video source.<br>
---* return A remoting URL address.
---@return string
function VideoPlayer:getURL () end
---* Starts playback.
---@return self
function VideoPlayer:play () end
---* Checks whether the VideoPlayer is set to listen user input to resume and pause the video<br>
---* return true if the videoplayer user input is set, false otherwise.
---@return boolean
function VideoPlayer:isUserInputEnabled () end
---* Causes the video player to keep aspect ratio or no when displaying the video.<br>
---* param enable    Specify true to keep aspect ratio or false to scale the video until <br>
---* both dimensions fit the visible bounds of the view exactly.
---@param enable boolean
---@return self
function VideoPlayer:setKeepAspectRatioEnabled (enable) end
---* Stops playback.
---@return self
function VideoPlayer:stop () end
---* Causes the video player to enter or exit full-screen mode.<br>
---* param fullscreen    Specify true to enter full-screen mode or false to exit full-screen mode.
---@param fullscreen boolean
---@return self
function VideoPlayer:setFullScreenEnabled (fullscreen) end
---* Sets a file path as a video source for VideoPlayer.
---@param videoPath string
---@return self
function VideoPlayer:setFileName (videoPath) end
---* Sets a URL as a video source for VideoPlayer.
---@param _videoURL string
---@return self
function VideoPlayer:setURL (_videoURL) end
---* Set the style of the player<br>
---* param style The corresponding style
---@param style int
---@return self
function VideoPlayer:setStyle (style) end
---* Seeks to specified time position.<br>
---* param sec   The offset in seconds from the start to seek to.
---@param sec float
---@return self
function VideoPlayer:seekTo (sec) end
---* Indicates whether the video player keep aspect ratio when displaying the video.
---@return boolean
function VideoPlayer:isKeepAspectRatioEnabled () end
---* brief A function which will be called when video is playing.<br>
---* param event @see VideoPlayer::EventType.
---@param event int
---@return self
function VideoPlayer:onPlayEvent (event) end
---* Indicates whether the video player is in full-screen mode.<br>
---* return True if the video player is in full-screen mode, false otherwise.
---@return boolean
function VideoPlayer:isFullScreenEnabled () end
---* Checks whether the VideoPlayer is set with looping mode.<br>
---* return true if the videoplayer is set to loop, false otherwise.
---@return boolean
function VideoPlayer:isLooping () end
---* Checks whether the VideoPlayer is playing.<br>
---* return True if currently playing, false otherwise.
---@return boolean
function VideoPlayer:isPlaying () end
---* brief Set if playback is done in loop mode<br>
---* param looping the video will or not automatically restart at the end
---@param looping boolean
---@return self
function VideoPlayer:setLooping (looping) end
---* Set if the player will enable user input for basic pause and resume of video<br>
---* param enableInput If true, input will be handled for basic functionality (pause/resume)
---@param enableInput boolean
---@return self
function VideoPlayer:setUserInputEnabled (enableInput) end
---* 
---@return self
function VideoPlayer:create () end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function VideoPlayer:draw (renderer,transform,flags) end
---* Pauses playback.
---@return self
function VideoPlayer:pause () end
---* 
---@return self
function VideoPlayer:onEnter () end
---* 
---@return self
function VideoPlayer:onExit () end
---* Resumes playback.
---@return self
function VideoPlayer:resume () end
---* 
---@param visible boolean
---@return self
function VideoPlayer:setVisible (visible) end
---* 
---@return self
function VideoPlayer:VideoPlayer () end