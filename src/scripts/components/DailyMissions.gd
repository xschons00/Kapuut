extends Control

# Nodes
@onready var background_panel: Panel = $BackgroundPanel
@onready var status_label: Label = $Header/StatusLabel
@onready var collapsed_click_area: Button = $CollapsedClickArea
@onready var expanded_content: VBoxContainer = $ExpandedContent
@onready var click_detector: Control = $ClickDetector

@onready var mission1_progress: Label = $ExpandedContent/Mission1/Progress
@onready var mission2_progress: Label = $ExpandedContent/Mission2/Progress
@onready var mission3_progress: Label = $ExpandedContent/Mission3/Progress
@onready var claim_button: Button = $ExpandedContent/ClaimButton

# Vars
var config: AppConfigObject
var current_user_id: String
var is_expanded: bool = false

# Mission targets
const FLASHCARDS_TARGET: int = 10
const PVP_TARGET: int = 3
const LUCKY_MODE_TARGET: int = 20

# Size constants
const COLLAPSED_HEIGHT: float = 100.0
const EXPANDED_HEIGHT: float = 532.0

func _ready() -> void:
	Globals.connect("refresh_menu_signal", _on_refresh_signal)
	_load_mission_progress()

func _on_refresh_signal() -> void:
	_load_mission_progress()

func _load_mission_progress() -> void:
	config = Globals.data_manager.app_config.get_config()
	if config == null:
		print("ERROR: config not found")
		return

	current_user_id = config.user_id
	var user: ProfileObject = Globals.data_manager.profiles.get_profile(current_user_id)
	if user == null:
		print("ERROR: user not found")
		return

	# Get mission progress from raw profile data
	var profiles_dict = Globals.data_manager.profiles._get_section("profiles")
	if not profiles_dict.has(current_user_id):
		return

	var profile_data = profiles_dict[current_user_id]

	# Initialize missions if not exist
	if not profile_data.has("daily_missions"):
		profile_data["daily_missions"] = {
			"flashcards": 0,
			"pvp": 0,
			"lucky_mode": 0
		}
		Globals.data_manager.profiles._save_section("profiles", profiles_dict)

	var missions = profile_data["daily_missions"]
	var flashcards_progress: int = missions.get("flashcards", 0)
	var pvp_progress: int = missions.get("pvp", 0)
	var lucky_mode_progress: int = missions.get("lucky_mode", 0)

	# Update UI
	mission1_progress.text = str(flashcards_progress) + "/" + str(FLASHCARDS_TARGET)
	mission2_progress.text = str(pvp_progress) + "/" + str(PVP_TARGET)
	mission3_progress.text = str(lucky_mode_progress) + "/" + str(LUCKY_MODE_TARGET)

	# Count completed missions
	var completed: int = 0
	if flashcards_progress >= FLASHCARDS_TARGET:
		completed += 1
	if pvp_progress >= PVP_TARGET:
		completed += 1
	if lucky_mode_progress >= LUCKY_MODE_TARGET:
		completed += 1

	status_label.text = str(completed) + "/3 completed"

	# Enable/disable claim button
	claim_button.disabled = (completed < 3)

func _on_click_area_pressed() -> void:
	if is_expanded:
		_collapse()
	else:
		_expand()

func _on_click_detector_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_collapse()

func _expand() -> void:
	if is_expanded:
		return
	is_expanded = true

	# Expand the root control
	offset_bottom = offset_top + EXPANDED_HEIGHT

	# Show expanded content
	expanded_content.visible = true
	click_detector.visible = true

func _collapse() -> void:
	if not is_expanded:
		return
	is_expanded = false

	# Collapse the root control
	offset_bottom = offset_top + COLLAPSED_HEIGHT

	# Hide expanded content
	expanded_content.visible = false
	click_detector.visible = false

func _on_claim_button_pressed() -> void:
	# Get profile data
	var profiles_dict = Globals.data_manager.profiles._get_section("profiles")
	if not profiles_dict.has(current_user_id):
		print("ERROR: Cannot claim, profile not found")
		return

	var profile_data = profiles_dict[current_user_id]

	# Reset missions
	profile_data["daily_missions"] = {
		"flashcards": 0,
		"pvp": 0,
		"lucky_mode": 0
	}

	# Add 500 coins
	var current_coins: int = profile_data.get("coins", 0)
	profile_data["coins"] = current_coins + 500

	# Save
	Globals.data_manager.profiles._save_section("profiles", profiles_dict)

	# Reload UI
	_load_mission_progress()

	# Refresh menu to update coins display
	Globals.emit_signal("refresh_menu_signal")

# Public function to increment mission progress
func increment_mission(mission_type: String) -> void:
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

	# Reload UI
	_load_mission_progress()
