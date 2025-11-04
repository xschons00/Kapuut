extends Control

@onready var menu_scene = preload("res://src/scenes/components/Menu.tscn")
var data_manager = DataManager.get_instance()
var sample_data_seed = SampleDataSeed.get_instance()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = menu_scene.instantiate()
	add_child(menu)
	data_manager.clear_data()
	sample_data_seed.seed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
