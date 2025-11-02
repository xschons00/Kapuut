extends Control

var data_manager: DataManager
var config: AppConfigObject
var user: ProfileObject
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add menu
	var menu = load("res://src/scenes/Menu.tscn").instantiate()
	add_child(menu)
	data_manager = DataManager.get_instance()
	#load profiles
	_refresh_models()
	set_profile_rect()
	set_user_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _refresh_models() -> void:
	config = data_manager.app_config.get_config()
	if config == null:
		print("ERROR: config not found")
		return
	user = data_manager.profiles.get_profile(config.user_name)
	if user == null:
		print("Error: Could not load the user")
		return
	if not ResourceLoader.exists(user.profile_pic):
		print("Error: Invalid path: ", user.profile_pic)
		
func set_profile_rect() -> void:
	var profile_rect = $profile_rect
	profile_rect.texture = load(user.profile_pic)	
	
func set_user_label() -> void:
	var user_label = $HBoxContainer/user_label
	user_label.text = user.user_name
