extends Control

# scene paths
var main_page_path: String = "res://src/scenes/MainPage.tscn"

# nodes
@onready var price_selector_container: VBoxContainer = $MainContainer/LeftPanel/PriceSelector/VBoxContainer
@onready var wheel_container: Control = $MainContainer/CenterPanel/WheelContainer
@onready var history_container: VBoxContainer = $MainContainer/RightPanel/HistoryPanel/ScrollContainer/VBoxContainer
@onready var balance_label: Label = $BottomBar/StatsContainer/BalanceContainer/BalanceValue
@onready var win_label: Label = $BottomBar/StatsContainer/WinContainer/WinValue
@onready var spin_button: Button = $MainContainer/CenterPanel/SpinButton

# vars
var selected_price: int = 100
var user_balance: int = 12500
var last_win: int = 0
var spin_history: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_price_options()
	_update_stats_display()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _setup_price_options() -> void:
	# Setup price option buttons - skip the label (first child)
	for i in range(1, price_selector_container.get_child_count()):
		var child = price_selector_container.get_child(i)
		if child is Button:
			child.connect("pressed", Callable(self, "_on_price_option_pressed").bind(child))
	
	# Set default selected - Option100 is at index 2 (after Label and Option25)
	if price_selector_container.get_child_count() > 2:
		var default_button = price_selector_container.get_child(2) # 100 credits option
		if default_button is Button:
			default_button.modulate = Color(0.31, 0.8, 0.77) # highlight color

func _on_price_option_pressed(button: Button) -> void:
	# Reset all buttons colors (skip Label at index 0)
	for i in range(1, price_selector_container.get_child_count()):
		var child = price_selector_container.get_child(i)
		if child is Button:
			child.modulate = Color(1, 1, 1)
	
	# Highlight selected button
	button.modulate = Color(0.31, 0.8, 0.77)
	
	# Extract price from button text
	var text = button.text.strip_edges()
	if "25" in text:
		selected_price = 25
	elif "100" in text:
		selected_price = 100
	elif "250" in text:
		selected_price = 250
	elif "1000" in text:
		selected_price = 1000
	
	print("Selected price: ", selected_price)

func _update_stats_display() -> void:
	balance_label.text = str(user_balance) + " credits"
	win_label.text = str(last_win) + " credits"

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(main_page_path)

func _on_spin_button_pressed() -> void:
	print("Spin wheel with price: ", selected_price)
	# TODO: Implement wheel spinning logic
