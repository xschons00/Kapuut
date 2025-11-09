extends Button


	
func _on_button_down() -> void:
	Globals.GameInstance.Next_question()
