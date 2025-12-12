class_name ProfileObject
extends DataObject

var user_name: String
var profile_pic: String
var elo: int
var coins: int
var unlocked_items: Array
var PvPPoints: int

func _init() -> void: #setting propper id is handled in data access
	id = "NOT_SET"
	unlocked_items = []

func to_dict() -> Dictionary:
	var tmp_array: Array = []
	for item in unlocked_items:
		tmp_array.append(item.to_dict())
		
	return {"user_name" : user_name,
			"profile_pic" : profile_pic,
			"elo" : elo,
			"coins" : coins,
			"unlocked_items" : tmp_array
			}

static func from_dict(obj_id: String, dict: Dictionary) -> ProfileObject:
	var obj = ProfileObject.new()
	obj.id = obj_id
	obj.user_name = dict.get("user_name", "")
	obj.profile_pic = dict.get("profile_pic", "")
	obj.elo = dict.get("elo", 0)
	obj.coins = dict.get("coins", 0)
	obj.unlocked_items = []
	var tmp_array: Array = dict.get("unlocked_items", [])
	for item in tmp_array:
		obj.unlocked_items.append(AvatarItem.from_dict("unlocked_item", item))
	
	return obj
