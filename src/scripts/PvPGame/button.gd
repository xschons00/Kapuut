

func _on_button_down() -> void:
	var game:PvPGame = Globals.GameInstance
	game.ButtonPressed(int(self.text)) 
