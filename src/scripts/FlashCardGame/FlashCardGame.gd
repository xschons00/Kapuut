class_name FlashCards
extends GameController

var num_of_questions: int = 0
var curr_Question: int = 0
var EndingPath :String = "res://src/scenes/FlashCardGame/FlashGameEnd.tscn"
var switch:bool = true

func load_additional_data():
	num_of_questions = Gtheme.Questions.size()
	if $Progress:
		$Progress.text = str("\n",1,"/",num_of_questions)
		Refresh()
	
func Next_question():
	curr_Question += 1
	if (curr_Question == num_of_questions):
		Switch_Scene(EndingPath)
	else:
		self.Refresh()
		
func UpdateProgress():
	$Progress.text = str("\n",curr_Question+1,"/",num_of_questions)
	$ProgressBar.size.x = ((curr_Question+1) / float(num_of_questions)) * $ProgressBackground.size.x
	
func Refresh():
	var questions: Array = data["Questions"]
	if $Panel/FlashCard:
		$Panel/FlashCard.text = questions[curr_Question]["Question"]
		

	
func _on_next_button_down() -> void:

	Next_question()
	if curr_Question <num_of_questions:
		UpdateProgress()

func _on_FlashCard_button_down() -> void:

	var questions: Array = data["Questions"]
	if (switch):
		$Panel/FlashCard.text = questions[curr_Question]["Correct"]
		switch = false
	else:
		$Panel/FlashCard.text = questions[curr_Question]["Question"]
		switch = true
		
func _on_Start_button_down() -> void:
	Switch_Scene("res://src/scenes/FlashCardGame/FlashGame.tscn")

func _on_leave_button_down() -> void:
	Switch_Scene("res://src/scenes/FlashcardsMainPage.tscn")
