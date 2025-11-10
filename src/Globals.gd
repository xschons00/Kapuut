extends Node
# global constants and utilities 

var data_manager: DataManager
var data_seed: DataSeed
var menu_scene = preload("res://src/scenes/components/Menu.tscn")
var menu: Control
var GameTheme: String = "DANODREVO" # default je None, ale pre testovanie to bude toto
var GameInstance : GameController

signal menu_refresh_signal()

const default_profile_pic = "res://assets/icons/icon.svg"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#data init
	data_manager = DataManager.get_instance()
	data_seed = DataSeed.get_instance()
	data_manager.clear_data()
	data_seed.seed()
	#menu setup
	_init_menu()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _init_menu():
	if menu == null:
		var inst = menu_scene.instantiate()
		inst.name = "Menu"
		menu = inst
		get_tree().root.add_child(menu)
		menu.show()


func add_menu(target: Node) -> Node:
	if menu == null:
		_init_menu()
	var current_parent = menu.get_parent()
	if current_parent and current_parent != target:
		current_parent.remove_child(menu)
	if menu.get_parent() != target:
		target.add_child(menu)
	return menu
		
func show_warning(text: String):
	var popup = PopupPanel.new()
	popup.name = "WarningPopup"
	popup.set_exclusive(true)
	#popup.modulate = Color(1, 0, 0)
	
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	popup.add_child(label)
	get_tree().root.add_child(popup)
	popup.popup_centered(Vector2(500, 100))
	await get_tree().create_timer(1.0).timeout
	popup.queue_free()
