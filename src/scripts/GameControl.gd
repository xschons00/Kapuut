# Author:
# Description: Base UI controller for game scenes (background + navigation).

class_name GameController
extends Control


@onready
var ThemeName: String = Globals.GameTheme
@onready
var Gtheme:GameThemeObject = Globals.data_manager.themes.get_Theme(ThemeName)
var data:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Gtheme:
		push_error("Critical failure: missing game data")
		get_tree().quit(1)
	data = Gtheme.to_dict()
	add_background(data["img"])

	load_additional_data()
	
# Allow child scenes to extend initialization
func load_additional_data():
	pass
			
# Sets panel background texture
func add_background(TexPath):
	var Tex: Texture2D  = load(TexPath)
	if Tex:
		var stylebox := StyleBoxTexture.new()
		stylebox.texture = Tex
		$Panel.add_theme_stylebox_override("panel", stylebox)

func Switch_Scene(Path:String):
	get_tree().change_scene_to_file(Path)
