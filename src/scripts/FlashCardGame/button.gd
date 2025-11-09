extends Button

var switch:bool = true
	
func _on_button_down() -> void:
	var Game: FlashCards = Globals.GameInstance
	var questions: Array = Game.data["Questions"]
	if (switch):
		self.text = questions[Game.curr_Question]["Correct"]
		switch = false
	else:
		self.text = questions[Game.curr_Question]["Question"]
		switch = true
