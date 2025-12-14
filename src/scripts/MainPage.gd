# Author: xschons00
# Description: Landing page wrapper that attaches the global menu.

extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.add_menu(self)
	Globals.add_daily_missions(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
