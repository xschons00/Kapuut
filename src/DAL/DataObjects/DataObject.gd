# generic parent class for all data objects

class_name DataObject
extends RefCounted

var id: String

func to_dict() -> Dictionary:
	return {}

static func from_dict(obj_id: String, dict: Dictionary) -> DataObject:
	var obj = DataObject.new()
	obj.id = obj_id
	obj.item = dict.get("item", "")
	return DataObject.new()
