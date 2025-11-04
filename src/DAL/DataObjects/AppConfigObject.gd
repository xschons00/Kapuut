class_name AppConfigObject
extends DataObject

var user_id: String

func to_dict() -> Dictionary:
	return {"user_id": user_id}

static func from_dict(obj_id: String, dict: Dictionary) -> AppConfigObject:
	var obj = AppConfigObject.new()
	obj.id = obj_id
	obj.user_id = dict.get("user_id", "")
	return obj
