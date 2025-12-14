# Author:
# Description: Data container for game theme metadata and questions.

class_name GameThemeObject
extends DataObject

var img: String
var Questions: Array


func _init() -> void: #setting propper id is handled in data access
	id = "NOT_SET"

# Serializes theme including questions
func to_dict() -> Dictionary:
	var newarr: Array[Dictionary] = []
	for i in Questions:
		newarr.append(i.to_dict())
	return {"img" : img,
			"Questions": newarr
			}

# Rebuilds theme object from dictionary
static func from_dict(obj_id: String, dict: Dictionary) -> GameThemeObject:
	var obj = GameThemeObject.new()
	obj.id = obj_id
	obj.img = dict.get("img", "")
	var objs = dict.get("Questions", "")
	for i in objs:
		obj.Questions.append(QuestionObject.from_dict(obj_id,i))

	return obj
