extends Control

# scene paths
var main_page_path: String = "res://src/scenes/MainPage.tscn"

# nodes
@onready var price_selector_container: VBoxContainer = $MainContainer/LeftPanel/PriceSelector/VBoxContainer
@onready var wheel_container: CenterContainer = $MainContainer/CenterPanel/VBox/WheelContainer
@onready var history_container: VBoxContainer = $MainContainer/RightPanel/HistoryPanel/ScrollContainer/VBoxContainer
@onready var balance_label: Label = $BottomBar/StatsContainer/BalanceContainer/BalanceValue
@onready var win_label: Label = $BottomBar/StatsContainer/WinContainer/WinValue
@onready var spin_button: Button = $MainContainer/CenterPanel/VBox/SpinButton

# vars
var selected_price: int = 100
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
var placeholder_node: Node2D = null
var question_color: Color = Color(0.17254902, 0.24313726, 0.3137255, 1)
var container_fill_color: Color = Color(0.10196078, 0.10196078, 0.10196078, 1)
var neon_color: Color = Color(0.30588236, 0.8039216, 0.77254903, 1)
var is_spinning: bool = false 
var center_skull_label: Label = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_data_manager()
	_load_user_data()
	_setup_price_options()
	_update_stats_display()
	_update_history_display()
	_create_placeholder_wheel()
	_create_wheel_pointer()
	_connect_spin_button()
	
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

	# Load spin history
	var profiles_dict = data_manager.profiles._get_section("profiles")
	var profile_data = profiles_dict.get(current_user_id, {})
	var history_data = profile_data.get("spin_history", [])

	if typeof(history_data) == TYPE_ARRAY:
		spin_history = history_data
	else:
		spin_history = []

	# Load last win
	if spin_history.size() > 0:
		last_win = spin_history[0].get("win", 0)
	else:
		last_win = 0

func _save_user_data() -> void:
	# Load current profile
	var profile = data_manager.profiles.get_profile(current_user_id)
	if profile == null:
		print("Error: Cannot save, profile not found")
		return

	# Update balance
	profile.coins = user_balance

	# Save profile
	data_manager.profiles.save_profile(profile)

	# Save spin history
	var profiles_dict = data_manager.profiles._get_section("profiles")
	if profiles_dict.has(current_user_id):
		profiles_dict[current_user_id]["spin_history"] = spin_history
		data_manager.profiles._save_section("profiles", profiles_dict)

func _setup_price_options() -> void:
	# Setup price option buttons - skip the label (first child)
	for i in range(1, price_selector_container.get_child_count()):
		var child = price_selector_container.get_child(i)
		if child is Button:
			child.connect("pressed", Callable(self, "_on_price_option_pressed").bind(child))
	
	# Set default selected - Option100 is at index 2 (after Label and Option25)
	if price_selector_container.get_child_count() > 2:
		var default_button = price_selector_container.get_child(2)	# 100 credits option
		if default_button is Button:
			default_button.modulate = neon_color

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

	if "25" == text:
		selected_price = 25
	elif "100" == text:
		selected_price = 100
	elif "250" == text:
		selected_price = 250
	elif "1000" == text:
		selected_price = 1000
	
	print("Selected price: ", selected_price)

func _update_stats_display() -> void:
	balance_label.text = str(user_balance) + " credits"
	win_label.text = str(last_win) + " credits"

func _update_history_display() -> void:
	# Clear existing history items (keep first child - label)
	for child in history_container.get_children():
		child.queue_free()

	# If no spins yet, show message
	if spin_history.size() == 0:
		var empty_label = Label.new()
		empty_label.text = "Zatiaľ si netočil kolesom.\nSkús svoje šťastie!"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		empty_label.add_theme_font_size_override("font_size", 16)
		empty_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.6))
		empty_label.custom_minimum_size = Vector2(0, 200)
		history_container.add_child(empty_label)
		return

	# Display all history
	for i in range(spin_history.size()):
		var spin_data = spin_history[i]
		var history_item = _create_history_item(spin_data)
		history_container.add_child(history_item)

func _create_history_item(spin_data: Dictionary) -> Panel:
	var panel = Panel.new()
	panel.self_modulate = Color(0.1764706, 0.2901961, 0.2901961, 1)
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
	cost_label.text = "(" + str(spin_data.cost) + " kreditov)"
	cost_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
	cost_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(cost_label)

	# Result HBox
	var hbox = HBoxContainer.new()
	vbox.add_child(hbox)

	# Result text
	var result_label = Label.new()
	var multiplier = spin_data.multiplier
	if typeof(multiplier) == TYPE_STRING:
		result_label.text = "? → 0 kreditov"
	else:
		result_label.text = "%.1fx → %d kreditov" % [multiplier, spin_data.win]
	result_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	result_label.add_theme_color_override("font_color", neon_color)
	result_label.add_theme_font_size_override("font_size", 13)
	hbox.add_child(result_label)

	# Profit label
	var profit_label = Label.new()
	var profit = spin_data.profit
	if profit > 0:
		profit_label.text = "+" + str(profit)
		profit_label.add_theme_color_override("font_color", Color(0.18039216, 0.8, 0.44313726, 1))
	elif profit < 0:
		profit_label.text = str(profit)
		profit_label.add_theme_color_override("font_color", Color(0.8, 0.18039216, 0.18039216, 1))
	else:
		profit_label.text = "0"
		profit_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
	profit_label.add_theme_font_size_override("font_size", 13)
	hbox.add_child(profit_label)

	return panel

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(main_page_path)

func _on_spin_button_pressed() -> void:
	print("Spin wheel with price: ", selected_price)
	_spin_wheel()

func _create_placeholder_wheel() -> void:
	placeholder_node = Node2D.new()
	placeholder_node.name = "PlaceholderWheel"
	wheel_container.add_child(placeholder_node)

	placeholder_node.position = Vector2(200, 200)

	var wheel_radius: float = 180.0
	var border_width: float = 3.0

	# Neon border circle (outer)
	var outer_circle = Polygon2D.new()
	outer_circle.name = "OuterBorder"
	outer_circle.color = neon_color

	var outer_points: PackedVector2Array = []
	var segments: int = 64
	for i in range(segments):
		var angle: float = (float(i) / float(segments)) * TAU
		var point: Vector2 = Vector2(cos(angle), sin(angle)) * (wheel_radius + border_width)
		outer_points.append(point)

	outer_circle.polygon = outer_points
	placeholder_node.add_child(outer_circle)

	# Dark filler circle (inner)
	var circle = Polygon2D.new()
	circle.name = "Circle"
	circle.color = container_fill_color

	var points: PackedVector2Array = []
	for i in range(segments):
		var angle: float = (float(i) / float(segments)) * TAU
		var point: Vector2 = Vector2(cos(angle), sin(angle)) * wheel_radius
		points.append(point)

	circle.polygon = points
	placeholder_node.add_child(circle)

	# Text "¿ Kapuut ?"
	var label = Label.new()
	label.text = "¿ Kapuut ?"
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position = Vector2(-80, -20)	# Center approximately
	placeholder_node.add_child(label)

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

	# Add multiplier segments with random values 0.0 to 3.0
	for i in range(multiplier_count):
		var multiplier: float = randf() * 3.0
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
	var t: float = multiplier / 3.0  # Normalize to 0.0-1.0

	var dark_blue: Color = Color(0.2, 0.3, 0.4)
	var light_blue: Color = Color(0.31, 0.8, 0.77)

	return dark_blue.lerp(light_blue, t)

func _create_wheel() -> void:
	wheel_node = Node2D.new()
	wheel_node.name = "Wheel"
	wheel_container.add_child(wheel_node)

	wheel_node.position = Vector2(200, 200)

	var wheel_radius: float = 180.0
	var border_width: float = 3.0

	# Background circle
	var background_circle = _create_background_circle(wheel_radius + border_width, neon_color)
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

func _create_wheel_pointer() -> void:
	var pointer = Node2D.new()
	pointer.name = "WheelPointer"
	pointer.z_index = 50  # Above wheel
	wheel_container.add_child(pointer)
	pointer.position = Vector2(200, 200)

	# White triangle (outer)
	var outer_triangle = Polygon2D.new()
	var outer_points: PackedVector2Array = []
	outer_points.append(Vector2(-25, -198))		# Top left
	outer_points.append(Vector2(25, -198))		# Top right
	outer_points.append(Vector2(0, -165.35))	# Bottom
	outer_triangle.polygon = outer_points
	outer_triangle.color = Color.WHITE
	pointer.add_child(outer_triangle)

	# Blue triangle (inner)
	var inner_triangle = Polygon2D.new()
	var inner_points: PackedVector2Array = []
	inner_points.append(Vector2(-20, -195.5))	# Top left
	inner_points.append(Vector2(20, -195.5))	# Top right
	inner_points.append(Vector2(0, -170))		# Bottom
	inner_triangle.polygon = inner_points
	inner_triangle.color = neon_color
	pointer.add_child(inner_triangle)

func _create_center_skull() -> void:
	# Only create on first spin
	if center_skull_label == null:
		center_skull_label = Label.new()
		center_skull_label.name = "CenterSkull"
		center_skull_label.text = "💀"
		center_skull_label.add_theme_font_size_override("font_size", 40)
		center_skull_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		center_skull_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		center_skull_label.position = Vector2(200 - 20, 200 - 20)
		center_skull_label.z_index = 100
		wheel_container.add_child(center_skull_label)

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
		var t: float = float(j) / float(segments_per_arc)
		var angle: float = lerp(start_angle, end_angle, t)
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

	var label_angle_deg: float = -96.0 + (index * 30.0) + 15.0
	var label_angle_rad: float = deg_to_rad(label_angle_deg)

	var label_distance: float = radius * 0.9
	label.position = Vector2(cos(label_angle_rad), sin(label_angle_rad)) * label_distance

	label.rotation = label_angle_rad + deg_to_rad(96.0)

	return label

func _create_background_circle(radius: float, color: Color) -> Polygon2D:
	var circle = Polygon2D.new()
	circle.name = "BackgroundCircle"
	circle.color = color

	var points: PackedVector2Array = []
	var segments: int = 64
	for i in range(segments):
		var angle: float = (float(i) / float(segments)) * TAU
		var point: Vector2 = Vector2(cos(angle), sin(angle)) * radius
		points.append(point)

	circle.polygon = points
	return circle

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

func _spin_wheel() -> void:
	if is_spinning:
		return

	if user_balance < selected_price:
		print("Not enough credits!")
		return

	is_spinning = true
	spin_button.disabled = true

	# Hide placeholder wheel on first spin
	if placeholder_node:
		placeholder_node.queue_free()
		placeholder_node = null

	# Skull emoji
	_create_center_skull()

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
		win_amount = int(selected_price * winning_value)

	var profit: int = win_amount - selected_price

	# Update balance
	user_balance -= selected_price
	user_balance += win_amount

	# Create history entry
	var spin_entry: Dictionary = {
		"cost": selected_price,
		"multiplier": winning_value,
		"win": win_amount,
		"profit": profit
	}
	spin_history.insert(0, spin_entry)
	last_win = win_amount
	_save_user_data()

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

		is_spinning = false
		spin_button.disabled = false
	)
