extends Button
# Signals
signal item_unlock_signal(item: AvatarItem)

#vars
var item: AvatarItem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_item_data(item_obj: AvatarItem) -> void:
	item = item_obj
	self.text = "Unlock for:\n%d" % item_obj.price

func _on_select_button_pressed() -> void:
	emit_signal("item_unlock_signal",item)
