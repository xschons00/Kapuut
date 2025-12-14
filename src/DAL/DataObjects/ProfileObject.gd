# Author:
# Description: Player profile data and serialization helpers.

class_name ProfileObject
extends DataObject

var user_name: String
var profile_pic: String
var background_pic: String
var elo: int
var coins: int
var unlocked_items: Array
var PvPPoints: int
var daily_missions: Dictionary
var spin_history: Array
var selected_price: int

func _init() -> void: #setting propper id is handled in data access
	id = "NOT_SET"
	unlocked_items = []
	daily_missions = {
		"flashcards": 0,
		"pvp": 0,
		"lucky_mode": 0
	}
	spin_history = []
	selected_price = 50

# Serializes profile and unlocked items
func to_dict() -> Dictionary:
	var tmp_array: Array = []
	for item in unlocked_items:
		tmp_array.append(item.to_dict())

	return {
		"user_name": user_name,
		"profile_pic": profile_pic,
		"background_pic": background_pic,
		"elo": elo,
		"coins": coins,
		"unlocked_items": tmp_array,
		"PvPPoints": PvPPoints,
		"daily_missions": daily_missions,
		"spin_history": spin_history,
		"selected_price": selected_price
	}

# Builds profile object from saved dictionary
static func from_dict(obj_id: String, dict: Dictionary) -> ProfileObject:
	var obj = ProfileObject.new()
	obj.id = obj_id
	obj.user_name = dict.get("user_name", "")
	obj.profile_pic = dict.get("profile_pic", "")
	obj.background_pic = dict.get("background_pic", "")
	obj.elo = dict.get("elo", 0)
	obj.coins = dict.get("coins", 0)
	obj.PvPPoints = dict.get("PvPPoints", 0)
	obj.daily_missions = dict.get("daily_missions", {
		"flashcards": 0,
		"pvp": 0,
		"lucky_mode": 0
	})
	obj.spin_history = dict.get("spin_history", [])
	obj.selected_price = dict.get("selected_price", 50)

	obj.unlocked_items = []
	var tmp_array: Array = dict.get("unlocked_items", [])
	for item in tmp_array:
		obj.unlocked_items.append(AvatarItem.from_dict("unlocked_item", item))
	
	return obj
