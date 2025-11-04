extends Control

var data_manager: DataManager
var config: AppConfigObject
var user: ProfileObject


#scene paths
var create_profile_path: String = "res://src/scenes/CreateProfile.tscn"

#components
@onready var menu_scene = preload("res://src/scenes/components/Menu.tscn")
@onready var profile_item_scene = preload("res://src/scenes/components/ProfileItem.tscn")

#nodes
@onready var profile_rect: TextureRect = $ColorRect/profile_rect
@onready var user_label: Label = $HBoxContainer/user_label
@onready var profile_container: VBoxContainer = $all_profiles/VBoxContainer
@onready var line_edit: LineEdit = $LineEdit
@onready var profile_pic_button: TextureRect = $profile_pic_button/TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add menu
	var menu = menu_scene.instantiate()
	add_child(menu)
	data_manager = DataManager.get_instance()
	#load profiles
	_refresh_page_content()
	profile_pic_button.texture = load("res://assets/icons/plus.png")
	profile_pic_button.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	profile_pic_button.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _refresh_page_content() -> void:
	_refresh_models()
	_refresh_profile_rect()
	_refresh_user_label()
	_refresh_all_profiles()
	
	
func _refresh_models() -> void:
	config = data_manager.app_config.get_config()
	if config == null:
		print("ERROR: config not found")
		return
	user = data_manager.profiles.get_profile(config.user_id)
	if user == null:
		print("Error: Could not load the user")
		return
	if not ResourceLoader.exists(user.profile_pic):
		print("Error: Invalid path: ", user.profile_pic)
		
func _refresh_profile_rect() -> void:
	profile_rect.texture = load(user.profile_pic)	
	
func _refresh_user_label() -> void:
	user_label.text = user.user_name
	
func _refresh_all_profiles() -> void:
	var profiles: Array[ProfileObject] = data_manager.profiles.get_all_profiles()
	for child in profile_container.get_children():
		child.queue_free()
	
	for profile in profiles:
		var profile_item = profile_item_scene.instantiate()
		profile_container.add_child(profile_item)
		profile_item.set_profile_data(profile)
		profile_item.profile_selected.connect(_on_profile_selected)
		profile_item.profile_delete.connect(_on_profile_delete)
	profile_container.queue_sort()  # ensure container layout updates
		
func _on_profile_selected(user_select: ProfileObject) -> void:
	print("Selected profile:", user_select.user_name)
	config.user_id = user_select.id
	data_manager.app_config.save_config(config)
	_refresh_page_content()
	
func _on_profile_delete(user_select: ProfileObject) -> void:
	print("Delete profile:", user_select.user_name)
	data_manager.profiles.delete_profile(user_select)
	_refresh_page_content()
	

func _on_save_button_pressed() -> void: #save profile changes
	var new_name: String = line_edit.text
	if new_name != "":
		user.user_name = new_name
	#TODO all other changes
	data_manager.profiles.save_profile(user)
	_refresh_page_content()
	
func _on_new_button_pressed() -> void:
	get_tree().change_scene_to_file(create_profile_path)
