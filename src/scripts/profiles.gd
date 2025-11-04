extends Control

var data_manager: DataManager
var config: AppConfigObject
var user: ProfileObject

@onready var menu_scene = preload("res://src/scenes/Menu.tscn")
@onready var profile_item_scene = preload("res://src/scenes/ProfileItem.tscn")
@onready var profile_rect: TextureRect = $ColorRect/profile_rect
@onready var user_label: Label = $HBoxContainer/user_label
@onready var profile_container: VBoxContainer = $all_profiles/VBoxContainer
@onready var line_edit: LineEdit = $LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add menu
	var menu = menu_scene.instantiate()
	add_child(menu)
	data_manager = DataManager.get_instance()
	#load profiles
	_refresh_page_content()
	

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
	profile_container.queue_sort()  # ensure container layout updates
		
func _on_profile_selected(user_id: String):
	print("Selected profile:", user_id)
	config.user_id = user_id
	data_manager.app_config.save_config(config)
	_refresh_page_content()

func _on_save_button_pressed() -> void: #save profile changes
	var new_name: String = line_edit.text
	if new_name != "":
		user.user_name = new_name
	#TODO all other changes
	data_manager.profiles.save_profile(user)
	_refresh_page_content()
