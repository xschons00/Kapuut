extends Control

# Signals
signal avatar_selected_signal(picture_path: String)

#nodes
@onready var container: GridContainer = $ColorRect/GridContainer

#vars
var is_open: bool = false
var new_avatar_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	for button in container.get_children():
		if button is Button:
			button.connect("pressed", Callable(self, "_on_avatar_button_pressed").bind(button))


func _on_avatar_button_pressed(button: Button) -> void:
	var texture_rect: TextureRect = button.get_node("TextureRect")
	new_avatar_path = texture_rect.texture.resource_path
	emit_signal("avatar_selected_signal", new_avatar_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func switch_visibility() -> void:
	if is_open:
		self.visible = false
		is_open = false
	else:
		self.visible = true
		is_open = true	
	
