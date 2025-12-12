class_name AvatarItem
extends DataObject

var item_name: String
var item_path: String
var price: int
var is_unlocked: bool

func to_dict() -> Dictionary:
	return {"item_name" : item_name,
			"item_path" : item_path,
			"price" 	: price,
			}

static func from_dict(obj_id: String, dict: Dictionary) -> AvatarItem:
	var obj = AvatarItem.new()
	obj.id = obj_id
	obj.item_name = dict.get("item_name", "")
	obj.item_path = dict.get("item_path", "")
	obj.price = dict.get("price", 0)
	obj.is_unlocked = dict.get("is_unlocked", false)
	return obj
