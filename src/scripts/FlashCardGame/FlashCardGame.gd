class_name FlashCards
extends GameController

var num_of_questions: int = 0
var curr_Question: int = 0
var EndingPath :String = "res://src/scenes/FlashCardGame/FlashGameEnd.tscn"
var switch:bool = true
var known_count: int = 0

func load_additional_data():
	num_of_questions = Gtheme.Questions.size()
	Globals.flash_total_questions = num_of_questions
	known_count = Globals.flash_known_count

	if num_of_questions == 0:
		return

	var progress_label: Label = get_node_or_null("Progress")
	if progress_label:
		progress_label.text = str("\n", curr_Question + 1, "/", num_of_questions)
		Refresh()

	_update_score_label()
	_show_end_summary()
	
func Next_question():
	curr_Question += 1
	if (curr_Question == num_of_questions):
		Switch_Scene(EndingPath)
	else:
		self.Refresh()
		
func UpdateProgress():
	if num_of_questions <= 0:
		return

	var progress_label: Label = get_node_or_null("Progress")
	if progress_label:
		progress_label.text = str("\n", curr_Question + 1, "/", num_of_questions)

	var progress_bar: Control = get_node_or_null("ProgressBar")
	var progress_background: Control = get_node_or_null("ProgressBackground")
	if progress_bar and progress_background:
		progress_bar.size.x = ((curr_Question + 1) / float(num_of_questions)) * progress_background.size.x
	
func Refresh():
	var questions: Array = data["Questions"]
	var flash_card: Button = get_node_or_null("Panel/FlashCard")
	if flash_card and curr_Question < questions.size():
		flash_card.text = questions[curr_Question]["Question"]
		

	
func _on_next_button_down() -> void:

	Next_question()
	if curr_Question < num_of_questions:
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
	Globals.flash_known_count = 0
	Globals.flash_total_questions = num_of_questions
	curr_Question = 0
	known_count = 0
	Switch_Scene("res://src/scenes/FlashCardGame/FlashGame.tscn")

func _on_leave_button_down() -> void:
	Switch_Scene("res://src/scenes/FlashcardsMainPage.tscn")

func _on_Know_button_down() -> void:
	Globals.flash_known_count += 1
	known_count = Globals.flash_known_count
	_update_score_label()
	Next_question()
	if curr_Question < num_of_questions:
		UpdateProgress()


func _show_end_summary() -> void:
	var summary_label: Label = get_node_or_null("Panel/Result")
	if summary_label:
		var total := Globals.flash_total_questions
		if total <= 0:
			total = num_of_questions
		summary_label.text = str("You knew ", Globals.flash_known_count, " / ", total)


func _update_score_label() -> void:
	var score_label: Label = get_node_or_null("Label")
	if score_label and score_label.get_parent() == self:
		var total := Globals.flash_total_questions
		if total <= 0:
			total = num_of_questions
		score_label.text = str("Score: \n", Globals.flash_known_count, " / ", total)
