class_name FlashCards
extends GameController

var num_of_questions: int = 0
var curr_Question: int = 0
var EndingPath :String = "res://src/scenes/FlashCardGame/FlashGameEnd.tscn"

func load_additional_data():
	num_of_questions = Gtheme.Questions.size()
	
func Next_question():
	curr_Question += 1
	if (curr_Question >= num_of_questions):
		Switch_Scene(EndingPath)
