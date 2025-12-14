# Author:
# Description: Shows PvP result text, avatars, and highlights winner.

extends Label

@onready var user_avatar: TextureRect = get_node_or_null("../UserProfilePic")
@onready var opponent_avatar: TextureRect = get_node_or_null("../OpponentProfilePic")
@onready var user_glow: ColorRect = get_node_or_null("../UserGlow")
@onready var opponent_glow: ColorRect = get_node_or_null("../OpponentGlow")


func _ready() -> void:
	text = str("SCORE\n", Globals.score)
	_set_profile_pics()
	_highlight_winner()


func _set_profile_pics() -> void:
	var config: AppConfigObject = Globals.data_manager.app_config.get_config()
	if config == null:
		_apply_avatar(user_avatar, Globals.default_profile_pic)
		_apply_avatar(opponent_avatar, Globals.default_profile_pic)
		return

	_apply_avatar(user_avatar, _resolve_profile_pic(config.user_id))
	_apply_avatar(opponent_avatar, _resolve_profile_pic(config.opponent))


func _resolve_profile_pic(profile_id: String) -> String:
	if profile_id == "":
		return Globals.default_profile_pic
	var profile: ProfileObject = Globals.data_manager.profiles.get_profile(profile_id)
	if profile == null:
		return Globals.default_profile_pic
	if ResourceLoader.exists(profile.profile_pic):
		return profile.profile_pic
	return Globals.default_profile_pic


func _apply_avatar(rect: TextureRect, texture_path: String) -> void:
	if rect == null:
		return
	if texture_path == "":
		texture_path = Globals.default_profile_pic
	rect.texture = load(texture_path)


func _highlight_winner() -> void:
	if user_glow:
		user_glow.visible = false
	if opponent_glow:
		opponent_glow.visible = false

	match Globals.pvp_winner:
		1:
			if user_glow:
				user_glow.visible = true
		2:
			if opponent_glow:
				opponent_glow.visible = true
