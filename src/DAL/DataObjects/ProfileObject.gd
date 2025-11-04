class_name ProfileObject
extends DataObject

var user_name: String
var profile_pic: String
var elo: int
var credits: int

func _init() -> void: #setting propper id is handled in data access
	id = "NOT_SET"

func to_dict() -> Dictionary:
	return {"user_name" : user_name,
			"profile_pic" : profile_pic,
			"elo" : elo,
			"credits" : credits
			}

static func from_dict(obj_id: String, dict: Dictionary) -> ProfileObject:
	var obj = ProfileObject.new()
	obj.id = obj_id
	obj.user_name = dict.get("user_name", "")
	obj.profile_pic = dict.get("profile_pic", "")
	obj.elo = dict.get("elo", 0)
	obj.credits = dict.get("credits", 0)
	return obj
