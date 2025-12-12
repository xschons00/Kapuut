extends Control

# Signals
signal avatar_selected_signal(picture_path: String)
signal item_unlock_signal
#components
@onready var unlock_button_scene = preload("res://src/scenes/components/UnlockButton.tscn")

#nodes
@onready var container: GridContainer = $ColorRect/GridContainer

#vars
var is_open: bool = false
var new_avatar_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent_node = get_parent()
	if parent_node.has_signal("user_changed_signal"):
		parent_node.connect("user_changed_signal", Callable(self, "_reload_avatars"))
	self.visible = false
	_reload_avatars()
				
func _reload_avatars() -> void:
	for button in container.get_children():
		if button is Button and button.name.contains("avatar"): #only for avatar buttons
			#remove old unlock button
			for child in button.get_children():
				if child.is_in_group("UnlockButtons"):   # match root node name of UnlockButton.tscn
					child.queue_free()
				
			# check if index already exists
			var obj: AvatarItem = _load_item_or_default(button)
			if obj == null:
				return
				
			if obj.is_unlocked:
				Globals.set_greyscale(button.get_node("TextureRect"), false)
				if not button.is_connected("pressed", Callable(self, "_on_avatar_button_pressed")):
					button.connect("pressed", Callable(self, "_on_avatar_button_pressed").bind(button))

			else:
				Globals.set_greyscale(button.get_node("TextureRect"))
				_set_unlock_button(button, obj)
				
func _load_item_or_default(button: Button) -> AvatarItem: #checks if item already is unloked for this user
	var item_name: String = button.name.substr(0, 7) #first 7 char (avatarN)
	var config: AppConfigObject = Globals.data_manager.app_config.get_config()
	if	config == null:
		print("Error: could not load config")
		return null
	var user = Globals.data_manager.profiles.get_profile(config.user_id)
	if user == null:
		print("Error: could not load current user")
		return null
	for unlocked in user.unlocked_items:
		if unlocked.item_name == item_name:
			print("item already owned: ", item_name)
			unlocked.is_unlocked = true
			return unlocked
	return _init_new_item(button)
				
func _init_new_item(button: Button) -> AvatarItem:
	var obj_index: int = int(button.name.replace("avatar", "")) #index N only
	var obj = AvatarItem.new()
	obj.item_name = button.name.replace("_button", "") #first 7-8 char (avatarN)
	obj.item_path = button.get_node("TextureRect").texture.resource_path
	if obj_index <= 3:
		obj.is_unlocked = true
		obj.price = 0
	elif obj_index > 3 and obj_index <= 6:
		obj.is_unlocked = false
		obj.price = 500
	else:
		obj.is_unlocked = false
		obj.price = 750
	return obj

func _on_avatar_button_pressed(button: Button) -> void:
	var texture_rect: TextureRect = button.get_node("TextureRect")
	new_avatar_path = texture_rect.texture.resource_path
	emit_signal("avatar_selected_signal", new_avatar_path)
	
func _set_unlock_button(avatar_button: Button, item: AvatarItem) -> void:

	var unlock_button = unlock_button_scene.instantiate()
	avatar_button.add_child(unlock_button)
	unlock_button.set_item_data(item)
	unlock_button.item_unlock_signal.connect(_on_item_unlock_signal)
	#center
	unlock_button.anchor_left = 0.5
	unlock_button.anchor_top = 0.5
	unlock_button.anchor_right = 0.5
	unlock_button.anchor_bottom = 0.5

	unlock_button.offset_left = -50   # half of width
	unlock_button.offset_top = -25    # half of height
	unlock_button.offset_right = 50
	unlock_button.offset_bottom = 25
	
	unlock_button.add_to_group("UnlockButtons")

		
func _on_item_unlock_signal(item: AvatarItem) -> void:
	item.is_unlocked = true
	print("Unlocked: ",item.item_name)
	emit_signal("item_unlock_signal")
	_reload_avatars()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func switch_visibility() -> void:
	if is_open:
		self.visible = false
		is_open = false
	else:
		self.visible = true
		is_open = true	

func _on_close_button_pressed() -> void:
	switch_visibility()
	

func _unhandled_input(event: InputEvent) -> void:# close if any key is pressed
	if event is InputEventKey and is_open:
		switch_visibility()
		
