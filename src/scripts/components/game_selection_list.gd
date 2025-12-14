# Author: xjakubk00
# Description: Scrollable list for game selection cards with search and arrows.

class_name GameSelectionList
extends Control

@export var card_scene: PackedScene = preload("res://src/scenes/components/Game_Selection_item.tscn")
@export var scroll_step: float = 320.0

@onready var scroll_container: ScrollContainer = $Panel/ScrollContainer
@onready var items_container: HBoxContainer = $Panel/ScrollContainer/HBoxContainer
@onready var search_bar: LineEdit = $Panel/SearchBar
@onready var prev_button: Button = $Panel/PrevButton
@onready var next_button: Button = $Panel/NextButton

var _all_items: Array = []

func _ready() -> void:
	_update_arrows()

# Accepts items and renders cards
func set_items(items: Array) -> void:
	_all_items = items
	_render_items(items)

# Filters cards by name substring
func filter_items(query: String) -> void:
	if _all_items.is_empty():
		return

	var trimmed_query := query.strip_edges().to_lower()
	if trimmed_query == "":
		_render_items(_all_items)
		return

	var filtered: Array = []
	for item in _all_items:
		var name_text := str(item.get("name", "")).to_lower()
		if name_text.find(trimmed_query) != -1:
			filtered.append(item)

	_render_items(filtered)

func _on_search_bar_text_changed(new_text: String) -> void:
	filter_items(new_text)

func _render_items(items: Array) -> void:
	for child in items_container.get_children():
		child.queue_free()

	for item in items:
		if card_scene == null:
			continue
		var card: Control = card_scene.instantiate()
		items_container.add_child(card)
		if card.has_method("SetGameName"):
			card.SetGameName(str(item.get("name", "")))
		if card.has_method("SetGameImage") and item.has("image"):
			card.SetGameImage(str(item["image"]))
		if card.has_method("SetButtonPath") and item.has("path"):
			card.SetButtonPath(str(item["path"]))
		if card.has_method("SetThemeName") and item.has("theme"):
			card.SetThemeName(str(item["theme"]))

	call_deferred("_update_arrows")

func _scroll_by(amount: float) -> void:
	scroll_container.scroll_horizontal = clampf(
		scroll_container.scroll_horizontal + amount,
		0.0,
		scroll_container.get_h_scroll_bar().max_value
	)
	_update_arrows()

func _update_arrows() -> void:
	var bar := scroll_container.get_h_scroll_bar()
	var max_scroll := 0.0
	if bar:
		max_scroll = bar.max_value

	var has_overflow := max_scroll > 1.0
	prev_button.visible = has_overflow
	next_button.visible = has_overflow

	if not has_overflow:
		return

	prev_button.disabled = scroll_container.scroll_horizontal <= 0.0
	next_button.disabled = scroll_container.scroll_horizontal >= max_scroll

func _process(_delta: float) -> void:
	_update_arrows()

func _on_prev_button_pressed() -> void:
	_scroll_by(-scroll_step)

func _on_next_button_pressed() -> void:
	_scroll_by(scroll_step)
