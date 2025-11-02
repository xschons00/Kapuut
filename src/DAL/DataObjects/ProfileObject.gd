class_name ProfileObject
extends DataObject

var user_name
var profile_pic: String
var elo: int

func to_dict() -> Dictionary:
	return {"profile_pic" : profile_pic, "elo": elo}

static func from_dict(obj_name: String, dict: Dictionary) -> ProfileObject:
	var obj = ProfileObject.new()
	obj.user_name = obj_name
	obj.elo = dict.get("elo", 0)
	obj.profile_pic = dict.get("profile_pic", "")
	return obj
