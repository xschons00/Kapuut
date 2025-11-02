class_name AppConfigAccess
extends DataAccess

static var	_instance: AppConfigAccess
var app_config: Dictionary = {}

static func get_instance() -> AppConfigAccess:
	if _instance == null:
		_instance = AppConfigAccess.new()
	return _instance

func get_config() -> AppConfigObject:
	app_config = _get_section("app_config")
	if app_config.is_empty():
		return null
	return AppConfigObject.from_dict("app_config", app_config)

func save_config(config: AppConfigObject) -> void:
	app_config = config.to_dict()
	_save_section("app_config", app_config)
	
