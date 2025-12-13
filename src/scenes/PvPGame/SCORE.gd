extends Label


func _ready() -> void:
	self.text = str("SCORE\n", Globals.score ) 
