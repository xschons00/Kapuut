extends Control

func _ready() -> void:
	Globals.add_menu(self)

func _on_start_game_button_down() -> void:
	Globals.GameTheme = "HARRYPOTTER"
	get_tree().change_scene_to_file("res://src/scenes/PvPGame/PvPStart.tscn")
