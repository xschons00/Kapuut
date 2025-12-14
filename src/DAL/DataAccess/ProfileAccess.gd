# Author:
# Description: Manages persistence for player profiles and items.

class_name ProfileAccess
extends DataAccess

static var _instance: ProfileAccess
var profile_cnt: int
var profiles: Dictionary = {}

# Returns singleton instance and initializes counters
static func get_instance() -> ProfileAccess:
	if _instance == null:
		_instance = ProfileAccess.new()
		_instance.profile_cnt = 0
	return _instance

# Returns profile by ID or null
func get_profile(id: String) -> ProfileObject:
	profiles = _get_section("profiles")
	if not profiles.has(id):
		return null
	return ProfileObject.from_dict(id, profiles[id])
	
# Gets unlocked items for a profile
func get_profile_items(id: String) -> Array[AvatarItem]:
	var profile: ProfileObject = self.get_profile(id)
	if profile == null:
		return []
	return profile.unlocked_items
	
# Returns all profiles
func get_all_profiles() -> Array[ProfileObject]:
	var profile_arr: Array[ProfileObject] = []
	profiles = _get_section("profiles")
	for id in profiles:
		profile_arr.append(ProfileObject.from_dict(id, profiles[id]))
	return profile_arr

# Saves profile and assigns id when missing
func save_profile(profile: ProfileObject) -> String:
	profiles = _get_section("profiles")
	if profile.id == "NOT_SET": #new profile, set propper ID
		profile.id = str(profile_cnt)
		profile_cnt+=1
		
	profiles[profile.id] = profile.to_dict()
	_save_section("profiles", profiles)
	return profile.id
	
# Deletes a profile by object and returns success flag
func delete_profile(profile: ProfileObject) -> bool:
	profiles = _get_section("profiles")
	var ret_code: bool = profiles.erase(profile.id)
	_save_section("profiles", profiles)
	return ret_code
	
	
