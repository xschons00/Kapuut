# Author:xjakubk00
# Description: Controls PvP board flow, turn logic, and scoring.

class_name PvPGame
extends GameController

var Question:int = -1
var CorrectAnswer:int 
var game_status:Array = [0,0,0,0,0,0,0,0,0,0] # 1 je P1,2 je P2, -1 nobody
var Curr_Player:int = 1
var wrong:int = 0
var P1 : String = Globals.data_manager.app_config.get_config().user_id
var P2 : String =  Globals.data_manager.app_config.get_config().opponent
var Player1Points: int = 0
var Player2Points: int = 0
var winner_coin_awarded: bool = false
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
	Globals.pvp_winner = 0
	$Question.hide()
	Start()

# Initializes UI visibility or question depending on state
func Start():
	if Question == -1 : 
		$Panel/Player1.visible = true
		$Panel/Player2.visible = false
		return
	
	if $Question.visible:
		RefreshQuestion()
		if Curr_Player == 1:
			$Panel/Player1.visible = true
			$Panel/Player2.visible = false
		elif Curr_Player == 2:
			$Panel/Player1.visible = false
			$Panel/Player2.visible = true
	else:
		RefreshMain()
		if game_status[Question] == 0:
			BallPressed(Question)
		if game_status[Question] == 1:
			Curr_Player = 2
			Question = -1
		if game_status[Question] == 2:
			Curr_Player = 1
			Question = -1
		if Curr_Player == 1:
			$Panel/Player1.visible = true
			$Panel/Player2.visible = false
		elif Curr_Player == 2:
			$Panel/Player1.visible = false
			$Panel/Player2.visible = true


func BallPressed(index:int):
	Question = index
	$Question.show()
	$Main.hide()
	Start()

# Updates board tiles, checks end-state, and colors selections
func RefreshMain():
	var index:int = 0
	if not game_status.has(0):
		var prof1 = Globals.data_manager.profiles.get_profile(P1).user_name
		var prof2 = Globals.data_manager.profiles.get_profile(P2).user_name
		Globals.score = str(prof1,"   ",prof2,"\n",Player1Points,"    /    ",Player2Points,)
		if Player1Points > Player2Points:
			Globals.pvp_winner = 1
		elif Player2Points > Player1Points:
			Globals.pvp_winner = 2
		else:
			Globals.pvp_winner = 0
		_award_winner_coin()
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

# Populates UI for the current question card
func RefreshQuestion():
	revelared = false
	var questionData:Dictionary = data["Questions"][Question]
	# add randomization to the answers
	CorrectAnswer = 1
	$Question/QuestionPanel/Question.text = questionData["Question"]
	$Question/AnswerPanel/VBoxContainer/Answer1.text = questionData["Correct"]
	$Question/AnswerPanel/VBoxContainer/Answer2.text = questionData["otherquestion1"]
	$Question/AnswerPanel/VBoxContainer/Answer3.text = questionData["otherquestion2"]
	$Question/AnswerPanel/VBoxContainer/Answer4.text = questionData["otherquestion3"]

var revelared: bool = false

# Processes chosen answer and updates score/turn
func RevealAnswer(button: Button):
	revelared = true
	var stylebox_flat = StyleBoxFlat.new()
	var name_str = str(button.name)
	var index = int(name_str[-1])
	
	if index == CorrectAnswer:
		stylebox_flat.bg_color = Color.GREEN
		game_status[Question] = Curr_Player
		if Curr_Player == 1:
			add_point(P1)
		else:
			add_point(P2)
		wrong = 0
	else:
		wrong +=1
		if wrong == 2:
			game_status[Question] = -1
			wrong = 0
		else:
			# pass turn to the other player after a single wrong attempt
			Curr_Player = 2 if Curr_Player == 1 else 1
		stylebox_flat.bg_color = Color.RED
	
	button.add_theme_stylebox_override("normal", stylebox_flat)
	button.add_theme_stylebox_override("hover", stylebox_flat)
	await get_tree().create_timer(1.0).timeout
	$Question.hide()
	$Main.show()
	button.remove_theme_stylebox_override("normal")
	button.remove_theme_stylebox_override("hover")
	Start()

func add_point(player:String ):
	var PlayerObject:ProfileObject = Globals.data_manager.profiles.get_profile(player)
	PlayerObject.elo += 1
	if player == P1 :
		Player1Points+=1
	else :
		Player2Points+=1
	Globals.data_manager.profiles.save_profile(PlayerObject)
	
func _award_winner_coin() -> void:
	if winner_coin_awarded:
		return
	var winner_id := ""
	if Globals.pvp_winner == 1:
		winner_id = P1
	elif Globals.pvp_winner == 2:
		winner_id = P2
	else:
		return
	var winner_profile: ProfileObject = Globals.data_manager.profiles.get_profile(winner_id)
	if winner_profile == null:
		return
	winner_profile.coins += 100
	Globals.data_manager.profiles.save_profile(winner_profile)
	winner_coin_awarded = true
	

func _on_answer_1_button_down() -> void:
	var button:Button = $Question/AnswerPanel/VBoxContainer/Answer1
	if revelared:
		return
	RevealAnswer(button)

func _on_answer_2_button_down() -> void:
	var button:Button = $Question/AnswerPanel/VBoxContainer/Answer2
	if revelared:
		return
	RevealAnswer(button)	

func _on_answer_3_button_down() -> void:
	var button:Button = $Question/AnswerPanel/VBoxContainer/Answer3
	if revelared:
		return
	RevealAnswer(button)

func _on_answer_4_button_down() -> void:
	var button:Button = $Question/AnswerPanel/VBoxContainer/Answer4
	if revelared:
		return
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
	if Globals.data_manager.app_config.get_config().opponent != "":
		get_tree().change_scene_to_file("res://src/scenes/PvPGame/PvPGame.tscn")

func _on_leave_button_down() -> void:
	var config = Globals.data_manager.app_config.get_config()
	config.opponent = ""
	Globals.data_manager.app_config.save_config(config)
	var prof1 = Globals.data_manager.profiles.get_profile(P1)
	prof1.elo -= Player1Points
	Globals.data_manager.profiles.save_profile(prof1)
	var prof2 = Globals.data_manager.profiles.get_profile(P2)
	prof2.elo -= Player2Points
	Globals.data_manager.profiles.save_profile(prof2)
	get_tree().change_scene_to_file("res://src/scenes/PvPMainPageTmp.tscn")


func _on_grid_container_ready() -> void:
	var container: GridContainer = $"Panel/ScrollContainer/GridContainer"
	for child in container.get_children():
		child.queue_free()
	var profiles: Array[ProfileObject] = Globals.data_manager.profiles.get_all_profiles()
	var config: AppConfigObject = Globals.data_manager.app_config.get_config()
	P2 = config.opponent
	var button_group := ButtonGroup.new()
	for profile in profiles:
		if profile.id == config.user_id:
			continue
		var button := Button.new()
		button.text = profile.user_name
		button.toggle_mode = true
		button.button_group = button_group
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(Callable(self, "_on_opponent_selected").bind(profile.id))
		container.add_child(button)
		if profile.id == P2:
			button.set_pressed_no_signal(true)
	_update_start_button_state()

func _on_opponent_selected(opponent_id: String) -> void:
	P2 = opponent_id
	var config: AppConfigObject = Globals.data_manager.app_config.get_config()
	config.opponent = opponent_id
	Globals.data_manager.app_config.save_config(config)
	_update_start_button_state()

func _update_start_button_state() -> void:
	var start_button: Button = get_node_or_null("Panel/Start")
	if start_button:
		start_button.disabled = P2 == ""
