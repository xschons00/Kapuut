extends Control

# Signals
signal avatar_selected_signal(picture_path: String)

#nodes
@onready var container: GridContainer = $ColorRect/GridContainer

#vars
var is_open: bool = false
var new_avatar_path: String
var avatar_images: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	self.visible = false
	for button in container.get_children():
		if button is Button and button.name.contains("avatar"): #only for avatar buttons
			var obj = AvatarItem.new()
			
			obj.item_name = button.name.substr(0, 7) #first 7 char (avatarN)
			var obj_index: int = int(obj.item_name.substr(6, 7))
			print("item name: ", obj.item_name, ", index: ", obj_index)
			obj.item_path = button.get_node("TextureRect").texture.resource_path
			if obj_index <= 3:
				obj.is_unlocked = true
				obj.price = 0
			elif obj_index > 3 and obj_index <= 6:
				obj.is_unlocked = false
				obj.price = 500
			else:
				obj.is_unlocked = false
				obj.price = 750
			
			if not avatar_images.has(obj_index):
				avatar_images[obj_index] = obj
			if obj.is_unlocked:
				button.connect("pressed", Callable(self, "_on_avatar_button_pressed").bind(button))
			else:
				Globals.set_greyscale(button.get_node("TextureRect"))


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
		
	
