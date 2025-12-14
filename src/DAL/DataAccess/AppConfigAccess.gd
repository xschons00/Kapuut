# Author:
# Description: Provides load/save helpers for app configuration.

class_name AppConfigAccess
extends DataAccess

static var	_instance: AppConfigAccess
var app_config: Dictionary = {}

# Returns singleton instance
static func get_instance() -> AppConfigAccess:
	if _instance == null:
		_instance = AppConfigAccess.new()
	return _instance

# Loads config or null if not set
func get_config() -> AppConfigObject:
	app_config = _get_section("app_config")
	if app_config.is_empty():
		return null
	return AppConfigObject.from_dict("app_config", app_config)

# Persists configuration to storage
func save_config(config: AppConfigObject) -> void:
	app_config = config.to_dict()
	_save_section("app_config", app_config)
	
