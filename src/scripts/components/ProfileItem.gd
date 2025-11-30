extends Control

# Signals
signal profile_selected_signal(user: ProfileObject)
signal profile_delete_signal(user: ProfileObject)

# nodes
@onready var profile_rect: TextureRect = $ColorRect/profile_rect
@onready var user_label: Label = $VBoxContainer/user_label
@onready var elo_label: Label = $VBoxContainer/HBoxContainer/elo_label

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
	if ResourceLoader.exists(user.profile_pic):
		profile_rect.texture = load(user.profile_pic)
	else:
		profile_rect.texture = load(Globals.default_profile_pic) #fallback
		
	user_label.text = user.user_name
	elo_label.text = str(user.elo)


func _on_select_button_pressed() -> void:
	emit_signal("profile_selected_signal", user)
	
func _on_delete_button_pressed() -> void:
	emit_signal("profile_delete_signal", user)
