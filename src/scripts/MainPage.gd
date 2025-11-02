extends Control

var sample_data_seed = SampleDataSeed.get_instance()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = load("res://src/scenes/Menu.tscn").instantiate()
	add_child(menu)
	sample_data_seed.seed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
