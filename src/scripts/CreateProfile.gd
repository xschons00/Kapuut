extends Control


#scene paths
var profiles_path: String = "res://src/scenes/Profiles.tscn"

#components

#nodes
@onready var profile_rect = $ColorRect/profile_rect
@onready var line_edit = $VBoxContainer/LineEdit

#vars
var new_user: ProfileObject
var default_pic: String = "res://assets/icons/user.png"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add menu
	Globals.add_menu(self)
	
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
	Globals.data_manager.profiles.save_profile(new_user)
	get_tree().change_scene_to_file(profiles_path)
