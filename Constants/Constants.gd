extends Node
const jobs = {
	'Farmwork': {
		'stats': {
			'experience': 10,
			'gold': 50,
			'max_hp': 1,
			'attack': 1,
			'defense': 1,
			'stress': 3,
		},
		'required_stats': {
			'max_hp': 10,
			'attack': 5,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 10,
		'skill':{
			'proficiency_required': 50,
			'id': 'apprentice_farmer',
		},
		"description": "Helping out at a traditional potato farm.\nSince modern agriculture is heavily magicalized, this is more of a hobby than a real job.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/ingredients_hempbag01_03.png",
		#TODO, add more farmwork timelines
		"timelines": ["Farmwork0", "Farmwork1"],
	},
	'Housework': {
		'stats': {
			'experience': 10,
			'max_hp': 1,
			'max_mp': 1,
			'agility': 1,
			'stress': 2,
		},
		'required_stats': {
			'max_hp': 10,
			'max_mp': 10,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 10,
		'skill':{
			'proficiency_required': 50,
			'id': 'maid_training',
		},
		"description": "Technically, this is your job.\nYou don't get paid extra just for doing your job, unfortunately.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/clothes05_01.png",
		"timelines": ["Housework0", "Housework1", "Housework2"],
	},
	'Carpentry': {
		'stats': {
			'experience': 20,
			'gold': 75,
			'max_hp': 1,
			'attack': 3,
			'defense': 1,
			'stress': 6,
		},
		'required_stats': {
			'max_hp': 100,
			'attack': 100,
		},
		'difficulty': -50,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 140,
			'id': 'apprentice_carpenter',
		},
		"description": "It might be better to call this 'hauling' than 'carpentry.'\nIt's mostly just carrying planks around for the actual carpenter.\nThis kind of menial work is better left to golems, but it's good exercise.",
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/wood.png",
		"timelines": ["Carpentry0", "Carpentry1"],
	},
	'Tutoring': {
		'stats': {
			'experience': 25,
			'gold': 100,
			'max_mp': 1,
			'magic': 1,
			'scholarship': 1,
			'stress': 6,
		},
		'required_stats': {
			'max_mp': 0,
			'magic': 0,
			'scholarship': 200,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
		#Note, skill is shared with general education
		'skill':{
			'proficiency_required': 100,
			'id': 'diligent_student',
		},
		"description": "A good way to be paid while doing classwork.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/note01_04.png",
		"timelines": ["Tutoring0", "Tutoring1"],
	},
	"Wizard's Apprentice": {
		'stats': {
			'experience': 40,
			'gold': 100,
			'magic': 4,
			'agility': 1,
			'resistance': 1,
			'stress': 12,
		},
		'required_stats': {
			'max_mp': 100,
			'resistance': 100,
			'magic': 100,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'wizarding_license_apprentice',
		},
		"description": "Helping out at a certain alchemist's workshop.\nSurprisingly, not as smelly as one might expect, but a busy and stressful job nontheless.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/alchemy01_01.png",
		"timelines": ["WizardsApprentice0", "WizardsApprentice1"],
	},
	'Acolyte': {
		'stats': {
			'experience': 10,
			'gold': 10,
			'max_hp': 1,
			'magic': 1,
			'max_mp': 1,
			'defense': 1,
			'resistance': 1,
			'stress': 1,
		},
		'required_stats': {
			'max_hp': 100,
			'max_mp': 100,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 150,
			'id': 'church_helper',
		},
		"description": "General cleaning around the local church.\nOccasionally the head priest lets you help with making holy water.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/clothes06_02.png",
		"timelines": ["Acolyte0", "Acolyte1"],
	},
	'Hunting': {
		'stats': {
			'experience': 50,
			'gold': 150,
			'max_hp': 1,
			'attack': 3,
			'agility': 5,
			'skill': 5,
			'stress': 15,
		},
		'required_stats': {
			'agility': 200,
			'attack': 100,
			'skill': 0,
			'max_hp': 100,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 25,
		"description": "Not as bloody as you might expect, since it's Dumpling hunting.\nTranquilizer bolts are provided, but they don't really make a difference against Dumplings.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/weapon02_01.png",
		"timelines": ["Hunting0", "Hunting1"],
	},
	'Cook': {
		'stats': {
			'experience': 50,
			'gold': 150,
			'max_hp': 2,
			'max_mp': 2,
			'magic': 1,
			'agility': 2,
			'stress': 10,
		},
		'required_stats': {
			'agility': 100,
			'max_mp': 100,
			'max_hp': 100,
			'magic': 100,
		},
		'difficulty': 25,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'budding_chef',
		},
		"description": "Helping out at the palace kitchen.\nTechnically part of your actual job, but you do get paid for it.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/book03_01.png",
	},
	'Doodle': {
		'stats': {
			'experience': 25,
			'gold': 50,
			'art': 10,
			'stress': 5,
		},
		'required_stats': {
			'art': 10,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 25,
		"description": "Her majesty is willing to pay for your doodles.\nThat said, it might be a good idea to reconsider.\nDo you really want her to have a collection of your earliest, ugliest works?\nShe'll happily put them on display, you know?",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/palette01_04.png",
	},
	'Painting': {
		'stats': {
			'experience': 100,
			'gold': 150,
			'art': 25,
			'stress': 10,
		},
		'required_stats': {
			'art': 250,
			'skill': 0,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
		"description": "Officially, your paintings are being sold on the open market.\nUnofficially, her majesty is collecting most of them.\nHopefully she won't use them to make fun of you later.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/palette01_01.png",
	},
	'Court Painter': {
		'stats': {
			'experience': 250,
			'gold': 500,
			'art': 50,
			'stress': 25,
		},
		'required_stats': {
			'art': 500,
			'skill': 0,
		},
		'difficulty': 25,
		'proficiency': 200,
		'proficiency_gain': 25,
		"description": "Unsurprisingly, her majesty pays quite well for commissioned works.\nHopefully the request to paint the ceilings isn't just another prank.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/paint01_08.png",
	},
	'Preach': {
		'stats': {
			'experience': 10,
			'gold': 50,
			'max_hp': 2,
			'magic': 2,
			'max_mp': 2,
			'defense': 2,
			'resistance': 2,
			'stress': 10,
		},
		'required_stats': {
			'max_hp': 200,
			'max_mp': 200,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'local_preacher',
		},
		"description": "The job is more like handing out fliers than actual missionary work.\nTry not to bother anyone.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/rosary_02.png",
	},
	'Teaching Assistant': {
		'stats': {
			'experience': 25,
			'gold': 150,
			'magic': 1,
			'max_mp': 1,
			'scholarship': 2,
			'stress': 15,
		},
		'required_stats': {
			'max_mp': 100,
			'magic': 100,
			'scholarship': 200,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 20,
		"description": "Helping out at the academy.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/eraser01_02.png",
	},
	'Lecture': {
		'stats': {
			'experience': 50,
			'gold': 250,
			'magic': 1,
			'max_mp': 1,
			'scholarship': 3,
			'art': 1,
			'stress': 20,
		},
		'required_stats': {
			'max_mp': 100,
			'magic': 100,
			'scholarship': 400,
			'art': 100,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 20,
		"description": "The fact that you could get a classroom to teach can only be attributed to nepotism.\nThat said, you still need to lecture properly to get paid.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/file01_04.png",
	},
	'Architect': {
		'stats': {
			'experience': 50,
			'gold': 250,
			'art': 10,
			'scholarship': 2,
			'magic': 1,
			'max_mp': 1,
			'stress': 15,
		},
		'required_stats': {
			'art': 200,
			'scholarship': 200,
			'magic': 100,
			'max_mp': 100,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 20,
		"description": "The hardhat isn't really necessary, but it makes you feel more professional.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/helmet.png",
	},
}

#depreciated, use as reference for courses only
const lessons = {
	'Basic Magic Training': {
		'stats': {
			'experience': 50,
			'gold': -100,
			'magic': 2,
			'max_mp': 2,
			'scholarship': 5,
			'resistance': 1,
			'stress': 5,
		},
		'required_stats': {
			'magic': 10,
			'max_mp': 10,
			'resistance': 10,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_magic_training',
		},
		'description': "An introductory class to magecraft. You don't really need to take this, but it's part of the standard curriculum.",
	},
	'Basic Melee Training': {
		'stats': {
			'experience': 50,
			'gold': -100,
			'max_hp': 2,
			'attack': 2,
			'defense': 1,
			'agility': 1,
			'stress': 5,
		},
		'required_stats': {
			'attack': 10,
			'max_hp': 10,
			'defense': 10,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_melee_training',
		},
	},
	'Basic Theology': {
		'stats': {
			'experience': 50,
			'gold': -100,
			'max_hp': 3,
			'max_mp': 2,
			'defense': 1,
			'resistance': 1,
			'skill': 1,
			'stress': 5,
		},
		'required_stats': {
			'max_hp': 10,
			'max_mp': 10,
			'defense': 5,
			'resistance': 5,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_theology',
		},
	},
	'General Education': {
		'stats': {
			'experience': 100,
			'gold': -100,
			'scholarship': 5,
			'stress': 10,
		},
		'required_stats': {
			'scholarship': 0,
		},
		'difficulty': -50,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'diligent_student',
		},
	},
	'Combat Theory': {
		'stats': {
			'experience': 100,
			'gold': -100,
			'max_hp': 1,
			'max_mp': 1,
			'attack': 1,
			'defense': 1,
			'agility': 1,
			'magic': 1,
			'resistance': 1,
			'stress': 5,
		},
		'required_stats': {
			'max_hp': 100,
			'max_mp': 100,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 100,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'basic_combat_training',
		},
	},
	'Intermediate Magic Training': {
		'stats': {
			'experience': 100,
			'gold': -250,
			'magic': 5,
			'max_mp': 5,
			'scholarship': 2,
			'agility': 2,
			'resistance': 2,
			'stress': 15,
		},
		'required_stats': {
			'magic': 100,
			'max_mp': 100,
			'resistance': 100,
			'scholarship': 0,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'fireball',
		},
	},
	'Intermediate Melee Training': {
		'stats': {
			'experience': 100,
			'gold': -250,
			'max_hp': 10,
			'attack': 5,
			'defense': 2,
			'agility': 2,
			'stress': 15,
		},
		'required_stats': {
			'attack': 100,
			'max_hp': 100,
			'defense': 100,
			'scholarship': 0,
		},
		'difficulty': 50,
		'proficiency': 200,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'intermediate_combat_training',
		},
	},
	'Theology': {
		'stats': {
			'experience': 100,
			'gold': -250,
			'max_hp': 5,
			'max_mp': 5,
			'defense': 5,
			'resistance': 5,
			'skill': 2,
			'stress': 15,
		},
		'required_stats': {
			'max_hp': 100,
			'max_mp': 100,
			'defense': 50,
			'resistance': 50,
			'scholarship': 0,
		},
		'difficulty': 0,
		'proficiency': 200,
		'proficiency_gain': 25,
	},
	'Vanguard Training': {
		'stats': {
			'experience': 200,
			'gold': -500,
			'max_hp': 25,
			'attack': 5,
			'defense': 10,
			'resistance': 5,
			'agility': 5,
			'skill': 5,
			'stress': 25,
		},
		'required_stats': {
			'attack': 100,
			'max_hp': 100,
			'defense': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
	},
	'Assassin Training': {
		'stats': {
			'experience': 200,
			'gold': -500,
			'max_hp': 5,
			'attack': 10,
			'defense': 2,
			'resistance': 2,
			'agility': 15,
			'skill': 5,
			'stress': 25,
		},
		'required_stats': {
			'attack': 100,
			'agility': 100,
			'skill': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'finishing_blow',
		},
	},
	'Artillerist Training': {
		'stats': {
			'experience': 200,
			'gold': -500,
			'magic': 20,
			'max_mp': 5,
			'stress': 25,
		},
		'required_stats': {
			'magic': 200,
			'max_mp': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'meteor',
		},
	},
	'Magic Officer Training': {
		'stats': {
			'experience': 200,
			'gold': -500,
			'magic': 10,
			'max_mp': 5,
			'max_hp': 5,
			'agility': 5,
			'attack': 2,
			'defense': 2,
			'resistance': 2,
			'skill': 1,
			'stress': 25,
		},
		'required_stats': {
			'magic': 100,
			'max_mp': 100,
			'max_hp': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
		'skill':{
			'proficiency_required': 100,
			'id': 'honorary_officer',
		},
	},
	'Royal Lecture (Theology)': {
		'stats': {
			'experience': 200,
			'gold': -1000,
			'max_hp': 10,
			'max_mp': 10,
			'magic': 10,
			'defense': 15,
			'resistance': 15,
			'skill': 10,
			'agility': 10,
			'attack': 5,
			'stress': 25,
		},
		'required_stats': {
			'max_hp': 100,
			'max_mp': 100,
			'magic': 100,
			'resistance': 100,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 300,
		'proficiency_gain': 25,
	},
	'Royal Lecture (Magecraft)': {
		'stats': {
			'experience': 200,
			'gold': -1000,
			'max_hp': 5,
			'max_mp': 10,
			'magic': 30,
			'resistance': 15,
			'defense': 5,
			'agility': 15,
			'stress': 25,
		},
		'required_stats': {
			'max_mp': 100,
			'magic': 300,
			'resistance': 0,
			'scholarship': 0,
		},
		'difficulty': 100,
		'proficiency': 200,
		'proficiency_gain': 25,
	},
}

const courses = {
	#TODO, every class outside core should have gold cost
	"Core": {
		#TODO, required every semester
		#TODO, redo this section so that required stats is cumulative rather than chance
		'General Education': {
			'stats': {
				'experience': 100,
				'gold': -100,
				'scholarship': 20,
				'stress': 10,
			},
			#Scale so that it takes 10 days at 0 scholarship
			'required_progress': 10000,
			#TODO, rework diligent student (and other studying skills) to increase max scholarship
			'skill':{
				'id': 'diligent_student',
			},
			'timelines': ["GeneralEducationFirst", "GeneralEducationMiddle", "GeneralEducationEnd"],
			"description": "The main thing you learn in this class is how to learn.",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/planner01_02.png",
		},
		'Basics of Magecraft': {
			'stats': {
				'experience': 50,
				'gold': -100,
				'magic': 2,
				'max_mp': 2,
				'scholarship': 10,
				'resistance': 1,
				'stress': 5,
			},
			'required_progress': 10000,
			#TODO,  implement skill for magic training
			'skill':{
			},
			'timelines': ["MagecraftEducationFirst", "MagecraftEducationMiddle", "MagecraftEducationEnd"],
			"description": "Since you already know how to cast spells, this class is a freebie.",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/planner01_01.png",
		},
		'Physical Education': {
			'stats': {
				'experience': 50,
				'gold': -100,
				'attack': 2,
				'max_hp': 2,
				'scholarship': 5,
				'defense': 1,
				'stress': 5,
			},
			'required_progress': 10000,
			#TODO, implement new skill for PE
			'skill':{
			},
			'timelines': ["PhysicalEducationFirst", "PhysicalEducationMiddle", "PhysicalEducationEnd"],
			"description": "Mostly physical exercise, but there are some lectures about how to train properly.",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/planner01_05.png",
		},
	},
	"Ink Mage": {
		'Color Theory (Magic)': {
			'stats': {
				'experience': 200,
				'gold': -250,
				'magic': 2,
				'max_mp': 2,
				'scholarship': 2,
				'art': 10,
				'stress': 5,
			},
			'required_progress': 20000,
			'skill':{
			},
			'timelines': ["ColorTheoryEducationFirst", "ColorTheoryEducationMiddle", "ColorTheoryEducationEnd"],
			"description": "You'll get ninety percent of the questions right if you just answer 'blue.'",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/element02_01.png",
		},
		'Line, Color, and Composition': {
			'stats': {
				'experience': 200,
				'gold': -250,
				'scholarship': 1,
				'art': 25,
				'stress': -5,
			},
			'required_progress': 20000,
			'skill':{
			},
			"description": "Just a regular art class.",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/book04_01.png",
		},
		'Imaging and Illustration': {
			'stats': {
				'experience': 200,
				'gold': -250,
				'scholarship': 1,
				'art': 25,
				'stress': -5,
			},
			'required_progress': 20000,
			'skill':{
			},
			"description": "Another relaxing art class.",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/book04_03.png",
		},
		'Introduction to Illusion Magecraft': {
			'stats': {
				'experience': 200,
				'gold': -250,
				'magic': 5,
				'max_mp': 2,
				'scholarship': 2,
				'resistance': 2,
				'stress': 5,
			},
			'required_progress': 20000,
			#TODO,  implement skill for magic training
			'skill':{
			},
			"description": "Conceptually speaking, ink magic and illusion magic should be very similar.\nHence why you're taking this class.",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/element02_03.png",
		},
	},
	"Magic Officer": {
		'Ley Line Logistics': {
			'stats': {
				'experience': 500,
				'gold': -500,
				'magic': 2,
				'max_mp': 1,
				'scholarship': 5,
				'stress': 15,
			},
			'required_progress': 30000,
			'skill':{
			},
		},
		'Fundamentals of Small Unit Operations': {
			'stats': {
				'experience': 500,
				'gold': -500,
				'scholarship': 10,
				'agility': 5,
				'stress': 15,
			},
			'required_progress': 30000,
			'skill':{
			},
		},
		'Military Movement': {
			'stats': {
				'experience': 500,
				'gold': -500,
				'max_hp': 5,
				'max_mp': 2,
				'attack': 5,
				'agility': 5,
				'defense': 2,
				'stress': 15,
			},
			'required_progress': 30000,
			'skill':{
			},
		},
		'Fundamentals of Fitness (Magic)': {
			'stats': {
				'experience': 500,
				'gold': -500,
				'max_hp': 2,
				'max_mp': 5,
				'attack': 2,
				'agility': 5,
				'defense': 2,
				'resistance': 3,
				'stress': 15,
			},
			'required_progress': 30000,
			'skill':{
			},
		},
	},
	"Diplomat": {
		
	},
	"Acolyte": {
		
	},
	"Extra": {
		#TODO, make sure always available, maybe bonus point to course
		'Basic Combat Magic (Fireball)': {
			'stats': {
				'experience': 100,
				'gold': -250,
				'magic': 5,
				'max_mp': 5,
				'scholarship': 2,
				'agility': 2,
				'resistance': 2,
				'stress': 15,
			},
			'required_progress': 15000,
			'skill':{
				'id': 'fireball',
			},
			"description": "A simple and effective offensive spell.\nCan cause suffocation if used in enclosed spaces.",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/element03_01.png",
			"card": "res://Scenes/CardGame/Characters/Mao/Cards/fireball.tres",
		},
		'Artillerist Training (Meteor)': {
			'stats': {
					'experience': 200,
					'gold': -500,
					'magic': 20,
					'max_mp': 5,
					'scholarship': 2,
					'stress': 25,
			},
			'required_progress': 25000,
			'skill':{
				'id': 'meteor'
			},
			"description": "Fortunately, the output of this spell is limited by your personal magic power.\n...Even so, they really shouldn't be teaching this in school.",
			"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/meteor.png",
			"card": "res://Scenes/CardGame/Characters/Mao/Cards/meteor.tres",
		},
	},
	"Witch": {
		#TODO, only display this course if flag is set
	},
}

const rests = {
	'Nap': {
		'stats': {
			'stress': -20,
		},
		"description": "There's nothing like a quick nap when you're feeling tired.",
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/sleep.png",
	},
	'Library': {
		'stats': {
			'experience': 2,
			'gold': -10,
			'scholarship': 3,
			'stress': -15,
		},
		"description": "There's a nominal fee to enter, but the local library has quite a collection of books.",
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/element45_01.png",
	},
	'Dessert Buffet': {
		'stats': {
			'experience': 5,
			'gold': -100,
			'max_hp': 2,
			'attack': 2,
			'agility': -2,
			'stress': -50,
		},
		"description": "Surprisingly cheap, considering how much they let you eat.",
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/cake01_01.png",
	},
	'Vacation': {
		'stats': {
			'experience': 5,
			'gold': -100,
			'magic': 1,
			'max_mp': 1,
			'stress': -50,
		},
		"description": "It sure is convenient when a beach resort is only a teleport hop away.",
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/weather01_02.png",
	},
}

const school = {
	'School': {
		'description': "It's a student's job to go to class.\nTuition is waived since it's compulsory education.",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/bag04_01.png",
	}
}

const other = {
	'Cram School': {
		'description': "Technically, this is just taking extra classes at the academy.\nHer majesty insists you pay for said extra classes, though.\n(Why would anyone do this to themselves?)",
		"icon": "res://Art/Mori no oku no kakurezato/Job Icons/Resized/bag04_03.png",
	}
}

const stats = {
	#TODO, make base stats affect card game. Max hand size, draw at start, draw per turn, mana per turn, max mana, starting mana, hp, damage, etc. Mao's favorite deck is the 'Brick Hand Accident' 10 super rare cards (with dupes), apothesis costs 10 mana and makes her immune until her next turn
	'base_stats' = ["max_hp", "max_mp", "attack", "magic", "skill", "agility",
		"defense", "resistance", "art",],
	'scholarship_unaffected' = ["gold", "stress",],
	"class_change_unaffected" = ["gold", "action_points", "bonus_exp",],
	'max_hp' = {
		'label': 'Health Points',
		'emoji': '❤',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'max_mp' = {
		'label': 'Mana Points',
		'emoji': '💙',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'attack' = {
		'label': 'Attack',
		'emoji': '💪',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'magic' = {
		'label': 'Magic',
		'emoji': '🪄',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'skill' = {
		'label': 'Skill',
		'emoji': '🎲',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'agility' = {
		'label': 'Agility',
		'emoji': '⚡',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'defense' = {
		'label': 'Defense',
		'emoji': '🛡',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'resistance' = {
		'label': 'Resistance',
		'emoji': '🥽',
		'min': 0,
		'max': 1000,
		'value': 1,
	},
	'stress' = {
		'label': 'Stress',
		'emoji': '😣',
		'min': 0,
		'max': 100,
		'value': -30,
	},
	'level' = {
		'label': 'Level',
		'min': 1,
		'max': 1000,
		'value': 20,
	},
	'experience' = {
		'label': 'Experience',
		'min': 0,
	},
	'gold' = {
		'label': 'Gold',
		'emoji': '🪙',
		'max': 1000000,
		'value': .01,
	},
	'scholarship' = {
		'label': 'Scholarship',
		'emoji': '📖',
		'min': 0,
		'max': 1000,
		'bonus_ratio': 400.0,
		'value': 1,
	},
	'art' = {
		'label': 'Art',
		'emoji': '🎨',
		'max': 1000,
		'value': 2,
	},
	'bonus_exp' = {
		'label': 'Exp Bonus',
		'emoji': '',
		'min': 0,
	},
	'action_points' = {
		'label': 'Action Point',
		'emoji': '',
		'min': 1,
	}
}

const constants = {
	'days_in_month' = 30,
	'months_in_year' = 4,
	'seasons' = ['Spring', 'Summer', 'Autumn', 'Winter'],
	'TIMES_OF_DAY' = ['morning', 'afternoon', 'night', 'bedtime'],
	'DAILY_ACTION_LIMIT' = 3,
	'BASE_COURSE_PROGRESS' = 1000,
	'JOB_EVENT_ODDS' = 20, #The percentage chance of triggering a job event
	'BEDTIME_EVENT_ODDS' = 20,
	'TOAST_TIMEOUT_DURATION' = .5,
	'ALWAYS_ACTIVE_COURSES' = {"Core": true, "Extra": true},
	'ACTION_TYPES' = {
		'jobs': {
			'label': 'Work',
			'id': 'jobs',
		},
		'rests': {
			'label': 'Rest',
			'id': 'rests',
		},
		'expeditions': {
			'label': 'Expedition',
			'id': 'expedition',
		},
		'other': {
			'label': 'Other',
			'id': 'other',
			#TODO, integrate other actions here (enter tower, cram school, etc.)
		},
	},
	'ACTION_LABELS' = {
		'school': 'School',
	}
}

const locations = {
	'new_years_shrine': {
		'label': 'Shrine (New Year\'s)',
		'day': 1,
		'outcomes':
			[{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Let's go visit a shrine for New Year's."],
				'timeline': "NewYearsShrine",
			},],
		"icon": "res://Art/Background/NoranekoGames/Shrine_Spring_Day.png"
	},
	'palace': {
		'label': 'Palace',
		'outcomes':
			[{
				'stats': {
					'stress': -1,
					'gold': 10,
				},
				'toasts': ["Found a shiny coin."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 2,
				'toasts': ["Found Hiyori's Corner, let's visit."],
				'timeline': 'res://Timelines/WalkEvents/HiyoriCorner.dtl',
				'first_toasts': ["Found an interesting door, let's go in."],
				'first_timeline': 'res://Timelines/WalkEvents/HiyoriCornerFirst.dtl',
				'flag': "hiyori_corner"
			},],
		"icon": "res://Art/Background/Background material shop/bg008a.jpg"
	},
	'atelier': {
		"label": "Atelier",
		'location_flag': "atelier",
		'outcomes':
			[{
				'stats': {
					'stress': -3,
					'art': 5,
				},
				'toasts': ["Wandered around look at the sculptures since Hiyori wasn't in."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Hiyori's here, let's go say hi."],
				'timeline': 'res://Timelines/WalkEvents/HiyoriAtelier.dtl',
				'first_toasts': ["Hiyori's here, let's go say hi."],
				'first_timeline': 'res://Timelines/WalkEvents/HiyoriAtelierFirst.dtl',
				'second_toasts': ["Hiyori's here, let's go say hi."],
				'second_timeline': 'res://Timelines/WalkEvents/HiyoriAtelierSecond.dtl',
				'flag': "hiyori_atelier"
			},],
		"icon": "res://Art/Background/Background material shop/bg019a.bmp"
	},
	'storage_room': {
		"label": "Storage Room",
		'location_flag': "storage_room",
		'outcomes':
			[{
				'stats': {
					'stress': -5,
					'art': 3,
				},
				'toasts': ["Had a bit of fun looking around."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Let's go look around the storage room."],
				'timeline': 'res://Timelines/WalkEvents/StorageRoom.dtl',
				'first_toasts': ["Found Gray in the storage room."],
				'first_timeline': 'res://Timelines/WalkEvents/StorageRoomFirst.dtl',
				'flag': "storage_room"
			},],
		"icon": "res://Art/Background/Background material shop/bg014a.jpg"
	},
	'reception_hall': {
		"label": "Reception Hall",
		'location_flag': "reception_hall",
		'outcomes':
			[{
				'stats': {
					'stress': -10,
				},
				'toasts': ["Got a cookie from the maid cleaning the hall. It was delicious"],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Her majesty is here."],
				'timeline': 'res://Timelines/WalkEvents/ReceptionHall.dtl',
				'first_toasts': ["There's an omnious presence."],
				'first_timeline': 'res://Timelines/WalkEvents/ReceptionHallFirst.dtl',
				'flag': "reception_hall"
			},],
		"icon": "res://Art/Background/Background material shop/bg007a.jpg"
	},
	'rice_house': {
		"label": "Rice's House",
		'location_flag': "rice_house",
		'outcomes':
			[{
				'stats': {
					'stress': -5,
					'agility': 1,
					'max_hp': 1,
				},
				'toasts': ["Had a relaxing walk."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Found Rice's house, let's go visit."],
				'timeline': 'res://Timelines/WalkEvents/RiceHouse.dtl',
				'first_toasts': ["Found a pleasant looking cottage in the woods."],
				'first_timeline': 'res://Timelines/WalkEvents/RiceHouseFirst.dtl',
				'flag': "rice_house"
			},],
		"icon": "res://Art/Background/NoranekoGames/Livingroom_Day.png"
	},
	'city_gates': {
		"label": "City Gates",
		'location_flag': "city_gates",
		'outcomes':
			[{
				'stats': {
					'stress': -10,
					'agility': 1,
				},
				'toasts': ["Took a walk around the gates."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Let's take a short break at the gates."],
				'timeline': 'res://Timelines/WalkEvents/CityGates.dtl',
				'first_toasts': ["Reached the gates, let's check in."],
				'first_timeline': 'res://Timelines/WalkEvents/CityGatesFirst.dtl',
				'flag': "city_gates"
			},],
		"icon": "res://Art/Background/Background material shop/bg003a.jpg"
	},
	'blessed_plains': {
		"label": "Blessed Plains",
		'location_flag': "blessed_plains",
		'outcomes':
			[{
				'stats': {
					'stress': -20,
				},
				'toasts': ["The air here feels really refreshing."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Let's wander around for a bit, the Dumplings seem quite friendly."],
				'timeline': 'res://Timelines/WalkEvents/BlessedPlains.dtl',
				'first_toasts': ["There seems to be a lot of Dumplings rolling around."],
				'first_timeline': 'res://Timelines/WalkEvents/BlessedPlainsFirst.dtl',
				'flag': "blessed_plains"
			},],
		"icon": "res://Art/Background/Background material shop/Edited/BlessedPlains.png"
	},
	#TODO Use https://atelier.fandom.com/wiki/Category:Atelier_Sophie_Locations as inspiration?
	'sacred_woods': {
		"label": "Sacred Woods",
		'location_flag': "sacred_woods",
		'outcomes':
			[{
				'stats': {
					'stress': -10,
					'magic': 5,
				},
				'toasts': ["There seems to be a trace of mana in the air."],
				'weight': 1,
			},
			{
				'stats': {
				},
				'weight': 1,
				'toasts': ["Time to toast some Dumplings at the campfire."],
				'timeline': 'res://Timelines/WalkEvents/SacredWoods.dtl',
				'first_toasts': ["Found a nice clearing to rest at."],
				'first_timeline': 'res://Timelines/WalkEvents/SacredWoodsFirst.dtl',
				'flag': "sacred_woods"
			},],
		"icon": "res://Art/Background/Background material shop/bg019a.jpg"
	},
}

const character_classes = {
	'warrior': {
		'base_stats': {
			'max_hp': 50,
			'attack': 10,
			'defense': 5,
			'agility': 5,
			'resistance': 1,
			'gold': 50,
			'experience': 10,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 50,
			'attack': 10,
			'defense': 6,
			'agility': 4,
			'resistance': 2,
			'gold': 10,
			'experience': 25,
		},
		'combat_skills': ["warcry"],
		'label': "Warrior",
	},
	'rogue': {
		'base_stats': {
			'max_hp': 20,
			'attack': 10,
			'defense': 5,
			'agility': 10,
			'resistance': 5,
			'gold': 50,
			'experience': 10,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 30,
			'attack': 6,
			'defense': 4,
			'agility': 10,
			'resistance': 8,
			'gold': 25,
			'experience': 25,
		},
		'combat_skills': ["preparation"],
		'label': "Rogue",
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_Yakimarsh.png',
			'skeleton': 'res://Art/It Came From The Swamp/Enemies/f_MinionsB.png',
			'human': 'res://Art/It Came From The Swamp/Enemies/f_thief1A.png',
		},
	},
	'priest': {
		'base_stats': {
			'max_hp': 25,
			'attack': 3,
			'magic': 5,
			'defense': 5,
			'agility': 5,
			'resistance': 10,
			'gold': 25,
			'experience': 50,
			'action_points': 1,
		},
		'level_stats': {
			'max_hp': 30,
			'attack': 2,
			'magic': 8,
			'defense': 6,
			'agility': 4,
			'resistance': 10,
			'gold': 15,
			'experience': 25,
		},
		'combat_skills': ["heal"],
		'label': "Priest",
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_LunaChime.png',
			'teru': 'res://Art/It Came From The Swamp/Enemies/f_Teruko.png',
			'human': 'res://Art/It Came From The Swamp/Enemies/f_ClericC.png',
		},
	},
	'mage': {
		'base_stats': {
			'max_hp': 10,
			'attack': 1,
			'magic': 10,
			'defense': 5,
			'agility': 5,
			'resistance': 5,
			'gold': 100,
			'experience': 100,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 20,
			'attack': 2,
			'magic': 10,
			'defense': 2,
			'agility': 6,
			'resistance': 6,
			'gold': 25,
			'experience': 25,
		},
		'combat_skills': ["fireball", "brilliance"],
		'label': "Mage",
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_candle.png',
			'teru': 'res://Art/It Came From The Swamp/Enemies/f_Teruo.png',
			'human': 'res://Art/It Came From The Swamp/Enemies/f_witchA.png',
		},
	},
	'hero': {
		'base_stats': {
			'max_hp': 50,
			'attack': 25,
			'magic': 15,
			'agility': 10,
			'defense': 10,
			'resistance': 10,
			'gold': 500,
			'experience': 250,
			'action_points': 1,
		},
		'level_stats': {
			'max_hp': 50,
			'attack': 10,
			'magic': 5,
			'agility': 10,
			'defense': 5,
			'resistance': 5,
			'gold': 250,
			'experience': 100,
		},
		'combat_skills': ["rally", "heal"],
		'label': "Hero",
		'portrait': {
			'human': 'res://Art/It Came From The Swamp/Enemies/f_brave2B.png',
		},
	},
	'assassin': {
		'base_stats': {
			'max_hp': 100,
			'attack': 50,
			'defense': 25,
			'agility': 50,
			'resistance': 25,
			'gold': 500,
			'experience': 250,
			'action_points': 4,
		},
		'level_stats': {
			'max_hp': 50,
			'attack': 10,
			'defense': 5,
			'agility': 15,
			'resistance': 12,
			'gold': 50,
			'experience': 50,
		},
		'combat_skills': ["preparation", "finishing_blow"],
		'label': "Assassin",
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_Yakimarsh.png',
			'skeleton': 'res://Art/It Came From The Swamp/Enemies/f_MinionsB.png',
		},
	},
	'knight': {
		'base_stats': {
			'max_hp': 100,
			'attack': 75,
			'defense': 50,
			'agility': 25,
			'resistance': 25,
			'gold': 500,
			'experience': 250,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 75,
			'attack': 15,
			'defense': 10,
			'agility': 10,
			'resistance': 10,
			'gold': 50,
			'experience': 50,
		},
		'combat_skills': ["rally", "finishing_blow"],
		'label': "Knight",
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_IcedCoffee.png',
			'skeleton': 'res://Art/It Came From The Swamp/Enemies/f_CaoptainB.png',
		},
	},
	'chieftain': {
		'base_stats': {
			'max_hp': 100,
			'attack': 75,
			'defense': 50,
			'agility': 25,
			'resistance': 25,
			'gold': 500,
			'experience': 250,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 125,
			'attack': 15,
			'defense': 10,
			'agility': 10,
			'resistance': 10,
			'gold': 50,
			'experience': 50,
		},
		'combat_skills': ["rally"],
		'label': "Chieftain",
		'portrait': {
			'orc': 'res://Characters/Orc King/Images/Portrait/OrcKing_0.png',
		},
	},
	'high_priest': {
		'base_stats': {
			'max_hp': 50,
			'attack': 25,
			'magic': 50,
			'defense': 25,
			'agility': 10,
			'resistance': 50,
			'gold': 500,
			'experience': 250,
			'action_points': 1,
		},
		'level_stats': {
			'max_hp': 35,
			'attack': 8,
			'magic': 12,
			'defense': 10,
			'agility': 5,
			'resistance': 20,
			'gold': 50,
			'experience': 50,
		},
		'combat_skills': ["light_barrier", "smite"],
		'label': "High Priest",
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_BroccoliA.png',
			'teru': 'res://Art/It Came From The Swamp/Enemies/f_Teruko.png',
		},
	},
	'wizard': {
		'base_stats': {
			'max_hp': 50,
			'attack': 15,
			'magic': 75,
			'defense': 10,
			'agility': 25,
			'resistance': 35,
			'gold': 500,
			'experience': 250,
			'action_points': 1,
		},
		'level_stats': {
			'max_hp': 25,
			'attack': 5,
			'magic': 20,
			'defense': 5,
			'agility': 15,
			'resistance': 10,
			'gold': 50,
			'experience': 50,
		},
		'combat_skills': ["fireball", "lightning_bolt", "amplify_magic"],
		'label': "Wizard",
		'portrait': {
			'dumpling': 'res://Art/It Came From The Swamp/Enemies/f_curry.png',
			'teru': 'res://Art/It Came From The Swamp/Enemies/f_Teruo.png',
		},
	},
	'rice': {
		'base_stats': {
			'max_hp': 100,
			'attack': 50,
			'defense': 50,
			'agility': 50,
			'magic': 50,
			'resistance': 50,
			'gold': 500,
			'experience': 250,
			'action_points': 4,
		},
		'level_stats': {
			'experience': 100,
			'gold': 50,
			'max_hp': 50,
			'attack': 25,
			'defense': 25,
			'agility': 40,
			'magic': 50,
			'resistance': 25,
		},
		'combat_skills': ["judgement"],
		'label': "Rice",
		'portrait': {
			'lesser_phantom': 'res://Characters/Rice/Images/Portrait/idle_000.png',
			'greater_phantom_magic_officer': 'res://Characters/Rice/Images/Portrait/idle_000.png',
		},
	},
	'oliver': {
		'base_stats': {
		},
		'level_stats': {
			'max_hp': 50,
			'attack': 20,
			'magic': 10,
			'agility': 15,
			'defense': 10,
			'resistance': 10,
			'gold': 3,
			'experience': 15,
		},
		'combat_skills': [],
		'label': "Oliver",
		'portrait': {
			'blank': 'res://Characters/Oliver/Images/Portrait/Goblin_1.png',
		},
	},
}

const races = {
	'dumpling': {
		'base_stats': {
			'max_hp': 25,
			'attack': 5,
			'defense': 5,
			'agility': 5,
			'resistance': 5,
			'gold': 100,
			'experience': 10,
			'action_points': 1,
		},
		'level_stats': {
			'experience': 1,
		},
		'label': 'Dumpling',
		'portrait': 'res://Art/It Came From The Swamp/Enemies/f_manju.png',
	},
	'skeleton': {
		'base_stats': {
			'max_hp': 50,
			'attack': 10,
			'defense': 10,
			'agility': 10,
			'resistance': 5,
			'gold': 150,
			'experience': 20,
			'action_points': 1,
		},
		'level_stats': {
			'experience': 2,
			'gold': 5,
		},
		'label': 'Skeleton',
		'portrait': 'res://Art/It Came From The Swamp/Enemies/f_MinionsA.png',
	},
	'teru': {
		'base_stats': {
			'max_hp': 100,
			'attack': 25,
			'defense': 25,
			'agility': 25,
			'resistance': 10,
			'gold': 250,
			'experience': 50,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 2,
			'attack': 1,
			'experience': 10,
			'gold': 5,
		},
		'label': 'Teru',
		'portrait': 'res://Art/It Came From The Swamp/Enemies/f_TeruoB.png',
	},
	'human': {
		'base_stats': {
			'max_hp': 50,
			'attack': 10,
			'defense': 10,
			'agility': 10,
			'resistance': 10,
			'gold': 500,
			'experience': 100,
			'action_points': 1,
		},
		'level_stats': {
			'max_hp': 5,
			'attack': 1,
			'magic': 1,
			'experience': 25,
			'gold': 15,
		},
		'label': 'Human',
		'portrait': 'res://Art/It Came From The Swamp/Enemies/f_SoldierB.png',
	},
	'orc': {
		'base_stats': {
			'max_hp': 100,
			'attack': 25,
			'defense': 25,
			'agility': 25,
			'resistance': 10,
			'gold': 250,
			'experience': 50,
			'action_points': 2,
		},
		'level_stats': {
			'max_hp': 10,
			'attack': 5,
			'experience': 50,
			'gold': 50,
		},
		'label': 'Orc',
		'portrait': 'res://Characters/Orc/Images/Portrait/Orc_0.png',
	},
	'lesser_phantom': {
		'base_stats': {
			'max_hp': 50,
			'attack': 10,
			'defense': 10,
			'agility': 10,
			'resistance': 10,
			'magic': 10,
			'gold': 200,
			'experience': 100,
			'action_points': -3,
		},
		'level_stats': {
			'gold': 25,
			'experience': 25,
			'max_hp': -20,
			'attack': -10,
			'defense': -10,
			'agility': -10,
			'magic': -10,
			'resistance': -10,
		},
		'label': 'Lesser Phantom:',
	},
	'greater_phantom_magic_officer': {
		'base_stats': {
			'max_hp': 50,
			'attack': 15,
			'magic': 75,
			'defense': 10,
			'agility': 25,
			'resistance': 35,
			'gold': 500,
			'experience': 250,
		},
		'level_stats': {
			'max_hp': 15,
			'attack': -5,
			'magic': 10,
			'defense': -5,
			'agility': 5,
			'resistance': 0,
			'gold': 50,
			'experience': 50,
		},
		'combat_skills': ["lightning_bolt", "amplify_magic", "light_barrier"],
		'label': 'Greater Phantom: Magic Officer ',
	},
	'blank': {
		'base_stats': {
			'max_hp': 100,
			'attack': 10,
			'defense': 10,
			'agility': 10,
			'resistance': 10,
			'gold': 100,
			'experience': 10,
			'action_points': 1,
		},
		'level_stats': {
		},
		'label': '',
		'portrait': 'res://icon.svg',
	},
}

const tower_levels = [
	{
		'level': 0,
		'enemies': [
			{
				"level": 1,
				"character_class": "warrior",
				"race": "dumpling",
			},
		],
		'image': "res://Art/It Came From The Swamp/Enemies/f_manju.png",
		'description': "A Dumpling Warrior. Starts weak, but can buff itself to dangerous levels.\n\nDumplings are a variety of slime. Domesticated Dumplings have a fluffy texture and slightly sweet taste, but wild Dumplings are rubbery and bitter. It's considered extremely rude to nibble on Dumplings without asking permission first.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_0.tscn",
	},
	{
		'level': 1,
		'enemies': [
			{
				"level": 2,
				"character_class": "rogue",
				"race": "skeleton",
			},
		],
		'image': "res://Art/It Came From The Swamp/Enemies/f_MinionsB.png",
		'description': "A Skeleton Rogue. Has the ability to slow you down.\n\nAnimated Skeletons are a common sight anywhere creatures have died. Regardless of where the bones came from, all Skeletons share the same basic shape. Surprisingly fond of alcohol, so remember to bring a mop if you invite one to a party. Not a good source of calcium.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_1.tscn",
	},
	{
		'level': 2,
		'enemies': [
			{
				"level": 3,
				"character_class": "mage",
				"race": "dumpling",
			},
		],
		'image': "res://Art/It Came From The Swamp/Enemies/f_candle.png",
		'description': "A Dumpling Mage. Good with Fireballs, occasionally buffs, sometimes smacks you with a stick. Don't ask where the stick came from.\n\nMages tend to know a counterspell or two, which can gunk up your spellbook. Due to its burn effect, Fireball does more damage than you might expect, so keep your guard up.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_2.tscn",
	},
	{
		'level': 3,
		'enemies': [
			{
				"level": 4,
				"character_class": "warrior",
				"race": "teru",
			},
		],
		'description': "A Teru Warrior. Teru are naturally stronger and faster than Dumplings or Skeletons.\n\nTeru, or 'teru teru bōzu', are a relatively new variety of ghost. Small and friendly, they're commonly thought to be signs of good weather. Like hanging themselves on string, often surprising people by accident while doing so. Non-edible, so please stop trying.",
		'image': "res://Art/It Came From The Swamp/Enemies/f_TeruoB.png",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_3.tscn",
	},
	{
		'level': 4,
		'enemies': [
			{
				"level": 5,
				"character_class": "warrior",
				"race": "dumpling",
			},
			{
				"level": 5,
				"character_class": "priest",
				"race": "dumpling",
			},
		],
		'image': "res://Art/It Came From The Swamp/Enemies/f_LunaChime.png",
		'description': "A Dumpling Warrior and a Dumpling Priest. You should probably deal with the healer as quickly as possible.\n\nA Dumpling's taste changes depending on its class. Unfortunately, wild varieties get less palatable from changing to a rarer class. Domesticated Dumplings, on the other hand, are too expensive to be affordable outside of the most common classes.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_4.tscn",
	},
	{
		'level': 5,
		'enemies': [
			{
				"level": 6,
				"character_class": "warrior",
				"race": "skeleton",
			},
			{
				"level": 6,
				"character_class": "mage",
				"race": "teru",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_MinionsA.png',
		'description': "A Skeleton Warrior and a Teru Mage. Although Teru don't have any special advantages in casting magic, their high agility means they make excellent mages nontheless.\n\nAlthough normal undead tend to be mindlessly hostile, the ones you can find near the capital are easy to get along with. The reason is very simple, the dangerous ones have been dealt with already.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_5.tscn",
	},
	{
		'level': 6,
		'enemies': [
			{
				"level": 7,
				"character_class": "warrior",
				"race": "teru",
			},
			{
				"level": 7,
				"character_class": "rogue",
				"race": "skeleton",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_TeruoB.png',
		'description': "A Teru Warrior and a Skeleton Rogue. Fast enemies can be very hard to deal with, sometimes they can even 'lap' you, forcing you to do nothing for a turn.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_6.tscn",
	},
	{
		'level': 7,
		'enemies': [
			{
				"level": 8,
				"character_class": "mage",
				"race": "teru",
			},
			{
				"level": 8,
				"character_class": "priest",
				"race": "teru",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_Teruo.png',
		'description': "A Teru Mage and a Teru Priest. Both are dangerous in their own way, but the Mage is probably the bigger immediate danger.\n\nIt's a common belief that seeing a Teru holding an umbrella is a sign of rain. In fact, however, all Teru have umbrellas, but only Teru Mages carry them even when the sun is shining. Although they'll happily share if asked, it's hard to see how such a tiny umbrella can be helpful when you're being rained on.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_7.tscn",
	},
	{
		'level': 8,
		'enemies': [
			{
				"level": 9,
				"character_class": "mage",
				"race": "teru",
			},
			{
				"level": 9,
				"character_class": "mage",
				"race": "dumpling",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_candle.png',
		'description': "A Teru Mage and a Dumpling Mage. Since Rice will be happy to heal you up after a duel, win or lose, a purely offensive team like this might be surprisingly easy to deal with.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_8.tscn",
	},
	{
		'level': 9,
		'enemies': [
			{
				"level": 10,
				"character_class": "warrior",
				"race": "dumpling",
			},
			{
				"level": 10,
				"character_class": "rogue",
				"race": "dumpling",
			},
			{
				"level": 10,
				"character_class": "mage",
				"race": "dumpling",
			},
			{
				"level": 10,
				"character_class": "priest",
				"race": "dumpling",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_Yakimarsh.png',
		'description': "A Dumpling adventuring party! Even Dumplings get to go on adventures. Although the road ahead is long, they've taken their first steps to becoming Heroes.\n\nAccording to a certain King of Demons, a Dumpling Hero is surprisingly delicious. It seems like the Dumpling Hero regressed back to a Dumpling Swordmaster afterwards, although it's not certain if it's because it lost or because she took a bite.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_9.tscn",
	},
	{
		'level': 10,
		'enemies': [
			{
				"level": 11,
				"character_class": "rice",
				"race": "lesser_phantom",
			},
		],
		'image': 'res://Characters/Rice/Images/Portrait/idle_000.png',
		'description': "It's Rice! Not really. Phantoms are monsters that mimic the appearance and ability of others. This one is a Lesser Phantom, so it's significantly weaker and slower than the original.\n\nDue to their inherent disadvantages in fighting, Phantoms tend to be cautious and non-aggressive. Once famous for their ability as spies and infiltrators, the advances in disguise and detection magecraft caused most Phantoms to enter the service industry instead. Not to be confused with Doppelgangers, which have been hunted to near extinction for their tendency to aggressively replace their counterparts.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_10.tscn",
	},
	{
		'level': 11,
		'enemies': [
			{
				"level": 12,
				"character_class": "warrior",
				"race": "teru",
			},
			{
				"level": 12,
				"character_class": "warrior",
				"race": "teru",
			},
			{
				"level": 12,
				"character_class": "assassin",
				"race": "skeleton",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_MinionsB.png',
		'description': "Two Teru Warriors and a Skeleton Assassin. Assassin is an advanced class with extremely high agility.\n\nThankfully, you have Rice with you, so you'll almost always have the first turn. Counterintuitively, resistance, scholarship, and skill might be better than agility against enemies that focus on agility.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_11.tscn",
	},
	{
		'level': 12,
		'enemies': [
			{
				"level": 13,
				"character_class": "knight",
				"race": "skeleton",
			},
			{
				"level": 13,
				"character_class": "mage",
				"race": "teru",
			},
			{
				"level": 13,
				"character_class": "priest",
				"race": "teru",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_CaoptainB.png',
		'description': "A Skeleton Knight, Teru Mage, and Teru Priest. Knight is an advanced class with strong skills and well-rounded stats.\n\nAlthough a Knight's skills combine offense and defense in a balanced way, they tend to be too slow to be dangerous alone.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_12.tscn",
	},
	{
		'level': 13,
		'enemies': [
			{
				"level": 14,
				"character_class": "knight",
				"race": "dumpling",
			},
			{
				"level": 14,
				"character_class": "knight",
				"race": "dumpling",
			},
			{
				"level": 14,
				"character_class": "assassin",
				"race": "dumpling",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_IcedCoffee.png',
		'description': "Two Dumpling Knights and a Dumpling Asassin.\n\nDumpling Knights, as you might expect from their appearance, have a bitter, chocolatey taste. Although wild varieties are unpalatably bitter, domesticated Dumpling Knights are considered a prime tea time snack, pairing well with the sweetness of Dumpling Assassins. Assuming, of course, that you could afford the expense.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_13.tscn",
	},
	{
		'level': 14,
		'enemies': [
			{
				"level": 15,
				"character_class": "knight",
				"race": "dumpling",
			},
			{
				"level": 15,
				"character_class": "high_priest",
				"race": "dumpling",
			},
			{
				"level": 15,
				"character_class": "high_priest",
				"race": "dumpling",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_BroccoliA.png',
		'description': "A Dumpling Knight and two Dumpling High Priests. High Priests are excellent at healing and protection spells, and being an advanced class means they even have access to fireballs.\n\nDespite appearances, Dumpling High Priests aren't vegetables. Although they're nutritious, even domesticated varieties are exceptionally bitter. Some are quite sensitive about their appearance, so it's best not to mistake them for broccoli.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_14.tscn",
	},
	{
		'level': 15,
		'enemies': [
			{
				"level": 16,
				"character_class": "wizard",
				"race": "dumpling",
			},
			{
				"level": 16,
				"character_class": "mage",
				"race": "teru",
			},
			{
				"level": 16,
				"character_class": "mage",
				"race": "teru",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_curry.png',
		'description': "A Dumpling Wizard and two Teru Mages. Wizards tend to be deceptively hard to defeat as long as they aren't caught flat-footed, thanks to their ability to fast cast shielding spells in addition to another spell.\n\nAs a rare exception, even wild Dumpling Wizards have a sweet, mellow taste, making them extremely popular. It's unknown whether the rice portion or the curry portion is the main body. ...What do you mean curry isn't a type of dumpling?",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_15.tscn",
	},
	{
		'level': 16,
		'enemies': [
			{
				"level": 17,
				"character_class": "knight",
				"race": "teru",
			},
			{
				"level": 17,
				"character_class": "wizard",
				"race": "teru",
			},
			{
				"level": 17,
				"character_class": "high_priest",
				"race": "teru",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_TeruoB.png',
		'description': "A Teru adventuring party! Not really. It seems like a trio of Teru gathered together to play pretend adventurers. Please consider buying a demon king costume and getting defeated, it'll make their day.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_16.tscn",
	},
	{
		'level': 17,
		'enemies': [
			{
				"level": 18,
				"character_class": "knight",
				"race": "skeleton",
			},
			{
				"level": 18,
				"character_class": "warrior",
				"race": "skeleton",
			},
			{
				"level": 18,
				"character_class": "rogue",
				"race": "skeleton",
			},
			{
				"level": 18,
				"character_class": "knight",
				"race": "skeleton",
			},
			{
				"level": 18,
				"character_class": "warrior",
				"race": "skeleton",
			},
			{
				"level": 18,
				"character_class": "rogue",
				"race": "skeleton",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_CaoptainB.png',
		'description': "A squad of Skeletons on a training trip. Although basic Skeletons are quite weak, it's still dangerous to leave them alone too long.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_17.tscn",
	},
	{
		'level': 18,
		'enemies': [
			{
				"level": 19,
				"character_class": "wizard",
				"race": "teru",
			},
			{
				"level": 19,
				"character_class": "wizard",
				"race": "teru",
			},
			{
				"level": 19,
				"character_class": "wizard",
				"race": "teru",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_Teruo.png',
		'description': "A trio of Teru Wizards. The best defense is a fast offense against a team like this.\n\nIt's unkown where Teru carry their umbrellas, but even in the rare case that they lose one they take another one out from somewhere.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_18.tscn",
	},
	{
		'level': 19,
		'enemies': [
			{
				"level": 20,
				"character_class": "knight",
				"race": "dumpling",
			},
			{
				"level": 20,
				"character_class": "assassin",
				"race": "dumpling",
			},
			{
				"level": 20,
				"character_class": "wizard",
				"race": "dumpling",
			},
			{
				"level": 20,
				"character_class": "high_priest",
				"race": "dumpling",
			},
		],
		'image': 'res://Art/It Came From The Swamp/Enemies/f_IcedCoffee.png',
		'description': "A Dumpling adventuring party! They trained hard and even class changed. Unlike Teru, Dumplings tend to take duels seriously, so please don't hold back.\n\nAs you might expect, Dumplings are quite fond of flour, so gifting them a bag of flour is an easy way to get close. That said, since they're fundamentally slimes, Dumplings can eat just about everything, although they have a harder time digesting minerals. Thanks to that, it's quite common to see domesticated Dumplings acting as vacuum cleaners.",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_19.tscn",
	},
	{
		'level': 20,
		'enemies': [
			{
				"level": 21,
				"character_class": "rice",
				"race": "greater_phantom_magic_officer",
			},
		],
		'image': 'res://Characters/Rice/Images/Portrait/idle_000.png',
		'description': "It's Rice again! Not really. Again. This one is a Phantom rather than Lesser Phantom, so it has more health and managed to copy another of Rice's skills.  Dispel isn't very dangerous by itself, but it can cause massive issues for decks that rely on buffs.\n\nDid you know that default amount of cards you draw every turn is two?",
		'encounter': "res://Scenes/CardGame/EncounterScenes/TowerLevels/tower_level_20.tscn",
	},
]

const expedition = {
	"Dumpling Dungeon":{
		"random_encounters": ["res://Scenes/CardGame/EncounterScenes/ExpeditionCombats/DumplingDungeon/RandomEncounters/dumpling_dungeon_0.tscn", "res://Scenes/CardGame/EncounterScenes/ExpeditionCombats/DumplingDungeon/RandomEncounters/dumpling_dungeon_1.tscn", "res://Scenes/CardGame/EncounterScenes/ExpeditionCombats/DumplingDungeon/RandomEncounters/dumpling_dungeon_2.tscn", "res://Scenes/CardGame/EncounterScenes/ExpeditionCombats/DumplingDungeon/RandomEncounters/dumpling_dungeon_3.tscn", "res://Scenes/CardGame/EncounterScenes/ExpeditionCombats/DumplingDungeon/RandomEncounters/dumpling_dungeon_4.tscn"],
		"boss_fights": ["res://Scenes/CardGame/EncounterScenes/ExpeditionCombats/DumplingDungeon/BossFights/dumpling_dungeon_boss_fight.tscn"],
		"icon": "res://Art/It Came From The Swamp/Enemies/f_manju.png",
		"description": "Her majesty posted a dungeon delving request for a nearby dungeon. Apparently she's unsatisfied with the contents of the treasure chests inside, so she wants you to replace them with higher quality items.",
		"stats": {},
		"info_timeline": "DumplingDungeonInfo",
		"encounter_timeline": "DumplingDungeonRandomEncounter",
		"encounters_before_boss": 3,
		"victory_timeline": "DumplingDungeonVictory",
		"defeat_timeline": "DumplingDungeonDefeat",
		"boss_timeline": "DumplingDungeonBoss",
		"finish_timeline": "DumplingDungeonFinish",
	}
}

const combat_skills = {
	'basic_attack': {
		'weight': 10,
		'effect_target': 'enemy',
		'effect_type': 'attack',
		'effect_range': 'single',
		'effect_strength': 100,
		'label': "Basic Attack"
	},
	'warcry': {
		'stats': {
			'attack': 20,
		},
		'weight': 5,
		'effect_target': 'ally',
		'effect_type': 'buff',
		'effect_range': 'area',
		'message': "attack increased for the enemy party!",
		'message_player': "attack increased!",
		'label': "Warcry",
	},
	'rally': {
		'stats': {
			'attack': 50,
			'defense': 50,
			'resistance': 25,
		},
		'weight': 5,
		'effect_target': 'ally',
		'effect_type': 'buff',
		'effect_range': 'area',
		'message': "attack, defense, and resistance increased for the enemy party!",
		'message_player': "attack, defense, and resistance increased!",
		'label': "Rally",
	},
	'preparation': {
		'stats': {
			'action_points': 1,
		},
		'weight': 5,
		'effect_target': 'self',
		'effect_type': 'buff',
		'effect_range': 'self',
		'message': "Enemy action points increased!",
		'message_player': "Action points increased!",
		'label': "Preparation",
	},
	'heal': {
		'weight': 10,
		'effect_target': 'ally',
		'effect_type': 'heal',
		'effect_range': 'single',
		'effect_strength': 100,
		'label': "Heal"
	},
	'light_barrier': {
		'weight': 20,
		'effect_target': 'ally',
		'effect_type': 'heal',
		'effect_range': 'single',
		'effect_strength': 250,
		'label': "Light Barrier",
		#'animation': "", #TODO, replace with enemy animation
		'animation_player': "res://Characters/Mao/Videos/special_01.ogv",
		'animation_length_player': 3.8,
		'animation_size_player': Vector2(600, 750),
	},
	'brilliance': {
		'stats': {
			'magic': 20,
		},
		'weight': 10,
		'effect_target': 'ally',
		'effect_type': 'buff',
		'effect_range': 'area',
		'message': "Magic increased for the enemy party!",
		'message_player': "Magic increased!",
		'label': "Brilliance",
	},
	'amplify_magic': {
		'stats': {
			'magic': 75,
		},
		'weight': 10,
		'effect_target': 'ally',
		'effect_type': 'buff',
		'effect_range': 'area',
		'message': "Magic significantly increased for the enemy party!",
		'message_player': "Magic increased significantly!",
		'label': "Amplify Magic",
	},
	'paintball': {
		'weight': 10,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'single',
		'effect_strength': 50,
		'label': "Paintball"
	},
	'fireball': {
		'weight': 15,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'single',
		'effect_strength': 200,
		'label': "Fireball"
	},
	'lightning_bolt': {
		'weight': 10,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'single',
		'effect_strength': 350,
		'label': "Lightning Bolt"
	},
	'smite': {
		'weight': 10,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'single',
		'effect_strength': 100,
		'label': "Smite"
	},
	'meteor': {
		'weight': 10,
		'effect_target': 'enemy',
		'effect_type': 'magic_attack',
		'effect_range': 'area',
		'effect_strength': 150,
		'label': "Meteor",
		'animation_player': "res://Characters/Mao/Videos/mtn_04.ogv",
		'animation_length_player': 2.0,
		'animation_size_player': Vector2(600, 750),
	},
	'finishing_blow': {
		'weight': 5,
		'effect_target': 'enemy',
		'effect_type': 'physical_attack',
		'effect_range': 'single',
		'effect_strength': 300,
		'label': "Finishing Blow"
	},
	'judgement': {
		'weight': 25,
		'effect_target': 'enemy',
		'effect_type': 'special_fixed',
		'effect_range': 'single',
		'effect_strength': 1000,
		'label': "Judgement",
		'animation': "res://Characters/Rice/Videos/mtn_03.ogv",
		'animation_length': 4,
		'animation_size': Vector2(900, 750),
	},
	'blessing': {
		'stats': {
			'magic': 200,
			'attack': 200,
			'defense': 200,
			'resistance': 200,
			'agility': 200,
			'skill': 200,
		},
		'weight': 10,
		'effect_target': 'ally',
		'effect_type': 'buff',
		'effect_range': 'area',
		'message': "Stats drastically increased for enemy party!",
		'message_player': "Stats drastically increased!",
		#'animation': "res://Characters/Rice/Videos/mtn_03.ogv", #TODO, replace with enemy animation
		'animation_player': "res://Characters/Mao/Videos/special_03.ogv",
		'animation_length_player': 7.7,
		'animation_size_player': Vector2(600, 750),
		'label': "Blessing",
	},
}

const combat_items = {
	'health_potion': {
		'effects': {
			'health': 100,
		},
		'message': "Health restored!",
		'message_player': "HP increased!",
		'label': "Health Potion",
		'id': "health_potion",
		'icon': "res://Art/Mori no oku no kakurezato/Potions/Resized/potion1_05.png",
		'description': "A red potion for restoring health. Seems to heal around 100 health.",
	},
	'mana_potion': {
		'effects': {
			'mana': 5,
		},
		'message': "Mana restored!",
		'message_player': "Mana restored!",
		'label': "Mana Potion",
		'id': "mana_potion",
		'icon': "res://Art/Mori no oku no kakurezato/Potions/Resized/potion1_01.png",
		'description': "A blue potion for restoring mana. To be precise, it restores 5 units of mana.",
	},
	'overload_potion': {
		'effects': {
			'buffs': {
				'res://Scenes/CardGame/Status/attack.tres': 2,
				'res://Scenes/CardGame/Status/magic.tres': 2,
				'res://Scenes/CardGame/Status/skill.tres': 2,
				'res://Scenes/CardGame/Status/defense.tres': 2,
				'res://Scenes/CardGame/Status/resistance.tres': 2,
			},
		},
		'message': "Stats increased!",
		'message_player': "Stats increased!",
		'label': "Overload Potion",
		'id': "overload_potion",
		'icon': "res://Art/Mori no oku no kakurezato/Potions/Resized/potion1_02.png",
		"description": "An indigo potion which increases all stats when drunk. Increases increases attack, magic, skill, defense, and resistance by 2 stacks each.",
	},
}

const relics = {
	"big_potato": {
		"label": "Big Potato",
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/potato.png",
		"message_player": "You take out the Big Potato so people can behold it. It doesn't seem to do anything.",
		"description": "You lose 30 block at the start of your turn instead of all your block.",
		#implement additional effects directly in card_game, card is only for on use effect
		'card': "",
		"block_reduction": 30,
	},
	"detergent": {
		"label": "Detergent Bottle",
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/detergent01_01.png",
		"message_player": "You spray detergent all over yourself. For some reason.",
		"description": "Can be used to gain a stack of resistance in exchange for 2 mana.",
		'card': "res://Scenes/CardGame/Card/Relics/DetergentBottle.tres",
	},
}

const player_classes = {
	"ink_mage": {
		"description": "A mage with an affinity for ink. A rare non-combat variant of the mage class. \nAs a non-combat class, stat gains from leveling up are low, combat skills are difficult to acquire, and experience can be obtained for non-combat actions.",
		"id": "ink_mage",
		"label": "Ink Mage",
		"tier": 0,
		"type": "",
	},
	"ink_mage_journeyman": {
		"description": "A promoted ink mage. As a natural promotion to the basic ink mage class, requirements are low and stats are similar across the board. \n\nThe ink mage series has access to most types of magic, but won't learn spells from level ups.",
		"id": "ink_mage_journeyman",
		"label": "Ink Mage (Journeyman)",
		"tier": 1,
		"type": "Non-combat",
		"required_stats": {
			"level": 1,
			"max_hp": 100,
			"max_mp": 50,
			"attack": 20,
			"magic": 50,
			"agility": 25,
			"defense": 20,
			"resistance": 30,
			"scholarship": 100,
			"art": 50,
		},
	},
	"magic_officer_trainee": {
		"description": "A newly developed 'hybrid' version of the Magic Officer (Trainee) class. The original Magic Officer class is a combat class with high magic and agility, well rounded access to spells and combat skills, and excellent stat growths and caps.\n\nThe hybrid version is closer to a non-combat class than a combat class: stat gains from leveling up are low, stat caps are average, and experience can be obtained for non-combat actions. Skills can be acquired from leveling up.",
		"id": "magic_officer_trainee",
		"label": "Magic Officer (Trainee)",
		"tier": 1,
		"type": "Hybrid",
		"required_stats": {
			"level": 25,
			"max_hp": 400,
			"max_mp": 200,
			"attack": 200,
			"magic": 300,
			"agility": 300,
			"defense": 200,
			"resistance": 200,
			"skill": 200,
			"scholarship": 200,
		},
		"required_skills": ["honorary_officer"],
	},
}

const ending_cards = {
	#stats = ["max_hp", "max_mp", "attack", "magic", "skill", "agility", "defense", "resistance", "art", "scholarship"],
	"basic_dumpling": {
		"stats": {
			"max_hp": 10,
			"max_mp": 10,
			"attack": 10,
			"magic": 10,
			"skill": 10,
			"agility": 10,
			"defense": 10,
			"resistance": 10,
			"art": 10,
			"scholarship": 10,
		},
		"description": "You are a basic Dumpling. Although weak and small, you are well rounded and pleasant to be around. Be careful not to get nibbled on.",
	},
	"teru": {
		"stats": {
			"max_hp": 10,
			"max_mp": 10,
			"attack": 10,
			"magic": 10,
			"skill": 10,
			"agility": 10,
			"defense": 10,
			"resistance": 10,
			"art": 10,
			"scholarship": 10,
		},
		"description": "You are a Teru. Lively and cheerful with ex",
	}
}

const missions = {
	"black_forest_orcs": {
		"description": "There's a small tribe of orcs living in the Black Forest. Her majesty ordered you to either incorporate them into the kingdom or drive them out.\n\nAlthough the use of force is authorized, going in spells blazing would be the opposite of her majesty's intent. The orcs are valuable human resources.\n\nEncounter Level: 10\nThe wild Dumplings hanging out in the Blessed Plains are a bigger threat. Speaking of Dumplings, the head maid would like you to stop nibbling on the cleaning Dumplings.",
		"id": "black_forest_orcs",
		"label": "Black Forest Orcs",
		"first_timeline": "BlackForestOrcs0",
		"type": "Main Story",
		"encounter_difficulty": 10,
		"mission_complete_image": "res://Timelines/BlackForestOrcs/TheLittleGoblinWhoCould.png",
		"combats": [
			"res://Scenes/CardGame/EncounterScenes/MissionCombats/BlackForestOrcs/black_forest_orcs_0.tscn",
			"res://Scenes/CardGame/EncounterScenes/MissionCombats/BlackForestOrcs/black_forest_orcs_1.tscn",
			"res://Scenes/CardGame/EncounterScenes/MissionCombats/BlackForestOrcs/black_forest_orcs_2.tscn",
			"res://Scenes/CardGame/EncounterScenes/MissionCombats/BlackForestOrcs/black_forest_orcs_3.tscn",
		]
	},
}

const timelines = {
	"bedtime": ["Bedtime0", "Bedtime1"]#, "Bedtime2", "Bedtime3"],
}

const decks = {
	"Brick Hand Accident": "res://Scenes/CardGame/Characters/Mao/Decks/brick_hand_accident.tres",
	"New Beginning": "res://Scenes/CardGame/Characters/Mao/Decks/new_beginning.tres",
	"Prestidigitation": "res://Scenes/CardGame/Characters/Mao/Decks/prestidigitation.tres",
}

const quests = {
	"good_student": {
		"name": "Good Student",
		"requirements": {
			"stats": {
				"scholarship": 100,
				},
		},
		"description": "A student's job is to study. Let's get 100 scholarship in a week.",
		"rewards": {
			"stats": {
				"stress": -20,
				"scholarship": 20,
			},
			"timeline": "GoodStudentSuccess",
		},
		"failure_conditions": {
			"day": 7,
		},
		"failure_rewards": {
			"timeline": "GoodStudentFailure",
		}
	},
	"good_student_2": {
		"name": "Gooder Student",
		"requirements": {
			"stats": {
				"scholarship": 300,
				},
		},
		"description": "A student's job is to study. Let's get 300 scholarship before the middle of the month.",
		"rewards": {
			"stats": {
				"stress": -20,
				"scholarship": 20,
			},
			"timeline": "GoodStudentSuccess2",
		},
		"failure_conditions": {
			"day": 14,
		},
		"failure_rewards": {
			"timeline": "GoodStudentFailure",
		}
	},
	"good_student_3": {
		"name": "Goodest Student?",
		"requirements": {
			"stats": {
				"scholarship": 600,
				},
		},
		"description": "A student's job is to study. Let's get 600 scholarship before the 21st.",
		"rewards": {
			"stats": {
				"stress": -20,
				"scholarship": 20,
			},
			"timeline": "GoodStudentSuccess3",
		},
		"failure_conditions": {
			"day": 21,
		},
		"failure_rewards": {
			"timeline": "GoodStudentFailure",
		}
	},
	"good_student_4": {
		"name": "Good Student, Final Exam",
		"requirements": {
			"stats": {
				"scholarship": 800,
				},
		},
		"description": "A student's job is to study. Let's get 800 scholarship before the month ends and pass the finals.",
		"rewards": {
			"stats": {
				"stress": -20,
				"scholarship": 20,
			},
			"timeline": "GoodStudentSuccess4",
		},
		"failure_conditions": {
			"day": 21,
		},
		"failure_rewards": {
			"timeline": "GoodStudentFailure",
		}
	},
	"tower_climber": {
		"name": "Tower Climber",
		"requirements": {
			"tower_level": 10,
		},
		"description": "After finally getting some magic cards to play with, you decided to climb the tower. Try climbing past floor 10 first, maybe her majesty will encourage you with a reward?\nTime Limit: Day 14",
		"rewards": {
			"stats": {
				"stress": -20,
				"max_hp": 10,
				"max_mp": 20,
				"attack": 10,
				"magic": 10,
				"agility": 10,
			},
			"timeline": "TowerClimberSuccess",
		},
		"failure_conditions": {
			"day": 14,
		},
		"failure_rewards": {
			"timeline": "TowerClimberFailure",
		}
	},
	"tower_climber_2": {
		"name": "Tower Climberer",
		"requirements": {
			"tower_level": 20,
		},
		"description": "The first ten floors seemed easy enough, let's keep climbing. The goal is floor 20 this time.\nTime Limit: Day 30",
		"rewards": {
			"stats": {
				"gold": 1000,
				"stress": -20,
				"max_hp": 10,
				"max_mp": 20,
				"attack": 10,
				"magic": 10,
				"agility": 10,
			},
			"timeline": "TowerClimberSuccess2",
		},
		"failure_conditions": {
			"day": 30,
		},
		"failure_rewards": {
			"timeline": "TowerClimberFailure",
		}
	},
	"budding_artist": {
		"name": "Budding Arist",
		"requirements": {
			"stats": {
				"art": 400,
				},
		},
		"description": "Her majesty can be considered a patron of the arts, so she'll probably give you a reward for becoming a better artist.",
		"rewards": {
			"stats": {
				"gold": 1000,
				"stress": -20,
				"max_hp": 10,
				"max_mp": 20,
				"attack": 10,
				"magic": 10,
				"agility": 10,
			}
		},
		"failure_conditions": {
			"day": 30,
		},
	},
	"overlord": {
		"name": "Super Duper Ultra Supreme Overlord!",
		"requirements": {
			"tower_level": 20,
			"stats": {"scholarship": 600},
		},
		"description": "Now that you have some magic cards, it's time to turn evil! Get your studies out of the way before climbing as far up the tower as you can, which should get you the strength to challenge her majesty to a children's card game.",
		"rewards": {
			"stats": {
				"gold": 1000,
				"stress": -20,
				"max_hp": 10,
				"max_mp": 20,
				"attack": 10,
				"magic": 10,
				"agility": 10,
			}
		},
		"failure_conditions": {
			"day": 30,
		},
	},
	"inspiration": {
		"name": "Inspiration",
		"requirements": {
			"work": {
				"Doodle": 1,
				},
		},
		"description": "It feels like something good will happen if you try to draw something today.",
		"rewards": {
			"stats": {
				"gold": 100,
				"stress": -20,
				"max_hp": 5,
				"max_mp": 5,
				"attack": 5,
				"magic": 5,
				"agility": 5,
				"art": 10,
			}
		},
		"failure_conditions": {
			"day": 0,
		},
	},
	"chores": {
		"name": "Chores",
		"requirements": {
			"work": {
				"Housework": 1,
				},
		},
		"description": "Her majesty asked you to clean your room. Clearly, this is a quest with huge rewards. (No it's not.)",
		"rewards": {
			"stats": {
				"gold": 100,
				"stress": -20,
				"max_hp": 5,
				"skill": 5,
				"agility": 10,
				"scholarship": 5,
			}
		},
		"failure_conditions": {
			"day": 0,
		},
	},
}

const random_daily_events = [
	{
		'stats': {
		},
		'weight': 1,
		'toast': "Eureka!",
		'timeline': "Inspiration",
	},
	{
		'stats': {
		},
		'weight': 1,
		'toast': "Her majesty called you over.",
		'timeline': "Chores",
	},
]

const perspectives = {
	"remedial_lessons": {
		"label": "The Perspective of Remedial Lessons",
		"timeline": "RemedialLessonsPerspective",
		"icon": "res://Art/Background/UncleMugen/Classroom_04_day.webp",
		#TODO, add requirements
	}
}
