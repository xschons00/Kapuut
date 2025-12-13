extends Control

# Signals
signal profile_selected_signal(user: ProfileObject)
signal profile_delete_signal(user: ProfileObject)

# nodes
@onready var avatar_rect: TextureRect = $ColorRect/avatar_rect
@onready var background_rect: TextureRect = $ColorRect/background_rect
@onready var user_label: Label = $VBoxContainer/user_label
@onready var elo_label: Label = $VBoxContainer/HBoxContainer/elo_label
@onready var coins_label: Label = $VBoxContainer/HBoxContainer2/coins_label

#vars
var user: ProfileObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_profile_data(user_obj: ProfileObject) -> void:
	user = user_obj
	if ResourceLoader.exists(user.profile_pic) and ResourceLoader.exists(user.background_pic):
		background_rect.texture = load(user.background_pic)
		avatar_rect.texture = load(user.profile_pic)
	else:
		background_rect.texture = load(Globals.default_profile_background)
		avatar_rect.texture = load(Globals.default_profile_pic) #fallback
		
	user_label.text = user.user_name
	elo_label.text = str(user.elo)
	coins_label.text = str(user.coins)


func _on_select_button_pressed() -> void:
	emit_signal("profile_selected_signal", user)
	
func _on_delete_button_pressed() -> void:
	emit_signal("profile_delete_signal", user)
