class_name SampleDataSeed
extends Node

static var _instance: SampleDataSeed
var dm = DataManager.get_instance()

static func get_instance() -> SampleDataSeed:
	if _instance == null:
		_instance = SampleDataSeed.new()
	return _instance

func seed() -> void:
	var user1 = ProfileObject.new()
	user1.user_name = "John Doe"
	user1.profile_pic = "res://assets/icons/icon.svg"
	user1.elo = 1024
	dm.profiles.save_profile(user1)
	var config = AppConfigObject.new()
	config.user_id = user1.id
	dm.app_config.save_config(config)
