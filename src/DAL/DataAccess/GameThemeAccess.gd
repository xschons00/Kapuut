class_name GameThemeAccess
extends DataAccess

static var _instance: GameThemeAccess
var themes: Dictionary = {}

static func get_instance() -> GameThemeAccess:
	if _instance == null:
		_instance = GameThemeAccess.new()
	return _instance

func get_Theme(id: String) -> GameThemeObject:
	themes = _get_section("Themes")
	if not themes.has(id):
		return null
	return GameThemeObject.from_dict(id, themes[id])
	
func get_all_Themes() -> Array[GameThemeObject]:
	var theme_arr: Array[GameThemeObject] = []
	themes = _get_section("Themes")
	for id in themes:
		theme_arr.append(GameThemeObject.from_dict(id, themes[id]))
	return theme_arr

func save_Theme(name:String, theme: GameThemeObject) -> void:
	themes = _get_section("themes")
	if theme.id == "NOT_SET": #new theme, set propper ID
		theme.id = name
		
	themes[theme.id] = theme.to_dict()
	_save_section("themes", themes)
	
func delete_Theme(theme: GameThemeObject) -> bool:
	themes = _get_section("themes")
	var ret_code: bool = themes.erase(theme.id)
	_save_section("themes", themes)
	return ret_code
	
func add_question(theme: GameThemeObject, question:QuestionObject) -> void:
	themes = _get_section("themes")
		
	theme.Questions.append(question)
	themes[theme.id] = theme.to_dict()
	
	_save_section("themes", themes)

func remove_question_at(theme:GameThemeObject,index:int) -> bool:
	themes = _get_section("themes")
	if index >= theme.Questions.size():
		return false
	theme.Questions.remove_at(index)
	_save_section("themes", themes)
	return true	

func get_question(theme: GameThemeObject, index:int) -> QuestionObject:
	if index >= theme.Questions.size():
		return null
	return theme.Questions[index]
	
func get_all_questions(theme: GameThemeObject) -> Array[QuestionObject]:
	return theme.Questions
