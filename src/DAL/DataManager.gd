# Author:
# Description: Singleton holder for data access layers and test data reset.

class_name DataManager
extends Node

static var _instance: DataManager	# Singleton instance reference
var profiles: ProfileAccess
var themes: GameThemeAccess
var app_config: AppConfigAccess

# Returns the singleton instance and initializes access objects on first call
static func get_instance() -> DataManager:
	if _instance == null:
		_instance = DataManager.new()
		_instance.profiles = ProfileAccess.get_instance()
		_instance.themes = GameThemeAccess.get_instance()
		_instance.app_config = AppConfigAccess.get_instance()
	return _instance

# For testing only: wipes persisted data and counters
func clear_data() -> void:
	_instance.profiles.clear_data() #works with any access object 
	_instance.themes.clear_data()
	_instance.profiles.profile_cnt = 0
