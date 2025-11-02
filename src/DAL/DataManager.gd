class_name DataManager
extends Node

static var _instance: DataManager
var profiles: ProfileAccess
var app_config: AppConfigAccess

static func get_instance() -> DataManager:
	if _instance == null:
		_instance = DataManager.new()  # create the instance first
		_instance.profiles = ProfileAccess.get_instance()
		_instance.app_config = AppConfigAccess.get_instance()
	return _instance
