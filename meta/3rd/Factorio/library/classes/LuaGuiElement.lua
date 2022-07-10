---@meta

---An element of a custom GUI. This type is used to represent any kind of a GUI element - labels, buttons and frames are all instances of this type. Just like [LuaEntity](LuaEntity), different kinds of elements support different attributes; attempting to access an attribute on an element that doesn't support it (for instance, trying to access the `column_count` of a `textfield`) will result in a runtime error.
---
---The following types of GUI element are supported:
---
---- `"button"`: A clickable element. Relevant event: [on_gui_click](on_gui_click)
---- `"sprite-button"`: A `button` that displays a sprite rather than text. Relevant event: [on_gui_click](on_gui_click)
---- `"checkbox"`: A clickable element with a check mark that can be turned off or on. Relevant event: [on_gui_checked_state_changed](on_gui_checked_state_changed)
---- `"flow"`: An invisible container that lays out its children either horizontally or vertically.
---- `"frame"`: A non-transparent box that contains other elements. It can have a title (set via the `caption` attribute). Just like a `flow`, it lays out its children either horizontally or vertically. Relevant event: [on_gui_location_changed](on_gui_location_changed)
---- `"label"`: A piece of text.
---- `"line"`: A horizontal or vertical separation line.
---- `"progressbar"`: A partially filled bar that can be used to indicate progress.
---- `"table"`: An invisible container that lays out its children in a specific number of columns. The width of each column is determined by the widest element it contains.
---- `"textfield"`: A single-line box the user can type into. Relevant events: [on_gui_text_changed](on_gui_text_changed), [on_gui_confirmed](on_gui_confirmed)
---- `"radiobutton"`: A clickable element that is functionally identical to a `checkbox`, but has a circular appearance. Relevant event: [on_gui_checked_state_changed](on_gui_checked_state_changed)
---- `"sprite"`: An element that shows an image.
---- `"scroll-pane"`: An invisible element that is similar to a `flow`, but has the ability to show and use scroll bars.
---- `"drop-down"`: A drop-down containing strings of text. Relevant event: [on_gui_selection_state_changed](on_gui_selection_state_changed)
---- `"list-box"`: A list of strings, only one of which can be selected at a time. Shows a scroll bar if necessary. Relevant event: [on_gui_selection_state_changed](on_gui_selection_state_changed)
---- `"camera"`: A camera that shows the game at the given position on the given surface. It can visually track an [entity](LuaGuiElement::entity) that is set after the element has been created.
---- `"choose-elem-button"`: A button that lets the player pick from a certain kind of prototype, with optional filtering. Relevant event: [on_gui_elem_changed](on_gui_elem_changed)
---- `"text-box"`: A multi-line `textfield`. Relevant event: [on_gui_text_changed](on_gui_text_changed)
---- `"slider"`: A horizontal number line which can be used to choose a number. Relevant event: [on_gui_value_changed](on_gui_value_changed)
---- `"minimap"`: A minimap preview, similar to the normal player minimap. It can visually track an [entity](LuaGuiElement::entity) that is set after the element has been created.
---- `"entity-preview"`: A preview of an entity. The [entity](LuaGuiElement::entity) has to be set after the element has been created.
---- `"empty-widget"`: An empty element that just exists. The root GUI elements `screen` and `relative` are `empty-widget`s.
---- `"tabbed-pane"`: A collection of `tab`s and their contents. Relevant event: [on_gui_selected_tab_changed](on_gui_selected_tab_changed)
---- `"tab"`: A tab for use in a `tabbed-pane`.
---- `"switch"`: A switch with three possible states. Can have labels attached to either side. Relevant event: [on_gui_switch_state_changed](on_gui_switch_state_changed)
---
---Each GUI element allows access to its children by having them as attributes. Thus, one can use the `parent.child` syntax to refer to children. Lua also supports the `parent["child"]` syntax to refer to the same element. This can be used in cases where the child has a name that isn't a valid Lua identifier.
---
---This will add a label called `greeting` to the top flow. Immediately after, it will change its text to illustrate accessing child elements. 
---```lua
---game.player.gui.top.add{type="label", name="greeting", caption="Hi"}
---game.player.gui.top.greeting.caption = "Hello there!"
---game.player.gui.top["greeting"].caption = "Actually, never mind, I don't like your face"
---```
---\
---This will add a tabbed-pane and 2 tabs with contents. 
---```lua
---local tabbed_pane = game.player.gui.top.add{type="tabbed-pane"}
---local tab1 = tabbed_pane.add{type="tab", caption="Tab 1"}
---local tab2 = tabbed_pane.add{type="tab", caption="Tab 2"}
---local label1 = tabbed_pane.add{type="label", caption="Label 1"}
---local label2 = tabbed_pane.add{type="label", caption="Label 2"}
---tabbed_pane.add_tab(tab1, label1)
---tabbed_pane.add_tab(tab2, label2)
---```
---@class LuaGuiElement
---@field allow_decimal boolean @Whether this textfield (when in numeric mode) allows decimal numbers.`[RW]`
---@field allow_negative boolean @Whether this textfield (when in numeric mode) allows negative numbers.`[RW]`
---Whether the `"none"` state is allowed for this switch.`[RW]`
---
---This can't be set to false if the current switch_state is 'none'.
---@field allow_none_state boolean
---@field anchor GuiAnchor @Sets the anchor for this relative widget. Setting `nil` clears the anchor.`[RW]`
---@field auto_center boolean @Whether this frame auto-centers on window resize when stored in [LuaGui::screen](LuaGui::screen).`[RW]`
---@field badge_text LocalisedString @The text to display after the normal tab text (designed to work with numbers)`[RW]`
---The text displayed on this element. For frames, this is the "heading". For other elements, like buttons or labels, this is the content.`[RW]`
---
---Whilst this attribute may be used on all elements without producing an error, it doesn't make sense for tables and flows as they won't display it.
---@field caption LocalisedString
---@field children LuaGuiElement[] @The child-elements of this GUI element.`[R]`
---@field children_names string[] @Names of all the children of this element. These are the identifiers that can be used to access the child as an attribute of this element.`[R]`
---@field clear_and_focus_on_right_click boolean @Makes it so right-clicking on this textfield clears and focuses it.`[RW]`
---@field clicked_sprite SpritePath @The image to display on this sprite-button when it is clicked.`[RW]`
---@field column_count uint @The number of columns in this table.`[R]`
---@field direction string @Direction of this element's layout. May be either `"horizontal"` or `"vertical"`.`[R]`
---The `frame` that is being moved when dragging this GUI element, or `nil`. This element needs to be a child of the `drag_target` at some level.`[RW]`
---
---Only top-level elements in [LuaGui::screen](LuaGui::screen) can be `drag_target`s.
---
---This creates a frame that contains a dragging handle which can move the frame. 
---```lua
---local frame = player.gui.screen.add{type="frame", direction="vertical"}
---local dragger = frame.add{type="empty-widget", style="draggable_space"}
---dragger.style.size = {128, 24}
---dragger.drag_target = frame
---```
---@field drag_target LuaGuiElement
---@field draw_horizontal_line_after_headers boolean @Whether this table should draw a horizontal grid line below the first table row.`[RW]`
---@field draw_horizontal_lines boolean @Whether this table should draw horizontal grid lines.`[RW]`
---@field draw_vertical_lines boolean @Whether this table should draw vertical grid lines.`[RW]`
---The elem filters of this choose-elem-button, or `nil` if there are no filters. The compatible type of filter is determined by `elem_type`.`[RW]`
---
---Writing to this field does not change or clear the currently selected element.
---
---This will configure a choose-elem-button of type `"entity"` to only show items of type `"furnace"`. 
---```lua
---button.elem_filters = {{filter = "type", type = "furnace"}}
---```
---\
---Then, there are some types of filters that work on a specific kind of attribute. The following will configure a choose-elem-button of type `"entity"` to only show entities that have their `"hidden"` [flags](EntityPrototypeFlags) set. 
---```lua
---button.elem_filters = {{filter = "hidden"}}
---```
---\
---Lastly, these filters can be combined at will, taking care to specify how they should be combined (either `"and"` or `"or"`. The following will filter for any `"entities"` that are `"furnaces"` and that are not `"hidden"`. 
---```lua
---button.elem_filters = {{filter = "type", type = "furnace"}, {filter = "hidden", invert = true, mode = "and"}}
---```
---@field elem_filters PrototypeFilter[]
---@field elem_type string @The elem type of this choose-elem-button.`[R]`
---The elem value of this choose-elem-button or `nil` if there is no value.`[RW]`
---
---The `"signal"` type operates with [SignalID](SignalID), while all other types use strings.
---@field elem_value string|SignalID
---@field enabled boolean @Whether this GUI element is enabled. Disabled GUI elements don't trigger events when clicked.`[RW]`
---@field entity LuaEntity @The entity associated with this entity-preview, camera, minimap or `nil` if no entity is associated.`[RW]`
---@field force string @The force this minimap is using or `nil` if no force is set.`[RW]`
---@field gui LuaGui @The GUI this element is a child of.`[R]`
---@field horizontal_scroll_policy string @Policy of the horizontal scroll bar. Possible values are `"auto"`, `"never"`, `"always"`, `"auto-and-reserve-space"`, `"dont-show-but-allow-scrolling"`.`[RW]`
---@field hovered_sprite SpritePath @The image to display on this sprite-button when it is hovered.`[RW]`
---@field ignored_by_interaction boolean @Whether this GUI element is ignored by interaction. This makes clicks on this element 'go through' to the GUI element or even the game surface below it.`[RW]`
---@field index uint @The index of this GUI element (unique amongst the GUI elements of a LuaPlayer).`[R]`
---@field is_password boolean @Whether this textfield displays as a password field, which renders all characters as `*`.`[RW]`
---@field items LocalisedString[] @The items in this dropdown or listbox.`[RW]`
---@field left_label_caption LocalisedString @The text shown for the left switch label.`[RW]`
---@field left_label_tooltip LocalisedString @The tooltip shown on the left switch label.`[RW]`
---@field location GuiLocation @The location of this widget when stored in [LuaGui::screen](LuaGui::screen), or `nil` if not set or not in [LuaGui::screen](LuaGui::screen).`[RW]`
---@field locked boolean @Whether this choose-elem-button can be changed by the player.`[RW]`
---@field lose_focus_on_confirm boolean @Whether this textfield loses focus after [defines.events.on_gui_confirmed](defines.events.on_gui_confirmed) is fired.`[RW]`
---@field minimap_player_index uint @The player index this minimap is using.`[RW]`
---@field mouse_button_filter MouseButtonFlags @The mouse button filters for this button or sprite-button.`[RW]`
---The name of this element. `""` if no name was set.`[RW]`
---
---```lua
---game.player.gui.top.greeting.name == "greeting"
---```
---@field name string
---@field number double @The number to be shown in the bottom right corner of this sprite-button. Set this to `nil` to show nothing.`[RW]`
---@field numeric boolean @Whether this textfield is limited to only numberic characters.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field parent LuaGuiElement @The direct parent of this element; `nil` if this is a top-level element.`[R]`
---@field player_index uint @Index into [LuaGameScript::players](LuaGameScript::players) specifying the player who owns this element.`[R]`
---@field position MapPosition @The position this camera or minimap is focused on, if any.`[RW]`
---@field read_only boolean @Whether this text-box is read-only. Defaults to `false`.`[RW]`
---@field resize_to_sprite boolean @Whether the image widget should resize according to the sprite in it. Defaults to `true`.`[RW]`
---@field right_label_caption LocalisedString @The text shown for the right switch label.`[RW]`
---@field right_label_tooltip LocalisedString @The tooltip shown on the right switch label.`[RW]`
---@field selectable boolean @Whether the contents of this text-box are selectable. Defaults to `true`.`[RW]`
---@field selected_index uint @The selected index for this dropdown or listbox. Returns `0` if none is selected.`[RW]`
---@field selected_tab_index uint @The selected tab index for this tabbed pane or `nil` if no tab is selected.`[RW]`
---@field show_percent_for_small_numbers boolean @Related to the number to be shown in the bottom right corner of this sprite-button. When set to `true`, numbers that are non-zero and smaller than one are shown as a percentage rather than the value. For example, `0.5` will be shown as `50%` instead.`[RW]`
---@field slider_value double @The value of this slider element.`[RW]`
---@field sprite SpritePath @The image to display on this sprite-button or sprite in the default state.`[RW]`
---@field state boolean @Is this checkbox or radiobutton checked?`[RW]`
---@field style LuaStyle|string @The style of this element. When read, this evaluates to a [LuaStyle](LuaStyle). For writing, it only accepts a string that specifies the textual identifier (prototype name) of the desired style.`[RW]`
---@field surface_index uint @The surface index this camera or minimap is using.`[RW]`
---The switch state (left, none, right) for this switch.`[RW]`
---
---If [LuaGuiElement::allow_none_state](LuaGuiElement::allow_none_state) is false this can't be set to `"none"`.
---@field switch_state string
---@field tabs TabAndContent[] @The tabs and contents being shown in this tabbed-pane.`[R]`
---@field tags Tags @The tags associated with this LuaGuiElement.`[RW]`
---@field text string @The text contained in this textfield or text-box.`[RW]`
---@field tooltip LocalisedString @`[RW]`
---@field type string @The type of this GUI element.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field value double @How much this progress bar is filled. It is a value in the range [0, 1].`[RW]`
---@field vertical_centering boolean @Whether the content of this table should be vertically centered. Overrides [LuaStyle::column_alignments](LuaStyle::column_alignments). Defaults to `true`.`[RW]`
---@field vertical_scroll_policy string @Policy of the vertical scroll bar. Possible values are `"auto"`, `"never"`, `"always"`, `"auto-and-reserve-space"`, `"dont-show-but-allow-scrolling"`.`[RW]`
---@field visible boolean @Sets whether this GUI element is visible or completely hidden, taking no space in the layout.`[RW]`
---@field word_wrap boolean @Whether this text-box will word-wrap automatically. Defaults to `false`.`[RW]`
---@field zoom double @The zoom this camera or minimap is using. This value must be positive.`[RW]`
---@field [number] LuaGuiElement @The indexing operator. Gets children by name.`[R]`
local LuaGuiElement = {}

---Add a new child element to this GuiElement.
---@param _table LuaGuiElement.add
---@return LuaGuiElement @The GUI element that was added.
function LuaGuiElement.add(_table) end

---Inserts a string at the end or at the given index of this dropdown or listbox.
---@param _string LocalisedString @The text to insert.
---@param _index? uint @The index at which to insert the item.
function LuaGuiElement.add_item(_string, _index) end

---Adds the given tab and content widgets to this tabbed pane as a new tab.
---@param _tab LuaGuiElement @The tab to add, must be a GUI element of type "tab".
---@param _content LuaGuiElement @The content to show when this tab is selected. Can be any type of GUI element.
function LuaGuiElement.add_tab(_tab, _content) end

---Moves this GUI element to the "front" so it will draw over other elements.
---
---Only works for elements in [LuaGui::screen](LuaGui::screen)
function LuaGuiElement.bring_to_front() end

---Remove children of this element. Any [LuaGuiElement](LuaGuiElement) objects referring to the destroyed elements become invalid after this operation.
---
---```lua
---game.player.gui.top.clear()
---```
function LuaGuiElement.clear() end

---Removes the items in this dropdown or listbox.
function LuaGuiElement.clear_items() end

---Remove this element, along with its children. Any [LuaGuiElement](LuaGuiElement) objects referring to the destroyed elements become invalid after this operation.
---
---The top-level GUI elements - [LuaGui::top](LuaGui::top), [LuaGui::left](LuaGui::left), [LuaGui::center](LuaGui::center) and [LuaGui::screen](LuaGui::screen) - can't be destroyed.
---
---```lua
---game.player.gui.top.greeting.destroy()
---```
function LuaGuiElement.destroy() end

---Focuses this GUI element if possible.
function LuaGuiElement.focus() end

---Forces this frame to re-auto-center. Only works on frames stored directly in [LuaGui::screen](LuaGui::screen).
function LuaGuiElement.force_auto_center() end

---Gets the index that this element has in its parent element.
---
---This iterates through the children of the parent of this element, meaning this has a non-free cost to get, but is faster than doing the equivalent in Lua.
---@return uint
function LuaGuiElement.get_index_in_parent() end

---Gets the item at the given index from this dropdown or listbox.
---@param _index uint @The index to get
---@return LocalisedString
function LuaGuiElement.get_item(_index) end

---The mod that owns this Gui element or `nil` if it's owned by the scenario script.
---
---This has a not-super-expensive, but non-free cost to get.
---@return string
function LuaGuiElement.get_mod() end

---Returns whether this slider only allows being moved to discrete positions.
---@return boolean
function LuaGuiElement.get_slider_discrete_slider() end

---Returns whether this slider only allows discrete values.
---@return boolean
function LuaGuiElement.get_slider_discrete_values() end

---Gets this sliders maximum value.
---@return double
function LuaGuiElement.get_slider_maximum() end

---Gets this sliders minimum value.
---@return double
function LuaGuiElement.get_slider_minimum() end

---Gets the minimum distance this slider can move.
---@return double
function LuaGuiElement.get_slider_value_step() end

---All methods and properties that this object supports.
---@return string
function LuaGuiElement.help() end

---Removes the item at the given index from this dropdown or listbox.
---@param _index uint @The index
function LuaGuiElement.remove_item(_index) end

---Removes the given tab and its associated content from this tabbed pane.
---
---Removing a tab does not destroy the tab or the tab contents. It just removes them from the view.
---\
---When removing tabs, [LuaGuiElement::selected_tab_index](LuaGuiElement::selected_tab_index) needs to be manually updated.
---@param _tab LuaGuiElement @The tab to remove. If not given, it removes all tabs.
function LuaGuiElement.remove_tab(_tab) end

---Scrolls this scroll bar to the bottom.
function LuaGuiElement.scroll_to_bottom() end

---Scrolls this scroll bar such that the specified GUI element is visible to the player.
---@param _element LuaGuiElement @The element to scroll to.
---@param _scroll_mode? string @Where the element should be positioned in the scroll-pane. Must be either `"in-view"` or `"top-third"`. Defaults to `"in-view"`.
function LuaGuiElement.scroll_to_element(_element, _scroll_mode) end

---Scrolls the scroll bar such that the specified listbox item is visible to the player.
---@param _index int @The item index to scroll to.
---@param _scroll_mode? string @Where the item should be positioned in the list-box. Must be either `"in-view"` or `"top-third"`. Defaults to `"in-view"`.
function LuaGuiElement.scroll_to_item(_index, _scroll_mode) end

---Scrolls this scroll bar to the left.
function LuaGuiElement.scroll_to_left() end

---Scrolls this scroll bar to the right.
function LuaGuiElement.scroll_to_right() end

---Scrolls this scroll bar to the top.
function LuaGuiElement.scroll_to_top() end

---Selects a range of text in this textbox.
---
---Select the characters `amp` from `example`: 
---```lua
---textbox.select(3, 5)
---```
---\
---Move the cursor to the start of the text box: 
---```lua
---textbox.select(1, 0)
---```
---@param _start int @The index of the first character to select
---@param _end int @The index of the last character to select
function LuaGuiElement.select(_start, _end) end

---Selects all the text in this textbox.
function LuaGuiElement.select_all() end

---Sets the given string at the given index in this dropdown or listbox.
---@param _index uint @The index whose text to replace.
---@param _string LocalisedString @The text to set at the given index.
function LuaGuiElement.set_item(_index, _string) end

---Sets whether this slider only allows being moved to discrete positions.
---@param _value boolean
function LuaGuiElement.set_slider_discrete_slider(_value) end

---Sets whether this slider only allows discrete values.
---@param _value boolean
function LuaGuiElement.set_slider_discrete_values(_value) end

---Sets this sliders minimum and maximum values.
---
---The minimum can't be >= the maximum.
---@param _minimum double
---@param _maximum double
function LuaGuiElement.set_slider_minimum_maximum(_minimum, _maximum) end

---Sets the minimum distance this slider can move.
---
---The minimum distance can't be > (max - min).
---@param _value double
function LuaGuiElement.set_slider_value_step(_value) end

---Swaps the children at the given indices in this element.
---@param _index_1 uint @The index of the first child.
---@param _index_2 uint @The index of the second child.
function LuaGuiElement.swap_children(_index_1, _index_2) end


---@class LuaGuiElement.add
---@field type string @The kind of element to add. Has to be one of the GUI element types listed at the top of this page.
---@field name? string @Name of the child element. It must be unique within the parent element.
---@field caption? LocalisedString @Text displayed on the child element. For frames, this is their title. For other elements, like buttons or labels, this is the content. Whilst this attribute may be used on all elements, it doesn't make sense for tables and flows as they won't display it.
---@field tooltip? LocalisedString @Tooltip of the child element.
---@field enabled? boolean @Whether the child element is enabled. Defaults to `true`.
---@field visible? boolean @Whether the child element is visible. Defaults to `true`.
---@field ignored_by_interaction? boolean @Whether the child element is ignored by interaction. Defaults to `false`.
---@field style? string @Style of the child element.
---@field tags? Tags @[Tags](Tags) associated with the child element.
---@field index? uint @Location in its parent that the child element should slot into. By default, the child will be appended onto the end.
---@field anchor? GuiAnchor @Where to position the child element when in the `relative` element.

