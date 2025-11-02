extends Control

var data_manager = DataManager.get_instance()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var config: AppConfigObject = data_manager.app_config.get_config()
	if config == null:
		print("ERROR: config not found")
		return
	var user: ProfileObject = data_manager.profiles.get_profile(config.user_name)
	if user != null and ResourceLoader.exists(user.profile_pic):
		var profile_button = $HBoxContainer/profile_button/TextureButton
		profile_button.texture_normal = load(user.profile_pic)
	else:
		print("Error: Invalid path: ", user.profile_pic)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/MainPage.tscn")
	

func _on_flashcards_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/FlashcardsMainPage.tscn")

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/Profiles.tscn")
