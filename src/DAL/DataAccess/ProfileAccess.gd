class_name ProfileAccess
extends DataAccess

static var _instance: ProfileAccess
var profiles: Dictionary = {}

static func get_instance() -> ProfileAccess:
	if _instance == null:
		_instance = ProfileAccess.new()
	return _instance

func get_profile(user_name: String) -> ProfileObject:
	profiles = _get_section("profiles")
	if not profiles.has(user_name):
		return null
	return ProfileObject.from_dict(user_name, profiles[user_name])

func save_profile(profile: ProfileObject) -> void:
	profiles = _get_section("profiles")
	profiles[profile.user_name] = profile.to_dict()
	_save_section("profiles", profiles)
	
	
