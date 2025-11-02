extends Control

var data_manager = DataManager.get_instance()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add menu
	var menu = load("res://src/scenes/Menu.tscn").instantiate()
	add_child(menu)
	#load profiles
	var profile_rect = $TextureRect
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
