class_name DataSeed
extends Node

static var _instance: DataSeed


static func get_instance() -> DataSeed:
	if _instance == null:
		_instance = DataSeed.new()
	return _instance
	
func seed() -> void:
	var default_user = ProfileObject.new()
	default_user.user_name = "player 1"
	default_user.profile_pic = Globals.default_profile_pic
	default_user.coins = 0
	default_user.elo = 0
	Globals.data_manager.profiles.save_profile(default_user)
	
	# Build the HARRYPOTTER theme programmatically
	var hp_game_data = GameThemeObject.new()
	hp_game_data.img = "res://assets/FlashCardBackgrounds/danodrevo.jpg"
	hp_game_data.Questions = []

	var q

	q = QuestionObject.new()
	q.Question = "Who is the Half-Blood Prince?"
	q.Correct = "Severus Snape"
	q.otherquestion1 = "Harry Potter"
	q.otherquestion2 = "Tom Riddle"
	q.otherquestion3 = "Draco Malfoy"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which house is known for bravery?"
	q.Correct = "Gryffindor"
	q.otherquestion1 = "Ravenclaw"
	q.otherquestion2 = "Hufflepuff"
	q.otherquestion3 = "Slytherin"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What spell disarms an opponent?"
	q.Correct = "Expelliarmus"
	q.otherquestion1 = "Stupefy"
	q.otherquestion2 = "Alohomora"
	q.otherquestion3 = "Lumos"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Who is Hogwarts headmaster for most of the series?"
	q.Correct = "Albus Dumbledore"
	q.otherquestion1 = "Minerva McGonagall"
	q.otherquestion2 = "Dolores Umbridge"
	q.otherquestion3 = "Severus Snape"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What creature guards the deepest Gringotts vaults?"
	q.Correct = "Dragon"
	q.otherquestion1 = "Basilisk"
	q.otherquestion2 = "Hippogriff"
	q.otherquestion3 = "Thestral"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What are Hermione Granger’s parents’ profession?"
	q.Correct = "Dentists"
	q.otherquestion1 = "Healers"
	q.otherquestion2 = "Teachers"
	q.otherquestion3 = "Aurors"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What object chooses students’ Hogwarts houses?"
	q.Correct = "Sorting Hat"
	q.otherquestion1 = "Goblet of Fire"
	q.otherquestion2 = "Elder Wand"
	q.otherquestion3 = "Pensieve"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is Sirius Black’s Animagus form?"
	q.Correct = "Dog"
	q.otherquestion1 = "Stag"
	q.otherquestion2 = "Rat"
	q.otherquestion3 = "Cat"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "How many Deathly Hallows are there?"
	q.Correct = "Three"
	q.otherquestion1 = "Two"
	q.otherquestion2 = "Four"
	q.otherquestion3 = "Seven"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the name of the Weasley family home?"
	q.Correct = "The Burrow"
	q.otherquestion1 = "Grimmauld Place"
	q.otherquestion2 = "Shell Cottage"
	q.otherquestion3 = "Hogsmeade House"
	hp_game_data.Questions.append(q)

	Globals.data_manager.themes.save_Theme("HARRYPOTTER", hp_game_data)

	# Empty showcase themes for selection UI
	var empty_themes = [
		{"id": "SCIENCE", "img": "res://assets/icons/icon.svg"},
		{"id": "HISTORY", "img": "res://assets/FlashCardBackgrounds/danodrevo.jpg"},
		{"id": "GEOGRAPHY", "img": "res://assets/icons/user.png"}
	]

	for theme_data in empty_themes:
		var theme := GameThemeObject.new()
		theme.img = theme_data["img"]
		theme.Questions = []
		Globals.data_manager.themes.save_Theme(theme_data["id"], theme)

	var config = AppConfigObject.new()
	config.user_id = default_user.id
	Globals.data_manager.app_config.save_config(config)
	
func test_seed() -> void:
	var user1 = ProfileObject.new()
	user1.user_name = "John Doe"
	user1.profile_pic = "res://assets/icons/icon.svg"
	user1.elo = 1024
	user1.coins = 2000
	Globals.data_manager.profiles.save_profile(user1)
	
	
	var config = AppConfigObject.new()
	config.user_id = user1.id
	Globals.data_manager.app_config.save_config(config)
