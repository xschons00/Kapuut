# Author: xjakubk00
# Description: Holds quiz question text with correct and alternate answers.

class_name QuestionObject
extends DataObject

var Question: String
var Correct: String
var otherquestion1:String
var otherquestion2:String
var otherquestion3:String



func _init() -> void: #setting propper id is handled in data access
	id = "NOT_SET"

# Serializes question content
func to_dict() -> Dictionary:
	return {"Question" : Question,
			"Correct" : Correct,
			"otherquestion1" : otherquestion1,
			"otherquestion2" : otherquestion2,
			"otherquestion3" : otherquestion3
			}

# Creates question object from dictionary values
static func from_dict(obj_id: String, dict: Dictionary) -> QuestionObject:
	var obj = QuestionObject.new()
	obj.id = obj_id
	obj.Question = dict["Question"]
	obj.Correct = dict["Correct"]
	obj.otherquestion1 = dict.get("otherquestion1", "")
	obj.otherquestion2 = dict.get("otherquestion2", "")
	obj.otherquestion3 = dict.get("otherquestion3", "")
	return obj
