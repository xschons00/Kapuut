# Author:
# Description: Seeds default profiles, themes, and app config.

class_name DataSeed
extends Node

static var _instance: DataSeed	# Singleton instance reference


# Returns the singleton instance of DataSeed
static func get_instance() -> DataSeed:
	if _instance == null:
		_instance = DataSeed.new()
	return _instance
	
# Creates default user, themes, and app configuration
func seed() -> void:
	# Create default user profile
	var default_user = ProfileObject.new()
	default_user.user_name = "player 1"
	default_user.profile_pic = Globals.default_profile_pic
	default_user.background_pic = Globals.default_profile_background
	default_user.coins = 0
	default_user.elo = 0
	default_user.daily_missions = {
		"flashcards": 0,
		"pvp": 0,
		"lucky_mode": 0
	}
	default_user.spin_history = []
	default_user.selected_price = 50
	Globals.data_manager.profiles.save_profile(default_user)
	
	var hp_game_data := _create_harry_potter_theme()
	Globals.data_manager.themes.save_Theme("HARRYPOTTER", hp_game_data)

	var science_theme := _create_science_theme()
	Globals.data_manager.themes.save_Theme("SCIENCE", science_theme)

	var history_theme := _create_history_theme()
	Globals.data_manager.themes.save_Theme("HISTORY", history_theme)

	var geography_theme := _create_geography_theme()
	Globals.data_manager.themes.save_Theme("GEOGRAPHY", geography_theme)

	# Save app configuration for the default user
	var config = AppConfigObject.new()
	config.user_id = default_user.id
	Globals.data_manager.app_config.save_config(config)

# Creates Harry Potter themed questions
func _create_harry_potter_theme() -> GameThemeObject:
	var hp_game_data := GameThemeObject.new()
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
	q.Question = "What are Hermione Granger's parents' profession?"
	q.Correct = "Dentists"
	q.otherquestion1 = "Healers"
	q.otherquestion2 = "Teachers"
	q.otherquestion3 = "Aurors"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What object chooses students' Hogwarts houses?"
	q.Correct = "Sorting Hat"
	q.otherquestion1 = "Goblet of Fire"
	q.otherquestion2 = "Elder Wand"
	q.otherquestion3 = "Pensieve"
	hp_game_data.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is Sirius Black's Animagus form?"
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

	return hp_game_data

# Creates Science themed questions
func _create_science_theme() -> GameThemeObject:
	var theme := GameThemeObject.new()
	theme.img = "res://assets/icons/icon.svg"
	theme.Questions = []

	var q

	q = QuestionObject.new()
	q.Question = "What is the chemical symbol for water?"
	q.Correct = "H2O"
	q.otherquestion1 = "CO2"
	q.otherquestion2 = "O2"
	q.otherquestion3 = "NaCl"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What force keeps us on the ground?"
	q.Correct = "Gravity"
	q.otherquestion1 = "Friction"
	q.otherquestion2 = "Magnetism"
	q.otherquestion3 = "Electricity"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What planet is known as the Red Planet?"
	q.Correct = "Mars"
	q.otherquestion1 = "Venus"
	q.otherquestion2 = "Jupiter"
	q.otherquestion3 = "Mercury"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Humans breathe in which gas to live?"
	q.Correct = "Oxygen"
	q.otherquestion1 = "Carbon dioxide"
	q.otherquestion2 = "Nitrogen"
	q.otherquestion3 = "Helium"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What part of the cell contains DNA?"
	q.Correct = "Nucleus"
	q.otherquestion1 = "Cell membrane"
	q.otherquestion2 = "Cytoplasm"
	q.otherquestion3 = "Ribosome"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the boiling point of water at sea level in °C?"
	q.Correct = "100"
	q.otherquestion1 = "0"
	q.otherquestion2 = "50"
	q.otherquestion3 = "212"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What organ pumps blood through the body?"
	q.Correct = "Heart"
	q.otherquestion1 = "Lungs"
	q.otherquestion2 = "Brain"
	q.otherquestion3 = "Stomach"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which scientist proposed the theory of relativity?"
	q.Correct = "Albert Einstein"
	q.otherquestion1 = "Isaac Newton"
	q.otherquestion2 = "Marie Curie"
	q.otherquestion3 = "Nikola Tesla"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What gas do plants absorb from the air?"
	q.Correct = "Carbon dioxide"
	q.otherquestion1 = "Oxygen"
	q.otherquestion2 = "Hydrogen"
	q.otherquestion3 = "Nitrogen"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "How many planets are in the Solar System?"
	q.Correct = "8"
	q.otherquestion1 = "7"
	q.otherquestion2 = "9"
	q.otherquestion3 = "10"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the center of an atom called?"
	q.Correct = "Nucleus"
	q.otherquestion1 = "Electron"
	q.otherquestion2 = "Proton"
	q.otherquestion3 = "Neutron"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the largest planet in our Solar System?"
	q.Correct = "Jupiter"
	q.otherquestion1 = "Saturn"
	q.otherquestion2 = "Earth"
	q.otherquestion3 = "Neptune"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What do bees collect from flowers?"
	q.Correct = "Nectar"
	q.otherquestion1 = "Water"
	q.otherquestion2 = "Sand"
	q.otherquestion3 = "Salt"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What process turns liquid water into gas?"
	q.Correct = "Evaporation"
	q.otherquestion1 = "Condensation"
	q.otherquestion2 = "Freezing"
	q.otherquestion3 = "Melting"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the basic unit of life?"
	q.Correct = "Cell"
	q.otherquestion1 = "Atom"
	q.otherquestion2 = "Molecule"
	q.otherquestion3 = "Organ"
	theme.Questions.append(q)

	return theme

func _create_history_theme() -> GameThemeObject:
	var theme := GameThemeObject.new()
	theme.img = "res://assets/FlashCardBackgrounds/danodrevo.jpg"
	theme.Questions = []

	var q

	q = QuestionObject.new()
	q.Question = "Which wall in Europe fell in 1989?"
	q.Correct = "Berlin Wall"
	q.otherquestion1 = "Great Wall of China"
	q.otherquestion2 = "Hadrian's Wall"
	q.otherquestion3 = "City Wall of London"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which ancient civilization built the pyramids at Giza?"
	q.Correct = "Ancient Egyptians"
	q.otherquestion1 = "Romans"
	q.otherquestion2 = "Greeks"
	q.otherquestion3 = "Mayans"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Who was the leader of the Soviet Union during World War II?"
	q.Correct = "Joseph Stalin"
	q.otherquestion1 = "Vladimir Lenin"
	q.otherquestion2 = "Nikita Khrushchev"
	q.otherquestion3 = "Mikhail Gorbachev"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "In which year did World War II end?"
	q.Correct = "1945"
	q.otherquestion1 = "1939"
	q.otherquestion2 = "1918"
	q.otherquestion3 = "1963"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which explorer is credited with the first circumnavigation of the Earth?"
	q.Correct = "Ferdinand Magellan"
	q.otherquestion1 = "Christopher Columbus"
	q.otherquestion2 = "James Cook"
	q.otherquestion3 = "Marco Polo"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which country is famous for samurai warriors?"
	q.Correct = "Japan"
	q.otherquestion1 = "China"
	q.otherquestion2 = "Korea"
	q.otherquestion3 = "Mongolia"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Who was known as the 'Maid of Orléans'?"
	q.Correct = "Joan of Arc"
	q.otherquestion1 = "Cleopatra"
	q.otherquestion2 = "Boudicca"
	q.otherquestion3 = "Catherine the Great"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "The Renaissance began in which country?"
	q.Correct = "Italy"
	q.otherquestion1 = "Spain"
	q.otherquestion2 = "France"
	q.otherquestion3 = "Germany"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Who was the first person to walk on the Moon?"
	q.Correct = "Neil Armstrong"
	q.otherquestion1 = "Buzz Aldrin"
	q.otherquestion2 = "Yuri Gagarin"
	q.otherquestion3 = "Michael Collins"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which empire built the Colosseum?"
	q.Correct = "Roman Empire"
	q.otherquestion1 = "Ottoman Empire"
	q.otherquestion2 = "British Empire"
	q.otherquestion3 = "Mongol Empire"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which city was divided by a wall from 1961 to 1989?"
	q.Correct = "Berlin"
	q.otherquestion1 = "Moscow"
	q.otherquestion2 = "Prague"
	q.otherquestion3 = "Warsaw"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Who wrote the play 'Romeo and Juliet'?"
	q.Correct = "William Shakespeare"
	q.otherquestion1 = "Charles Dickens"
	q.otherquestion2 = "Leo Tolstoy"
	q.otherquestion3 = "Mark Twain"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which ship famously sank after hitting an iceberg in 1912?"
	q.Correct = "Titanic"
	q.otherquestion1 = "Lusitania"
	q.otherquestion2 = "Bismarck"
	q.otherquestion3 = "Endeavour"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which document begins with the words 'We the People'?"
	q.Correct = "U.S. Constitution"
	q.otherquestion1 = "Magna Carta"
	q.otherquestion2 = "Declaration of Independence"
	q.otherquestion3 = "Bill of Rights"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which empire was ruled by Genghis Khan?"
	q.Correct = "Mongol Empire"
	q.otherquestion1 = "Roman Empire"
	q.otherquestion2 = "Persian Empire"
	q.otherquestion3 = "British Empire"
	theme.Questions.append(q)

	return theme

# Creates Geography themed questions
func _create_geography_theme() -> GameThemeObject:
	var theme := GameThemeObject.new()
	theme.img = "res://assets/icons/user.png"
	theme.Questions = []

	var q

	q = QuestionObject.new()
	q.Question = "What is the largest ocean on Earth?"
	q.Correct = "Pacific Ocean"
	q.otherquestion1 = "Atlantic Ocean"
	q.otherquestion2 = "Indian Ocean"
	q.otherquestion3 = "Arctic Ocean"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which is the longest river in Africa?"
	q.Correct = "Nile River"
	q.otherquestion1 = "Amazon River"
	q.otherquestion2 = "Yangtze River"
	q.otherquestion3 = "Danube River"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which country has the largest land area?"
	q.Correct = "Russia"
	q.otherquestion1 = "Canada"
	q.otherquestion2 = "China"
	q.otherquestion3 = "United States"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the capital city of France?"
	q.Correct = "Paris"
	q.otherquestion1 = "Rome"
	q.otherquestion2 = "Madrid"
	q.otherquestion3 = "Berlin"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "On which continent is Brazil located?"
	q.Correct = "South America"
	q.otherquestion1 = "North America"
	q.otherquestion2 = "Africa"
	q.otherquestion3 = "Asia"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Mount Everest lies in which mountain range?"
	q.Correct = "Himalayas"
	q.otherquestion1 = "Alps"
	q.otherquestion2 = "Andes"
	q.otherquestion3 = "Rockies"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which desert is the largest hot desert in the world?"
	q.Correct = "Sahara Desert"
	q.otherquestion1 = "Gobi Desert"
	q.otherquestion2 = "Kalahari Desert"
	q.otherquestion3 = "Mojave Desert"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which continent is also a country?"
	q.Correct = "Australia"
	q.otherquestion1 = "Europe"
	q.otherquestion2 = "Antarctica"
	q.otherquestion3 = "Africa"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the smallest country in the world by area?"
	q.Correct = "Vatican City"
	q.otherquestion1 = "Monaco"
	q.otherquestion2 = "San Marino"
	q.otherquestion3 = "Liechtenstein"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which ocean lies on the east coast of the United States?"
	q.Correct = "Atlantic Ocean"
	q.otherquestion1 = "Pacific Ocean"
	q.otherquestion2 = "Indian Ocean"
	q.otherquestion3 = "Arctic Ocean"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the capital of Japan?"
	q.Correct = "Tokyo"
	q.otherquestion1 = "Kyoto"
	q.otherquestion2 = "Osaka"
	q.otherquestion3 = "Nagoya"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which country is home to the city of Cairo?"
	q.Correct = "Egypt"
	q.otherquestion1 = "Morocco"
	q.otherquestion2 = "Turkey"
	q.otherquestion3 = "Saudi Arabia"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "What is the term for land surrounded by water on three sides?"
	q.Correct = "Peninsula"
	q.otherquestion1 = "Island"
	q.otherquestion2 = "Isthmus"
	q.otherquestion3 = "Delta"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which continent has the most countries?"
	q.Correct = "Africa"
	q.otherquestion1 = "Europe"
	q.otherquestion2 = "Asia"
	q.otherquestion3 = "South America"
	theme.Questions.append(q)

	q = QuestionObject.new()
	q.Question = "Which line divides Earth into Northern and Southern Hemispheres?"
	q.Correct = "Equator"
	q.otherquestion1 = "Prime Meridian"
	q.otherquestion2 = "Tropic of Cancer"
	q.otherquestion3 = "Tropic of Capricorn"
	theme.Questions.append(q)

	return theme
	
# Creates test users and config for development
func test_seed() -> void:
	var profile_seeds := [
		{
			"user_name": "John Doe",
			"profile_pic": Globals.default_profile_pic,
			"background_pic": Globals.default_profile_background,
			"elo": 1024,
			"coins": 2000
		},
		{
			"user_name": "Ava Sparks",
			"profile_pic": "res://assets/avatars/avatar2.png",
			"background_pic": "res://assets/backgrounds/forest_bg.jpg",
			"elo": 980,
			"coins": 1500
		},
		{
			"user_name": "Mila Rivers",
			"profile_pic": "res://assets/avatars/avatar3.png",
			"background_pic": "res://assets/backgrounds/space_bg.jpg",
			"elo": 940,
			"coins": 1200
		},
		{
			"user_name": "Leo Stone",
			"profile_pic": "res://assets/avatars/avatar4.png",
			"background_pic": "res://assets/backgrounds/red_bg.png",
			"elo": 910,
			"coins": 900
		},
		{
			"user_name": "Zara Quinn",
			"profile_pic": "res://assets/avatars/avatar5.png",
			"background_pic": "res://assets/backgrounds/mountain_bg.png",
			"elo": 970,
			"coins": 800
		},
		{
			"user_name": "Finn Wilder",
			"profile_pic": "res://assets/avatars/avatar6.png",
			"background_pic": "res://assets/backgrounds/valley_bg.png",
			"elo": 930,
			"coins": 600
		}
	]

	var primary_user_id := ""
	for seed in profile_seeds:
		var profile_id := _create_profile_from_seed(seed)
		if primary_user_id == "":
			primary_user_id = profile_id

	var config = AppConfigObject.new()
	config.user_id = primary_user_id
	Globals.data_manager.app_config.save_config(config)


func _create_profile_from_seed(seed: Dictionary) -> String:
	var profile := ProfileObject.new()
	profile.user_name = seed.get("user_name", "player")
	profile.profile_pic = seed.get("profile_pic", Globals.default_profile_pic)
	profile.background_pic = seed.get("background_pic", Globals.default_profile_background)
	profile.elo = seed.get("elo", 0)
	profile.coins = seed.get("coins", 0)
	profile.daily_missions = seed.get("daily_missions", {
		"flashcards": 0,
		"pvp": 0,
		"lucky_mode": 0
	})
	profile.spin_history = seed.get("spin_history", [])
	profile.selected_price = seed.get("selected_price", 50)
	return Globals.data_manager.profiles.save_profile(profile)
