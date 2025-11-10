extends Control


#scene paths
var profiles_path: String = "res://src/scenes/Profiles.tscn"

#components
@onready var avatar_selection_scene = preload("res://src/scenes/components/AvatarSelection.tscn")

#nodes
@onready var profile_rect = $ColorRect/profile_rect
@onready var line_edit = $VBoxContainer/LineEdit
@onready var avatar_selection: Control
#vars
var new_user: ProfileObject
var default_pic: String = "res://assets/icons/user.png"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add menu
	Globals.add_menu(self)
	
	# add avatar selection (hidden)
	avatar_selection = avatar_selection_scene.instantiate()
	add_child(avatar_selection)
	avatar_selection.avatar_selected_signal.connect(_on_avatar_selected_signal)
	
	profile_rect.texture = load(default_pic)
	profile_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	profile_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	#prepare new object
	new_user = ProfileObject.new()
	new_user.profile_pic = default_pic

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_save_button_pressed() -> void:
	new_user.user_name = line_edit.text
	if new_user.user_name == "":
		Globals.show_warning("Warning: User name not selected")
		return
	Globals.data_manager.profiles.save_profile(new_user)
	get_tree().change_scene_to_file(profiles_path)
	
func _on_avatar_selected_signal(picture_path: String) -> void:
	print("Avatar change, path: ", picture_path)
	new_user.profile_pic = picture_path
	profile_rect.texture = load(picture_path)
	avatar_selection.switch_visibility()
	
func _on_profile_pic_button_pressed() -> void:
	avatar_selection.switch_visibility()

func _on_avatar_select_button_pressed() -> void:
	avatar_selection.switch_visibility()

func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file(profiles_path)
