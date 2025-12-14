# Author:
# Description: Game selection card controlling navigation and appearance.

class_name GameSelectionItem
extends Control

var GamePath: String = ""
var ThemeName: String = ""

@onready var title_label: Label = $Label
@onready var image_panel: Panel = $Panel

func SetGameName(name: String) -> void:
	title_label.text = name

func SetGameImage(path: String) -> void:
	var Tex: Texture2D = load(path)
	if Tex:
		var stylebox := StyleBoxTexture.new()
		stylebox.texture = Tex
		image_panel.add_theme_stylebox_override("panel", stylebox)

func SetButtonPath(path: String) -> void:
	GamePath = path

func SetThemeName(theme: String) -> void:
	ThemeName = theme

func Configure(name: String, image_path: String, scene_path: String, theme: String = "") -> void:
	SetGameName(name)
	SetGameImage(image_path)
	SetButtonPath(scene_path)
	if theme != "":
		SetThemeName(theme)

# Switches theme and loads game scene
func _on_button_button_down() -> void:
	if ThemeName != "":
		Globals.GameTheme = ThemeName
	if GamePath != "":
		get_tree().change_scene_to_file(GamePath)
