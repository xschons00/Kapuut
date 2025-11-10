class_name PvPGame
extends GameController

var Question:int = -1
var CorrectAnswer:int 
var game_status:Array = [0,0,0,0,0,0,0,0,0,0] # 1 je P1,2 je P2, -1 nobody
var Curr_Player:int = 1
var wrong:int = 0
var P1 : int  = 0
var P2 : int = 0
#buttons
@onready
var buttons:Array = [
$"Main/HFlowContainer/0",
$"Main/HFlowContainer2/1",
$"Main/HFlowContainer2/2",
$"Main/HFlowContainer3/3",
$"Main/HFlowContainer3/4",
$"Main/HFlowContainer3/5",
$"Main/HFlowContainer4/6",
$"Main/HFlowContainer4/7",
$"Main/HFlowContainer4/8",
$"Main/HFlowContainer4/9"
]

func _on_ready():
	$Question.hide()
	Start()

func Start():
	if Question == -1 : return
	if $Question.visible:
		RefreshQuestion()
	else:
		RefreshMain()
		if game_status[Question] == 0:
			Curr_Player = 2
			BallPressed(Question)
		if game_status[Question] == 1:
			Curr_Player = 2
			Question = -1
		if game_status[Question] == 2:
			Curr_Player = 1
			Question = -1

func BallPressed(index:int):
	Question = index
	$Question.show()
	$Main.hide()
	Start()

func RefreshMain():
	var index:int = 0
	if not game_status.has(0):
		Globals.score = str(P1,": ",P2)
		get_tree().change_scene_to_file("res://src/scenes/PvPGame/PvPEnd.tscn")
		
	for i in game_status:
		var stylebox_flat = StyleBoxFlat.new()
		stylebox_flat.corner_radius_bottom_left = 45
		stylebox_flat.corner_radius_bottom_right = 45
		stylebox_flat.corner_radius_top_left = 45
		stylebox_flat.corner_radius_top_right = 45
		if i == 1:
			stylebox_flat.bg_color = Color.GREEN
			buttons[index].add_theme_stylebox_override("normal", stylebox_flat)
			buttons[index].add_theme_stylebox_override("hover", stylebox_flat)
		elif i == -1:
			buttons[index].disabled = true
		elif i == 2:
			stylebox_flat.bg_color = Color.RED
			buttons[index].add_theme_stylebox_override("normal", stylebox_flat)
			buttons[index].add_theme_stylebox_override("hover", stylebox_flat)
		index+=1

func RefreshQuestion():

	var questionData:Dictionary = data["Questions"][Question]
	# add randomization to the answers
	CorrectAnswer = 1
	$Question/QuestionPanel/Question.text = questionData["Question"]
	$Question/AnswerPanel/VBoxContainer/Answer1.text = questionData["Correct"]
	$Question/AnswerPanel/VBoxContainer/Answer2.text = questionData["otherquestion1"]
	$Question/AnswerPanel/VBoxContainer/Answer3.text = questionData["otherquestion2"]
	$Question/AnswerPanel/VBoxContainer/Answer4.text = questionData["otherquestion3"]

func RevealAnswer(button: Button):
	var stylebox_flat = StyleBoxFlat.new()
	var name_str = str(button.name)
	var index = int(name_str[-1])
	
	if index == CorrectAnswer:
		stylebox_flat.bg_color = Color.GREEN
		game_status[Question] = Curr_Player
		if Curr_Player == 1:
			P1 +=1
		else:
			P2 += 1
	else:
		wrong +=1
		if wrong == 2:
			game_status[Question] = -1
			wrong = 0
		stylebox_flat.bg_color = Color.RED
	
	
	
	button.add_theme_stylebox_override("normal", stylebox_flat)
	button.add_theme_stylebox_override("hover", stylebox_flat)
	await get_tree().create_timer(2.0).timeout
	$Question.hide()
	$Main.show()
	button.remove_theme_stylebox_override("normal")
	button.remove_theme_stylebox_override("hover")
	Start()

func _on_answer_1_button_down() -> void:
	var button:Button = $Question/AnswerPanel/VBoxContainer/Answer1
	RevealAnswer(button)

func _on_answer_2_button_down() -> void:
	var button:Button = $Question/AnswerPanel/VBoxContainer/Answer2
	RevealAnswer(button)	

func _on_answer_3_button_down() -> void:
	var button:Button = $Question/AnswerPanel/VBoxContainer/Answer3
	RevealAnswer(button)

func _on_answer_4_button_down() -> void:
	var button:Button = $Question/AnswerPanel/VBoxContainer/Answer4
	RevealAnswer(button)

func _on_0_button_down() -> void:
	BallPressed(0)

func _on_1_button_down() -> void:
	BallPressed(1)

func _on_2_button_down() -> void:
	BallPressed(2)

func _on_3_button_down() -> void:
	BallPressed(3)

func _on_4_button_down() -> void:
	BallPressed(4)

func _on_5_button_down() -> void:
	BallPressed(5)

func _on_6_button_down() -> void:
	BallPressed(6)

func _on_7_button_down() -> void:
	BallPressed(7)

func _on_8_button_down() -> void:
	BallPressed(8)

func _on_9_button_down() -> void:
	BallPressed(9)


func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://src/scenes/PvPGame/PvPGame.tscn")

func _on_leave_button_down() -> void:
	get_tree().change_scene_to_file("res://src/scenes/PvPMainPageTmp.tscn")
