# Author: xschons00
# Description: Handles unlocking avatar/background items with coins.

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
	self.text = "unlock for:\n%d coins" % item_obj.price


# Deducts coins and unlocks the selected item
func _on_pressed() -> void:
	var config: AppConfigObject = Globals.data_manager.app_config.get_config()
	if	config == null:
		print("Error: could not load config")
		return
	var user = Globals.data_manager.profiles.get_profile(config.user_id)
	if user == null:
		print("Error: could not load current user")
		return
	if user.coins < item.price:
		Globals.show_warning("Warning: not enough coins for this item")
		return
	user.coins -= item.price #subtract price for item
	item.is_unlocked = true;
	user.unlocked_items.append(item)
	Globals.data_manager.profiles.save_profile(user)
	emit_signal("item_unlock_signal",item)
