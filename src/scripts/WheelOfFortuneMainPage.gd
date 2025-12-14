# Author:
# Description: Wheel of Fortune game flow, UI wiring, and persistence.

extends Control

# Helper class for drawing circles
class CircleDrawer extends Node2D:
	var radius: float
	var color: Color

	func _init(p_radius: float, p_color: Color):
		radius = p_radius
		color = p_color

	func _draw():
		draw_circle(Vector2.ZERO, radius, color)

# nodes
@onready var menu: Control = $Menu
@onready var daily_missions: Control = $DailyMissions
@onready var coins_label: Label = $Menu/menu_panel/profile_area/coins_label
@onready var price_selector_container: VBoxContainer = $MainContainer/LeftPanel/PriceSelector/VBoxContainer
@onready var wheel_container: CenterContainer = $MainContainer/CenterPanel/VBox/WheelContainer
@onready var history_container: VBoxContainer = $MainContainer/RightPanel/HistoryPanel/ScrollContainer/VBoxContainer
@onready var empty_history_label: Label = $MainContainer/RightPanel/HistoryPanel/ScrollContainer/VBoxContainer/EmptyHistoryLabel
@onready var spin_button: Button = $MainContainer/CenterPanel/VBox/SpinButton
@onready var error_label: Label = $ErrorLabel
@onready var placeholder_wheel: Node2D = $MainContainer/CenterPanel/VBox/WheelContainer/PlaceholderWheel
@onready var center_skull_label: Label = $MainContainer/CenterPanel/VBox/WheelContainer/CenterSkull
@onready var question_popup: Panel = $QuestionPopup
@onready var question_label: Label = $QuestionPopup/PopupContainer/PopupPanel/VBoxContainer/QuestionLabel
@onready var answer_buttons: Array = [
	$QuestionPopup/PopupContainer/PopupPanel/VBoxContainer/AnswersContainer/Answer1,
	$QuestionPopup/PopupContainer/PopupPanel/VBoxContainer/AnswersContainer/Answer2,
	$QuestionPopup/PopupContainer/PopupPanel/VBoxContainer/AnswersContainer/Answer3,
	$QuestionPopup/PopupContainer/PopupPanel/VBoxContainer/AnswersContainer/Answer4
]

# vars
var selected_price: int
var user_balance: int
var last_win: int
var spin_history: Array  # Array of {cost: int, multiplier: float/string, win: int, profit: int}
var current_user_id: String
var data_manager

# wheel vars
var wheel_segments: Array = []		# Multipliers or "?"
var segment_colors: Array = []		# Colors for each segment
var segment_angle: float = 30.0		# 360 / 12 segments = 30
var wheel_node: Node2D = null
var is_spinning: bool = false

# color constants (rounded to 3 decimal places)
var neon_color: Color = Color(0.306, 0.804, 0.773, 1.0)
var container_fill_color: Color = Color(0.102, 0.102, 0.102, 1.0)
var question_color: Color = Color(0.173, 0.243, 0.314, 1.0)
var history_panel_color: Color = Color(0.176, 0.290, 0.290, 1.0)
var correct_answer_color: Color = Color(0.180, 0.800, 0.443, 1.0)
var incorrect_answer_color: Color = Color(0.800, 0.180, 0.180, 1.0)
var text_secondary_color: Color = Color(1.0, 1.0, 1.0, 0.7)
var text_tertiary_color: Color = Color(1.0, 1.0, 1.0, 0.6)
var dark_blue_color: Color = Color(0.200, 0.300, 0.400, 1.0)
var light_blue_color: Color = Color(0.310, 0.800, 0.770, 1.0)

# question vars
var current_question_correct_answer: String = ""
var question_multiplier: float = 2.5
var current_spin_price: int = 0  # Price locked at spin time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_data_manager()
	_load_user_data()
	_setup_price_options()
	_update_stats_display()
	_update_history_display()
	_connect_spin_button()
	_create_placeholder_circles()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _load_data_manager() -> void:
	data_manager = DataManager.get_instance()

func _load_user_data() -> void:
	# Load current user ID
	var app_config = data_manager.app_config.get_config()
	if app_config == null:
		print("Error: No app config found")
		return
	current_user_id = app_config.user_id

	# Load user profile
	var profile = data_manager.profiles.get_profile(current_user_id)
	if profile == null:
		print("Error: No profile found for user_id: ", current_user_id)
		return

	# Load user balance
	user_balance = profile.coins

	# Load extra data from raw dict
	var profiles_dict = data_manager.profiles._get_section("profiles")
	var profile_data = profiles_dict.get(current_user_id, {})

	# Load spin history (default empty array)
	var history_data = profile_data.get("spin_history", [])
	if typeof(history_data) == TYPE_ARRAY:
		spin_history = history_data
	else:
		spin_history = []

	# Load selected price (default 50)
	selected_price = profile_data.get("selected_price", 50)

	# Load last win
	if spin_history.size() > 0:
		last_win = spin_history[0].get("win", 0)
	else:
		last_win = 0

func _save_user_data() -> void:
	# Get profiles dictionary
	var profiles_dict = data_manager.profiles._get_section("profiles")
	if not profiles_dict.has(current_user_id):
		print("Error: Cannot save, profile not found in dictionary")
		return

	# Update all data in one place
	profiles_dict[current_user_id]["coins"] = user_balance
	profiles_dict[current_user_id]["spin_history"] = spin_history
	profiles_dict[current_user_id]["selected_price"] = selected_price

	# Save everything at once
	data_manager.profiles._save_section("profiles", profiles_dict)

func _setup_price_options() -> void:
	# Setup price option buttons - skip the label (first child)
	for i in range(1, price_selector_container.get_child_count()):
		var child = price_selector_container.get_child(i)
		if child is Button:
			child.connect("pressed", Callable(self, "_on_price_option_pressed").bind(child))

			# Highlight button if it matches selected_price
			var text = child.text.split(" ")[0]
			var button_price = 0
			if "50" == text:
				button_price = 50
			elif "100" == text:
				button_price = 100
			elif "250" == text:
				button_price = 250
			elif "1000" == text:
				button_price = 1000

			if button_price == selected_price:
				child.modulate = neon_color
			else:
				child.modulate = Color.WHITE

func _on_price_option_pressed(button: Button) -> void:
	# Reset all buttons colors (skip Label at index 0)
	for i in range(1, price_selector_container.get_child_count()):
		var child = price_selector_container.get_child(i)
		if child is Button:
			child.modulate = Color.WHITE
	
	# Highlight selected button
	button.modulate = neon_color
	
	# Extract price from button text
	var text = button.text.split(" ")[0]

	if "50" == text:
		selected_price = 50
	elif "100" == text:
		selected_price = 100
	elif "250" == text:
		selected_price = 250
	elif "1000" == text:
		selected_price = 1000

	# Save selected price to profile
	var profiles_dict = data_manager.profiles._get_section("profiles")
	if profiles_dict.has(current_user_id):
		profiles_dict[current_user_id]["selected_price"] = selected_price
		data_manager.profiles._save_section("profiles", profiles_dict)

	print("Selected price: ", selected_price)

func _update_stats_display() -> void:
	coins_label.text = str(user_balance)

func _update_history_display() -> void:
	# Clear existing history items (except EmptyHistoryLabel)
	for child in history_container.get_children():
		if child != empty_history_label:
			child.queue_free()

	# If no spins yet, show empty message
	if spin_history.size() == 0:
		empty_history_label.visible = true
		return

	# Hide empty message and display history
	empty_history_label.visible = false
	for i in range(spin_history.size()):
		var spin_data = spin_history[i]
		var history_item = _create_history_item(spin_data)
		history_container.add_child(history_item)

func _create_history_item(spin_data: Dictionary) -> Panel:
	var panel = Panel.new()
	panel.self_modulate = history_panel_color
	panel.custom_minimum_size = Vector2(0, 60)

	var vbox = VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left = 15
	vbox.offset_top = 12
	vbox.offset_right = -15
	vbox.offset_bottom = -12
	panel.add_child(vbox)

	# Cost label
	var cost_label = Label.new()
	cost_label.text = "(" + str(int(spin_data.cost)) + " coins)"
	cost_label.add_theme_color_override("font_color", text_secondary_color)
	cost_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(cost_label)

	# Result HBox
	var hbox = HBoxContainer.new()
	vbox.add_child(hbox)

	# Result text
	var result_label = Label.new()
	var multiplier = spin_data.multiplier
	if typeof(multiplier) == TYPE_STRING:
		result_label.text = "? → %d coins" % spin_data.win
	else:
		result_label.text = "%.1fx → %d coins" % [multiplier, spin_data.win]
	result_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	result_label.add_theme_color_override("font_color", neon_color)
	result_label.add_theme_font_size_override("font_size", 13)
	hbox.add_child(result_label)

	# Profit label
	var profit_label = Label.new()
	var profit = spin_data.profit
	if profit > 0:
		profit_label.text = "+" + str(int(profit))
		profit_label.add_theme_color_override("font_color", correct_answer_color)
	elif profit < 0:
		profit_label.text = str(int(profit))
		profit_label.add_theme_color_override("font_color", incorrect_answer_color)
	else:
		profit_label.text = "0"
		profit_label.add_theme_color_override("font_color", text_secondary_color)
	profit_label.add_theme_font_size_override("font_size", 13)
	hbox.add_child(profit_label)

	return panel

func _on_spin_button_pressed() -> void:
	print("Spin wheel with price: ", selected_price)
	_spin_wheel()

func _generate_random_wheel() -> void:
	wheel_segments.clear()
	segment_colors.clear()

	# Random number of "?" segments (3-6)
	var question_count: int = randi() % 4 + 3

	# Remaining segments will be multipliers
	var multiplier_count: int = 12 - question_count

	# Create array of all segments
	var all_segments: Array = []

	# Add "?" segments
	for i in range(question_count):
		all_segments.append("?")

	# Add multiplier segments with random values 0.0 to 2.0
	for i in range(multiplier_count):
		var multiplier: float = randf() * 2.0
		multiplier = snapped(multiplier, 0.1)	# Round to 1 decimal
		all_segments.append(multiplier)

	all_segments.shuffle()
	wheel_segments = all_segments

	# Generate colors for each segment
	for segment in wheel_segments:
		if typeof(segment) == TYPE_STRING:
			# "?" segment
			segment_colors.append(question_color)
		else:
			# Multiplier segment
			segment_colors.append(_get_multiplier_color(segment))

	print("Generated wheel segments: ", wheel_segments)

func _get_multiplier_color(multiplier: float) -> Color:
	# Higher multiplier - lighter blue
	var weight: float = multiplier / 2.0  # Normalize to 0.0-1.0
	return dark_blue_color.lerp(light_blue_color, weight)

func _create_wheel() -> void:
	wheel_node = Node2D.new()
	wheel_node.name = "Wheel"
	wheel_container.add_child(wheel_node)

	wheel_node.position = Vector2(200, 200)

	var wheel_radius: float = 180.0
	var border_width: float = 3.0

	# Background circle
	var background_circle = CircleDrawer.new(wheel_radius + border_width, neon_color)
	wheel_node.add_child(background_circle)

	# Segment color
	for i in range(12):
		var segment = _create_segment(i, wheel_radius, segment_colors[i])
		wheel_node.add_child(segment)

	# Divider lines
	for i in range(12):
		var line = _create_divider_line(i, wheel_radius + border_width, neon_color, border_width)
		wheel_node.add_child(line)

	# Segment Labels
	for i in range(12):
		var label = _create_label(i, wheel_radius)
		wheel_node.add_child(label)

func _create_segment(index: int, radius: float, color: Color) -> Node2D:
	var segment = Node2D.new()
	segment.name = "Segment_" + str(index)

	# Create polygon for the segment
	var polygon = Polygon2D.new()

	# Ssegment 0 starts at 12 o'clock = -90 degrees
	var start_angle_deg: float = -90.0 + (index * segment_angle)
	var end_angle_deg: float = start_angle_deg + segment_angle

	# Convert to radians
	var start_angle: float = deg_to_rad(start_angle_deg)
	var end_angle: float = deg_to_rad(end_angle_deg)

	# Create triangle fan points for the segment
	var points: PackedVector2Array = []
	points.append(Vector2.ZERO)  # Center point

	# Add points along the arc
	var segments_per_arc: int = 10
	for j in range(segments_per_arc + 1):
		var weight: float = float(j) / float(segments_per_arc)
		var angle: float = lerp(start_angle, end_angle, weight)
		var point: Vector2 = Vector2(cos(angle), sin(angle)) * radius
		points.append(point)

	polygon.polygon = points
	polygon.color = color
	segment.add_child(polygon)

	return segment

func _create_label(index: int, radius: float) -> Label:
	var label = Label.new()
	label.name = "Label_" + str(index)

	# Text based on segment type
	var segment_value = wheel_segments[index]
	if typeof(segment_value) == TYPE_STRING:
		label.text = "¿ • ?"
	else:
		label.text = "%.1fx" % segment_value

	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	var label_angle: float = deg_to_rad(-96.0 + (index * 30.0) + 15.0)

	var label_distance: float = radius * 0.9
	label.position = Vector2(cos(label_angle), sin(label_angle)) * label_distance

	label.rotation = label_angle + deg_to_rad(96.0)

	return label

func _create_divider_line(segment_index: int, length: float, color: Color, width: float) -> Line2D:
	var line = Line2D.new()
	line.name = "Divider_" + str(segment_index)
	line.width = width
	line.default_color = color

	var angle_deg: float = -90.0 + (segment_index * segment_angle)
	var angle_rad: float = deg_to_rad(angle_deg)

	# Line from center to edge
	var points: PackedVector2Array = []
	points.append(Vector2.ZERO)
	points.append(Vector2(cos(angle_rad), sin(angle_rad)) * length)

	line.points = points
	return line

func _connect_spin_button() -> void:
	spin_button.connect("pressed", Callable(self, "_on_spin_button_pressed"))

func _create_placeholder_circles() -> void:
	# Create border circle (neon color)
	var border_circle = CircleDrawer.new(183.0, neon_color)
	placeholder_wheel.add_child(border_circle)

	# Create inner circle (dark color)
	var inner_circle = CircleDrawer.new(180.0, container_fill_color)
	placeholder_wheel.add_child(inner_circle)

func _get_random_question() -> Dictionary:
	# Load themes from data.json
	var themes_data = data_manager.themes._get_section("Themes")
	if themes_data == null or themes_data.size() == 0:
		print("Error: No themes found")
		return {}

	# Filter themes that have questions
	var themes_with_questions: Array = []
	for theme_name in themes_data.keys():
		var theme = themes_data[theme_name]
		if theme.has("Questions") and theme["Questions"].size() > 0:
			themes_with_questions.append(theme_name)

	if themes_with_questions.size() == 0:
		print("Error: No themes with questions found")
		return {}

	# Pick random theme
	var random_theme_name = themes_with_questions[randi() % themes_with_questions.size()]
	var random_theme = themes_data[random_theme_name]

	# Pick random question
	var questions = random_theme["Questions"]
	var random_question = questions[randi() % questions.size()]

	return random_question

func _show_question_popup(question_data: Dictionary) -> void:
	if question_data.is_empty():
		print("Error: No question data")
		return

	# Set question text
	question_label.text = question_data["Question"]

	# Store correct answer
	current_question_correct_answer = question_data["Correct"]

	# Create answers array and shuffle
	var answers: Array = [
		question_data["Correct"],
		question_data["otherquestion1"],
		question_data["otherquestion2"],
		question_data["otherquestion3"]
	]
	answers.shuffle()

	# Set button texts and connect signals
	for i in range(4):
		var button: Button = answer_buttons[i]
		button.text = answers[i]
		# Disconnect previous signals if any
		if button.is_connected("pressed", Callable(self, "_on_answer_selected")):
			button.disconnect("pressed", Callable(self, "_on_answer_selected"))
		# Connect new signal
		button.connect("pressed", Callable(self, "_on_answer_selected").bind(answers[i]))
		button.disabled = false
		button.modulate = Color.WHITE

	# Show popup
	question_popup.visible = true

func _on_answer_selected(selected_answer: String) -> void:
	# Disable all buttons
	for button in answer_buttons:
		button.disabled = true

	# Check if answer is correct
	var is_correct: bool = (selected_answer == current_question_correct_answer)

	# Highlight selected answer
	for button in answer_buttons:
		if button.text == selected_answer:
			if is_correct:
				button.modulate = correct_answer_color  # Green
			else:
				button.modulate = incorrect_answer_color  # Red
		# Show correct answer
		if button.text == current_question_correct_answer:
			button.modulate = correct_answer_color  # Green

	# Wait a moment then process result
	await get_tree().create_timer(2.0).timeout

	# If correct, add win amount
	if is_correct:
		var win_amount = int(current_spin_price * question_multiplier)
		user_balance += win_amount
		last_win = win_amount

		# Update history - keep "?" multiplier, but update win and profit
		if spin_history.size() > 0:
			spin_history[0]["win"] = win_amount
			spin_history[0]["profit"] = win_amount - current_spin_price

		# Save updated data
		_save_user_data()

	# Hide popup and update display
	question_popup.visible = false
	_update_stats_display()
	_update_history_display()

	# Re-enable spin button
	is_spinning = false
	spin_button.disabled = false

func _spin_wheel() -> void:
	if is_spinning:
		return

	if user_balance < selected_price:
		print("Not enough coins!")
		# Show error message for 2 seconds
		error_label.visible = true
		await get_tree().create_timer(2.0).timeout
		error_label.visible = false
		return

	# Lock the price at spin time
	current_spin_price = selected_price

	is_spinning = true
	spin_button.disabled = true

	# Hide placeholder wheel and show skull
	placeholder_wheel.visible = false
	center_skull_label.visible = true

	# Generate new random wheel
	_generate_random_wheel()

	# Clear old wheel and create new one
	if wheel_node:
		wheel_node.queue_free()

	_create_wheel()

	# Determine winning segment
	var random_angle: float = randf() * 360.0
	var winning_index: int = int(random_angle / segment_angle)
	var winning_value = wheel_segments[winning_index]

	# Calculate win amount and profit
	var win_amount: int = 0
	if typeof(winning_value) != TYPE_STRING:
		win_amount = int(current_spin_price * winning_value)

	var profit: int = win_amount - current_spin_price

	# Visually deduct the selected price from balance
	coins_label.text = str(user_balance - current_spin_price)

	# Update balance
	user_balance = user_balance - current_spin_price + win_amount

	# Create history entry
	var spin_entry: Dictionary = {
		"cost": current_spin_price,
		"multiplier": winning_value,
		"win": win_amount,
		"profit": profit
	}
	spin_history.insert(0, spin_entry)
	last_win = win_amount

	# Save data
	_save_user_data()

	# Increment lucky mode mission
	daily_missions.increment_mission("lucky_mode")

	print("Random angle: ", random_angle)
	print("Winning segment index: ", winning_index)
	if typeof(winning_value) == TYPE_STRING:
		print("Result: Question segment! Win: 0 credits")
	else:
		print("Winning multiplier: %.1fx" % winning_value)
		print("Win amount: ", win_amount, " credits")
		print("Profit: ", profit, " credits")

	# 6 full rotations + random angle
	var total_rotation: float = (6.0 * 360.0) - random_angle
	var animation_duration: float = 4.0  # seconds

	# Reset wheel rotation
	wheel_node.rotation = 0.0

	# Spinning animation
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)

	tween.tween_property(wheel_node, "rotation", deg_to_rad(total_rotation), animation_duration)

	# Update page after animation
	tween.tween_callback(func():
		_update_stats_display()
		_update_history_display()

		# If question segment, show question popup
		if typeof(winning_value) == TYPE_STRING:
			var question_data = _get_random_question()
			_show_question_popup(question_data)
		else:
			# Normal multiplier segment - re-enable spin button
			is_spinning = false
			spin_button.disabled = false
	)
