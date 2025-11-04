extends Control

@onready var profile_button: TextureRect = $profiles_button/TextureRect
var data_manager: DataManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data_manager = DataManager.get_instance()
	var config: AppConfigObject = data_manager.app_config.get_config()
	if config == null:
		print("ERROR: config not found")
		return
	var user: ProfileObject = data_manager.profiles.get_profile(config.user_id)
	if user == null:
		print("Error: user not found: ", config.user_id)
		return
	if not ResourceLoader.exists(user.profile_pic):
		print("Error: Invalid path: ", user.profile_pic)
		return
	profile_button.texture = load(user.profile_pic)
	profile_button.stretch_mode = TextureRect.STRETCH_SCALE
	profile_button.expand = true
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/MainPage.tscn")
	

func _on_flashcards_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/FlashcardsMainPage.tscn")


func _on_profiles_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/Profiles.tscn")
