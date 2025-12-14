# Author: xschons00
# Description: Builds flashcard game selection page with theme filtering.

extends Control


const GAME_SCENE_PATH := "res://src/scenes/FlashCardGame/FlashGameStart.tscn"

@onready var selection_list: Control = $GameSelectionWrapper/GameSelectionList

func _ready() -> void:
	Globals.add_menu(self)
	_populate_games()

# Populate selection list with available themes
func _populate_games() -> void:
	if not selection_list:
		return

	var items: Array = []
	var themes: Array = Globals.data_manager.themes.get_all_Themes()
	for theme: GameThemeObject in themes:
		var display_name := theme.id.replace("_", " ").capitalize()
		items.append({
			"name": display_name,
			"image": theme.img,
			"path": GAME_SCENE_PATH,
			"theme": theme.id
		})

	if items.is_empty():
		items.append({
			"name": "Demo game",
			"image": Globals.default_profile_pic,
			"path": GAME_SCENE_PATH,
			"theme": Globals.GameTheme
		})

	selection_list.set_items(items)


func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/MainPage.tscn")
