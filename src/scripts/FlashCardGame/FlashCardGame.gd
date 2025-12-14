# Author:xjakubk00
# Description: Flashcard gameplay controller for navigating questions.

class_name FlashCards
extends GameController

var num_of_questions: int = 0
var curr_Question: int = 0
var EndingPath :String = "res://src/scenes/FlashCardGame/FlashGameEnd.tscn"
var switch:bool = true
var known_count: int = 0
var known_questions: Array = []

# Mission targets
const FLASHCARDS_TARGET: int = 10
const PVP_TARGET: int = 3
const LUCKY_MODE_TARGET: int = 20
# Load deck data and initialize counters/UI
func load_additional_data():
	num_of_questions = Gtheme.Questions.size()
	Globals.flash_total_questions = num_of_questions
	known_count = Globals.flash_known_count

	known_questions.clear()
	if num_of_questions > 0:
		known_questions.resize(num_of_questions)
		for i in range(num_of_questions):
			known_questions[i] = false

	if num_of_questions == 0:
		return

	var progress_label: Label = get_node_or_null("Progress")
	if progress_label:
		progress_label.text = str("\n", curr_Question + 1, "/", num_of_questions)
		Refresh()
		_update_back_button_visibility()

	_update_score_label()
	_show_end_summary()
	
func Next_question():
	curr_Question += 1
	if (curr_Question == num_of_questions):
		Switch_Scene(EndingPath)
	else:
		self.Refresh()
		_update_back_button_visibility()

# Allows stepping backwards when possible
func Previous_question() -> void:
	if curr_Question <= 0:
		return

	curr_Question -= 1
	self.Refresh()
	_update_back_button_visibility()
		
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

func _update_back_button_visibility() -> void:
	var back_button: Button = get_node_or_null("Panel/back")
	if back_button:
		var can_go_back := num_of_questions > 0 and curr_Question > 0
		back_button.visible = can_go_back
		back_button.disabled = not can_go_back
	
# Refresh flashcard text for current question
func Refresh():
	var questions: Array = data["Questions"]
	var flash_card: Button = get_node_or_null("Panel/FlashCard")
	if flash_card and curr_Question < questions.size():
		flash_card.text = questions[curr_Question]["Question"]

func _on_next_button_down() -> void:

	Next_question()
	if curr_Question < num_of_questions:
		UpdateProgress()

func _on_back_button_down() -> void:
	Previous_question()
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
	increment_mission("flashcards")
	if curr_Question >= 0 and curr_Question < num_of_questions:
		if known_questions.size() != num_of_questions:
			known_questions.clear()
			known_questions.resize(num_of_questions)
			for i in range(num_of_questions):
				if typeof(known_questions[i]) != TYPE_BOOL:
					known_questions[i] = false
		if not known_questions[curr_Question]:
			Globals.flash_known_count += 1
			known_questions[curr_Question] = true

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


func increment_mission(mission_type: String) -> void:
	var current_user_id = Globals.data_manager.app_config.get_config().user_id
	var profiles_dict = Globals.data_manager.profiles._get_section("profiles")
	if not profiles_dict.has(current_user_id):
		return

	var profile_data = profiles_dict[current_user_id]

	if not profile_data.has("daily_missions"):
		profile_data["daily_missions"] = {
			"flashcards": 0,
			"pvp": 0,
			"lucky_mode": 0
		}

	var missions = profile_data["daily_missions"]

	# Increment the specified mission
	match mission_type:
		"flashcards":
			if missions["flashcards"] < FLASHCARDS_TARGET:
				missions["flashcards"] += 1
		"pvp":
			if missions["pvp"] < PVP_TARGET:
				missions["pvp"] += 1
		"lucky_mode":
			if missions["lucky_mode"] < LUCKY_MODE_TARGET:
				missions["lucky_mode"] += 1

	profile_data["daily_missions"] = missions
	Globals.data_manager.profiles._save_section("profiles", profiles_dict)
