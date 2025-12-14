# Author:
# Description: Base class for data access objects handling JSON persistence.

#base class for each data access

class_name DataAccess
extends Node

const SAVE_PATH := "res://src/DAL/data.json"
var data: Dictionary = {}

# Reads JSON from disk into the shared data dictionary
func _load_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var f = FileAccess.open(SAVE_PATH, FileAccess.READ)
		data = JSON.parse_string(f.get_as_text())
		f.close()
	if typeof(data) != TYPE_DICTIONARY:
		data = {}

# Saves the current dictionary to disk
func _save_data() -> void:
	var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(data, "\t"))
	f.close()

# returns subdictionary or empty dict
func _get_section(key: String, default_value = {}):
	_load_data()  # Always reload before reading
	return data.get(key, default_value)

func _save_section(key: String, value) -> void:
	_load_data()  # Refresh before saving
	data[key] = value
	_save_data()

func clear_data() -> void:# for testing only, deletes saved data
	data = {}
	_save_data()
	
