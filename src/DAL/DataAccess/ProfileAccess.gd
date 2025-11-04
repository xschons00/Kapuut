class_name ProfileAccess
extends DataAccess

static var _instance: ProfileAccess
var profile_cnt: int
var profiles: Dictionary = {}

static func get_instance() -> ProfileAccess:
	if _instance == null:
		_instance = ProfileAccess.new()
		_instance.profile_cnt = 0
	return _instance

func get_profile(id: String) -> ProfileObject:
	profiles = _get_section("profiles")
	if not profiles.has(id):
		return null
	return ProfileObject.from_dict(id, profiles[id])
	
func get_all_profiles() -> Array[ProfileObject]:
	var profile_arr: Array[ProfileObject] = []
	profiles = _get_section("profiles")
	for id in profiles:
		profile_arr.append(ProfileObject.from_dict(id, profiles[id]))
	return profile_arr

func save_profile(profile: ProfileObject) -> void:
	profiles = _get_section("profiles")
	if profile.id == "NOT_SET": #new profile, set propper ID
		profile.id = str(profile_cnt)
		profile_cnt+=1
		
	profiles[profile.id] = profile.to_dict()
	_save_section("profiles", profiles)
	
func delete_profile(profile: ProfileObject) -> bool:
	profiles = _get_section("profiles")
	var ret_code: bool = profiles.erase(profile.id)
	_save_section("profiles", profiles)
	return ret_code
	
	
