extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var id = Globals.data_manager.app_config.get_config().user_id
	var bababui = Globals.data_manager.profiles.get_profile(id).user_name
	self.text = bababui
