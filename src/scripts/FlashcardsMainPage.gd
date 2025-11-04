extends Control

@onready var menu_scene = preload("res://src/scenes/components/Menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = menu_scene.instantiate()
	add_child(menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/MainPage.tscn")
