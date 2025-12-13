extends Control

#scene paths
var main_page_path: String = "res://src/scenes/MainPage.tscn"
var flashcards_main_path: String = "res://src/scenes/FlashcardsMainPage.tscn"
var profiles_path: String = "res://src/scenes/Profiles.tscn"
var wheel_of_fortune_path: String = "res://src/scenes/WheelOfFortuneMainPage.tscn"
var pvp_path:String = "res://src/scenes/PvPMainPageTmp.tscn"

#nodes
@onready var background_rect: TextureRect = $profile_area/profiles_button/background_rect
@onready var avatar_rect: TextureRect = $profile_area/profiles_button/avatar_rect
@onready var username_label: Label = $profile_area/username_label
@onready var coins_label: Label = $profile_area/HBoxContainer/coins_label

#vars
var config: AppConfigObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("refresh_menu_signal", _on_refresh_menu_signal)
	_refresh_profile_info()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_refresh_menu_signal() -> void:
	print("menu refresh signal")
	_refresh_profile_info()
	
func _refresh_profile_info() -> void:
	config = Globals.data_manager.app_config.get_config()
	if config == null:
		print("ERROR: config not found")
		return
	var user: ProfileObject = Globals.data_manager.profiles.get_profile(config.user_id)
	if user != null:
		if not ResourceLoader.exists(user.profile_pic):
			print("Error: Invalid path: ", user.profile_pic)
			return
		background_rect.texture = load(user.background_pic)
		avatar_rect.texture = load(user.profile_pic)
		username_label.text = user.user_name
		coins_label.text = str(user.coins)
		return
	#fallback value	
	print("Warning: User not set: ")
	background_rect.texture = load(Globals.default_profile_background)
	avatar_rect.texture = load(Globals.default_profile_pic)
	

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file(main_page_path)
	

func _on_flashcards_button_pressed() -> void:
	get_tree().change_scene_to_file(flashcards_main_path)


func _on_profiles_button_pressed() -> void:
	get_tree().change_scene_to_file(profiles_path)

func _on_pvp_button_button_up() -> void:
	get_tree().change_scene_to_file(pvp_path)


func _on_lucky_mode_button_button_down() -> void:
	get_tree().change_scene_to_file(wheel_of_fortune_path)
