# Author:
# Description: Button handler to start the Harry Potter demo game.

extends Button


func _on_button_button_down() -> void:
	Globals.GameTheme = "HARRYPOTTER"
	get_tree().change_scene_to_file("res://src/scenes/FlashCardGame/FlashGameStart.tscn")
