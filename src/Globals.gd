# Author: xschons00
# Description: Global setup, default resources, and helper utilities.

extends Node
# global constants and utilities 

signal refresh_menu_signal

var data_manager: DataManager
var data_seed: DataSeed
var menu_scene = preload("res://src/scenes/components/Menu.tscn")
var menu: Control
var GameTheme: String = "DANODREVO" # default je None, ale pre testovanie to bude toto
var score : String 
var pvp_winner: int = 0 # 0 = tie, 1 = user, 2 = opponent
var pvp_user_elo_gain: int = 0
var pvp_opponent_elo_gain: int = 0
var pvp_user_coins_gain: int = 0
var pvp_opponent_coins_gain: int = 0
var flash_known_count: int = 0
var flash_total_questions: int = 0
var greyscale_shader: Shader = preload("res://assets/shaders/greyscale.gdshader")
var greyscale: ShaderMaterial

const default_profile_background = "res://assets/backgrounds/blue_bg.png"
const default_profile_pic = "res://assets/avatars/avatar1.png"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#data init
	data_manager = DataManager.get_instance()
	data_seed = DataSeed.get_instance()
	data_manager.clear_data()
	data_seed.seed()
	data_seed.test_seed()
	#menu setup
	_init_menu()
	greyscale = ShaderMaterial.new()
	greyscale.shader = greyscale_shader
	
	
# Creates and attaches menu singleton if missing
func _init_menu():
	if menu != null:
		return
	menu = menu_scene.instantiate()
	menu.name = "Menu"


func add_menu(target: Node) -> Node:
	if menu == null:
		_init_menu()
	if menu.get_parent() == target:
		return menu
	var current_parent := menu.get_parent()
	if current_parent:
		current_parent.remove_child.call_deferred(menu)

	target.add_child.call_deferred(menu)
	menu.show.call_deferred()
	return menu
		
# Shows a short-lived warning popup
func show_warning(text: String):
	var popup := PopupPanel.new()
	popup.name = "WarningPopup"
	popup.set_exclusive(true)

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.12, 0.12, 1.0) # solid background
	style.border_color = Color("ff8419")

	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3

	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8

	popup.add_theme_stylebox_override("panel", style)

	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	popup.add_child(label)
	get_tree().root.add_child(popup)

	popup.popup_centered(Vector2(500, 100))
	await get_tree().create_timer(1.0).timeout
	popup.queue_free()

	
# Toggle greyscale material on texture rects
func set_greyscale(rect: TextureRect, enabled: bool = true) -> void:
	if enabled:
		rect.material = greyscale
	else:
		rect.material = null
