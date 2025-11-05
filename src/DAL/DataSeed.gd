class_name DataSeed
extends Node

static var _instance: DataSeed


static func get_instance() -> DataSeed:
	if _instance == null:
		_instance = DataSeed.new()
	return _instance
	
func seed() -> void:
	var default_user = ProfileObject.new()
	default_user.user_name = "player 1"
	default_user.profile_pic = Globals.default_profile_pic
	default_user.credits = 0
	default_user.elo = 0
	Globals.data_manager.profiles.save_profile(default_user)
	var config = AppConfigObject.new()
	config.user_id = default_user.id
	Globals.data_manager.app_config.save_config(config)
	
func test_seed() -> void:
	var user1 = ProfileObject.new()
	user1.user_name = "John Doe"
	user1.profile_pic = "res://assets/icons/icon.svg"
	user1.elo = 1024
	Globals.data_manager.profiles.save_profile(user1)
	var config = AppConfigObject.new()
	config.user_id = user1.id
	Globals.data_manager.app_config.save_config(config)
