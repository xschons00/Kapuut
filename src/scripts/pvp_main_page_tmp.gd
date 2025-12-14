# Author:
# Description: PvP game selection page with search/filter support.

extends Control

const GAME_SCENE_PATH := "res://src/scenes/PvPGame/PvPStart.tscn"

@onready var selection_list: Control = $GameSelectionWrapper/GameSelectionList

func _ready() -> void:
	Globals.add_menu(self)
	_populate_games()

# Build card list for available themes
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

func _on_search_bar_text_changed(new_text: String) -> void:
	if selection_list:
		selection_list.filter_items(new_text)
