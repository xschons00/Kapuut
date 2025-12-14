# Author:
# Description: Handles persistence for game themes and their questions.

class_name GameThemeAccess
extends DataAccess

static var _instance: GameThemeAccess
var themes: Dictionary = {}

# Returns singleton instance
static func get_instance() -> GameThemeAccess:
	if _instance == null:
		_instance = GameThemeAccess.new()
	return _instance

# Retrieves theme by ID or null if missing
func get_Theme(id: String) -> GameThemeObject:
	themes = _get_section("Themes")
	if not themes.has(id):
		return null
	return GameThemeObject.from_dict(id, themes[id])
	
# Returns all themes as objects
func get_all_Themes() -> Array[GameThemeObject]:
	var theme_arr: Array[GameThemeObject] = []
	themes = _get_section("Themes")
	for id in themes:
		theme_arr.append(GameThemeObject.from_dict(id, themes[id]))
	return theme_arr

# Saves or updates a theme, setting id when needed
func save_Theme(theme_name:String, theme: GameThemeObject) -> void:
	themes = _get_section("Themes")
	if theme.id == "NOT_SET": #new theme, set propper ID
		theme.id = theme_name
		
	themes[theme.id] = theme.to_dict()
	_save_section("Themes", themes)
	
# Deletes a theme and returns true if removed
func delete_Theme(theme: GameThemeObject) -> bool:
	themes = _get_section("Themes")
	var ret_code: bool = themes.erase(theme.id)
	_save_section("Themes", themes)
	return ret_code
	
# Adds a question to a theme and persists
func add_question(theme: GameThemeObject, question:QuestionObject) -> void:
	themes = _get_section("Themes")
		
	theme.Questions.append(question)
	themes[theme.id] = theme.to_dict()
	
	_save_section("Themes", themes)

# Removes a question at index if it exists
func remove_question_at(theme:GameThemeObject,index:int) -> bool:
	themes = _get_section("Themes")
	if index >= theme.Questions.size():
		return false
	theme.Questions.remove_at(index)
	_save_section("Themes", themes)
	return true	

# Returns question at index or null
func get_question(theme: GameThemeObject, index:int) -> QuestionObject:
	if index >= theme.Questions.size():
		return null
	return theme.Questions[index]
	
# Returns all questions for a given theme
func get_all_questions(theme: GameThemeObject) -> Array[QuestionObject]:
	return theme.Questions
