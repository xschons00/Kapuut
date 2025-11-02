class_name AppConfigObject
extends DataObject

var _name: String
var user_name: String

func to_dict() -> Dictionary:
	return {"user": user_name}

static func from_dict(obj_name: String, dict: Dictionary) -> AppConfigObject:
	var obj = AppConfigObject.new()
	obj._name = obj_name
	obj.user_name = dict.get("user", "")
	return obj
