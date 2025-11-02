# generic parent class for all data objects

class_name DataObject
extends RefCounted

var _item: String

func to_dict() -> Dictionary:
	return {"item" : _item}

static func from_dict(obj_name: String, dict: Dictionary) -> DataObject:
	var obj = DataObject.new()
	obj.name = obj_name
	obj.item = dict.get("item", "")
	return DataObject.new()
