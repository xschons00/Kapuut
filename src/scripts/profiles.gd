extends Control

var config: AppConfigObject
var active_user: ProfileObject

#signals
signal refresh_menu_signal
signal user_changed_signal


#components
@onready var profile_item_scene = preload("res://src/scenes/components/ProfileItem.tscn")
@onready var avatar_selection_scene = preload("res://src/scenes/components/AvatarSelection.tscn")
@onready var background_selection_scene = preload("res://src/scenes/components/BackgroundSelection.tscn")
#nodes
@onready var profile_rect: TextureRect = $ColorRect/profile_rect
@onready var background_rect: TextureRect = $ColorRect/background_rect
@onready var user_label: Label = $HBoxContainer/user_label
@onready var profile_container: VBoxContainer = $all_profiles/VBoxContainer
@onready var line_edit: LineEdit = $LineEdit
@onready var profile_pic_button: TextureRect = $profile_pic_button/TextureRect
@onready var avatar_selection: Control
@onready var background_selection: Control
#@onready var menu: Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add menu
	Globals.add_menu(self)
	# add avatar selection (hidden)
	avatar_selection = avatar_selection_scene.instantiate()
	avatar_selection.item_unlock_signal.connect(_on_avatar_unlocked_signal)
	avatar_selection.avatar_selected_signal.connect(_on_avatar_selected_signal)
	add_child(avatar_selection)
	# add background selection (hidden)
	background_selection = background_selection_scene.instantiate()
	background_selection.background_selected_signal.connect(_on_background_selected_signal)
	background_selection.item_unlock_signal.connect(_on_background_unlocked_signal)
	add_child(background_selection)
	#load profiles
	_refresh_page_content()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _refresh_page_content() -> void:
	_refresh_models()
	_refresh_profile_rect()
	_refresh_background_rect()
	_refresh_user_label()
	_refresh_all_profiles()
	
	
func _refresh_models() -> void:
	config = Globals.data_manager.app_config.get_config()
	if config == null:
		print("ERROR: config not found")
		return
	active_user = Globals.data_manager.profiles.get_profile(config.user_id)
	if active_user == null:
		print("Warning: no user set")
		return
	if not ResourceLoader.exists(active_user.profile_pic):
		print("Error: Invalid path: ", active_user.profile_pic)
		
func _refresh_profile_rect() -> void:
	profile_rect.texture = load(active_user.profile_pic)	
	
func _refresh_background_rect() -> void:
	background_rect.texture = load(active_user.background_pic)
	
func _refresh_user_label() -> void:
	user_label.text = active_user.user_name
	
func _refresh_all_profiles() -> void:
	var profiles: Array[ProfileObject] = Globals.data_manager.profiles.get_all_profiles()
	for child in profile_container.get_children():
		child.queue_free()
	
	for profile in profiles:
		var profile_item = profile_item_scene.instantiate()
		profile_container.add_child(profile_item)
		profile_item.set_profile_data(profile)
		profile_item.profile_selected_signal.connect(_on_profile_selected_signal)
		profile_item.profile_delete_signal.connect(_on_profile_delete_signal)
	profile_container.queue_sort()  # ensure container layout updates
		
func _on_avatar_unlocked_signal() -> void:
	Globals.emit_signal("refresh_menu_signal")
	_refresh_page_content()	
	
func _on_background_unlocked_signal() -> void:
	Globals.emit_signal("refresh_menu_signal")
	_refresh_page_content()	

func _on_profile_selected_signal(user_select: ProfileObject) -> void:
	print("Selected profile:", user_select.user_name)
	config.user_id = user_select.id
	Globals.data_manager.app_config.save_config(config)
	Globals.emit_signal("refresh_menu_signal")
	emit_signal("user_changed_signal")
	_refresh_page_content()
	
func _on_profile_delete_signal(user_select: ProfileObject) -> void:
	print("Delete profile:", user_select.user_name)
	if user_select.id == active_user.id: #delete selected user is forbidden
		print("Warning: Cannot delete active user")
		Globals.show_warning("Warning: Cannot delete active user")
		return
	Globals.data_manager.profiles.delete_profile(user_select)
	_refresh_page_content()
	
	
func _on_new_button_pressed() -> void:
	var new_profile = ProfileObject.new()
	new_profile.user_name = "new player"
	new_profile.profile_pic = Globals.default_profile_pic
	Globals.data_manager.profiles.save_profile(new_profile)
	_refresh_page_content()

func _on_profile_pic_button_pressed() -> void: #shows or hides profile picture selection
	avatar_selection.switch_visibility()
	if background_selection.is_open:
		background_selection.switch_visibility()
	
func _on_background_pic_button_pressed() -> void:
	background_selection.switch_visibility()
	if avatar_selection.is_open:
		avatar_selection.switch_visibility()
	
func _on_avatar_selected_signal(picture_path: String) -> void:
	print("Avatar change, path: ", picture_path)
	if active_user.profile_pic != picture_path:
		active_user.profile_pic = picture_path
		Globals.data_manager.profiles.save_profile(active_user)
		Globals.emit_signal("refresh_menu_signal")
		_refresh_page_content()
	avatar_selection.switch_visibility()

func _on_background_selected_signal(picture_path: String) -> void:
	print("Background change, path: ", picture_path)
	if active_user.background_pic != picture_path:
		active_user.background_pic = picture_path
		Globals.data_manager.profiles.save_profile(active_user)
		Globals.emit_signal("refresh_menu_signal")
		_refresh_page_content()
	background_selection.switch_visibility()
	
func _change_profile_name(new_text: String = "") -> void:
	var new_name: String
	if new_text == "":
		new_name = line_edit.text
		if new_name == "":
			return
	else:
		new_name = new_text
	if new_name.length() > 15:
		Globals.show_warning("Warning: Player name too long")
		return
	active_user.user_name = new_name
	line_edit.text = ""
	Globals.data_manager.profiles.save_profile(active_user)
	Globals.emit_signal("refresh_menu_signal")
	_refresh_page_content()

func _on_save_button_pressed() -> void: #save profile changes
	_change_profile_name()

func _on_line_edit_text_submitted(new_text: String) -> void:
	_change_profile_name(new_text)
		
