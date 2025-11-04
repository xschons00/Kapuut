class_name ProfileObject
extends DataObject

var user_name: String
var profile_pic: String
var elo: int

func _init() -> void: #setting propper id is handled in data access
	id = "NOT_SET"

func to_dict() -> Dictionary:
	return {"user_name" : user_name, "profile_pic" : profile_pic, "elo": elo}

static func from_dict(obj_id: String, dict: Dictionary) -> ProfileObject:
	var obj = ProfileObject.new()
	obj.id = obj_id
	obj.user_name = dict.get("user_name", "")
	obj.elo = dict.get("elo", 0)
	obj.profile_pic = dict.get("profile_pic", "")
	return obj
