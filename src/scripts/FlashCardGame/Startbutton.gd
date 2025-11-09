extends Button

func _on_button_down() -> void:
	Globals.GameInstance.Switch_Scene("res://src/scenes/FlashCardGame/FlashGame.tscn")
